Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0056C2BAE2
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389643; cv=none; b=ovbtkIrI5WiLYS8qmtfSC3q6UvfzdJyE8qZqjt8NVIdQedt+QwZsAgdXmOAXcfL97hoUKSw8TTHDqr5iPUBFb02UOqOepb7UWu5DWwDd+Vfl0F6u3uOBEoxCZ7B1LzLMshMfJoGe8c+E5wK/67kpc7Gc5ExhsFz29Fov/wWiYT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389643; c=relaxed/simple;
	bh=tpfrNK8HmLih0XuA/CuomzUXxoRDW/24sGf2P6vfFb4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W4BfhOkQrZcKhd1cGLbQo741CRQMTlmtPBckQAeYOjbw8GkOkL5/Ym11eCfIFKAqPTqijZVijL4p5tGobhB4m62LptSRZdKzWjbTvCNiFYk1ZOBKozUIG46wnxZKjj+qDwmvpjfvStDLmZ21fpM1pJk19wOqEZbweut4h5LDwf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YNJEv8ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YNJEv8ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB81C072AA;
	Wed, 17 Apr 2024 21:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389642;
	bh=tpfrNK8HmLih0XuA/CuomzUXxoRDW/24sGf2P6vfFb4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YNJEv8ckFL9EoCK1BgIvt2Ob7CY72EAn1MvhonXPFei9Nu7I6PZKcXtygmGmHMVwS
	 +mdtX9GdFpksDT0RqBLm1eyCWdT8mSROd+PL/Tt1wPm4/CTGgqsDdFH3Yv3L9UbkTA
	 Mg+c8t3efmyC9EGDZ75Mr9Xq1LpND8eTaiL8ujRg890hQyyzf0AGPrYByYqKws2Qn8
	 hr4GJ2e6ovul1MtEgBujPqMQ2oPbCC+gCEbVkkXvEzZdsEwMzWYy6icHFZ0hwithgb
	 cJu3S1Hu4aFlite4E7zF/Iuy6Ru25mWdqLDzO2mM48t7hrbXJcE8RlmGrOgpcoZjeO
	 Dq0IPMJ82Yh+Q==
Date: Wed, 17 Apr 2024 14:34:02 -0700
Subject: [PATCH 47/67] xfs: also use xfs_bmap_btalloc_accounting for RT
 allocations
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338843045.1853449.15801907715895544248.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

Source kernel commit: 58643460546da1dc61593fc6fd78762798b4534f

Make xfs_bmap_btalloc_accounting more generic by handling the RT quota
reservations and then also use it from xfs_bmap_rtalloc instead of
open coding the accounting logic there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/libxfs_priv.h    |    5 ++++-
 libxfs/xfs_bmap.c       |   21 ++++++++++++++-------
 libxfs/xfs_bmap.h       |    2 ++
 libxfs/xfs_bmap_btree.c |    1 +
 4 files changed, 21 insertions(+), 8 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 30ff8dba9..28ee19250 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -434,7 +434,10 @@ void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
 #define xfs_filestream_select_ag(...)		(-ENOSYS)
 
 /* quota bits */
-#define xfs_trans_mod_dquot_byino(t,i,f,d)		((void) 0)
+#define xfs_trans_mod_dquot_byino(t,i,f,d)		({ \
+	uint _f = (f); \
+	_f = _f; /* shut up gcc */ \
+})
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
 
 /* hack too silence gcc */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ad058bb12..4f6bd8dff 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -3257,10 +3257,14 @@ xfs_bmap_btalloc_select_lengths(
 }
 
 /* Update all inode and quota accounting for the allocation we just did. */
-static void
-xfs_bmap_btalloc_accounting(
+void
+xfs_bmap_alloc_account(
 	struct xfs_bmalloca	*ap)
 {
+	bool			isrt = XFS_IS_REALTIME_INODE(ap->ip) &&
+					(ap->flags & XFS_BMAPI_ATTRFORK);
+	uint			fld;
+
 	if (ap->flags & XFS_BMAPI_COWFORK) {
 		/*
 		 * COW fork blocks are in-core only and thus are treated as
@@ -3285,7 +3289,8 @@ xfs_bmap_btalloc_accounting(
 		 * to that of a delalloc extent.
 		 */
 		ap->ip->i_delayed_blks += ap->length;
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, XFS_TRANS_DQ_RES_BLKS,
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip, isrt ?
+				XFS_TRANS_DQ_RES_RTBLKS : XFS_TRANS_DQ_RES_BLKS,
 				-(long)ap->length);
 		return;
 	}
@@ -3296,10 +3301,12 @@ xfs_bmap_btalloc_accounting(
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= ap->length;
 		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
+		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
+	} else {
+		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 	}
-	xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-		ap->wasdel ? XFS_TRANS_DQ_DELBCOUNT : XFS_TRANS_DQ_BCOUNT,
-		ap->length);
+
+	xfs_trans_mod_dquot_byino(ap->tp, ap->ip, fld, ap->length);
 }
 
 static int
@@ -3373,7 +3380,7 @@ xfs_bmap_process_allocated_extent(
 		ap->offset = orig_offset;
 	else if (ap->offset + ap->length < orig_offset + orig_length)
 		ap->offset = orig_offset + orig_length - ap->length;
-	xfs_bmap_btalloc_accounting(ap);
+	xfs_bmap_alloc_account(ap);
 }
 
 #ifdef DEBUG
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 4b83f6148..f6b73f1ba 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -116,6 +116,8 @@ static inline int xfs_bmapi_whichfork(uint32_t bmapi_flags)
 	return XFS_DATA_FORK;
 }
 
+void xfs_bmap_alloc_account(struct xfs_bmalloca *ap);
+
 /*
  * Special values for xfs_bmbt_irec_t br_startblock field.
  */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 73ba067df..887ba56f3 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -21,6 +21,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
+#include "xfs_quota_defs.h"
 
 static struct kmem_cache	*xfs_bmbt_cur_cache;
 

