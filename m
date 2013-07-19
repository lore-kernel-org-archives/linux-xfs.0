Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2EC2B809F
	for <xfs@oss.sgi.com>; Fri, 19 Jul 2013 01:46:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F05F8F8033
	for <xfs@oss.sgi.com>; Thu, 18 Jul 2013 23:46:03 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	tPKKWapZE2cs1LJm for <xfs@oss.sgi.com>;
	Thu, 18 Jul 2013 23:46:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V04RT-0004J3-Ka
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V04RT-0002Mz-IO
	for xfs@oss.sgi.com; Fri, 19 Jul 2013 16:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 49/49] xfsprogs: add dtype support to mkfs and db
Date: Fri, 19 Jul 2013 16:45:24 +1000
Message-Id: <1374216324-8781-50-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-1-git-send-email-david@fromorbit.com>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
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

Now that we have an extra field in the dirent, add support into
xfs_db to be able to view it when looking at directory structures.

Add support to mkfs to create filesystems with filetype - we'll
always set it on CRC enabled filesystems so all new v5 filesystems
will have this functionality enabled.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/dir2.c       | 41 ++++++++++++++++++++++++++++++++++++++++-
 db/dir2.h       |  1 +
 db/dir2sf.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 db/dir2sf.h     |  3 +++
 db/field.c      |  7 +++++++
 db/field.h      |  3 +++
 db/inode.c      | 23 +++++++++++++++++++++--
 mkfs/xfs_mkfs.c |  7 +++++++
 8 files changed, 133 insertions(+), 4 deletions(-)

diff --git a/db/dir2.c b/db/dir2.c
index 39042b3..53fe961 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -596,6 +596,25 @@ dir2_data_union_size(
 	}
 }
 
+static int
+dir3_data_union_ftype_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	xfs_dir2_data_entry_t	*dep;
+	xfs_dir2_data_unused_t	*dup;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(idx == 0);
+	dup = (xfs_dir2_data_unused_t *)((char *)obj + byteize(startoff));
+	if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG)
+		return bitize((int)((char *)xfs_dir2_data_unused_tag_p(dup) -
+				    (char *)dup));
+	dep = (xfs_dir2_data_entry_t *)dup;
+	return bitize((int)((char *)&dep->name[dep->namelen] - (char *)dep));
+}
+
 /*
  * Free block functions
  */
@@ -859,7 +878,7 @@ const field_t	dir3_flds[] = {
 	  dir3_block_tail_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "dhdr", FLDT_DIR3_DATA_HDR, OI(D3OFF(hdr)), dir3_data_hdr_count,
 	  FLD_COUNT, TYP_NONE },
-	{ "du", FLDT_DIR2_DATA_UNION, dir2_data_u_offset, dir2_data_u_count,
+	{ "du", FLDT_DIR3_DATA_UNION, dir2_data_u_offset, dir2_data_u_count,
 	  FLD_ARRAY|FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "lhdr", FLDT_DIR3_LEAF_HDR, OI(L3OFF(hdr)), dir3_leaf_hdr_count,
 	  FLD_COUNT, TYP_NONE },
@@ -880,6 +899,26 @@ const field_t	dir3_flds[] = {
 	{ NULL }
 };
 
+#define	D3EOFF(f)	bitize(offsetof(xfs_dir2_data_entry_t, f))
+#define	D3UOFF(f)	bitize(offsetof(xfs_dir2_data_unused_t, f))
+const field_t	dir3_data_union_flds[] = {
+	{ "freetag", FLDT_UINT16X, OI(D3UOFF(freetag)),
+	  dir2_data_union_freetag_count, FLD_COUNT, TYP_NONE },
+	{ "inumber", FLDT_INO, OI(D3EOFF(inumber)),
+	  dir2_data_union_inumber_count, FLD_COUNT, TYP_INODE },
+	{ "length", FLDT_DIR2_DATA_OFF, OI(D3UOFF(length)),
+	  dir2_data_union_length_count, FLD_COUNT, TYP_NONE },
+	{ "namelen", FLDT_UINT8D, OI(D3EOFF(namelen)),
+	  dir2_data_union_namelen_count, FLD_COUNT, TYP_NONE },
+	{ "name", FLDT_CHARNS, OI(D3EOFF(name)), dir2_data_union_name_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "filetype", FLDT_UINT8D, dir3_data_union_ftype_offset, C1,
+	  FLD_OFFSET, TYP_NONE },
+	{ "tag", FLDT_DIR2_DATA_OFF, dir2_data_union_tag_offset,
+	  dir2_data_union_tag_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
+	{ NULL }
+};
+
 #define	DBH3OFF(f)	bitize(offsetof(struct xfs_dir3_blk_hdr, f))
 const field_t	dir3_blkhdr_flds[] = {
 	{ "magic", FLDT_UINT32X, OI(DBH3OFF(magic)), C1, 0, TYP_NONE },
diff --git a/db/dir2.h b/db/dir2.h
index d9dc27b..b3651d5 100644
--- a/db/dir2.h
+++ b/db/dir2.h
@@ -48,6 +48,7 @@ extern const field_t	dir3_blkhdr_flds[];
 extern const field_t	dir3_data_hdr_flds[];
 extern const field_t	dir3_free_hdr_flds[];
 extern const field_t	dir3_leaf_hdr_flds[];
+extern const field_t	dir3_data_union_flds[];
 
 extern const field_t	da3_blkinfo_flds[];
 extern const field_t	da3_node_hdr_flds[];
diff --git a/db/dir2sf.c b/db/dir2sf.c
index d628641..5285647 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -127,7 +127,6 @@ dir2_sf_entry_name_count(
 	return e->namelen;
 }
 
-/*ARGSUSED*/
 static int
 dir2_sf_entry_inumber_offset(
 	void			*obj,
@@ -142,6 +141,35 @@ dir2_sf_entry_inumber_offset(
 	return bitize((int)((char *)xfs_dir2_sf_inumberp(e) - (char *)e));
 }
 
+static int
+dir3_sf_entry_inumber_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	xfs_dir2_sf_entry_t	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(idx == 0);
+	e = (xfs_dir2_sf_entry_t *)((char *)obj + byteize(startoff));
+	/* plus 1 to skip the ftype entry */
+	return bitize((int)((char *)xfs_dir2_sf_inumberp(e) + 1 - (char *)e));
+}
+
+static int
+dir3_sf_entry_ftype_offset(
+	void			*obj,
+	int			startoff,
+	int			idx)
+{
+	xfs_dir2_sf_entry_t	*e;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(idx == 0);
+	e = (xfs_dir2_sf_entry_t *)((char *)obj + byteize(startoff));
+	return bitize((int)((char *)&e->name[e->namelen] - (char *)e));
+}
+
 int
 dir2_sf_entry_size(
 	void			*obj,
@@ -224,3 +252,25 @@ dir2sf_size(
 		e = xfs_dir3_sf_nextentry(mp, sf, e);
 	return bitize((int)((char *)e - (char *)sf));
 }
+
+#define	OFF(f)	bitize(offsetof(struct xfs_dir2_sf_hdr, f))
+const field_t	dir3sf_flds[] = {
+	{ "hdr", FLDT_DIR2_SF_HDR, OI(OFF(count)), C1, 0, TYP_NONE },
+	{ "list", FLDT_DIR3_SF_ENTRY, dir2_sf_list_offset, dir2_sf_list_count,
+	  FLD_ARRAY|FLD_COUNT|FLD_OFFSET, TYP_NONE },
+	{ NULL }
+};
+
+#define	E3OFF(f)	bitize(offsetof(xfs_dir2_sf_entry_t, f))
+const field_t	dir3_sf_entry_flds[] = {
+	{ "namelen", FLDT_UINT8D, OI(EOFF(namelen)), C1, 0, TYP_NONE },
+	{ "offset", FLDT_DIR2_SF_OFF, OI(EOFF(offset)), C1, 0, TYP_NONE },
+	{ "name", FLDT_CHARNS, OI(EOFF(name)), dir2_sf_entry_name_count,
+	  FLD_COUNT, TYP_NONE },
+	{ "inumber", FLDT_DIR2_INOU, dir3_sf_entry_inumber_offset, C1,
+	  FLD_OFFSET, TYP_NONE },
+	{ "filetype", FLDT_UINT8D, dir3_sf_entry_ftype_offset, C1,
+	  FLD_OFFSET, TYP_NONE },
+	{ NULL }
+};
+
diff --git a/db/dir2sf.h b/db/dir2sf.h
index 66d229c..cabe5b4 100644
--- a/db/dir2sf.h
+++ b/db/dir2sf.h
@@ -21,6 +21,9 @@ extern const field_t	dir2_inou_flds[];
 extern const field_t	dir2_sf_hdr_flds[];
 extern const field_t	dir2_sf_entry_flds[];
 
+extern const field_t	dir3sf_flds[];
+extern const field_t	dir3_sf_entry_flds[];
+
 extern int	dir2sf_size(void *obj, int startoff, int idx);
 extern int	dir2_inou_size(void *obj, int startoff, int idx);
 extern int	dir2_sf_entry_size(void *obj, int startoff, int idx);
diff --git a/db/field.c b/db/field.c
index e4f6c7d..c6d7404 100644
--- a/db/field.c
+++ b/db/field.c
@@ -235,6 +235,13 @@ const ftattr_t	ftattrtab[] = {
 	  SI(bitsz(struct xfs_dir3_free_hdr)), 0, NULL, dir3_free_hdr_flds },
 	{ FLDT_DIR3_LEAF_HDR, "dir3_leaf_hdr", NULL, (char *)dir3_leaf_hdr_flds,
 	  SI(bitsz(struct xfs_dir3_leaf_hdr)), 0, NULL, dir3_leaf_hdr_flds },
+	{ FLDT_DIR3_DATA_UNION, "dir3_data_union", NULL,
+	  (char *)dir3_data_union_flds, dir2_data_union_size, FTARG_SIZE, NULL,
+	  dir3_data_union_flds },
+	{ FLDT_DIR3_SF_ENTRY, "dir3_sf_entry", NULL, (char *)dir3_sf_entry_flds,
+	  dir2_sf_entry_size, FTARG_SIZE, NULL, dir3_sf_entry_flds },
+	{ FLDT_DIR3SF, "dir3sf", NULL, (char *)dir3sf_flds, dir2sf_size,
+	  FTARG_SIZE, NULL, dir3sf_flds },
 
 /* dir v2/3 node fields */
 	{ FLDT_DA_BLKINFO, "dir_blkinfo", NULL, (char *)da_blkinfo_flds,
diff --git a/db/field.h b/db/field.h
index b97d917..aecdf9f 100644
--- a/db/field.h
+++ b/db/field.h
@@ -116,6 +116,9 @@ typedef enum fldt	{
 	FLDT_DIR3_DATA_HDR,
 	FLDT_DIR3_FREE_HDR,
 	FLDT_DIR3_LEAF_HDR,
+	FLDT_DIR3_DATA_UNION,
+	FLDT_DIR3_SF_ENTRY,
+	FLDT_DIR3SF,
 
 	/* dir v2/3 node fields */
 	FLDT_DA_BLKINFO,
diff --git a/db/inode.c b/db/inode.c
index 68ef564..7038c18 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -47,6 +47,7 @@ static int	inode_u_c_count(void *obj, int startoff);
 static int	inode_u_dev_count(void *obj, int startoff);
 static int	inode_u_muuid_count(void *obj, int startoff);
 static int	inode_u_sfdir2_count(void *obj, int startoff);
+static int	inode_u_sfdir3_count(void *obj, int startoff);
 static int	inode_u_symlink_count(void *obj, int startoff);
 
 static const cmdinfo_t	inode_cmd =
@@ -78,7 +79,7 @@ const field_t	inode_crc_flds[] = {
 	{ "next_unlinked", FLDT_AGINO, OI(OFF(next_unlinked)), C1, 0,
 	  TYP_INODE },
 	{ "v3", FLDT_DINODE_V3, OI(OFF(magic)), C1, 0, TYP_NONE },
-	{ "u", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
+	{ "u3", FLDT_DINODE_U, inode_u_offset, C1, FLD_OFFSET, TYP_NONE },
 	{ "a", FLDT_DINODE_A, inode_a_offset, inode_a_count,
 	  FLD_COUNT|FLD_OFFSET, TYP_NONE },
 	{ NULL }
@@ -193,6 +194,7 @@ const field_t	inode_u_flds[] = {
 	{ "dev", FLDT_DEV, NULL, inode_u_dev_count, FLD_COUNT, TYP_NONE },
 	{ "muuid", FLDT_UUID, NULL, inode_u_muuid_count, FLD_COUNT, TYP_NONE },
 	{ "sfdir2", FLDT_DIR2SF, NULL, inode_u_sfdir2_count, FLD_COUNT, TYP_NONE },
+	{ "sfdir3", FLDT_DIR3SF, NULL, inode_u_sfdir3_count, FLD_COUNT, TYP_NONE },
 	{ "symlink", FLDT_CHARNS, NULL, inode_u_symlink_count, FLD_COUNT,
 	  TYP_NONE },
 	{ NULL }
@@ -556,7 +558,24 @@ inode_u_sfdir2_count(
 	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
 	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
 	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
-	       xfs_sb_version_hasdirv2(&mp->m_sb);
+	       xfs_sb_version_hasdirv2(&mp->m_sb) &&
+	       !xfs_sb_version_hasftype(&mp->m_sb);
+}
+
+static int
+inode_u_sfdir3_count(
+	void		*obj,
+	int		startoff)
+{
+	xfs_dinode_t	*dip;
+
+	ASSERT(bitoffs(startoff) == 0);
+	ASSERT(obj == iocur_top->data);
+	dip = obj;
+	ASSERT((char *)XFS_DFORK_DPTR(dip) - (char *)dip == byteize(startoff));
+	return dip->di_format == XFS_DINODE_FMT_LOCAL &&
+	       (be16_to_cpu(dip->di_mode) & S_IFMT) == S_IFDIR &&
+	       xfs_sb_version_hasftype(&mp->m_sb);
 }
 
 int
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 62e4d27..2a172cc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2513,6 +2513,13 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 							lsectorsize != BBSIZE),
 					nci, sbp->sb_features2 != 0);
 	/*
+	 * dirent filetype field always enabled on v5 superblocks
+	 */
+	if (crcs_enabled) {
+		sbp->sb_features_incompat = XFS_SB_FEAT_INCOMPAT_FTYPE;
+	}
+
+	/*
 	 * Due to a structure alignment issue, sb_features2 ended up in one
 	 * of two locations, the second "incorrect" location represented by
 	 * the sb_bad_features2 field. To avoid older kernels mounting
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
