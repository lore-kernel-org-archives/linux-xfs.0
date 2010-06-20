Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5KNua3T091929 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 18:56:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C3C73ED453
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 16:59:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	mbxaP2iNN1jUbIdO for <xfs@oss.sgi.com>;
	Sun, 20 Jun 2010 16:59:14 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] xfs: rename XFS_IGET_BULKSTAT to XFS_IGET_UNTRUSTED
Date: Mon, 21 Jun 2010 09:59:00 +1000
Message-Id: <1277078341-19087-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1277078341-19087-1-git-send-email-david@fromorbit.com>
References: <1277078341-19087-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: security@kernel.org

From: Dave Chinner <dchinner@redhat.com>

Inode numbers may come from somewhere external to the filesystem
(e.g. file handles, bulkstat information) and so are inherently
untrusted. Rename the flag we use for these lookups to make it
obvious we are doing a lookup of an untrusted inode number and need
to verify it completely before trying to read it from disk.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_export.c |    9 ++++-----
 fs/xfs/xfs_ialloc.c           |   11 +++++++----
 fs/xfs/xfs_inode.c            |    2 +-
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_itable.c           |    2 +-
 5 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index e61232f..b39c05c 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -127,12 +127,11 @@ xfs_nfs_get_inode(
 		return ERR_PTR(-ESTALE);
 
 	/*
-	 * The XFS_IGET_BULKSTAT means that an invalid inode number is just
-	 * fine and not an indication of a corrupted filesystem.  Because
-	 * clients can send any kind of invalid file handle, e.g. after
-	 * a restore on the server we have to deal with this case gracefully.
+	 * The XFS_IGET_UNTRUSTED means that an invalid inode number is just
+	 * fine and not an indication of a corrupted filesystem as clients can
+	 * send invalid file handles and we have to handle it gracefully..
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_BULKSTAT,
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED,
 			 XFS_ILOCK_SHARED, &ip, 0);
 	if (error) {
 		/*
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 142ae8c..c3de5fa 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -1247,7 +1247,7 @@ xfs_imap_lookup(
 		return error;
 
 	/* for untrusted inodes check it is allocated first */
-	if ((flags & XFS_IGET_BULKSTAT) &&
+	if ((flags & XFS_IGET_UNTRUSTED) &&
 	    (rec.ir_free & XFS_INOBT_MASK(agino - rec.ir_startino)))
 		return EINVAL;
 
@@ -1288,8 +1288,11 @@ xfs_imap(
 	if (agno >= mp->m_sb.sb_agcount || agbno >= mp->m_sb.sb_agblocks ||
 	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
 #ifdef DEBUG
-		/* no diagnostics for bulkstat, ino comes from userspace */
-		if (flags & XFS_IGET_BULKSTAT)
+		/*
+		 * Don't output diagnostic information for untrusted inodes
+		 * as they can be invalid without implying corruption.
+		 */
+		if (flags & XFS_IGET_UNTRUSTED)
 			return XFS_ERROR(EINVAL);
 		if (agno >= mp->m_sb.sb_agcount) {
 			xfs_fs_cmn_err(CE_ALERT, mp,
@@ -1325,7 +1328,7 @@ xfs_imap(
 	 * inodes in stale state on disk. Hence we have to do a btree lookup
 	 * in all cases where an untrusted inode number is passed.
 	 */
-	if (flags & XFS_IGET_BULKSTAT) {
+	if (flags & XFS_IGET_UNTRUSTED) {
 		error = xfs_imap_lookup(mp, tp, agno, agino, agbno,
 					&chunk_agbno, &offset_agbno, flags);
 		if (error)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5c2ada4..9101e79 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -173,7 +173,7 @@ xfs_imap_to_bp(
 		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
 						XFS_ERRTAG_ITOBP_INOTOBP,
 						XFS_RANDOM_ITOBP_INOTOBP))) {
-			if (iget_flags & XFS_IGET_BULKSTAT) {
+			if (iget_flags & XFS_IGET_UNTRUSTED) {
 				xfs_trans_brelse(tp, bp);
 				return XFS_ERROR(EINVAL);
 			}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 10dd2e0..7a2f347 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -499,7 +499,7 @@ do { \
  * Flags for xfs_iget()
  */
 #define XFS_IGET_CREATE		0x1
-#define XFS_IGET_BULKSTAT	0x2
+#define XFS_IGET_UNTRUSTED	0x2
 
 int		xfs_inotobp(struct xfs_mount *, struct xfs_trans *,
 			    xfs_ino_t, struct xfs_dinode **,
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index f554bd9..5fccd84 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -76,7 +76,7 @@ xfs_bulkstat_one_int(
 		return XFS_ERROR(ENOMEM);
 
 	error = xfs_iget(mp, NULL, ino,
-			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
+			 XFS_IGET_UNTRUSTED, XFS_ILOCK_SHARED, &ip, bno);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
 		goto out_free;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
