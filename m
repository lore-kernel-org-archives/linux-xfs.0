Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E14B129E92
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424958; cv=none; b=a5wOVucKvP9eSv9WSes+WTfNAjqZFYEAYdNLYHrQtnXfsD9ISg8/8imiZR2GWaiQXfosCfseVs2eaCEvUMNEOvvDZrtnCLwysHE0KWwL5/KXBP277+gaZRmIAHc7UhFJ3eWXVM+UEsEOssN2BDXKlPGvzEr8A/BARYBbTibdpNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424958; c=relaxed/simple;
	bh=V/CxuF290yq+UPkIAJS1Zcxhkz3Zlex+RKyKCsn54sE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erTeENDSpsCLDqrBrj542rm6EZ08j8ZpkCwZc3TJnCl01frZfyqeG6jztdMRnZvvZXtMloj7GIquO3eCa1QD552KPrzwYUfw7hoyfFkbZPq1zVzV3qKSBqzjZtOgtZ8+PDUv+VfMjjNz7oRAzyd7kV4S0PydnJJQINVFKZ/x440=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUftF/6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUftF/6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4948BC433C7;
	Tue, 26 Mar 2024 03:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424958;
	bh=V/CxuF290yq+UPkIAJS1Zcxhkz3Zlex+RKyKCsn54sE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TUftF/6dnXQsHJq8gGVJiLE/iRkyM/f2+ah6eespdZ/My01FcHNgnxOgGvGw6BtM9
	 i0jGGmf+f4uxNq0Yw60HCqBvQc9VwUz61LOJe706EC++EkCUFGCDUlv1fPTLTyxx1h
	 NVW7gZCREvZqhzEapyANGtVcD3hmHA5X1xVzaV+95OJ6GJIOcbIeJKvroOLrf7PTuH
	 Cj9CMOSMbPGfaJcNbfAk5KmXW1AT9bnS5azhjQTOOPhW4ukvNm3XsA4VpvkzTaPdOv
	 +/1IX4uvLMYWF1ih8gfElHDxgodVPBRxlWxpV8omWPNk38VxZNOoyScbBt5KMEBi/B
	 Ao3B8jbg6WCUQ==
Date: Mon, 25 Mar 2024 20:49:17 -0700
Subject: [PATCH 080/110] xfs: remove the crc variable in
 __xfs_btree_check_lblock
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132533.2215168.4542335974314712450.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: bd45019d9aa942d1c2457d96a7dbf2ad3051754b

crc is only used once, just use the xfs_has_crc check directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 359125a21b18..0b5002540b50 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -103,11 +103,10 @@ __xfs_btree_check_lblock(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	bool			crc = xfs_has_crc(mp);
 	xfs_failaddr_t		fa;
 	xfs_fsblock_t		fsb = NULLFSBLOCK;
 
-	if (crc) {
+	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
 			return __this_address;
 		if (block->bb_u.l.bb_blkno !=

