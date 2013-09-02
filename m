Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 308C07F52
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 05:49:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10F2E304059
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 03:49:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	JLmyAQY372GgXpL3 for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 03:49:39 -0700 (PDT)
Date: Mon, 2 Sep 2013 20:49:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2 v2] xfs: fix some minor sparse warnings
Message-ID: <20130902104936.GG12779@dastard>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
	<1378092179-24973-3-git-send-email-david@fromorbit.com>
	<20130902081954.GD11210@infradead.org>
	<20130902100957.GE12779@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130902100957.GE12779@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

xfs: fix some minor sparse warnings

From: Dave Chinner <dchinner@redhat.com>

A couple of simple locking annotations and 0 vs NULL warnings.
Nothing that changes any code behaviour, just removes build noise.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
v2: move __release annotations to match the other notations in the
    XFS code at the end of the function declaration.

 fs/xfs/xfs_bmap.c        | 2 +-
 fs/xfs/xfs_dquot_item.c  | 3 ++-
 fs/xfs/xfs_extent_busy.c | 3 ++-
 fs/xfs/xfs_ioctl.c       | 2 +-
 fs/xfs/xfs_itable.c      | 5 +++--
 fs/xfs/xfs_log.c         | 3 ++-
 6 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 92b8309..f47e65c 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -4450,7 +4450,7 @@ xfs_bmapi_write(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
+	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 60c6e1f..e838d84 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -142,7 +142,8 @@ xfs_qm_dqunpin_wait(
 STATIC uint
 xfs_qm_dquot_logitem_push(
 	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
+	struct list_head	*buffer_list) __releases(&lip->li_ailp->xa_lock)
+					      __acquires(&lip->li_ailp->xa_lock)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 	struct xfs_buf		*bp = NULL;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 86f559f..e43708e 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -160,7 +160,8 @@ xfs_extent_busy_update_extent(
 	struct xfs_extent_busy	*busyp,
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
-	bool			userdata)
+	bool			userdata) __releases(&pag->pagb_lock)
+					  __acquires(&pag->pagb_lock)
 {
 	xfs_agblock_t		fend = fbno + flen;
 	xfs_agblock_t		bbno = busyp->bno;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bdebc21..21d9c9df 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -71,7 +71,7 @@ xfs_find_handle(
 	int			hsize;
 	xfs_handle_t		handle;
 	struct inode		*inode;
-	struct fd		f = {0};
+	struct fd		f = {NULL};
 	struct path		path;
 	int			error;
 	struct xfs_inode	*ip;
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index b93e14b..8a67d53 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -541,8 +541,9 @@ xfs_bulkstat_single(
 	 * at the expense of the error case.
 	 */
 
-	ino = (xfs_ino_t)*lastinop;
-	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t), 0, &res);
+	ino = *lastinop;
+	error = xfs_bulkstat_one(mp, ino, buffer, sizeof(xfs_bstat_t),
+				 NULL, &res);
 	if (error) {
 		/*
 		 * Special case way failed, do it the "long" way
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 5372d58..a2dea108 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -257,7 +257,8 @@ xlog_grant_head_wait(
 	struct xlog		*log,
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
-	int			need_bytes)
+	int			need_bytes) __releases(&head->lock)
+					    __acquires(&head->lock)
 {
 	list_add_tail(&tic->t_queue, &head->waiters);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
