Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 662D37F47
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 00:44:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29E398F8081
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 22:44:56 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id PgMWGlOEC8brU3uG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 22:44:53 -0700 (PDT)
Date: Tue, 26 May 2015 22:44:50 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 2/5] xfs_repair: better checking of v5 metadata fields
Message-ID: <20150527054450.GA10175@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
	<20150526225139.26434.37575.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150526225139.26434.37575.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Check the UUID, owner, and block number fields during repair, looking for
blocks that fail either the checksum or the data structure verifiers.  For
directories we can simply rebuild corrupt/broken index data, though for
anything else we have to toss out the broken object.

v2: Refactor the directory block header checks into a single function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dir2.c   |    7 +++
 repair/phase6.c |  121 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 repair/scan.c   |   19 ++++++++-
 3 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/repair/dir2.c b/repair/dir2.c
index c6d618d..644c214 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -198,6 +198,13 @@ _("bad dir magic number 0x%x in inode %" PRIu64 " bno = %u\n"),
 					da_cursor->ino, bno);
 			goto error_out;
 		}
+		/* corrupt node; rebuild the dir. */
+		if (bp->b_error == EFSBADCRC || bp->b_error == EFSCORRUPTED) {
+			do_warn(
+_("corrupt tree block %u for directory inode %" PRIu64 "\n"),
+				bno, da_cursor->ino);
+			goto error_out;
+		}
 		btree = xfs_da3_node_tree_p(node);
 		if (nodehdr.count > mp->m_dir_node_ents)  {
 			libxfs_putbuf(bp);
diff --git a/repair/phase6.c b/repair/phase6.c
index c09b394..7dd868c 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1925,6 +1925,69 @@ _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 "
 	freetab->ents[db].s = 0;
 }
 
+/* check v5 metadata */
+static int
+__check_dir3_header(
+	xfs_mount_t			*mp,
+	xfs_buf_t			*bp,
+	xfs_ino_t			ino,
+	__be64				owner,
+	__be64				blkno,
+	uuid_t				*uuid)
+{
+
+	/* verify owner */
+	if (be64_to_cpu(owner) != ino) {
+		do_warn(
+_("expected owner inode %" PRIu64 ", got %llu, directory block %" PRIu64 "\n"),
+			ino, be64_to_cpu(owner), bp->b_bn);
+		return 1;
+	}
+	/* verify block number */
+	if (be64_to_cpu(blkno) != bp->b_bn) {
+		do_warn(
+_("expected block %" PRIu64 ", got %llu, directory inode %" PRIu64 "\n"),
+			bp->b_bn, be64_to_cpu(blkno), ino);
+		return 1;
+	}
+	/* verify uuid */
+	if (platform_uuid_compare(uuid,
+				  &mp->m_sb.sb_uuid) != 0) {
+		do_warn(
+_("wrong FS UUID, directory inode %" PRIu64 " block %" PRIu64 "\n"),
+			ino, bp->b_bn);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int
+check_da3_header(
+	xfs_mount_t			*mp,
+	xfs_buf_t			*bp,
+	xfs_ino_t			ino)
+{
+	struct xfs_da3_blkinfo		*info;
+
+	info = bp->b_addr;
+	return __check_dir3_header(mp, bp, ino, info->owner, info->blkno,
+				   &info->uuid);
+}
+
+static int
+check_dir3_header(
+	xfs_mount_t			*mp,
+	xfs_buf_t			*bp,
+	xfs_ino_t			ino)
+{
+	struct xfs_dir3_blk_hdr		*info;
+
+	info = bp->b_addr;
+	return __check_dir3_header(mp, bp, ino, info->owner, info->blkno,
+				   &info->uuid);
+}
+
 /*
  * Check contents of leaf-form block.
  */
@@ -1981,6 +2044,15 @@ longform_dir2_check_leaf(
 		libxfs_putbuf(bp);
 		return 1;
 	}
+
+	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
+		error = check_da3_header(mp, bp, ip->i_ino);
+		if (error) {
+			libxfs_putbuf(bp);
+			return error;
+		}
+	}
+
 	seeval = dir_hash_see_all(hashtab, ents, leafhdr.count, leafhdr.stale);
 	if (dir_hash_check(hashtab, ip, seeval)) {
 		libxfs_putbuf(bp);
@@ -2055,12 +2127,9 @@ longform_dir2_check_node(
 		xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
 		ents = xfs_dir3_leaf_ents_p(leaf);
 		if (!(leafhdr.magic == XFS_DIR2_LEAFN_MAGIC ||
-		      leafhdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
-			if (leafhdr.magic == XFS_DA_NODE_MAGIC ||
-			    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
-				libxfs_putbuf(bp);
-				continue;
-			}
+		      leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
+		      leafhdr.magic == XFS_DA_NODE_MAGIC ||
+		      leafhdr.magic == XFS_DA3_NODE_MAGIC)) {
 			do_warn(
 	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
 				leafhdr.magic, da_bno, ip->i_ino);
@@ -2068,6 +2137,23 @@ longform_dir2_check_node(
 			return 1;
 		}
 
+		/* check v5 metadata */
+		if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
+		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
+			error = check_da3_header(mp, bp, ip->i_ino);
+			if (error) {
+				libxfs_putbuf(bp);
+				return error;
+			}
+		}
+
+		/* ignore nodes */
+		if (leafhdr.magic == XFS_DA_NODE_MAGIC ||
+		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
+			libxfs_putbuf(bp);
+			continue;
+		}
+
 		/*
 		 * If there's a validator error, we need to ensure that we got
 		 * the right ops on the buffer for when we write it back out.
@@ -2121,6 +2207,14 @@ longform_dir2_check_node(
 			libxfs_putbuf(bp);
 			return 1;
 		}
+
+		if (freehdr.magic == XFS_DIR3_FREE_MAGIC) {
+			error = check_dir3_header(mp, bp, ip->i_ino);
+			if (error) {
+				libxfs_putbuf(bp);
+				return error;
+			}
+		}
 		for (i = used = 0; i < freehdr.nvalid; i++) {
 			if (i + freehdr.firstdb >= freetab->nents ||
 					freetab->ents[i + freehdr.firstdb].v !=
@@ -2212,6 +2306,7 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 	     da_bno = (xfs_dablk_t)next_da_bno) {
 		const struct xfs_buf_ops *ops;
 		int			 error;
+		struct xfs_dir2_data_hdr *d;
 
 		next_da_bno = da_bno + mp->m_dirblkfsbs - 1;
 		if (bmap_next_offset(NULL, ip, &next_da_bno, XFS_DATA_FORK)) {
@@ -2260,6 +2355,20 @@ longform_dir2_entry_check(xfs_mount_t	*mp,
 			}
 			continue;
 		}
+
+		/* check v5 metadata */
+		d = bplist[db]->b_addr;
+		if (be32_to_cpu(d->magic) == XFS_DIR3_BLOCK_MAGIC ||
+		    be32_to_cpu(d->magic) == XFS_DIR3_DATA_MAGIC) {
+			struct xfs_buf		 *bp = bplist[db];
+
+			error = check_dir3_header(mp, bp, ino);
+			if (error) {
+				fixit++;
+				continue;
+			}
+		}
+
 		longform_dir2_entry_check_data(mp, ip, num_illegal, need_dot,
 				irec, ino_offset, &bplist[db], hashtab,
 				&freetab, da_bno, isblock);
diff --git a/repair/scan.c b/repair/scan.c
index 12aa782..6508a47 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -225,7 +225,24 @@ _("expected level %d got %d in inode %" PRIu64 ", (%s fork) bmbt block %" PRIu64
 			do_warn(
 _("expected owner inode %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
 				ino, be64_to_cpu(block->bb_u.l.bb_owner), bno);
-			return(1);
+			return 1;
+		}
+		/* verify block number */
+		if (be64_to_cpu(block->bb_u.l.bb_blkno) !=
+		    XFS_FSB_TO_DADDR(mp, bno)) {
+			do_warn(
+_("expected block %" PRIu64 ", got %llu, bmbt block %" PRIu64 "\n"),
+				XFS_FSB_TO_DADDR(mp, bno),
+				be64_to_cpu(block->bb_u.l.bb_blkno), bno);
+			return 1;
+		}
+		/* verify uuid */
+		if (platform_uuid_compare(&block->bb_u.l.bb_uuid,
+					  &mp->m_sb.sb_uuid) != 0) {
+			do_warn(
+_("wrong FS UUID, bmbt block %" PRIu64 "\n"),
+				bno);
+			return 1;
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
