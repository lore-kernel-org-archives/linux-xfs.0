Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:36439 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751831AbdANVZ0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 14 Jan 2017 16:25:26 -0500
Received: by mail-qt0-f175.google.com with SMTP id k15so76040795qtg.3
        for <linux-xfs@vger.kernel.org>; Sat, 14 Jan 2017 13:25:26 -0800 (PST)
MIME-Version: 1.0
From: Thorvald Natvig <thorvald@medallia.com>
Date: Sat, 14 Jan 2017 13:25:05 -0800
Message-ID: <CAF9twL7UHoD45JZyZ=Rsb=aMV=NzQrGecaT+QmWtT=q0fm6XRw@mail.gmail.com>
Subject: Memory allocation stuck in xfs_reclaim_inodes_ag
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Kjetil Joergensen <kjetil@medallia.com>

Hi,

We've run into a somewhat unexpected condition. Under high memory
pressure and high I/O write pressure on slow media, when doing network
calls, we have a call chain that looks like:

.. -> tcp_recvmsg -> .. -> do_page_fault -> .. ->
__alloc_pages_slowpath -> try_to_free_pages -> .. -> shrink_slab ->
super_cache_scan -> xfs_fs_free_cached_objects ->
xfs_reclaim_inodes_nr -> xfs_reclaim_inodes_ag -> mutex_lock ->
__mutex_lock_slowpath

And it stays stuck there. This causes the network traffic to stall,
which causes applications (in this case Ceph OSDs) to fail basic
health checks.

This particular call-chain is due to the end of xfs_reclaim_inodes_ag,
which has the code:

      if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
                trylock = 0;
                goto restart;
        }

The code first tries to release with trylock on the mutex, but it it
fails to release sufficient number of items, and there were groups
that it failed to lock, it tries again with blocking locks.
If another kernel thread holds the mutexes for any reason (such as
currently flushing the group), we essentially make kernel memory
allocation wait for disc I/O.

On this particular system, we have 30 other XFS filesystems also
mounted, and there's also a lot of non-XFS caches that could be
reclaimed to meet this memory request. There's about 100GB of other
caches that could be released, so why block?

We've worked around this with the following probe:

probe module("xfs").function("xfs_reclaim_inodes_ag").call {
       printf ("%s -> %s: %d %s [%s]\n", thread_indent(0),
probefunc(), kernel_int($nr_to_scan),kernel_string($mp->m_fsname),
$$parms)
       print_backtrace()
       $flags = $flags & 2
}

In other words, remove the SYNC_WAIT flag to the call. This causes the
slab shrinker to move on to the next candidate for releasing. So far,
this seems to fix all the problems we've seen. The probe could
probably be improved to only do this for the callchain that reaches
xfs_reclaim_inodes_ag from shrink_slab.

Is there a better way to fix this problem?

- Thorvald
