Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35738 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751943AbdGFWrr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jul 2017 18:47:47 -0400
Date: Thu, 6 Jul 2017 15:47:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: MAXPATHLEN == 1024 and 4096?!
Message-ID: <20170706224738.GA4103@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Brian Foster <bfoster@redhat.com>

Heh,

Brian Foster complained that he could create filesystems that do this on
for-next during the first mount attempt:

[62548.735187] XFS (dm-1): Log size 4497 blocks too small, minimum size is 4499 blocks
[62548.742853] XFS (dm-1): AAIEEE! Log failed size checks. Abort!

I started looking into why mkfs and mount have different ideas about the
minimum log length, and discovered that the struct xfs_trans_res between
kernel and userspace have vastly different ideas about how much space a
transaction type requires.  Most of the problems are easily fixed by
constructing a more complete phony superblock in mkfs' max_trans_res()
(patches soon), but I ran into a nasty one that I cannot resolve in
tr_symlink.

In fs/xfs/, MAXPATHLEN is defined as 1024, and returns -ENAMETOOLONG
(set) or -EFSCORRUPTED (get) if it is fed a symlink with a target longer
than 1024 bytes.

However, xfsprogs picks up the definition offered by libc, which is
PATH_MAX (4096).  Unfortunately, this also means that xfs_repair only
complains if the target is longer than 4096 bytes.

AFAICT the other filesystems allow 4k symlink targets, but XFS' special
definition has been there at least since git-prehistory.

Soooo... which is the correct value?  We could raise the kernel limit to
4k with at least the obvious problem that old kernels can't read such
symlinks, or lower the xfsprogs limit to 1k, with the problem that at
least in theory this would result in xfs_repair flagging things it
wouldn't have before.

My cautious side says lower xfsprogs, but I'll ask the list anyway. :)

--D
