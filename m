Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0173314C4
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022440; cv=none; b=MwYzVWM3y5jQqMBfs05nxB5QjQ7178WrTWad7iVjpBwj2za3jOjhu4kp8AE42sWLcgjMLbFkbpMUw0HPAKPds5FyO3axnsSeC0JvEO9m6ONeGGoYARbQDmsR/GL53hln73O/6tbiYQY1z5yhfZvNAmIYPuApRUB+1QxYmM1gE40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022440; c=relaxed/simple;
	bh=q/EOS/0Ll7rY8q7nRq+vE4I6a9lfDmdez52yOB8thJw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YB4j3Z/my/zYPf+SDBREIEkZ57FtFdan0EbIejAcV6hN7q+/xf+zNHGJ88irvrKJtR87I5C06KEHDNG/DHTGVGp5dLqiiCOUv63ccsNIPgbImratYRS0RdzyJ3KMSEVmeVEgOYmytR2Ir9bFuK9UZCwW8OkVcd9oiEsYOV0E5Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K66FntWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K66FntWm"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 722451F000E9;
	Thu,  2 Jul 2026 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022437;
	bh=2uU6uUcXBQ9V3M+Oo05s7z23rXqDf1hrLLVFpx92ibg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=K66FntWmu8SXPuCeggF9wFJNw8aN5FOrYTvTsGRyMSx+7VmiCjcE0oqGb6AWYY+3G
	 ky0xCe7Ko+eLWEqhrGJjKe65D1F0qdOgWYb8tHdZ8MHJp9ygVB/EZseUAOb6y6WQMM
	 +kolyxWYJhP/3fAnZOfay3JG+PPkGNN9Nq3+jNF/Sv7LsInvEa5ez8vbzFHXPWN+rC
	 ljkXBwbctrgEa991xdsg8mgdn33oZaN+bP4onlffMxPvptP8oII8VnKRuohGM7xfbe
	 I60whij947Q3tp6c9ps2fIlHAddnj2bVEFi8jOgWiDPYPElWmjFCaEUdDHrXSWYFvg
	 qMit4XLTj7Uqw==
Date: Thu, 02 Jul 2026 13:00:37 -0700
Subject: [PATCH 01/18] libxfs: convert diff_items helpers to cmp_int
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178302226322.845537.14974268104031687429.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Convert each log item type's ->diff_items implementation to use cmp_int
like we did for the kernel a while ago.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/defer_item.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 4fc2c74a548c91..5d72ee0706f0b7 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -50,7 +50,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
+	return cmp_int(ra->xefi_group->xg_gno, rb->xefi_group->xg_gno);
 }
 
 /* Get an EFI. */
@@ -252,7 +252,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an RUI. */
@@ -404,7 +404,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an CUI. */
@@ -563,7 +563,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
 }
 
 /* Get an BUI. */

