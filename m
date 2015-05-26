Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7464F29E04
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 17:51:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49CD6304043
	for <xfs@oss.sgi.com>; Tue, 26 May 2015 15:51:52 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 6jNp9H8iWb9b42tz (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 May 2015 15:51:50 -0700 (PDT)
Subject: [PATCH 3/5] xfs_repair: ensure .. is set to a sane ino value when
	rebuilding dir
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 26 May 2015 15:51:46 -0700
Message-ID: <20150526225146.26434.98106.stgit@birch.djwong.org>
In-Reply-To: <20150526225126.26434.69010.stgit@birch.djwong.org>
References: <20150526225126.26434.69010.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

When we're rebuilding a directory, ensure that we reinitialize the
directory with a sane parent ('..') inode value.  If we don't, the
error return from xfs_dir_init() is ignored, and the rebuild process
becomes confused and leaves the directory corrupt.  If repair later
discovers that the rebuilt directory is an orphan, it'll try to attach
it to lost+found and abort on the corrupted directory.  Also fix
ignoring the return value of xfs_dir_init().

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_dir2.h     |    2 ++
 libxfs/xfs_dir2_priv.h |    1 -
 repair/phase6.c        |    9 +++++++--
 3 files changed, 9 insertions(+), 3 deletions(-)


diff --git a/include/xfs_dir2.h b/include/xfs_dir2.h
index 3900130..2d41c5f 100644
--- a/include/xfs_dir2.h
+++ b/include/xfs_dir2.h
@@ -100,6 +100,8 @@ extern void xfs_dir2_data_use_free(struct xfs_trans *tp, struct xfs_buf *bp,
 extern struct xfs_dir2_data_free *xfs_dir2_data_freefind(
 		struct xfs_dir2_data_hdr *hdr, struct xfs_dir2_data_unused *dup);
 
+extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
+
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leaf1_buf_ops;
diff --git a/libxfs/xfs_dir2_priv.h b/libxfs/xfs_dir2_priv.h
index 1bad84c..926715f 100644
--- a/libxfs/xfs_dir2_priv.h
+++ b/libxfs/xfs_dir2_priv.h
@@ -21,7 +21,6 @@
 struct dir_context;
 
 /* xfs_dir2.c */
-extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 extern int xfs_dir2_grow_inode(struct xfs_da_args *args, int space,
 				xfs_dir2_db_t *dbp);
 extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
diff --git a/repair/phase6.c b/repair/phase6.c
index efefb2b..145e497 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1321,7 +1321,8 @@ longform_dir2_rebuild(
 	 * for the libxfs_dir_init() call).
 	 */
 	pip.i_ino = get_inode_parent(irec, ino_offset);
-	if (pip.i_ino == NULLFSINO)
+	if (pip.i_ino == NULLFSINO ||
+	    xfs_dir_ino_validate(mp, pip.i_ino))
 		pip.i_ino = mp->m_sb.sb_rootino;
 
 	xfs_bmap_init(&flist, &firstblock);
@@ -1348,7 +1349,11 @@ longform_dir2_rebuild(
 
 	ASSERT(done);
 
-	libxfs_dir_init(tp, ip, &pip);
+	error = libxfs_dir_init(tp, ip, &pip);
+	if (error) {
+		do_warn(_("xfs_dir_init failed -- error - %d\n"), error);
+		goto out_bmap_cancel;
+	}
 
 	error = libxfs_bmap_finish(&tp, &flist, &committed);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
