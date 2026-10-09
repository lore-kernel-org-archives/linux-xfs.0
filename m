Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD64446C00;
	Fri,  9 Oct 2026 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791526523; cv=none; b=eW/Vycbm2/Yc8NtlIqsgPdtbCYrxcYp0oi4zGYk1dDGTyBWf7w9lKQAdn/svqOHdN7IUbNzMZFsfCJV3k6QXQF1XS8KKrlQ/dxKDWvHvYmkq+nHs4/6Kfm5kKH2JBcWSj5atoJ7y2liD6p2+PiDqLyejsJ8107Ep1WQW+FBJjL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791526523; c=relaxed/simple;
	bh=ikcEDHi2gk9oHA3M6DxlwRZqqKo5ycrwXLbPCPqpL4M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XGA8k0FnBrp7/Gvv/h76anGDQTqVMSgG7VGZVv/2CzQn5rHk3oGEjfrBvkBB4k0FT+Mma/GW2r2bq88ElcXutZNejKO2BTISffqsFeXbuERzMS9iCLtDa3AXNvlO9USUA1pZEtvXaFRXHwN+ujS6mx6GX1IsZ4BIEJrfjyrgZqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fri5bCV6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fri5bCV6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6AA221F000FF;
	Fri,  9 Oct 2026 06:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791526521;
	bh=+eJN+aXI1qEMmcjCt86gwxvt0awGywZS9SbYstN6JzU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Fri5bCV6QEWJz14MkovrF0+E4MdLt0QiuZaYMh5W/2NK/jGV/Z8dsMggN+RN36wuQ
	 luvdF+ujdjWLWljZcxPcYkyuaqXMvnTsNAdMnJUBZRR5oEB1xMrQtwwe/PXzv3sb23
	 W9xIQVDKXzT3BKc09lF8lBLUajSAD0/8S1rS7na6jdFDggMe5upRPXmlrEF6kXhzjA
	 YpTRFGyx42shuYO0a1isVcknq+715W9tJ48e1k8zIsjfkLd/TCGPKe6Uu5IFwmywKx
	 noaclUGstKWVwAhiGfyvQqB07jfVHim9qLHqDPF1+zdUFZBE/FeOdqpCRjgu96q8DU
	 bl4JAdJXuYMyg==
Date: Thu, 08 Oct 2026 23:15:21 -0700
Subject: [PATCH 02/13] xfs: don't subtract excess usage twice when computing
 agf_btreeblks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <179151614663.3163896.1335957242495736456.stgit@frogsfrogsfrogs>
In-Reply-To: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
References: <179151614535.3163896.2744921556354655977.stgit@frogsfrogsfrogs>
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

