Return-Path: <SRS0=C5JC=AS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672CDC433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 19:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40E1F20773
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Jul 2020 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594151980;
	bh=wBUoZXp791DtM0idK2+sP5gdsYPKyaALxH32+tVv6O0=;
	h=Date:From:To:Cc:Subject:List-ID:From;
	b=Tva15CXMk6zQhv1WxT/qSTLQoaDc1NR2wcWrP6IiAyuaMO+eBdX+QAC2sUo8hHx2K
	 mmBLB9u0ZwHIfRRL3jZjYacu8QfM+Y6vkoPoTk7feJ9b2drJZrw1J3mCGC8W/qKlAx
	 ClVTYEJSM7mZ5wv4IekpQJ5TU3oHtou0dEghYdok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgGGT7j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 15:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgGGT7j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 7 Jul 2020 15:59:39 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E2E1206F6;
        Tue,  7 Jul 2020 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594151977;
        bh=wBUoZXp791DtM0idK2+sP5gdsYPKyaALxH32+tVv6O0=;
        h=Date:From:To:Cc:Subject:From;
        b=Bko9YNNVLC1f6MjlmJnmCwlQ0+04wBUeJIJ0YYZGJp3T7zGsEi902zVRUWGmMpJGd
         jBcYGTBjwDQPOW2gya1jjjHpmvOce2W5qyE11/XsOQR4ewFHzqDkpxnSb+XHFR1JVZ
         kjrj4i40iMEtN5JLMO57xnka0hs62fdxLCWooVBM=
Date:   Tue, 7 Jul 2020 15:05:04 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH] xfs: Use fallthrough pseudo-keyword
Message-ID: <20200707200504.GA4796@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/xfs/libxfs/xfs_ag_resv.c   |    4 ++--
 fs/xfs/libxfs/xfs_alloc.c     |    2 +-
 fs/xfs/libxfs/xfs_da_btree.c  |    2 +-
 fs/xfs/libxfs/xfs_inode_buf.c |    4 ++--
 fs/xfs/scrub/bmap.c           |    2 +-
 fs/xfs/scrub/btree.c          |    2 +-
 fs/xfs/scrub/common.c         |    6 +++---
 fs/xfs/scrub/dabtree.c        |    2 +-
 fs/xfs/scrub/repair.c         |    2 +-
 fs/xfs/xfs_bmap_util.c        |    2 +-
 fs/xfs/xfs_export.c           |    4 ++--
 fs/xfs/xfs_file.c             |    2 +-
 fs/xfs/xfs_fsmap.c            |    2 +-
 fs/xfs/xfs_inode.c            |    2 +-
 fs/xfs/xfs_ioctl.c            |    4 ++--
 fs/xfs/xfs_iomap.c            |    2 +-
 fs/xfs/xfs_trans_buf.c        |    2 +-
 17 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
index fdfe6dc0d307..0b061a027e4e 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.c
+++ b/fs/xfs/libxfs/xfs_ag_resv.c
@@ -338,7 +338,7 @@ xfs_ag_resv_alloc_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		fallthrough;
 	case XFS_AG_RESV_NONE:
 		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
 				       XFS_TRANS_SB_FDBLOCKS;
@@ -380,7 +380,7 @@ xfs_ag_resv_free_extent(
 		break;
 	default:
 		ASSERT(0);
-		/* fall through */
+		fallthrough;
 	case XFS_AG_RESV_NONE:
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
 		return;
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa..6b153e6ee342 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3119,7 +3119,7 @@ xfs_alloc_vextent(
 		}
 		args->agbno = XFS_FSB_TO_AGBNO(mp, args->fsbno);
 		args->type = XFS_ALLOCTYPE_NEAR_BNO;
-		/* FALLTHROUGH */
+		fallthrough;
 	case XFS_ALLOCTYPE_FIRST_AG:
 		/*
 		 * Rotate through the allocation groups looking for a winner.
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 897749c41f36..c48beec0c0df 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -276,7 +276,7 @@ xfs_da3_node_read_verify(
 						__this_address);
 				break;
 			}
-			/* fall through */
+			fallthrough;
 		case XFS_DA_NODE_MAGIC:
 			fa = xfs_da3_node_verify(bp);
 			if (fa)
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 6f84ea85fdd8..63b0d86ff985 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -439,8 +439,8 @@ xfs_dinode_verify_forkoff(
 		if (dip->di_forkoff != (roundup(sizeof(xfs_dev_t), 8) >> 3))
 			return __this_address;
 		break;
-	case XFS_DINODE_FMT_LOCAL:	/* fall through ... */
-	case XFS_DINODE_FMT_EXTENTS:    /* fall through ... */
+	case XFS_DINODE_FMT_LOCAL:
+	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
 		if (dip->di_forkoff >= (XFS_LITINO(mp) >> 3))
 			return __this_address;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 7badd6dfe544..10e8599b34f6 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -252,7 +252,7 @@ xchk_bmap_iextent_xref(
 	case XFS_DATA_FORK:
 		if (xfs_is_reflink_inode(info->sc->ip))
 			break;
-		/* fall through */
+		fallthrough;
 	case XFS_ATTR_FORK:
 		xchk_xref_is_not_shared(info->sc, agbno,
 				irec->br_blockcount);
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index f52a7b8256f9..990a379fc322 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -43,7 +43,7 @@ __xchk_btree_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		fallthrough;
 	default:
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 18876056e5e0..63f13c8ed8c7 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -81,7 +81,7 @@ __xchk_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		fallthrough;
 	default:
 		trace_xchk_op_error(sc, agno, bno, *error,
 				ret_ip);
@@ -134,7 +134,7 @@ __xchk_fblock_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
-		/* fall through */
+		fallthrough;
 	default:
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
@@ -713,7 +713,7 @@ xchk_get_inode(
 		if (error)
 			return -ENOENT;
 		error = -EFSCORRUPTED;
-		/* fall through */
+		fallthrough;
 	default:
 		trace_xchk_op_error(sc,
 				XFS_INO_TO_AGNO(mp, sc->sm->sm_ino),
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 44b15015021f..238a0cab792c 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -47,7 +47,7 @@ xchk_da_process_error(
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		*error = 0;
-		/* fall through */
+		fallthrough;
 	default:
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index db3cfd12803d..90948ca758a7 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -944,7 +944,7 @@ xrep_ino_dqattach(
 			xrep_force_quotacheck(sc, XFS_DQ_GROUP);
 		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
 			xrep_force_quotacheck(sc, XFS_DQ_PROJ);
-		/* fall through */
+		fallthrough;
 	case -ESRCH:
 		error = 0;
 		break;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f37f5cc4b19f..035896e81104 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -244,7 +244,7 @@ xfs_bmap_count_blocks(
 		 */
 		*count += btblocks - 1;
 
-		/* fall through */
+		fallthrough;
 	case XFS_DINODE_FMT_EXTENTS:
 		*nextents = xfs_bmap_count_leaves(ifp, count);
 		break;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 5a4b0119143a..bc5fcb631c51 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -84,7 +84,7 @@ xfs_fs_encode_fh(
 	case FILEID_INO32_GEN_PARENT:
 		fid->i32.parent_ino = XFS_I(parent)->i_ino;
 		fid->i32.parent_gen = parent->i_generation;
-		/*FALLTHRU*/
+		fallthrough;
 	case FILEID_INO32_GEN:
 		fid->i32.ino = XFS_I(inode)->i_ino;
 		fid->i32.gen = inode->i_generation;
@@ -92,7 +92,7 @@ xfs_fs_encode_fh(
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
 		fid64->parent_ino = XFS_I(parent)->i_ino;
 		fid64->parent_gen = parent->i_generation;
-		/*FALLTHRU*/
+		fallthrough;
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
 		fid64->ino = XFS_I(inode)->i_ino;
 		fid64->gen = inode->i_generation;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 00db81eac80d..b85d1da85b82 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -769,7 +769,7 @@ xfs_break_layouts(
 			error = xfs_break_dax_layouts(inode, &retry);
 			if (error || retry)
 				break;
-			/* fall through */
+			fallthrough;
 		case BREAK_WRITE:
 			error = xfs_break_leased_layouts(inode, iolock, &retry);
 			break;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 4eebcec4aae6..c334550aeea7 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -100,7 +100,7 @@ xfs_fsmap_owner_to_rmap(
 		dest->rm_owner = XFS_RMAP_OWN_COW;
 		break;
 	case XFS_FMR_OWN_DEFECTIVE:	/* not implemented */
-		/* fall through */
+		fallthrough;
 	default:
 		return -EINVAL;
 	}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 9aea7d68d8ab..52ce37ed14de 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -906,7 +906,7 @@ xfs_ialloc(
 			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
 				ip->i_d.di_flags2 |= XFS_DIFLAG2_DAX;
 		}
-		/* FALLTHROUGH */
+		fallthrough;
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_flags = XFS_IFEXTENTS;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a190212ca85d..ea366a645c8e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -557,7 +557,7 @@ xfs_ioc_attrmulti_one(
 	case ATTR_OP_REMOVE:
 		value = NULL;
 		*len = 0;
-		/* fall through */
+		fallthrough;
 	case ATTR_OP_SET:
 		error = mnt_want_write_file(parfilp);
 		if (error)
@@ -1660,7 +1660,7 @@ xfs_ioc_getbmap(
 	switch (cmd) {
 	case XFS_IOC_GETBMAPA:
 		bmx.bmv_iflags = BMV_IF_ATTRFORK;
-		/*FALLTHRU*/
+		fallthrough;
 	case XFS_IOC_GETBMAP:
 		if (file->f_mode & FMODE_NOCMTIME)
 			bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b9a8c3798e08..fc4b65b24fdf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1002,7 +1002,7 @@ xfs_buffered_write_iomap_begin(
 			prealloc_blocks = 0;
 			goto retry;
 		}
-		/*FALLTHRU*/
+		fallthrough;
 	default:
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 08174ffa2118..ad79065607cc 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -310,7 +310,7 @@ xfs_trans_read_buf_map(
 	default:
 		if (tp && (tp->t_flags & XFS_TRANS_DIRTY))
 			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
-		/* fall through */
+		fallthrough;
 	case -ENOMEM:
 	case -EAGAIN:
 		return error;

