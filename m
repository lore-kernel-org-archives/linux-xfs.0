Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 70BDD7F37
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 08:42:30 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41AFE30409B
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 06:42:30 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9NDgUaT002267
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 08:42:30 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131023133932.145199412@sgi.com>
Date: Wed, 23 Oct 2013 08:39:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [patch 5/4] xfsprogs: add field types to v4 xfs_db directory entries
References: <20131017152804.204045257@sgi.com>
Content-Disposition: inline;
	filename=5-4-xfsprog-add-ftype-to-xfs_db-v4-dirs.patch
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
To: XFS Community List <xfs@oss.sgi.com>

Display the inode type field that follows the name in xfs_db
for dir2 (non-crc filesystems) that enabled the feature
(mkfs -n ftype).

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 db/dir2.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: b/db/dir2.c
===================================================================
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -52,6 +52,8 @@ static int	dir2_leaf_tail_count(void *ob
 static int	dir2_leaf_tail_offset(void *obj, int startoff, int idx);
 static int	dir2_node_btree_count(void *obj, int startoff);
 static int	dir2_node_hdr_count(void *obj, int startoff);
+static int	dir3_data_union_ftype_offset(void *obj, int startoff, int idx);
+static int	dir2_data_union_ftype_count(void *obj, int startoff);
 
 const field_t	dir2_hfld[] = {
 	{ "", FLDT_DIR2, OI(0), C1, 0, TYP_NONE },
@@ -130,6 +132,8 @@ const field_t	dir2_data_union_flds[] = {
 	  dir2_data_union_namelen_count, FLD_COUNT, TYP_NONE },
 	{ "name", FLDT_CHARNS, OI(DEOFF(name)), dir2_data_union_name_count,
 	  FLD_COUNT, TYP_NONE },
+	{ "filetype", FLDT_UINT8D, dir3_data_union_ftype_offset,
+	  dir2_data_union_ftype_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ "tag", FLDT_DIR2_DATA_OFF, dir2_data_union_tag_offset,
 	  dir2_data_union_tag_count, FLD_OFFSET|FLD_COUNT, TYP_NONE },
 	{ NULL }
@@ -454,6 +458,14 @@ dir2_data_union_name_count(
 }
 
 static int
+dir2_data_union_ftype_count(
+	void			*obj,
+	int			startoff)
+{
+	return xfs_sb_version_hasftype(&mp->m_sb);
+}
+
+static int
 dir2_data_union_namelen_count(
 	void			*obj,
 	int			startoff)


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
