Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6F143AC7
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817006; cv=none; b=lSTl9fDtbzxED37bDB8Uotmgpu0PCvGoup7zYiCbzturoQr+dsMxN1VcNL2b/cG6fFnoOi+Q5F+b9O01LorewbWE5JXmlsOABg5ZMwdAnuON41W5dVSlLLFFpgJpSmdXKd8QjB72GBkXJEml3hOPlXNGV6zz5KTXwlqmGZEQh8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817006; c=relaxed/simple;
	bh=smAi/krLpMZEXJT2ORBAmSkCHpTq2mcNhjtMobT8XZw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJGDsjes23wQK2dM+dTDCwynJ++rJ7qySTk8S3y3FjQtIELu+8gq/aQ/nYdAULgZbqZDmCvzLWLoEEb3j8V6jQP/N7Whg4ZfIvkGXGG4a/fmAkht00ry/F1BJ/BlHtJcGUo090M2Z6pI/SjiN/bb/fHcqAziqXbDEXj9QSUL9O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2fqg9zh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2fqg9zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B87C433F1;
	Thu,  1 Feb 2024 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817006;
	bh=smAi/krLpMZEXJT2ORBAmSkCHpTq2mcNhjtMobT8XZw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=l2fqg9zhXipFUtkW9M0h4M4oXR7hlWEjtek/mTLHIwIWxUyvayxzklGE3L35qZqmb
	 3CebKMqvPwnUzBz+msy/gXA8+/QZ9zTS1GcSe+zLZT3O/dVcfvwkyGQR1lysx3DNxg
	 yhP7EFeOeN1Hhv1LUBNM/5H/YE2h/uzdcNW58PwIKUw0yj35C1X0nE3O5CqH6arHjj
	 HRJMv7pg2S3unS/xknO5CkX4zR8ruRRBC+Ty+pghtJq0lw0YytUfkz3mTTnv5AGqrZ
	 ULpiUwvVLOXT198dEbbCvYHoaIhEcFsH+CoXeF/8MMVFaiyMWzhAh7mnSpSuo57Aqf
	 7ic0eKfiEkbTQ==
Date: Thu, 01 Feb 2024 11:50:05 -0800
Subject: [PATCH 17/27] xfs: add a name field to struct xfs_btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335062.1605438.4257790245706970220.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

The btnum in struct xfs_btree_ops is often used for printing a symbolic
name for the btree.  Add a name field to the ops structure and use that
directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    8 ++--
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_btree.c          |    8 ++--
 fs/xfs/libxfs/xfs_btree.h          |    2 +
 fs/xfs/libxfs/xfs_ialloc.c         |    5 +--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +
 fs/xfs/libxfs/xfs_refcount_btree.c |    1 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 +
 fs/xfs/libxfs/xfs_types.h          |    9 -----
 fs/xfs/scrub/trace.h               |   40 ++++++++++-----------
 fs/xfs/xfs_trace.h                 |   70 ++++++++++++++++++------------------
 12 files changed, 73 insertions(+), 76 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 7300dc2195896..44d4f0da90bad 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -273,9 +273,8 @@ xfs_alloc_complain_bad_rec(
 	struct xfs_mount		*mp = cur->bc_mp;
 
 	xfs_warn(mp,
-		"%s Freespace BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
-		cur->bc_ag.pag->pag_agno, fa);
+		"%sbt record corruption in AG %d detected at %pS!",
+		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 		"start block 0x%x block count 0x%x", irec->ar_startblock,
 		irec->ar_blockcount);
@@ -996,8 +995,7 @@ xfs_alloc_cur_check(
 out:
 	if (deactivate)
 		cur->bc_flags &= ~XFS_BTREE_ALLOCBT_ACTIVE;
-	trace_xfs_alloc_cur_check(args->mp, cur->bc_btnum, bno, len, diff,
-				  *new);
+	trace_xfs_alloc_cur_check(cur, bno, len, diff, *new);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 6c09573a98a9a..262f5dc3a483e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -468,6 +468,7 @@ xfs_allocbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bnobt_ops = {
+	.name			= "bno",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
@@ -497,6 +498,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_cntbt_ops = {
+	.name			= "cnt",
 	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1104bf4098e2e..25193551e95b4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -517,6 +517,7 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
+	.name			= "bmap",
 	.type			= XFS_BTREE_TYPE_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2649f24ed7482..278461d0f64d0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -298,17 +298,17 @@ xfs_btree_check_ptr(
 				level))
 			return 0;
 		xfs_err(cur->bc_mp,
-"Inode %llu fork %d: Corrupt btree %d pointer at level %d index %d.",
+"Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
 				cur->bc_ino.ip->i_ino,
-				cur->bc_ino.whichfork, cur->bc_btnum,
+				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
 	} else {
 		if (xfs_btree_check_sptr(cur, be32_to_cpu((&ptr->s)[index]),
 				level))
 			return 0;
 		xfs_err(cur->bc_mp,
-"AG %u: Corrupt btree %d pointer at level %d index %d.",
-				cur->bc_ag.pag->pag_agno, cur->bc_btnum,
+"AG %u: Corrupt %sbt pointer at level %d index %d.",
+				cur->bc_ag.pag->pag_agno, cur->bc_ops->name,
 				level, index);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 273027515296a..1b27649905bbb 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -123,6 +123,8 @@ enum xfs_btree_type {
 };
 
 struct xfs_btree_ops {
+	const char		*name;
+
 	/* Type of btree - AG-rooted or inode-rooted */
 	enum xfs_btree_type	type;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1ff867075026d..52b82cd7e6c9c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -141,9 +141,8 @@ xfs_inobt_complain_bad_rec(
 	struct xfs_mount		*mp = cur->bc_mp;
 
 	xfs_warn(mp,
-		"%s Inode BTree record corruption in AG %d detected at %pS!",
-		cur->bc_btnum == XFS_BTNUM_INO ? "Used" : "Free",
-		cur->bc_ag.pag->pag_agno, fa);
+		"%sbt record corruption in AG %d detected at %pS!",
+		cur->bc_ops->name, cur->bc_ag.pag->pag_agno, fa);
 	xfs_warn(mp,
 "start inode 0x%x, count 0x%x, free 0x%x freemask 0x%llx, holemask 0x%x",
 		irec->ir_startino, irec->ir_count, irec->ir_freecount,
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index b45a2e5813133..ddb9a226914a8 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -399,6 +399,7 @@ xfs_inobt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_inobt_ops = {
+	.name			= "ino",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -427,6 +428,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_finobt_ops = {
+	.name			= "fino",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(xfs_inobt_rec_t),
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 4dcf6295e683b..16677cbbddfcc 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -318,6 +318,7 @@ xfs_refcountbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.name			= "refcount",
 	.type			= XFS_BTREE_TYPE_AG,
 
 	.rec_len		= sizeof(struct xfs_refcount_rec),
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e050d7342d6c9..e1ddf814492c5 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -472,6 +472,7 @@ xfs_rmapbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.name			= "rmap",
 	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a1004fb3c8fb4..f577247b748d3 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -125,15 +125,6 @@ typedef enum {
 	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
-#define XFS_BTNUM_STRINGS \
-	{ XFS_BTNUM_BNOi,	"bnobt" }, \
-	{ XFS_BTNUM_CNTi,	"cntbt" }, \
-	{ XFS_BTNUM_RMAPi,	"rmapbt" }, \
-	{ XFS_BTNUM_BMAPi,	"bmbt" }, \
-	{ XFS_BTNUM_INOi,	"inobt" }, \
-	{ XFS_BTNUM_FINOi,	"finobt" }, \
-	{ XFS_BTNUM_REFCi,	"refcbt" }
-
 struct xfs_name {
 	const unsigned char	*name;
 	int			len;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1e448d0c5aeef..2c2f99d8772cb 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -459,7 +459,7 @@ TRACE_EVENT(xchk_btree_op_error,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned int, type)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, level)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, bno)
@@ -472,7 +472,7 @@ TRACE_EVENT(xchk_btree_op_error,
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
@@ -480,10 +480,10 @@ TRACE_EVENT(xchk_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
+	TP_printk("dev %d:%d type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->ptr,
 		  __entry->agno,
@@ -501,7 +501,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__field(xfs_ino_t, ino)
 		__field(int, whichfork)
 		__field(unsigned int, type)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, level)
 		__field(int, ptr)
 		__field(xfs_agnumber_t, agno)
@@ -515,7 +515,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
@@ -523,12 +523,12 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->error = error;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x error %d ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->ptr,
 		  __entry->agno,
@@ -544,7 +544,7 @@ TRACE_EVENT(xchk_btree_error,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned int, type)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, level)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, bno)
@@ -555,17 +555,17 @@ TRACE_EVENT(xchk_btree_error,
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
+	TP_printk("dev %d:%d type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->ptr,
 		  __entry->agno,
@@ -582,7 +582,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__field(xfs_ino_t, ino)
 		__field(int, whichfork)
 		__field(unsigned int, type)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, level)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, bno)
@@ -595,19 +595,19 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->ret_ip = ret_ip;
 	),
-	TP_printk("dev %d:%d ino 0x%llx fork %s type %s btree %s level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
+	TP_printk("dev %d:%d ino 0x%llx fork %s type %s %sbt level %d ptr %d agno 0x%x agbno 0x%x ret_ip %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->ptr,
 		  __entry->agno,
@@ -622,7 +622,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(int, type)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, bno)
 		__field(int, level)
@@ -634,17 +634,17 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_levels[level].ptr;
 	),
-	TP_printk("dev %d:%d type %s btree %s agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
+	TP_printk("dev %d:%d type %s %sbt agno 0x%x agbno 0x%x level %d nlevels %d ptr %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->agno,
 		  __entry->bno,
 		  __entry->level,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 824e6dfe103a6..feb681a1eed1a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1888,28 +1888,28 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_near_bno);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_finish);
 
 TRACE_EVENT(xfs_alloc_cur_check,
-	TP_PROTO(struct xfs_mount *mp, xfs_btnum_t btnum, xfs_agblock_t bno,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		 xfs_extlen_t len, xfs_extlen_t diff, bool new),
-	TP_ARGS(mp, btnum, bno, len, diff, new),
+	TP_ARGS(cur, bno, len, diff, new),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(xfs_agblock_t, bno)
 		__field(xfs_extlen_t, len)
 		__field(xfs_extlen_t, diff)
 		__field(bool, new)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->btnum = btnum;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->bno = bno;
 		__entry->len = len;
 		__entry->diff = diff;
 		__entry->new = new;
 	),
-	TP_printk("dev %d:%d btree %s agbno 0x%x fsbcount 0x%x diff 0x%x new %d",
+	TP_printk("dev %d:%d %sbt agbno 0x%x fsbcount 0x%x diff 0x%x new %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->bno, __entry->len, __entry->diff, __entry->new)
 )
 
@@ -2464,7 +2464,7 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	TP_ARGS(cur, level, bp),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, level)
 		__field(int, nlevels)
 		__field(int, ptr)
@@ -2472,15 +2472,15 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->daddr = bp ? xfs_buf_daddr(bp) : -1;
 	),
-	TP_printk("dev %d:%d btree %s level %d/%d ptr %d daddr 0x%llx",
+	TP_printk("dev %d:%d %sbt level %d/%d ptr %d daddr 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->nlevels,
 		  __entry->ptr,
@@ -2502,7 +2502,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_ino_t, ino)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(int, error)
 		__field(xfs_agblock_t, agbno)
 	),
@@ -2515,7 +2515,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 			__entry->agno = cur->bc_ag.pag->pag_agno;
 			__entry->ino = 0;
 		}
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->error = error;
 		if (!error && stat) {
 			if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
@@ -2532,9 +2532,9 @@ TRACE_EVENT(xfs_btree_alloc_block,
 			__entry->agbno = NULLAGBLOCK;
 		}
 	),
-	TP_printk("dev %d:%d btree %s agno 0x%x ino 0x%llx agbno 0x%x error %d",
+	TP_printk("dev %d:%d %sbt agno 0x%x ino 0x%llx agbno 0x%x error %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->agno,
 		  __entry->ino,
 		  __entry->agbno,
@@ -2548,7 +2548,7 @@ TRACE_EVENT(xfs_btree_free_block,
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_ino_t, ino)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(xfs_agblock_t, agbno)
 	),
 	TP_fast_assign(
@@ -2559,13 +2559,13 @@ TRACE_EVENT(xfs_btree_free_block,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 		else
 			__entry->ino = 0;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->agbno = xfs_daddr_to_agbno(cur->bc_mp,
 							xfs_buf_daddr(bp));
 	),
-	TP_printk("dev %d:%d btree %s agno 0x%x ino 0x%llx agbno 0x%x",
+	TP_printk("dev %d:%d %sbt agno 0x%x ino 0x%llx agbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->agno,
 		  __entry->ino,
 		  __entry->agbno)
@@ -4163,7 +4163,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	TP_ARGS(cur),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agblock_t, agbno)
 		__field(unsigned int, levels)
@@ -4171,15 +4171,15 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = cur->bc_ag.afake->af_root;
 		__entry->levels = cur->bc_ag.afake->af_levels;
 		__entry->blocks = cur->bc_ag.afake->af_blocks;
 	),
-	TP_printk("dev %d:%d btree %s agno 0x%x levels %u blocks %u root %u",
+	TP_printk("dev %d:%d %sbt agno 0x%x levels %u blocks %u root %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->agno,
 		  __entry->levels,
 		  __entry->blocks,
@@ -4191,7 +4191,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 	TP_ARGS(cur),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_agino_t, agino)
 		__field(unsigned int, levels)
@@ -4200,7 +4200,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
 					cur->bc_ino.ip->i_ino);
 		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
@@ -4209,9 +4209,9 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 		__entry->blocks = cur->bc_ino.ifake->if_blocks;
 		__entry->whichfork = cur->bc_ino.whichfork;
 	),
-	TP_printk("dev %d:%d btree %s agno 0x%x agino 0x%x whichfork %s levels %u blocks %u",
+	TP_printk("dev %d:%d %sbt agno 0x%x agino 0x%x whichfork %s levels %u blocks %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->agno,
 		  __entry->agino,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
@@ -4228,7 +4228,7 @@ TRACE_EVENT(xfs_btree_bload_level_geometry,
 		blocks_with_extra),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(unsigned int, level)
 		__field(unsigned int, nlevels)
 		__field(uint64_t, nr_this_level)
@@ -4239,7 +4239,7 @@ TRACE_EVENT(xfs_btree_bload_level_geometry,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->nr_this_level = nr_this_level;
@@ -4248,9 +4248,9 @@ TRACE_EVENT(xfs_btree_bload_level_geometry,
 		__entry->blocks = blocks;
 		__entry->blocks_with_extra = blocks_with_extra;
 	),
-	TP_printk("dev %d:%d btree %s level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
+	TP_printk("dev %d:%d %sbt level %u/%u nr_this_level %llu nr_per_block %u desired_npb %u blocks %llu blocks_with_extra %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->nlevels,
 		  __entry->nr_this_level,
@@ -4267,7 +4267,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 	TP_ARGS(cur, level, block_idx, nr_blocks, ptr, nr_records),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_btnum_t, btnum)
+		__string(name, cur->bc_ops->name)
 		__field(unsigned int, level)
 		__field(unsigned long long, block_idx)
 		__field(unsigned long long, nr_blocks)
@@ -4277,7 +4277,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->btnum = cur->bc_btnum;
+		__assign_str(name, cur->bc_ops->name);
 		__entry->level = level;
 		__entry->block_idx = block_idx;
 		__entry->nr_blocks = nr_blocks;
@@ -4292,9 +4292,9 @@ TRACE_EVENT(xfs_btree_bload_block,
 		}
 		__entry->nr_records = nr_records;
 	),
-	TP_printk("dev %d:%d btree %s level %u block %llu/%llu agno 0x%x agbno 0x%x recs %u",
+	TP_printk("dev %d:%d %sbt level %u block %llu/%llu agno 0x%x agbno 0x%x recs %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __get_str(name),
 		  __entry->level,
 		  __entry->block_idx,
 		  __entry->nr_blocks,

