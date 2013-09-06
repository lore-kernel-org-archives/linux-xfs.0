Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9365D29DFB
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 16:35:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 54BF7AC001
	for <xfs@oss.sgi.com>; Fri,  6 Sep 2013 14:35:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	bO1mJJG5pG6mhIbq for <xfs@oss.sgi.com>;
	Fri, 06 Sep 2013 14:35:57 -0700 (PDT)
Date: Sat, 7 Sep 2013 07:35:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 00/11] xfs: introduce the free inode btree
Message-ID: <20130906213555.GC12541@dastard>
References: <1378232708-57156-1-git-send-email-bfoster@redhat.com>
	<5228F4D6.4050306@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5228F4D6.4050306@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Michael L. Semon" <mlsemon35@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

On Thu, Sep 05, 2013 at 05:17:10PM -0400, Michael L. Semon wrote:
....
> [  814.376620] XFS (sdb4): Mounting Filesystem
> [  815.050778] XFS (sdb4): Ending clean mount
> [  823.169368] 
> [  823.170932] ======================================================
> [  823.172146] [ INFO: possible circular locking dependency detected ]
> [  823.172146] 3.11.0+ #5 Not tainted
> [  823.172146] -------------------------------------------------------
> [  823.172146] dirstress/5276 is trying to acquire lock:
> [  823.172146]  (sb_internal){.+.+.+}, at: [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
> [  823.172146] 
> [  823.172146] but task is already holding lock:
> [  823.172146]  (&(&ip->i_lock)->mr_lock){+++++.}, at: [<c1206cfb>] xfs_ilock+0x100/0x1f1
> [  823.172146] 
> [  823.172146] which lock already depends on the new lock.
> [  823.172146] 
> [  823.172146] 
> [  823.172146] the existing dependency chain (in reverse order) is:
> [  823.172146] 
> [  823.172146] -> #1 (&(&ip->i_lock)->mr_lock){+++++.}:
> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
> [  823.172146]        [<c14bff98>] _raw_spin_lock+0x47/0x74
> [  823.172146]        [<c1116247>] __mark_inode_dirty+0x171/0x38c
> [  823.172146]        [<c111acab>] __set_page_dirty+0x5f/0x95
> [  823.172146]        [<c111b93e>] mark_buffer_dirty+0x58/0x12b
> [  823.172146]        [<c111baff>] __block_commit_write.isra.17+0x64/0x82
> [  823.172146]        [<c111c197>] block_write_end+0x2b/0x53
> [  823.172146]        [<c111c201>] generic_write_end+0x42/0x9a
> [  823.172146]        [<c11a42d5>] xfs_vm_write_end+0x60/0xbe
> [  823.172146]        [<c10bd47a>] generic_file_buffered_write+0x140/0x20f
> [  823.172146]        [<c11b2347>] xfs_file_buffered_aio_write+0x10b/0x205
> [  823.172146]        [<c11b24ee>] xfs_file_aio_write+0xad/0xec
> [  823.172146]        [<c10f0c5f>] do_sync_write+0x60/0x87
> [  823.172146]        [<c10f0e0f>] vfs_write+0x9c/0x189
> [  823.172146]        [<c10f0fc6>] SyS_write+0x49/0x81
> [  823.172146]        [<c14c14bb>] sysenter_do_call+0x12/0x32
> [  823.172146] 
> [  823.172146] -> #0 (sb_internal){.+.+.+}:
> [  823.172146]        [<c106e972>] validate_chain.isra.35+0xfc7/0xff4
> [  823.172146]        [<c1070a11>] __lock_acquire+0x345/0xa11
> [  823.172146]        [<c1071c45>] lock_acquire+0x88/0x17e
> [  823.172146]        [<c10f36eb>] __sb_start_write+0xad/0x177
> [  823.172146]        [<c11c5e60>] xfs_trans_alloc+0x1f/0x35
> [  823.172146]        [<c120a823>] xfs_inactive+0x129/0x4a3
> [  823.172146]        [<c11c280d>] xfs_fs_evict_inode+0x6c/0x114
> [  823.172146]        [<c1106678>] evict+0x8e/0x15d
> [  823.172146]        [<c1107126>] iput+0xc4/0x138
> [  823.172146]        [<c1103504>] dput+0x1b2/0x257
> [  823.172146]        [<c10f1a30>] __fput+0x140/0x1eb
> [  823.172146]        [<c10f1b0f>] ____fput+0xd/0xf
> [  823.172146]        [<c1048477>] task_work_run+0x67/0x90
> [  823.172146]        [<c1001ea5>] do_notify_resume+0x61/0x63
> [  823.172146]        [<c14c0cfa>] work_notifysig+0x1f/0x25
> [  823.172146] 
> [  823.172146] other info that might help us debug this:
> [  823.172146] 
> [  823.172146]  Possible unsafe locking scenario:
> [  823.172146] 
> [  823.172146]        CPU0                    CPU1
> [  823.172146]        ----                    ----
> [  823.172146]   lock(&(&ip->i_lock)->mr_lock);
> [  823.172146]                                lock(sb_internal);
> [  823.172146]                                lock(&(&ip->i_lock)->mr_lock);
> [  823.172146]   lock(sb_internal);

Ah, now there's something I missed in all the xfs_inactive
transaction rework - you can't call
xfs_trans_alloc()/xfs-trans_reserve with the XFS_ILOCK_??? held.
It's not the freeze locks you really have to worry about deadlocking
if you do, it's deadlocking against log space that is much more
likely.

i.e. if you hold the ILOCK, the AIL can't get it to flush the inode
to disk. That means if the inode you hold locked is pinning the tail
of the log and there is no logspace for the transaction you are
about to run, xfs_trans_reserve() will block forever waiting for the
inode to be flushed and the tail of the log to move forward. This
will end up blocking all further reservations and hence deadlock the
filesystem...

Brian, if you rewrite xfs_inactive in the way that I suggested, this
problem goes away ;)

Thanks for reporting this, Michael.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
