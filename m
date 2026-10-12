Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B9F49B215;
	Mon, 12 Oct 2026 15:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818453; cv=none; b=l0SBk4smuu2tMMAFzbDTmqpubgCPxDvaPBkw4nri2TyUA/JWZf/bOe4eJyIE1PCvui6niYncq+fIOL4s3b6txtvLdaILVcEeDe38VqJZbHL+R0uINQezz5+6DewpbR0SwFykPXxBP+CtgHgbFROxMj9zIv4H+KbL33SuWy9FZbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818453; c=relaxed/simple;
	bh=FBbjmiFAVoLWO9XKwyXvcZHIY3IJkTI94tCnVHBsdE4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ribIT2sosFhvV4KEOEj5hZfm50ApbZbZ9dfWYBNCkoO0mjNKJms0+DgZxUnJH0vFTbQhjQbp7Sbbd5bNYQYijsHJM3CnxzffHScka+8fRQAmJzmUSn4AbJlt7N9lTZke9hvRjg/fC8j8+rzHv0dHmTnxc0LSPs1OtLrsiX/bAkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXPZtMYz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXPZtMYz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C130B1F0089B;
	Mon, 12 Oct 2026 15:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818451;
	bh=Y97R1I5kqAjp/YsdlUOsrU3kW9a3rtvXJ9cPswxifjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=kXPZtMYzj5WiBX9ABqqhJYMW3/Xf+KMIEU876aq79qiplr/ZProt9M94HZrqOikKJ
	 5Yh/wYtDiqwq3z2DXQw96IytY4JJoX2wp3s9wzyRkIBO+2mWC7djXe52svJzElgVN2
	 YFMNpofHEsBHC0QPNuUvCGQR1lF+VcRZnQE8xz4nolGHxGkaKgWSJYwwk2DJ2m3KNT
	 bv36lxmUxbM14P3qjC2Py8HVfJ8kP7O10UBR2ECm0uUJyEQmaMG7hVgiA3q9ZK2qVi
	 +lX1YYDgPKWOtVc8emiHXPFbIVWFSzChpJCAlXivBeT5OU5dNLDsfHnWr4dpMdZ+Ky
	 fToSsDbK/YJYQ==
Date: Mon, 12 Oct 2026 08:20:51 -0700
Subject: [PATCH 02/13] xfs: don't subtract excess usage twice when computing
 agf_btreeblks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179181839290.1417179.13533766689463255088.stgit@frogsfrogsfrogs>
In-Reply-To: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
References: <179181839163.1417179.9019753534701755931.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

LOLLM noticed that the free space btree repair code calculates
agf_btreeblks from the number of blocks we wrote to rebuild the free
space btrees (minus the roots).  That's correct.  However, it observes
that we subtract the "excess" reservation, which is not correct.  Fix
this accounting problem.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/newbt.h        |    1 -
 fs/xfs/scrub/alloc_repair.c |    6 +-----
 fs/xfs/scrub/newbt.c        |   13 -------------
 3 files changed, 1 insertion(+), 19 deletions(-)


diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index 5ce785599287be..e5ebd3200c1849 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -71,6 +71,5 @@ void xrep_newbt_cancel(struct xrep_newbt *xnr);
 int xrep_newbt_commit(struct xrep_newbt *xnr);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
 		union xfs_btree_ptr *ptr);
-unsigned int xrep_newbt_unused_blocks(struct xrep_newbt *xnr);
 
 #endif /* __XFS_SCRUB_NEWBT_H__ */
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 9a09a9ea9c3089..05f27c927adfb9 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -660,15 +660,11 @@ xrep_abt_reset_counters(
 
 	/*
 	 * Compute the contribution to agf_btreeblks for the new free space
-	 * btrees.  This is the computed btree size minus anything we didn't
-	 * use.
+	 * btrees.  This is the computed btree size minus the root block.
 	 */
 	freesp_btreeblks += ra->new_bnobt.bload.nr_blocks - 1;
 	freesp_btreeblks += ra->new_cntbt.bload.nr_blocks - 1;
 
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_bnobt);
-	freesp_btreeblks -= xrep_newbt_unused_blocks(&ra->new_cntbt);
-
 	/*
 	 * The AGF header contains extra information related to the free space
 	 * btrees, so we must update those fields here.
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 584076b2a6eed9..a7554f925b7440 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -598,16 +598,3 @@ xrep_newbt_claim_block(
 	/* Relog all the EFIs. */
 	return xrep_defer_finish(xnr->sc);
 }
-
-/* How many reserved blocks are unused? */
-unsigned int
-xrep_newbt_unused_blocks(
-	struct xrep_newbt	*xnr)
-{
-	struct xrep_newbt_resv	*resv;
-	unsigned int		unused = 0;
-
-	list_for_each_entry(resv, &xnr->resv_list, list)
-		unused += resv->len - resv->used;
-	return unused;
-}

