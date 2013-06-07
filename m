Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 402097F5F
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 19:26:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2B9038F8059
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 17:26:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ubuDdnJRcXwewaY7 for <xfs@oss.sgi.com>;
	Thu, 06 Jun 2013 17:26:48 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UkkVm-0003uU-5k
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:34 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UkkVc-0001KS-2r
	for xfs@oss.sgi.com; Fri, 07 Jun 2013 10:26:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/48] xfs: shortform directory offsets change for dir3 format
Date: Fri,  7 Jun 2013 10:25:36 +1000
Message-Id: <1370564771-4929-14-git-send-email-david@fromorbit.com>
In-Reply-To: <1370564771-4929-1-git-send-email-david@fromorbit.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
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
 db/check.c                |    2 +-
 include/xfs_dir2_format.h |   25 ++++++++++++++-----------
 libxfs/xfs_dir2_sf.c      |    6 +++---
 repair/dir2.c             |    7 ++++---
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/db/check.c b/db/check.c
index b7855c0..27107a0 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3418,7 +3418,7 @@ process_sf_dir_v2(
 		dbprintf(_("dir %lld entry . %lld\n"), id->ino, id->ino);
 	(*dot)++;
 	sfe = xfs_dir2_sf_firstentry(&sf->hdr);
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	for (i = sf->hdr.count - 1, i8 = 0; i >= 0; i--) {
 		if ((__psint_t)sfe + xfs_dir2_sf_entsize(&sf->hdr,sfe->namelen) -
 		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index ce3626b..6dc884a 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -222,16 +222,6 @@ xfs_dir2_sf_nextentry(struct xfs_dir2_sf_hdr *hdr,
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
@@ -372,7 +362,20 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 
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
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 6848d05..cb23368 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -519,7 +519,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = XFS_DIR2_DATA_FIRST_OFFSET,
+	for (offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount),
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = xfs_dir2_data_entsize(args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -601,7 +601,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir2_data_entsize(args->namelen);
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -672,7 +672,7 @@ xfs_dir2_sf_check(
 	dp = args->dp;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(dp->i_mount);
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
diff --git a/repair/dir2.c b/repair/dir2.c
index 9f1d50b..2f13864 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -682,6 +682,7 @@ process_sf_dir2_fixi8(
  */
 static void
 process_sf_dir2_fixoff(
+	xfs_mount_t	*mp,
 	xfs_dinode_t	*dip)
 {
 	int			i;
@@ -691,7 +692,7 @@ process_sf_dir2_fixoff(
 
 	sfp = (xfs_dir2_sf_t *)XFS_DFORK_DPTR(dip);
 	sfep = xfs_dir2_sf_firstentry(&sfp->hdr);
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 
 	for (i = 0; i < sfp->hdr.count; i++) {
 		xfs_dir2_sf_put_offset(sfep, offset);
@@ -745,7 +746,7 @@ process_sf_dir2(
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sfp->hdr.count;
 	ino_dir_size = be64_to_cpu(dip->di_size);
-	offset = XFS_DIR2_DATA_FIRST_OFFSET;
+	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
 	bad_offset = *repair = 0;
 
 	ASSERT(ino_dir_size <= max_size);
@@ -1102,7 +1103,7 @@ _("would have corrected entry offsets in directory %" PRIu64 "\n"),
 			do_warn(
 _("corrected entry offsets in directory %" PRIu64 "\n"),
 				ino);
-			process_sf_dir2_fixoff(dip);
+			process_sf_dir2_fixoff(mp, dip);
 			*dino_dirty = 1;
 			*repair = 1;
 		}
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
