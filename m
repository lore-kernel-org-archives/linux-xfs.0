Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 14:16:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MLGJfH021028
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:16:19 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4AD7B10D1431
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:18:04 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id KYb5D8W6P6gTbysC for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 14:18:04 -0700 (PDT)
Date: Thu, 23 Oct 2008 08:18:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Handle ENOMEM during log initialisation
Message-ID: <20081022211800.GP18495@disturbed>
References: <20081022061002.GG18495@disturbed> <20081022101146.GA11313@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022101146.GA11313@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 06:11:46AM -0400, Christoph Hellwig wrote:
> On Wed, Oct 22, 2008 at 05:10:02PM +1100, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 5184017..1dfa5fe 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> 
> > -	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_SLEEP);
> > +	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
> 
> You might want to remove the cast when you touch that line anyway.

Ok. Removed those two casts. Updated patch below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


XFS: handle memory allocation failures during log initialisation

When there is no memory left in the system, xfs_buf_get_noaddr()
can fail. If this happens at mount time during xlog_alloc_log()
we fail to catch the error and oops.

Catch the error from xfs_buf_get_noaddr(), and allow other memory
allocations to fail and catch those errors too. Report the error
to the console and fail the mount with ENOMEM.

Tested by manually injecting errors into xfs_buf_get_noaddr() and
xlog_alloc_log().

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
Version 2:
o remove unnecessary casts of the returned pointer from kmem_zalloc()

 fs/xfs/xfs_log.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5184017..92c20a8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -563,6 +563,11 @@ xfs_log_mount(
 	}
 
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
+	if (!mp->m_log) {
+		cmn_err(CE_WARN, "XFS: Log allocation failed: No memory!");
+		error = ENOMEM;
+		goto out;
+	}
 
 	/*
 	 * Initialize the AIL now we have a log.
@@ -601,6 +606,7 @@ xfs_log_mount(
 	return 0;
 error:
 	xfs_log_unmount_dealloc(mp);
+out:
 	return error;
 }	/* xfs_log_mount */
 
@@ -1217,7 +1223,9 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	int			i;
 	int			iclogsize;
 
-	log = (xlog_t *)kmem_zalloc(sizeof(xlog_t), KM_SLEEP);
+	log = kmem_zalloc(sizeof(xlog_t), KM_MAYFAIL);
+	if (!log)
+		return NULL;
 
 	log->l_mp	   = mp;
 	log->l_targ	   = log_target;
@@ -1249,6 +1257,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_get_iclog_buffer_size(mp, log);
 
 	bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
+	if (!bp)
+		goto out_free_log;
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 	XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
@@ -1275,13 +1285,17 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	iclogsize = log->l_iclog_size;
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i=0; i < log->l_iclog_bufs; i++) {
-		*iclogp = (xlog_in_core_t *)
-			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
+		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
+		if (!*iclogp)
+			goto out_free_iclog;
+
 		iclog = *iclogp;
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
 		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		if (!bp)
+			goto out_free_iclog;
 		if (!XFS_BUF_CPSEMA(bp))
 			ASSERT(0);
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
@@ -1323,6 +1337,25 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	log->l_iclog->ic_prev = prev_iclog;	/* re-write 1st prev ptr */
 
 	return log;
+
+out_free_iclog:
+	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
+		prev_iclog = iclog->ic_next;
+		if (iclog->ic_bp) {
+			sv_destroy(&iclog->ic_force_wait);
+			sv_destroy(&iclog->ic_write_wait);
+			xfs_buf_free(iclog->ic_bp);
+			xlog_trace_iclog_dealloc(iclog);
+		}
+		kmem_free(iclog);
+	}
+	spinlock_destroy(&log->l_icloglock);
+	spinlock_destroy(&log->l_grant_lock);
+	xlog_trace_loggrant_dealloc(log);
+	xfs_buf_free(log->l_xbuf);
+out_free_log:
+	kmem_free(log);
+	return NULL;
 }	/* xlog_alloc_log */
 
 
