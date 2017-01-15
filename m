Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34788 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751206AbdAOT0r (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Jan 2017 14:26:47 -0500
Subject: Re: Memory allocation stuck in xfs_reclaim_inodes_ag
References: <CAF9twL7UHoD45JZyZ=Rsb=aMV=NzQrGecaT+QmWtT=q0fm6XRw@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <79a3e068-ac5c-6dbf-ae54-8d1a9818fcb6@sandeen.net>
Date: Sun, 15 Jan 2017 13:26:45 -0600
MIME-Version: 1.0
In-Reply-To: <CAF9twL7UHoD45JZyZ=Rsb=aMV=NzQrGecaT+QmWtT=q0fm6XRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Thorvald Natvig <thorvald@medallia.com>, linux-xfs@vger.kernel.org
Cc: Kjetil Joergensen <kjetil@medallia.com>

On 1/14/17 3:25 PM, Thorvald Natvig wrote:
> Hi,
> 
> We've run into a somewhat unexpected condition. Under high memory
> pressure and high I/O write pressure on slow media, when doing network
> calls, we have a call chain that looks like:
> 
> .. -> tcp_recvmsg -> .. -> do_page_fault -> .. ->
> __alloc_pages_slowpath -> try_to_free_pages -> .. -> shrink_slab ->
> super_cache_scan -> xfs_fs_free_cached_objects ->
> xfs_reclaim_inodes_nr -> xfs_reclaim_inodes_ag -> mutex_lock ->
> __mutex_lock_slowpath
> 
> And it stays stuck there. This causes the network traffic to stall,
> which causes applications (in this case Ceph OSDs) to fail basic
> health checks.

You might also want to take a look at the thread:

[PATCH RFC] xfs: drop SYNC_WAIT from xfs_reclaim_inodes_ag during slab reclaim

from this past mid-october, and also dave's patch sent mid-november
in that same thread.

(I need to re-read it too).

-Eric

> This particular call-chain is due to the end of xfs_reclaim_inodes_ag,
> which has the code:
> 
>       if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
>                 trylock = 0;
>                 goto restart;
>         }
> 
> The code first tries to release with trylock on the mutex, but it it
> fails to release sufficient number of items, and there were groups
> that it failed to lock, it tries again with blocking locks.
> If another kernel thread holds the mutexes for any reason (such as
> currently flushing the group), we essentially make kernel memory
> allocation wait for disc I/O.
> 
> On this particular system, we have 30 other XFS filesystems also
> mounted, and there's also a lot of non-XFS caches that could be
> reclaimed to meet this memory request. There's about 100GB of other
> caches that could be released, so why block?
> 
> We've worked around this with the following probe:
> 
> probe module("xfs").function("xfs_reclaim_inodes_ag").call {
>        printf ("%s -> %s: %d %s [%s]\n", thread_indent(0),
> probefunc(), kernel_int($nr_to_scan),kernel_string($mp->m_fsname),
> $$parms)
>        print_backtrace()
>        $flags = $flags & 2
> }
> 
> In other words, remove the SYNC_WAIT flag to the call. This causes the
> slab shrinker to move on to the next candidate for releasing. So far,
> this seems to fix all the problems we've seen. The probe could
> probably be improved to only do this for the callchain that reaches
> xfs_reclaim_inodes_ag from shrink_slab.
> 
> Is there a better way to fix this problem?
> 
> - Thorvald
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
