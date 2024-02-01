Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59AF85624
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817318; cv=none; b=J888fmikdczTDEmHI7jVhEkBE8CHooIfxYhY5tfyWviO1+T4tezGyUBNIO6oGjvdPQwWOoMalTyrDgzo5YOjhiXDIepd0zZSTrljwZ8o/toTdEcFJZ5zS0fMqJ7Rny0nHB+qumo0W/0E7cZs9dpD2/ZNC2YeAXeYBstlG/aNo+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817318; c=relaxed/simple;
	bh=Kra+ZKx13zRD4So+HKD7CWA+Syczb2nld4cLORoD9Og=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdBYFO5h5gE3zuubWLolwJhzn6W0ItTz8QsQj8v8bKGPEoMC6CUMc9Tf/w58+Irk+ha0rTQdsT1ICqRz7inJ0fR247ju1k0gmieJXjArs/mU4TCX3zOWx9JKcLjrpyy8tLntFlfev+OMLsxShsMCaXTA1ykUxstGj4NB+XhhDVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afKyIos6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afKyIos6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBA0C433C7;
	Thu,  1 Feb 2024 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817318;
	bh=Kra+ZKx13zRD4So+HKD7CWA+Syczb2nld4cLORoD9Og=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=afKyIos6WcRmWyegozmeWQ1oW6b5DaNlCESRHLJ1OAzKFz5ofUV4LFsl5EEjmTEqx
	 ZEuKPrIpyX8lWSuKcwh0t+Szwm+9vozErefEXGkLn50YYXRfz7hVtKNc2Ld5xYkV3T
	 Oz+YdPm/KpT05AEIwHYnbf3Y+LR87/PyPsb9efrctChJvYKNFAbuYFPQZWEV8QdLA7
	 70g2qqcuMtytcc1FNtz1moIHE0HmyFeC+5b3LjERSCogZBKbamJkR+P2IUrGuZJMAC
	 xyyVjce4PnjlrqEbtMDhmgipowcuAZeOvDdSuwkZy+PqezzX0bv9X9J6sRt5vpLdGo
	 89fHZ9zYGhXPA==
Date: Thu, 01 Feb 2024 11:55:18 -0800
Subject: [PATCH 10/10] xfs: factor out a __xfs_btree_check_lblock_hdr helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335775.1606142.573085723194430847.stgit@frogsfrogsfrogs>
In-Reply-To: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
References: <170681335588.1606142.6111968277910779056.stgit@frogsfrogsfrogs>
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

This will allow sharing code with the in-memory block checking helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 96c1c69689880..b228b22893fa0 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -94,20 +94,14 @@ xfs_btree_check_agblock_siblings(
 	return NULL;
 }
 
-/*
- * Check a long btree block header.  Return the address of the failing check,
- * or NULL if everything is ok.
- */
 static xfs_failaddr_t
-__xfs_btree_check_fsblock(
+__xfs_btree_check_lblock_hdr(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-	xfs_fsblock_t		fsb;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
@@ -127,6 +121,28 @@ __xfs_btree_check_fsblock(
 	    cur->bc_ops->get_maxrecs(cur, level))
 		return __this_address;
 
+	return NULL;
+}
+
+/*
+ * Check a long btree block header.  Return the address of the failing check,
+ * or NULL if everything is ok.
+ */
+static xfs_failaddr_t
+__xfs_btree_check_fsblock(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	int			level,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+	xfs_fsblock_t		fsb;
+
+	fa = __xfs_btree_check_lblock_hdr(cur, block, level, bp);
+	if (fa)
+		return fa;
+
 	/*
 	 * For inode-rooted btrees, the root block sits in the inode fork.  In
 	 * that case bp is NULL, and the block must not have any siblings.

