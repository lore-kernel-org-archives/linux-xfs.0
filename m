Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 22:31:05 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l2N5Uu6p008117
	for <xfs@oss.sgi.com>; Thu, 22 Mar 2007 22:30:59 -0700
Date: Fri, 23 Mar 2007 16:30:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS and write barriers.
Message-ID: <20070323053043.GD32602149@melbourne.sgi.com>
References: <17923.11463.459927.628762@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17923.11463.459927.628762@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: xfs@oss.sgi.com, hch@infradead.org

On Fri, Mar 23, 2007 at 12:26:31PM +1100, Neil Brown wrote:
> 
> Hi,
>  I have two concerns related to XFS and write barrier support that I'm
>  hoping can be resolved.
> 
> Firstly in xfs_mountfs_check_barriers in fs/xfs/linux-2.6/xfs_super.c,
> it tests ....->queue->ordered to see if that is QUEUE_ORDERED_NONE.
> If it is, then barriers are disabled.
> 
> I think this is a layering violation - xfs really has no business
> looking that deeply into the device.

Except that the device behaviour determines what XFS needs to do
and there used to be no other way to find out.

Christoph, any reason for needing this check anymore? I can't see
any particular reason for needing to do this as __make_request()
will check it for us when we test now.

> I think this test should just be removed and the xfs_barrier_test
> should be the main mechanism for seeing if barriers work.

Yup.

> Secondly, if a barrier write fails due to EOPNOTSUPP, it should be
> retried without the barrier (after possibly waiting for dependant
> requests to complete).  This is what other filesystems do, but I
> cannot find the code in xfs which does this.

XFS doesn't handle this - I was unaware that the barrier status of the
underlying block device could change....

OOC, when did this behaviour get introduced?

> The approach taken by xfs_barrier_test seems to suggest that xfs does
> do this... could someone please point me to the code ?

We test at mount time if barriers are supported, and the decision
lasts the life of the mount.

> This is particularly important for md/raid1 as it is quite possible
> that barriers will be supported at first, but after a failure and
> different device on a different controller could be swapped in that
> does not support barriers.

I/O errors are not the way this should be handled. What happens if
the opposite happens? A drive that needs barriers is used as a
replacement on a filesystem that has barriers disabled because they
weren't needed? Now a crash can result in filesystem corruption, but
the filesystem has not been able to warn the admin that this
situation occurred. 

/waves hands

At the recent FS/IO workshop in San Jose I raised the issue of how
we can get the I/O layers to tell the filesystems about changes in
status of the block layer that can affect filesystem behaviour. This
is a perfect example of the sort of communication that is needed....

In the mean time, we'll need to do something like the untested
patch below.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/linux-2.6/xfs_buf.c   |   13 ++++++++++++-
 fs/xfs/linux-2.6/xfs_super.c |    8 --------
 fs/xfs/xfs_log.c             |   13 +++++++++++++
 3 files changed, 25 insertions(+), 9 deletions(-)
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_buf.c	2007-02-07 15:51:09.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_buf.c	2007-03-23 16:19:19.790517132 +1100
@@ -1000,7 +1000,18 @@ xfs_buf_iodone_work(
 	xfs_buf_t		*bp =
 		container_of(work, xfs_buf_t, b_iodone_work);
 
-	if (bp->b_iodone)
+	/*
+	 * We can get an EOPNOTSUPP to ordered writes.  Here we clear the
+	 * ordered flag and reissue them.  Because we can't tell the higher
+	 * layers directly that they should not issue ordered I/O anymore, they
+	 * need to check if the ordered flag was cleared during I/O completion.
+	 */
+	if ((bp->b_error == EOPNOTSUPP) &&
+	    (bp->b_flags & (XBF_ORDERED|XBF_ASYNC)) == (XBF_ORDERED|XBF_ASYNC)) {
+		XB_TRACE(bp, "ordered_retry", bp->b_iodone);
+		bp->b_flags &= ~XBF_ORDERED;
+		xfs_buf_iorequest(bp);
+	} else if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
Index: 2.6.x-xfs-new/fs/xfs/xfs_log.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_log.c	2007-03-23 15:00:05.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/xfs_log.c	2007-03-23 16:19:40.355818889 +1100
@@ -961,6 +961,19 @@ xlog_iodone(xfs_buf_t *bp)
 	l = iclog->ic_log;
 
 	/*
+	 * If the ordered flag has been removed by a lower
+	 * layer, it means the underlyin device no longer supports
+	 * barrier I/O. Warn loudly and turn off barriers.
+	 */
+	if ((l->l_mp->m_flags & XFS_MOUNT_BARRIER) && !XFS_BUF_ORDERED(bp)) {
+		l->l_mp->m_flags &= ~XFS_MOUNT_BARRIER;
+		xfs_fs_cmn_err(CE_WARN, l->l_mp,
+				"xlog_iodone: Barriers are no longer supported"
+				" by device. Disabling barriers\n");
+		xfs_buftrace("XLOG_IODONE BARRIERS OFF", bp);
+	}
+
+	/*
 	 * Race to shutdown the filesystem if we see an error.
 	 */
 	if (XFS_TEST_ERROR((XFS_BUF_GETERROR(bp)), l->l_mp,
Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_super.c	2007-03-16 12:48:54.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_super.c	2007-03-23 16:24:26.998220227 +1100
@@ -314,14 +314,6 @@ xfs_mountfs_check_barriers(xfs_mount_t *
 		return;
 	}
 
-	if (mp->m_ddev_targp->bt_bdev->bd_disk->queue->ordered ==
-					QUEUE_ORDERED_NONE) {
-		xfs_fs_cmn_err(CE_NOTE, mp,
-		  "Disabling barriers, not supported by the underlying device");
-		mp->m_flags &= ~XFS_MOUNT_BARRIER;
-		return;
-	}
-
 	if (xfs_readonly_buftarg(mp->m_ddev_targp)) {
 		xfs_fs_cmn_err(CE_NOTE, mp,
 		  "Disabling barriers, underlying device is readonly");
