Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98213CF82
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925040; cv=none; b=IeyMrOUEFfWKnXvdHycftoKXRFcao9S9pLiQsDQqzWiow/2FT94GM1SU+J7enzFJsQNd2E3XGKv1wqzw63XtWBJNUK3Ae137ri8TH7TxhKMzRsPI3H8+MmIUOdxVWU49NimFbgsYDVts8EyvCkReRs9YTlPNUFsFKMFlBOUnaKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925040; c=relaxed/simple;
	bh=pcnBdEwWM43otL8ou6ouqTId7SjwnMUUr4Rkrg3d6hM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EozcqLk9N8rSGWBAvsTJxCf1/zbLPxeMiapvqFfobfUkQJdHutmiZz6wVtpxXf2QF64VAdysZ6a+76mXh3dQ04+HunRQetMTLfie0yuZs00HDTkpBHZFfRlXfIaLSYcZyp01Zqx2MEXsfDfKWWB9ZrUNMPo+LvHPK3wi/Ia3omE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EbB/gW7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EbB/gW7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F646C2BD10;
	Thu, 20 Jun 2024 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925039;
	bh=pcnBdEwWM43otL8ou6ouqTId7SjwnMUUr4Rkrg3d6hM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EbB/gW7ZbOah2kPCAM/87DH2G4hel9kkFzgdXt7enKyrXLAK9s2wpqe1weY4a6mu5
	 Y4ctBjz9soZm1WQCLb/0SAdo9EkyHyNkbardUE8ZLu7sfAGJcAiSy/3TqT/Q+imK+u
	 dbLDHOY5oweYq9/iAtfV4MgQBy0ZR9jsybsav3GkZZ5C3r7obOOFqt16PExs4Rk4Dp
	 nsMCQE/udZUPIHK9fIwtBdgoe7nybs8nY1SWfwSFxXD07qEgW2kt7jnzFK7siIn9o4
	 nQgJIzawYM5NK35daLummB5XMU0Z1c6COZ8L4JGGzxNUPXGq85dlaVCj3/iTGmASSV
	 tEmkrYvZfqhyA==
Date: Thu, 20 Jun 2024 16:10:39 -0700
Subject: [PATCH 05/10] xfs: remove xfs_trans_set_refcount_flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419858.3184748.8956724086429567211.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Remove this single-use helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_refcount_item.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 78e106d05aa20..deb8b4aaa9541 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -243,25 +243,6 @@ xfs_refcount_update_diff_items(
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
-/* Set the phys extent flags for this reverse mapping. */
-static void
-xfs_trans_set_refcount_flags(
-	struct xfs_phys_extent		*pmap,
-	enum xfs_refcount_intent_type	type)
-{
-	pmap->pe_flags = 0;
-	switch (type) {
-	case XFS_REFCOUNT_INCREASE:
-	case XFS_REFCOUNT_DECREASE:
-	case XFS_REFCOUNT_ALLOC_COW:
-	case XFS_REFCOUNT_FREE_COW:
-		pmap->pe_flags |= type;
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
 /* Log refcount updates in the intent item. */
 STATIC void
 xfs_refcount_update_log_item(
@@ -282,7 +263,18 @@ xfs_refcount_update_log_item(
 	pmap = &cuip->cui_format.cui_extents[next_extent];
 	pmap->pe_startblock = ri->ri_startblock;
 	pmap->pe_len = ri->ri_blockcount;
-	xfs_trans_set_refcount_flags(pmap, ri->ri_type);
+
+	pmap->pe_flags = 0;
+	switch (ri->ri_type) {
+	case XFS_REFCOUNT_INCREASE:
+	case XFS_REFCOUNT_DECREASE:
+	case XFS_REFCOUNT_ALLOC_COW:
+	case XFS_REFCOUNT_FREE_COW:
+		pmap->pe_flags |= ri->ri_type;
+		break;
+	default:
+		ASSERT(0);
+	}
 }
 
 static struct xfs_log_item *

