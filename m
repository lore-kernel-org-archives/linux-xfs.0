Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4C4037FB6
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3804A304048
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:31 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	8v5QlpA7d1mIdPPz for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:29 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOMa-0001Sg-Hn
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:28 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOMQ-0002Mo-Em
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 15/21] xfs: shortform directory offsets change for dir3 format
Date: Tue, 12 Mar 2013 23:30:48 +1100
Message-Id: <1363091454-8852-16-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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

Because the header size for the CRC enabled directory blocks is
larger, the offset of the first entry into a directory block is
different to the dir2 format. The shortform directory stores the
dirent's offset so that it doesn't change when moving from shortform
to block form and back again, and hence it needs to take into
account the different header sizes to maintain the correct offsets.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_format.h |   25 ++++++++++++++-----------
 fs/xfs/xfs_dir2_sf.c     |   10 +++++-----
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_dir2_format.h b/fs/xfs/xfs_dir2_format.h
index 8bb4efe..8d33f03 100644
--- a/fs/xfs/xfs_dir2_format.h
+++ b/fs/xfs/xfs_dir2_format.h
@@ -228,16 +228,6 @@ xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
 	xfs_dir2_byte_to_db(mp, XFS_DIR2_DATA_OFFSET)
 
 /*
- * Offsets of . and .. in data space (always block 0)
- */
-#define	XFS_DIR2_DATA_DOT_OFFSET	\
-	((xfs_dir2_data_aoff_t)sizeof(struct xfs_dir2_data_hdr))
-#define	XFS_DIR2_DATA_DOTDOT_OFFSET	\
-	(XFS_DIR2_DATA_DOT_OFFSET + xfs_dir2_data_entsize(1))
-#define	XFS_DIR2_DATA_FIRST_OFFSET		\
-	(XFS_DIR2_DATA_DOTDOT_OFFSET + xfs_dir2_data_entsize(2))
-
-/*
  * Describe a free area in the data block.
  *
  * The freespace will be formatted as a xfs_dir2_data_unused_t.
@@ -378,7 +368,20 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 
 /*
  * Offsets of . and .. in data space (always block 0)
- */
+ *
+ * The macros are used for shortform directories as they have no headers to read
+ * the magic number out of. Shortform directories need to know the size of the
+ * data block header because the sfe embeds the block offset of the entry into
+ * it so that it doesn't change when format conversion occurs. Bad Things Happen
+ * if we don't follow this rule.
+ */
+#define	XFS_DIR3_DATA_DOT_OFFSET(mp)	\
+	xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&(mp)->m_sb))
+#define	XFS_DIR3_DATA_DOTDOT_OFFSET(mp)	\
+	(XFS_DIR3_DATA_DOT_OFFSET(mp) + xfs_dir2_data_entsize(1))
+#define	XFS_DIR3_DATA_FIRST_OFFSET(mp)		\
+	(XFS_DIR3_DATA_DOTDOT_OFFSET(mp) + xfs_dir2_data_entsize(2))
+
 static inline xfs_dir2_data_aoff_t
 xfs_dir3_data_dot_offset(struct xfs_dir2_data_hdr *hdr)
 {
diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index b975622..6157424 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -535,7 +535,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = XFS_DIR2_DATA_FIRST_OFFSET,
+	for (offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount),
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = xfs_dir2_data_entsize(args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -617,7 +617,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(args->namelen);
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -688,7 +688,7 @@ xfs_dir2_sf_check(
 	dp = args->dp;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount);
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
@@ -812,9 +812,9 @@ xfs_dir2_sf_getdents(
 	 * mp->m_dirdatablk.
 	 */
 	dot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-					     XFS_DIR2_DATA_DOT_OFFSET);
+					     XFS_DIR3_DATA_DOT_OFFSET(mp));
 	dotdot_offset = xfs_dir2_db_off_to_dataptr(mp, mp->m_dirdatablk,
-						XFS_DIR2_DATA_DOTDOT_OFFSET);
+						XFS_DIR3_DATA_DOTDOT_OFFSET(mp));
 
 	/*
 	 * Put . entry unless we're starting past it.
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
