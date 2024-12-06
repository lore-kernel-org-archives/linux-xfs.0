Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E799B19ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527959; cv=none; b=XLhPd7hxZZY2jB9rbhaNZ7yS97KT6m7JmeZeTjAgReDReUGutgPuidkwOGXTY3vZGzX+3FpQL/eIjk2o0bRU0LEuxYN+8acFEs9uxqWUn8yL4Z8QN0UBx2q4TcbnQv8Sec8D9rEgHLqRj5Gwp0TWNziymFhXMIoLrGqHeoe8vhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527959; c=relaxed/simple;
	bh=KEhSsLTnaY7UnBeoreGM63Inqj2K6baPa++qObMUUEY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bJnCh50XzIsZoUEg+CFXevfwBQVMZBxjkhRu4bruWyGtK9j6mplIRpoJQpu+oOPu64DjR5NJP9G9P/DTjOB6E7uHh+9CXopZcgsplARJONmsLIlUNibJzsYHO5afKY9R/DmY3oTL4/qK9/QzkScjvu4NwRAlHFjG8XqIy4jIDpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bjfa1Yfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bjfa1Yfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B036C4CED1;
	Fri,  6 Dec 2024 23:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527957;
	bh=KEhSsLTnaY7UnBeoreGM63Inqj2K6baPa++qObMUUEY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bjfa1YfxsYsimYm8jYEOeohLIdhktXA/9dGxnxOR6tuQQvpKAhzy7XD6cxPsGXS/m
	 FbOiQqmiKTubHc6+Zo52IP27fVG/q2lW9nPGrgRvlyDorUvtOGPBgfnv5/VlHBdM7U
	 knHTAnh3T370uFnbBWpfuETTYXcBxGniPAWL7vlHp+x+VKeraDCe1kzE6zxFaQmMEr
	 7+0ELa8R0h6PzAob7uoiMyE3S33ryuFrCnKzXGRVYPglvKZT2yQTE/fsf58DlWYqyA
	 dQmBQWlskMTQAHwjxS/gMeJCDd8wuZ16Io4RsaZOpnE6SuogI1baWG1UF984COXYa7
	 1EMhwAUDj5bbA==
Date: Fri, 06 Dec 2024 15:32:36 -0800
Subject: [PATCH 09/36] xfs: pass a pag to xfs_extent_busy_{search,reuse}
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747020.121772.7695574959492573033.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b6dc8c6dd2d3f230e1a554f869d6df4568a2dfbb

Replace the [mp,agno] tuple with the perag structure, which will become
more useful later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h     |    2 +-
 libxfs/xfs_alloc.c       |    4 ++--
 libxfs/xfs_alloc_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 97f5003ea53862..9505806131bc42 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -465,7 +465,7 @@ xfs_buf_readahead(
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
 #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
 
-#define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
+#define xfs_extent_busy_reuse(...)			((void) 0)
 /* avoid unused variable warning */
 #define xfs_extent_busy_insert(tp,pag,bno,len,flags)({ 	\
 	struct xfs_perag *__foo = pag;			\
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 19b38eaf45dd07..ed04e40856740b 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1248,7 +1248,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
+	xfs_extent_busy_reuse(args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -3610,7 +3610,7 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(mp, args->pag, args->agbno,
+		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
 				args->len));
 	}
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 4a711f2463cd30..949cd18ab16a99 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -84,7 +84,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ada58e92645020..c261d6eae3bc3b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -101,7 +101,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);

