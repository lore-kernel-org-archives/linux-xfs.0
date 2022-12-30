Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A657AC46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236374AbiLaDXv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:23:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiLaDXt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:23:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E8212AB2
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5746B81E5A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54842C433EF;
        Sat, 31 Dec 2022 03:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457024;
        bh=70NvJ3RkvcvbwAZvdf41uK/hdDkv64QfPahuoh9CwHQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O83uIWrlIyJn68LjaLQZtOpMEKp+KXAP3QDSulMu3UejJglw9eDH+SVk30Mcj50wa
         4cp9+7DXCm0Q1vV0/HQkLe3o+AJUOEvX0xCUbSkkTmoZjBKZJh/UtirfY0W3XLtKGx
         G9YJ9Kvf+yXuge/8lzKNPR5tsM1YyMsqKlrrJ/MR7Scu238jqNTwGRXixouhnpTWJF
         pqHEwxA0fUFsVV8+eOmZtTTmwPUorJhcsXFMx3N+QM52b7oy3liMnHydd4g4hcbS+u
         lmqPnTnxqMBpb6Xb7gE7rx0llv2BohkeoJz4QOAZD64RLHmfqdBJ9ngD2zNBrXqNHb
         vvo6ly/4TqiyQ==
Subject: [PATCH 2/3] xfs: whine to dmesg when we encounter errors
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:23 -0800
Message-ID: <167243876392.726950.2504338863251448607.stgit@magnolia>
In-Reply-To: <167243876361.726950.2109456102182372814.stgit@magnolia>
References: <167243876361.726950.2109456102182372814.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Forward everything scrub whines about to dmesg.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c   |   88 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c  |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.h  |    1 
 fs/xfs/scrub/dabtree.c |   24 +++++++++++
 fs/xfs/scrub/inode.c   |    4 ++
 fs/xfs/scrub/scrub.c   |   37 +++++++++++++++++
 fs/xfs/scrub/trace.c   |   22 ++++++++++
 fs/xfs/scrub/trace.h   |    2 +
 8 files changed, 282 insertions(+)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 24ea77e46ebd..a6b1d82383e8 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -11,6 +11,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_log_format.h"
+#include "xfs_ag.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -18,6 +20,62 @@
 
 /* btree scrubbing */
 
+/* Figure out which block the btree cursor was pointing to. */
+static inline xfs_fsblock_t
+xchk_btree_cur_fsbno(
+	struct xfs_btree_cur		*cur,
+	int				level)
+{
+	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
+		return XFS_DADDR_TO_FSB(cur->bc_mp,
+				xfs_buf_daddr(cur->bc_levels[level].bp));
+	else if (level == cur->bc_nlevels - 1 &&
+		 (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
+		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
+	else if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
+		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
+	return NULLFSBLOCK;
+}
+
+static inline void
+process_error_whine(
+	struct xfs_scrub	*sc,
+	struct xfs_btree_cur	*cur,
+	int			level,
+	int			*error,
+	__u32			errflag,
+	void			*ret_ip)
+{
+	xfs_fsblock_t		fsbno = xchk_btree_cur_fsbno(cur, level);
+
+	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				*error,
+				errflag,
+				ret_ip);
+		return;
+	}
+
+	xchk_whine(sc->mp, "type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			cur->bc_btnum,
+			level,
+			cur->bc_levels[level].ptr,
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+			*error,
+			errflag,
+			ret_ip);
+}
+
 /*
  * Check for btree operation errors.  See the section about handling
  * operational errors in common.c.
@@ -44,9 +102,13 @@ __xchk_btree_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		process_error_whine(sc, cur, level, error, errflag, ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			process_error_whine(sc, cur, level, error, errflag,
+					ret_ip);
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
 					*error, ret_ip);
@@ -92,11 +154,37 @@ __xchk_btree_set_corrupt(
 	sc->sm->sm_flags |= errflag;
 
 	if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+	{
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x errflag 0x%x ret_ip %pS",
+				cur->bc_ino.ip->i_ino,
+				cur->bc_ino.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				errflag,
+				ret_ip);
 		trace_xchk_ifork_btree_error(sc, cur, level,
 				ret_ip);
+	}
 	else
+	{
+		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
+		xchk_whine(sc->mp, "type %s btnum %d level %d ptr %d agno 0x%x agbno 0x%x errflag 0x%x ret_ip %pS",
+				xchk_type_string(sc->sm->sm_type),
+				cur->bc_btnum,
+				level,
+				cur->bc_levels[level].ptr,
+				XFS_FSB_TO_AGNO(cur->bc_mp, fsbno),
+				XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno),
+				errflag,
+				ret_ip);
 		trace_xchk_btree_error(sc, cur, level,
 				ret_ip);
+	}
 }
 
 void
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a632d56f255f..2c6fd62874c6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -105,9 +105,23 @@ __xchk_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x error %d errflag 0x%x ret_ip %pS",
+				xchk_type_string(sc->sm->sm_type),
+				agno,
+				bno,
+				*error,
+				errflag,
+				ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+					xchk_type_string(sc->sm->sm_type),
+					agno,
+					bno,
+					*error,
+					ret_ip);
 		trace_xchk_op_error(sc, agno, bno, *error, ret_ip);
 		break;
 	}
@@ -190,9 +204,25 @@ __xchk_fblock_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu error %d errflag 0x%x ret_ip %pS",
+				sc->ip->i_ino,
+				whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				offset,
+				*error,
+				errflag,
+				ret_ip);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu error %d ret_ip %pS",
+					sc->ip->i_ino,
+					whichfork,
+					xchk_type_string(sc->sm->sm_type),
+					offset,
+					*error,
+					ret_ip);
 		trace_xchk_file_op_error(sc, whichfork, offset, *error,
 				ret_ip);
 		break;
@@ -264,6 +294,8 @@ xchk_set_corrupt(
 	struct xfs_scrub	*sc)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "type %s ret_ip %pS", xchk_type_string(sc->sm->sm_type),
+			__return_address);
 	trace_xchk_fs_error(sc, 0, __return_address);
 }
 
@@ -275,6 +307,11 @@ xchk_block_set_corrupt(
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			__return_address);
 }
 
 #ifdef CONFIG_XFS_QUOTA
@@ -286,6 +323,8 @@ xchk_qcheck_set_corrupt(
 	xfs_dqid_t		id)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "type %s dqtype %u id %u ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), dqtype, id, __return_address);
 	trace_xchk_qcheck_error(sc, dqtype, id, __return_address);
 }
 #endif /* CONFIG_XFS_QUOTA */
@@ -298,6 +337,11 @@ xchk_block_xref_set_corrupt(
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), __return_address);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			__return_address);
 }
 
 /*
@@ -311,6 +355,8 @@ xchk_ino_set_corrupt(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
@@ -321,6 +367,8 @@ xchk_ino_xref_set_corrupt(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_error(sc, ino, __return_address);
 }
 
@@ -332,6 +380,12 @@ xchk_fblock_set_corrupt(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
@@ -343,6 +397,12 @@ xchk_fblock_xref_set_corrupt(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_error(sc, whichfork, offset, __return_address);
 }
 
@@ -356,6 +416,8 @@ xchk_ino_set_warning(
 	xfs_ino_t		ino)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	xchk_whine(sc->mp, "ino 0x%llx type %s ret_ip %pS",
+			ino, xchk_type_string(sc->sm->sm_type), __return_address);
 	trace_xchk_ino_warning(sc, ino, __return_address);
 }
 
@@ -367,6 +429,12 @@ xchk_fblock_set_warning(
 	xfs_fileoff_t		offset)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_WARNING;
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s offset %llu ret_ip %pS",
+			sc->ip->i_ino,
+			whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			offset,
+			__return_address);
 	trace_xchk_fblock_warning(sc, whichfork, offset, __return_address);
 }
 
@@ -1255,6 +1323,10 @@ xchk_iget_for_scrubbing(
 out_cancel:
 	xchk_trans_cancel(sc);
 out_error:
+	xchk_whine(mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), agno,
+			XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino), error,
+			__return_address);
 	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
 			error, __return_address);
 	return error;
@@ -1390,6 +1462,10 @@ xchk_should_check_xref(
 	}
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XFAIL;
+	xchk_whine(sc->mp, "type %s xref error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			*error,
+			__return_address);
 	trace_xchk_xref_error(sc, *error, __return_address);
 
 	/*
@@ -1421,6 +1497,11 @@ xchk_buffer_recheck(
 		return;
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 	trace_xchk_block_error(sc, xfs_buf_daddr(bp), fa);
+	xchk_whine(sc->mp, "type %s agno 0x%x agbno 0x%x ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type),
+			xfs_daddr_to_agno(sc->mp, xfs_buf_daddr(bp)),
+			xfs_daddr_to_agbno(sc->mp, xfs_buf_daddr(bp)),
+			fa);
 }
 
 static inline int
@@ -1587,3 +1668,26 @@ xchk_inode_count_blocks(
 	*count = btblocks - 1;
 	return 0;
 }
+
+/* Complain about failures... */
+void
+xchk_whine(
+	const struct xfs_mount	*mp,
+	const char		*fmt,
+	...)
+{
+	struct va_format	vaf;
+	va_list			args;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_INFO "XFS (%s) %pS: %pV\n", mp->m_super->s_id,
+			__return_address, &vaf);
+	va_end(args);
+
+	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
+		xfs_stack_trace();
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index dd1b838a183f..10b124e4b02b 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -210,6 +210,7 @@ bool xchk_ilock_nowait(struct xfs_scrub *sc, unsigned int ilock_flags);
 void xchk_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
 
 void xchk_buffer_recheck(struct xfs_scrub *sc, struct xfs_buf *bp);
+void xchk_whine(const struct xfs_mount *mp, const char *fmt, ...);
 
 int xchk_iget(struct xfs_scrub *sc, xfs_ino_t inum, struct xfs_inode **ipp);
 int xchk_iget_agi(struct xfs_scrub *sc, xfs_ino_t inum,
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 764f7dfd78b5..15c9bfcda0d3 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -47,9 +47,26 @@ xchk_da_process_error(
 	case -EFSCORRUPTED:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+		xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx error %d ret_ip %pS",
+				sc->ip->i_ino,
+				ds->dargs.whichfork,
+				xchk_type_string(sc->sm->sm_type),
+				xfs_dir2_da_to_db(ds->dargs.geo,
+					ds->state->path.blk[level].blkno),
+				*error,
+				__return_address);
 		*error = 0;
 		fallthrough;
 	default:
+		if (*error)
+			xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx error %d ret_ip %pS",
+					sc->ip->i_ino,
+					ds->dargs.whichfork,
+					xchk_type_string(sc->sm->sm_type),
+					xfs_dir2_da_to_db(ds->dargs.geo,
+						ds->state->path.blk[level].blkno),
+					*error,
+					__return_address);
 		trace_xchk_file_op_error(sc, ds->dargs.whichfork,
 				xfs_dir2_da_to_db(ds->dargs.geo,
 					ds->state->path.blk[level].blkno),
@@ -72,6 +89,13 @@ xchk_da_set_corrupt(
 
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 
+	xchk_whine(sc->mp, "ino 0x%llx fork %d type %s dablk 0x%llx ret_ip %pS",
+			sc->ip->i_ino,
+			ds->dargs.whichfork,
+			xchk_type_string(sc->sm->sm_type),
+			xfs_dir2_da_to_db(ds->dargs.geo,
+				ds->state->path.blk[level].blkno),
+			__return_address);
 	trace_xchk_fblock_error(sc, ds->dargs.whichfork,
 			xfs_dir2_da_to_db(ds->dargs.geo,
 				ds->state->path.blk[level].blkno),
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 6a37973823d2..acd44858b2d0 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -187,6 +187,10 @@ xchk_setup_inode(
 out_cancel:
 	xchk_trans_cancel(sc);
 out_error:
+	xchk_whine(mp, "type %s agno 0x%x agbno 0x%x error %d ret_ip %pS",
+			xchk_type_string(sc->sm->sm_type), agno,
+			XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino), error,
+			__return_address);
 	trace_xchk_op_error(sc, agno, XFS_INO_TO_AGBNO(mp, sc->sm->sm_ino),
 			error, __return_address);
 	return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2f60fd6b86a9..342a50248650 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -551,6 +551,42 @@ static inline void xchk_postmortem(struct xfs_scrub *sc)
 }
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
+static inline void
+repair_outcomes(struct xfs_scrub *sc, int error)
+{
+	struct xfs_scrub_metadata *sm = sc->sm;
+	const char *wut = NULL;
+
+	if (sc->flags & XREP_ALREADY_FIXED) {
+		wut = "*** REPAIR SUCCESS";
+		error = 0;
+	} else if (error == -EBUSY) {
+		wut = "??? FILESYSTEM BUSY";
+	} else if (error == -EAGAIN) {
+		wut = "??? REPAIR DEFERRED";
+	} else if (error == -ECANCELED) {
+		wut = "??? REPAIR CANCELLED";
+	} else if (error == -EINTR) {
+		wut = "??? REPAIR INTERRUPTED";
+	} else if (error != -EOPNOTSUPP && error != -ENOENT) {
+		wut = "!!! REPAIR FAILED";
+		xfs_info(sc->mp,
+"%s ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
+				wut, XFS_I(file_inode(sc->file))->i_ino,
+				xchk_type_string(sm->sm_type), sm->sm_agno,
+				sm->sm_ino, sm->sm_gen, sm->sm_flags, error);
+		return;
+	} else {
+		return;
+	}
+
+	xfs_info_ratelimited(sc->mp,
+"%s ino 0x%llx type %s agno 0x%x inum 0x%llx gen 0x%x flags 0x%x error %d",
+			wut, XFS_I(file_inode(sc->file))->i_ino,
+			xchk_type_string(sm->sm_type), sm->sm_agno, sm->sm_ino,
+			sm->sm_gen, sm->sm_flags, error);
+}
+
 /* Dispatch metadata scrubbing. */
 int
 xfs_scrub_metadata(
@@ -643,6 +679,7 @@ xfs_scrub_metadata(
 		 * already tried to fix it, then attempt a repair.
 		 */
 		error = xrep_attempt(sc);
+		repair_outcomes(sc, error);
 		if (error == -EAGAIN) {
 			/*
 			 * Either the repair function succeeded or it couldn't
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 1bb868a54c06..f1a2b46a9355 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -62,3 +62,25 @@ xfbtree_ino(
  */
 #define CREATE_TRACE_POINTS
 #include "scrub/trace.h"
+
+/* xchk_whine stuff */
+struct xchk_tstr {
+	unsigned int	type;
+	const char	*tag;
+};
+
+static const struct xchk_tstr xchk_tstr_tags[] = { XFS_SCRUB_TYPE_STRINGS };
+
+const char *
+xchk_type_string(
+	unsigned int	type)
+{
+	unsigned int	i;
+
+	for (i = 0; i < ARRAY_SIZE(xchk_tstr_tags); i++) {
+		if (xchk_tstr_tags[i].type == type)
+			return xchk_tstr_tags[i].tag;
+	}
+
+	return "???";
+}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4d8e4b77cbbe..0e945f842732 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -115,6 +115,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_RTREFCBT);
 	{ XFS_SCRUB_TYPE_RTRMAPBT,	"rtrmapbt" }, \
 	{ XFS_SCRUB_TYPE_RTREFCBT,	"rtrefcountbt" }
 
+const char *xchk_type_string(unsigned int type);
+
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
 	{ XFS_SCRUB_OFLAG_CORRUPT,		"corrupt" }, \

