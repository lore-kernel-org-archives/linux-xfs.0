Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29G8iAC255101 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 10:08:44 -0600
Received: from webrelay-aldf.mr.itd.umich.edu (webrelay-aldf.mr.itd.umich.edu
	[141.211.14.43]) by cuda.sgi.com with ESMTP id EfL6NXQB1odEO8Nx
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 08:08:42 -0800 (PST)
Message-ID: <20120309110838.147865q6j5c9hqsc@web.mail.umich.edu>
Date: Fri, 09 Mar 2012 11:08:38 -0500
From: Sean Thomas Caron <scaron@umich.edu>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
	<20120308235326.GQ5091@dastard>
In-Reply-To: <20120308235326.GQ5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="Yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: scaron@umich.edu, hch@lst.de, xfs@oss.sgi.com

OK, Linux 3.2.9 doesn't sound very safe to use in production. So,  
fine, we can try 3.0.23; it appears that a fix for CVE-2012-0056 was  
applied around 3.0.19 so it should be all set in that regard.

I'm comparing the contents of the xfs-bulletproof-sync patch with the  
3.0.23 XFS sources and it's not entirely clear to me if 3.0.23 fully  
implements the fixes in the patch. Please forgive me because it's a  
little long, but here's the contents of the patch:



From: Christoph Hellwig <hch@lst.de>
Subject: xfs: make sync() bulletproof

We've had a few bug reports that we can basically stall filesize updates
forever when an inode is busy.  This seems to be the result of two factors:

  (1) XFS refuses to do a non-waiting ->write_inode if the inode can't be
      locked or is pinned.  A busy inode has a fair chance to be pinned most
      of the time, and thus won't easily be written back without force.
  (2) the VFS writeback assigned a new dirtied_when to an inode redirtied
      from withing ->write_inode, thus pushing back writeback for another
      30 seconds

even worse it seems since about Linux 2.6.36 this can lead to the livelock
detection code in sync(2) skipping writeback of the inode even for the
synchronous pass if file data writeback takes long enough to only complete
once the asynchronous pass is over completely, and thus redirtying the
inode only after the livelock avoidance cutoff of the waiting sync(2)
pass.

This patch changes the XFS sync code to:

  - always log the inode from ->write_inode, no matter if it was a blocking
    call or not.  This means we might stall the writeback thread on the
    inode lock for a short time, but except for that it should not cause
    problems as long as the delaylog option is enabled given that we do
    not cause additional log traffic by logging the inode multiple times
    in a single checkpoint.  This should solve issue (1)
  - add a pass to ->sync_fs to log all inodes that still have unlogged
    changes.  This should solve issue (2) at the expense of possibly
    logging inodes that have only been dirtied after the sync call was
    issued.  Given that logging the inode is cheap, and the radix tree
    gang lookup isn't lifelockable this should be fine, too.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_super.c	2011-11-30  
17:01:27.247619240 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_super.c	2011-11-30 17:05:58.376150409 +0100
@@ -871,94 +871,25 @@ xfs_fs_dirty_inode(
  }

  STATIC int
-xfs_log_inode(
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_trans	*tp;
-	int			error;
-
-	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
-	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-	if (error) {
-		xfs_trans_cancel(tp, 0);
-		return error;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp, 0);
-}
-
-STATIC int
  xfs_fs_write_inode(
  	struct inode		*inode,
  	struct writeback_control *wbc)
  {
  	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	int			error = EAGAIN;

  	trace_xfs_write_inode(ip);

-	if (XFS_FORCED_SHUTDOWN(mp))
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
  		return -XFS_ERROR(EIO);
-	if (!ip->i_update_core)
-		return 0;
-
-	if (wbc->sync_mode == WB_SYNC_ALL) {
-		/*
-		 * Make sure the inode has made it it into the log.  Instead
-		 * of forcing it all the way to stable storage using a
-		 * synchronous transaction we let the log force inside the
-		 * ->sync_fs call do that for thus, which reduces the number
-		 * of synchronous log foces dramatically.
-		 */
-		xfs_ioend_wait(ip);
-		error = xfs_log_inode(ip);
-		if (error)
-			goto out;
-		return 0;
-	} else {
-		/*
-		 * We make this non-blocking if the inode is contended, return
-		 * EAGAIN to indicate to the caller that they did not succeed.
-		 * This prevents the flush path from blocking on inodes inside
-		 * another operation right now, they get caught later by
-		 * xfs_sync.
-		 */
-		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
-			goto out;
-
-		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-			goto out_unlock;
-
-		/*
-		 * Now we have the flush lock and the inode is not pinned, we
-		 * can check if the inode is really clean as we know that
-		 * there are no pending transaction completions, it is not
-		 * waiting on the delayed write queue and there is no IO in
-		 * progress.
-		 */
-		if (xfs_inode_clean(ip)) {
-			xfs_ifunlock(ip);
-			error = 0;
-			goto out_unlock;
-		}
-		error = xfs_iflush(ip, SYNC_TRYLOCK);
-	}

- out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
- out:
  	/*
-	 * if we failed to write out the inode then mark
-	 * it dirty again so we'll try again later.
+	 * Make sure the inode has made it it into the log.  Instead
+	 * of forcing it all the way to stable storage using a
+	 * synchronous transaction we let the log force inside the
+	 * ->sync_fs call do that for thus, which reduces the number
+	 * of synchronous log foces dramatically.
  	 */
-	if (error)
-		xfs_mark_inode_dirty_sync(ip);
-	return -error;
+	return xfs_sync_log_inode(ip, NULL, 0);
  }

  STATIC void
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.c	2011-11-30  
17:01:27.240952610 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.c	2011-11-30 17:03:54.740153538 +0100
@@ -243,6 +243,32 @@ xfs_sync_inode_data(
  	return error;
  }

+int
+xfs_sync_log_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			flags)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;
+	int			error;
+
+	if (!ip->i_update_core)
+		return 0;
+
+	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
+	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
+	if (error) {
+		xfs_trans_cancel(tp, 0);
+		return error;
+	}
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp, 0);
+}
+
  STATIC int
  xfs_sync_inode_attr(
  	struct xfs_inode	*ip,
@@ -359,6 +385,14 @@ xfs_quiesce_data(
  {
  	int			error, error2 = 0;

+	/*
+	 * Write out all inodes with dirty non-transaction updates.
+	 * In theory ->write_inode should take care of that, but the livelock
+	 * detection in the writeback code causes us to miss file size
+	 * upates sometimes.
+	 */
+	xfs_inode_ag_iterator(mp, xfs_sync_log_inode, 0);
+
  	/* push non-blocking */
  	xfs_sync_data(mp, 0);
  	xfs_qm_sync(mp, SYNC_TRYLOCK);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_sync.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_sync.h	2011-11-30  
17:01:27.260952500 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_sync.h	2011-11-30 17:03:44.093544547 +0100
@@ -54,6 +54,8 @@ int xfs_inode_ag_iterator(struct xfs_mou
  	int (*execute)(struct xfs_inode *ip, struct xfs_perag *pag, int flags),
  	int flags);

+int xfs_sync_log_inode(struct xfs_inode *ip, struct xfs_perag *pag,  
int flags);
+
  void xfs_inode_shrinker_register(struct xfs_mount *mp);
  void xfs_inode_shrinker_unregister(struct xfs_mount *mp);



Does 3.0.23 fix these bugs? Do we need a new patch tailored for 3.0.23  
to get the same functionality?

Thanks,

-Sean

Quoting Dave Chinner <david@fromorbit.com>:

> On Thu, Mar 08, 2012 at 02:06:00PM -0500, Sean Thomas Caron wrote:
>> Hi all,
>>
>> We're currently using Linux 3.0.12 with Cristoph's
>> xfs-bulletproof-sync patch and it seems to be working very well for
>> us. Unfortunately this kernel is vulnerable to the recent
>> CVE-2012-0056 no permission checking on writes to /proc/(pid)/mem
>> local root exploit, so we've got to leave it behind.
>
> Hasn't it been fixed in 3.0.23? root exploits are the sort of thing
> that are supposed to be fixed in long term stable kernels....
>
>> I see that the newest recommended stable kernel on kernel.org is
>> 3.2.9. Have there been any major changes to XFS between 3.0.12 and
>> 3.2.9 that would be considered "risky" in a production environment?
>
> The 3.2.x kernels really haven't been run in production environments
> for that long for us to be able to tell if there are problems or
> not.
>
>> I assume the xfs-bulletproof-sync patch has already been committed
>> to the code base in 3.2-train, so we shouldn't have to worry about
>> that any longer?
>
> Should have been, but I'm not exactly sure what is in that patch
> Christoph gave you, so you'll have to verify that yourself.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
>
>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
