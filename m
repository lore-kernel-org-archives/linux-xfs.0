Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 485D629DFB
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 22:23:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1879830404E
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 20:23:08 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	fRfNfi9VGHnho93Y for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 20:23:06 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGKjF-0008Rb-VX
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGKjF-0006Vo-Tp
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix some minor sparse warnings
Date: Mon,  2 Sep 2013 13:22:59 +1000
Message-Id: <1378092179-24973-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378092179-24973-1-git-send-email-david@fromorbit.com>
References: <1378092179-24973-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

A couple of simple locking annotations and 0 vs NULL warnings.
Nothing that changes any code behaviour, just removes build noise.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap.c        | 2 +-
 fs/xfs/xfs_dquot_item.c  | 2 ++
 fs/xfs/xfs_extent_busy.c | 2 ++
 fs/xfs/xfs_ioctl.c       | 2 +-
 fs/xfs/xfs_itable.c      | 5 +++--
 fs/xfs/xfs_log.c         | 2 ++
 6 files changed, 11 insertions(+), 4 deletions(-)

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
index 60c6e1f..77eb762 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -143,6 +143,8 @@ STATIC uint
 xfs_qm_dquot_logitem_push(
 	struct xfs_log_item	*lip,
 	struct list_head	*buffer_list)
+	__releases(&lip->li_ailp->xa_lock)
+	__acquires(&lip->li_ailp->xa_lock)
 {
 	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
 	struct xfs_buf		*bp = NULL;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 86f559f..504e51ee 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -161,6 +161,8 @@ xfs_extent_busy_update_extent(
 	xfs_agblock_t		fbno,
 	xfs_extlen_t		flen,
 	bool			userdata)
+	__releases(&pag->pagb_lock)
+	__acquires(&pag->pagb_lock)
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
index 5372d58..8215b63 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -258,6 +258,8 @@ xlog_grant_head_wait(
 	struct xlog_grant_head	*head,
 	struct xlog_ticket	*tic,
 	int			need_bytes)
+	__releases(&head->lock)
+	__acquires(&head->lock)
 {
 	list_add_tail(&tic->t_queue, &head->waiters);
 
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
