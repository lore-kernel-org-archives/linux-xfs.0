Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E4913A884
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717441615; cv=none; b=UKq6hbcdyb2Lxt7/al93rBKtS6xmx+8rMRdFqFfjjzKE97CfOFFPGvJfFm4KmOqnOfrGjMpo597AuNBn9BNBkJVmPI7Bhx/gmyNKMWWPGBcmy03oRB2qgUULtiSGnfpSn1fQD4FwQh8szuIz+hS7QIdoNpikh12qFa38EGkWhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717441615; c=relaxed/simple;
	bh=Endd5SgKi1qHWUtVKhKxxTwKfz/F4LkMGm+OKbRHGos=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ARk5W1N4MKkROYkcGJexEZNmgWTMvCRFzf9Mxgn1jy/sfI6sRfvy/2n9kdvaixMzZCNuEFRC4fqEznjx9f4co5nuu+i3yS705V/ZjgnUtZcSf8QZXj1744mbRn44EbIwSRjVWzgULb/+wsdaZdtkJ13RiT22KiQXS1JfInuBVAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSOIGyZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSOIGyZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F001C2BD10;
	Mon,  3 Jun 2024 19:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717441615;
	bh=Endd5SgKi1qHWUtVKhKxxTwKfz/F4LkMGm+OKbRHGos=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nSOIGyZDU2cGRcTVRSoBkwIB7AJSX6yu51us4QpAIyVo+jfU1tDlrNTyAiHrXCxfr
	 MjXlPTVuEsxcakrSwLqtIyNKyXo186quYyS2rxjIDh1loFJ0a8NwY18QQJ84r8z2Bb
	 FkCAn8r/krpCU55Ck9hK7Slx4X67RJwJRz7vheE6FRa2qMPtp1edN3mNGGcY1GczW+
	 A3fmt8X58g2PDZwkReF7J1gCAFKDsMlRUGAMRQCYW/YyYBJ9ES9ciruJ7tFwTW9GDC
	 hRcBo7QcE5Piwg6jonYqzCHPcKpry0DVdGpE8GqQCtKyAQYIrIT5K6ZJFBbXBgm8FD
	 voOrBwz0yHrZw==
Date: Mon, 03 Jun 2024 12:06:55 -0700
Subject: [PATCH 057/111] xfs: fold xfs_refcountbt_init_common into
 xfs_refcountbt_init_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040230.1443973.9529883425738058298.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4f2dc69e4bcb4b3bfaea0a96ac6424b0ed998172

Make the levels initialization in xfs_refcountbt_init_cursor conditional
and merge the two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_refcount_btree.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 45bfb39e0..c1ae76949 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -345,12 +345,15 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 };
 
 /*
- * Initialize a new refcount btree cursor.
+ * Create a new refcount btree cursor.
+ *
+ * For staging cursors tp and agbp are NULL.
  */
-static struct xfs_btree_cur *
-xfs_refcountbt_init_common(
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
 	struct xfs_perag	*pag)
 {
 	struct xfs_btree_cur	*cur;
@@ -363,23 +366,12 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_refc.nr_ops = 0;
 	cur->bc_refc.shape_changes = 0;
-	return cur;
-}
-
-/* Create a btree cursor. */
-struct xfs_btree_cur *
-xfs_refcountbt_init_cursor(
-	struct xfs_mount	*mp,
-	struct xfs_trans	*tp,
-	struct xfs_buf		*agbp,
-	struct xfs_perag	*pag)
-{
-	struct xfs_agf		*agf = agbp->b_addr;
-	struct xfs_btree_cur	*cur;
-
-	cur = xfs_refcountbt_init_common(mp, tp, pag);
-	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
 	cur->bc_ag.agbp = agbp;
+	if (agbp) {
+		struct xfs_agf		*agf = agbp->b_addr;
+
+		cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+	}
 	return cur;
 }
 
@@ -392,7 +384,7 @@ xfs_refcountbt_stage_cursor(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_refcountbt_init_common(mp, NULL, pag);
+	cur = xfs_refcountbt_init_cursor(mp, NULL, NULL, pag);
 	xfs_btree_stage_afakeroot(cur, afake);
 	return cur;
 }

