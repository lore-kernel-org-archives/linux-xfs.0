Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 427EF7F85
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16252304039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:54 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	EhGPiu0r7FZreGJ4 for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006On-Uv
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:46 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002FZ-UH
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 07/32] xfs: dirent dtype presence is dependent on directory
	magic numbers
Date: Mon, 30 Sep 2013 13:15:19 +1000
Message-Id: <1380510944-8571-8-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

The determination of whether a directory entry contains a dtype
field originally was dependent on the filesystem having CRCs
enabled. This meant that the format for dtype beign enabled could be
determined by checking the directory block magic number rather than
doing a feature bit check. This was useful in that it meant that we
didn't need to pass a struct xfs_mount around to functions that
were already supplied with a directory block header.

Unfortunately, the introduction of dtype fields into the v4
structure via a feature bit meant this "use the directory block
magic number" method of discriminating the dirent entry sizes is
broken. Hence we need to convert the places that use magic number
checks to use feature bit checks so that they work correctly and not
by chance.

The current code works on v4 filesystems only because the dirent
size roundup covers the extra byte needed by the dtype field in the
places where this problem occurs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/check.c                |  2 +-
 include/xfs_dir2_format.h | 51 +++++++++++++++++++----------------------------
 libxfs/xfs_dir2_block.c   |  6 +++---
 libxfs/xfs_dir2_sf.c      |  6 +++---
 repair/dir2.c             |  4 ++--
 5 files changed, 29 insertions(+), 40 deletions(-)

diff --git a/db/check.c b/db/check.c
index 2d4718d..4867698 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3434,7 +3434,7 @@ process_sf_dir_v2(
 		dbprintf(_("dir %lld entry . %lld\n"), id->ino, id->ino);
 	(*dot)++;
 	sfe = xfs_dir2_sf_firstentry(sf);
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
+	offset = xfs_dir3_data_first_offset(mp);
 	for (i = sf->count - 1, i8 = 0; i >= 0; i--) {
 		if ((__psint_t)sfe + xfs_dir3_sf_entsize(mp, sf, sfe->namelen) -
 		    (__psint_t)sf > be64_to_cpu(dip->di_size)) {
diff --git a/include/xfs_dir2_format.h b/include/xfs_dir2_format.h
index a0961a6..9cf6738 100644
--- a/include/xfs_dir2_format.h
+++ b/include/xfs_dir2_format.h
@@ -497,69 +497,58 @@ xfs_dir3_data_unused_p(struct xfs_dir2_data_hdr *hdr)
 /*
  * Offsets of . and .. in data space (always block 0)
  *
- * The macros are used for shortform directories as they have no headers to read
- * the magic number out of. Shortform directories need to know the size of the
- * data block header because the sfe embeds the block offset of the entry into
- * it so that it doesn't change when format conversion occurs. Bad Things Happen
- * if we don't follow this rule.
- *
  * XXX: there is scope for significant optimisation of the logic here. Right
  * now we are checking for "dir3 format" over and over again. Ideally we should
  * only do it once for each operation.
  */
-#define	XFS_DIR3_DATA_DOT_OFFSET(mp)	\
-	xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&(mp)->m_sb))
-#define	XFS_DIR3_DATA_DOTDOT_OFFSET(mp)	\
-	(XFS_DIR3_DATA_DOT_OFFSET(mp) + xfs_dir3_data_entsize(mp, 1))
-#define	XFS_DIR3_DATA_FIRST_OFFSET(mp)		\
-	(XFS_DIR3_DATA_DOTDOT_OFFSET(mp) + xfs_dir3_data_entsize(mp, 2))
-
 static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_dot_offset(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_dot_offset(struct xfs_mount *mp)
 {
-	return xfs_dir3_data_entry_offset(hdr);
+	return xfs_dir3_data_hdr_size(xfs_sb_version_hascrc(&mp->m_sb));
 }
 
 static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_dotdot_offset(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_dotdot_offset(struct xfs_mount *mp)
 {
-	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
-	return xfs_dir3_data_dot_offset(hdr) +
-		__xfs_dir3_data_entsize(dir3, 1);
+	return xfs_dir3_data_dot_offset(mp) +
+		xfs_dir3_data_entsize(mp, 1);
 }
 
 static inline xfs_dir2_data_aoff_t
-xfs_dir3_data_first_offset(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_first_offset(struct xfs_mount *mp)
 {
-	bool dir3 = hdr->magic == cpu_to_be32(XFS_DIR3_DATA_MAGIC) ||
-		    hdr->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC);
-	return xfs_dir3_data_dotdot_offset(hdr) +
-		__xfs_dir3_data_entsize(dir3, 2);
+	return xfs_dir3_data_dotdot_offset(mp) +
+		xfs_dir3_data_entsize(mp, 2);
 }
 
 /*
  * location of . and .. in data space (always block 0)
  */
 static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_dot_entry_p(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_dot_entry_p(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dot_offset(hdr));
+		((char *)hdr + xfs_dir3_data_dot_offset(mp));
 }
 
 static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_dotdot_entry_p(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_dotdot_entry_p(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_dotdot_offset(hdr));
+		((char *)hdr + xfs_dir3_data_dotdot_offset(mp));
 }
 
 static inline struct xfs_dir2_data_entry *
-xfs_dir3_data_first_entry_p(struct xfs_dir2_data_hdr *hdr)
+xfs_dir3_data_first_entry_p(
+	struct xfs_mount	*mp,
+	struct xfs_dir2_data_hdr *hdr)
 {
 	return (struct xfs_dir2_data_entry *)
-		((char *)hdr + xfs_dir3_data_first_offset(hdr));
+		((char *)hdr + xfs_dir3_data_first_offset(mp));
 }
 
 /*
diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c
index 3e4bc53..1d8f598 100644
--- a/libxfs/xfs_dir2_block.c
+++ b/libxfs/xfs_dir2_block.c
@@ -1139,7 +1139,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for .
 	 */
-	dep = xfs_dir3_data_dot_entry_p(hdr);
+	dep = xfs_dir3_data_dot_entry_p(mp, hdr);
 	dep->inumber = cpu_to_be64(dp->i_ino);
 	dep->namelen = 1;
 	dep->name[0] = '.';
@@ -1153,7 +1153,7 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Create entry for ..
 	 */
-	dep = xfs_dir3_data_dotdot_entry_p(hdr);
+	dep = xfs_dir3_data_dotdot_entry_p(mp, hdr);
 	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_parent_ino(sfp));
 	dep->namelen = 2;
 	dep->name[0] = dep->name[1] = '.';
@@ -1164,7 +1164,7 @@ xfs_dir2_sf_to_block(
 	blp[1].hashval = cpu_to_be32(xfs_dir_hash_dotdot);
 	blp[1].address = cpu_to_be32(xfs_dir2_byte_to_dataptr(mp,
 				(char *)dep - (char *)hdr));
-	offset = xfs_dir3_data_first_offset(hdr);
+	offset = xfs_dir3_data_first_offset(mp);
 	/*
 	 * Loop over existing entries, stuff them in.
 	 */
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 740cab0..7580333 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -540,7 +540,7 @@ xfs_dir2_sf_addname_hard(
 	 * to insert the new entry.
 	 * If it's going to end up at the end then oldsfep will point there.
 	 */
-	for (offset = XFS_DIR3_DATA_FIRST_OFFSET(mp),
+	for (offset = xfs_dir3_data_first_offset(mp),
 	      oldsfep = xfs_dir2_sf_firstentry(oldsfp),
 	      add_datasize = xfs_dir3_data_entsize(mp, args->namelen),
 	      eof = (char *)oldsfep == &buf[old_isize];
@@ -623,7 +623,7 @@ xfs_dir2_sf_addname_pick(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	size = xfs_dir3_data_entsize(mp, args->namelen);
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
+	offset = xfs_dir3_data_first_offset(mp);
 	sfep = xfs_dir2_sf_firstentry(sfp);
 	holefit = 0;
 	/*
@@ -696,7 +696,7 @@ xfs_dir2_sf_check(
 	mp = dp->i_mount;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
+	offset = xfs_dir3_data_first_offset(mp);
 	ino = xfs_dir2_sf_get_parent_ino(sfp);
 	i8count = ino > XFS_DIR2_MAX_SHORT_INUM;
 
diff --git a/repair/dir2.c b/repair/dir2.c
index a856631..d931d1d 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -705,7 +705,7 @@ process_sf_dir2_fixoff(
 
 	sfp = (struct xfs_dir2_sf_hdr *)XFS_DFORK_DPTR(dip);
 	sfep = xfs_dir2_sf_firstentry(sfp);
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
+	offset = xfs_dir3_data_first_offset(mp);
 
 	for (i = 0; i < sfp->count; i++) {
 		xfs_dir2_sf_put_offset(sfep, offset);
@@ -759,7 +759,7 @@ process_sf_dir2(
 	max_size = XFS_DFORK_DSIZE(dip, mp);
 	num_entries = sfp->count;
 	ino_dir_size = be64_to_cpu(dip->di_size);
-	offset = XFS_DIR3_DATA_FIRST_OFFSET(mp);
+	offset = xfs_dir3_data_first_offset(mp);
 	bad_offset = *repair = 0;
 
 	ASSERT(ino_dir_size <= max_size);
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
