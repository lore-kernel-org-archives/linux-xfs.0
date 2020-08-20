Return-Path: <SRS0=hW3p=B6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E18C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 11:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5658F207BB
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Aug 2020 11:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730659AbgHTLrK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:47:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9793 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729640AbgHTLqy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Aug 2020 07:46:54 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D5DE7A295A6771F01718;
        Thu, 20 Aug 2020 19:46:44 +0800 (CST)
Received: from huawei.com (10.175.104.175) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 20 Aug 2020
 19:46:36 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <darrick.wong@oracle.com>, <cmaiolino@redhat.com>,
        <dchinner@redhat.com>, <bfoster@redhat.com>,
        <chandanrlinux@gmail.com>, <sandeen@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] xfs: Convert to use the preferred fallthrough macro
Date:   Thu, 20 Aug 2020 07:45:31 -0400
Message-ID: <20200820114531.47465-1-linmiaohe@huawei.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.175]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Convert the uses of fallthrough comments to fallthrough macro. Please see
commit 294f69e662d1 ("compiler_attributes.h: Add 'fallthrough' pseudo
keyword for switch/case use") for detail.

Signed-off-by: Hongxiang Lou <louhongxiang@huawei.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 fs/xfs/libxfs/xfs_ag_resv.c  | 4 ++--
 fs/xfs/libxfs/xfs_da_btree.c | 2 +-
 fs/xfs/scrub/bmap.c          | 2 +-
 fs/xfs/scrub/btree.c         | 2 +-
 fs/xfs/scrub/common.c        | 6 +++---
 fs/xfs/scrub/dabtree.c       | 2 +-
 fs/xfs/scrub/repair.c        | 2 +-
 fs/xfs/xfs_bmap_util.c       | 2 +-
 fs/xfs/xfs_file.c            | 2 +-
 fs/xfs/xfs_fsmap.c           | 2 +-
 fs/xfs/xfs_ioctl.c           | 2 +-
 fs/xfs/xfs_trans_buf.c       | 2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

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
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index e46bc03365db..5a13bfe0ebbf 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -282,7 +282,7 @@ xfs_da3_node_read_verify(
 						__this_address);
 				break;
 			}
-			/* fall through */
+			fallthrough;
 		case XFS_DA_NODE_MAGIC:
 			fa = xfs_da3_node_verify(bp);
 			if (fa)
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 955302e7cdde..6abd469d49d2 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -270,7 +270,7 @@ xchk_bmap_iextent_xref(
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
index e56786f0a13c..2b3fb0b37e18 100644
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
index 25e86c71e7b9..c814b18efba9 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -944,7 +944,7 @@ xrep_ino_dqattach(
 			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
 		if (XFS_IS_PQUOTA_ON(sc->mp) && !sc->ip->i_pdquot)
 			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
-		/* fall through */
+		fallthrough;
 	case -ESRCH:
 		error = 0;
 		break;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 73cafc843cd7..6045cc20b0fb 100644
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
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c31cd3be9fb2..976306724093 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -772,7 +772,7 @@ xfs_break_layouts(
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
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f22a66777cd..85d6631f7e99 100644
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
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 11cd666cd99a..86ba71580ffd 100644
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
-- 
2.19.1

