Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B914DF9F0
	for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2024 02:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000999; cv=none; b=Psc3vwdo4xvMqQYhW/MVPLonbRsMmhsC7EwchB4xH6gYrE/xFyYwF9jj5Tnu+QndfH71WnPEO7g5MyywvQrzQaf25CGITyziiqLkgeGeRLGIXS7W+me5uH20xTeMCyNZI1HZl7S+45xyXSXOC+dCt0GCP0JFPMkKxaQkJUZ+zwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000999; c=relaxed/simple;
	bh=bYYcFDAjIEIXAlaFT8RMhHFy94VEPwGjDL+1W7bb9e4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hh0Tdd/me7mPwyy0oJC5LYxdn6YC15laYrp5GbRaoFwHFE70U2bFjg20/N2AjxJakCG7+3Vo5OMO9N/s8M/tGHv8bOcTbU9uPF4v2mERf3PVeAOel2BD672UCuS2RrK5YAGk/TlclZGuXpWGTmFiksSHrBZJheb1KprejP4mSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCZRMWMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCZRMWMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC1C43390;
	Tue, 27 Feb 2024 02:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709000999;
	bh=bYYcFDAjIEIXAlaFT8RMhHFy94VEPwGjDL+1W7bb9e4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LCZRMWMv1scNYrgu0aA70vXwZFi5NTUv7VLlTTOc6Th7eA4HQyX/h8IFzdhE3uzYP
	 MqXYXM9cfT2QB67Xr5TXsZmLRPLl5Yu+fpAzP/9gTDD52posmlCs3spcTbm12Txbt1
	 FBDmdcIhqCcXmVR4mBP6Ztyj85XUPIMM2ORTdYGqi4QFrbjSFqoSZRAtul3/2RaLxd
	 h2gDgrGtn8s+A4xK1bJjmDO3LW+SBl7IQlImtEl5lj2788IQDaLygI/oqJMcdCejmd
	 8AClIe9xzSffSWa8LSoPISKkJfwiQX7ociVtQJHz3C3f2r+n1mHNG33xi6fXyUPWvc
	 ivciqgsXz01kA==
Date: Mon, 26 Feb 2024 18:29:59 -0800
Subject: [PATCH 5/6] xfs: flag empty xattr leaf blocks for optimization
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <170900013712.939212.17272210848443405734.stgit@frogsfrogsfrogs>
In-Reply-To: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
References: <170900013612.939212.8818215066021410611.stgit@frogsfrogsfrogs>
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

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ba06be86ac7d4..696971204b876 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -420,6 +420,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index d654c125feb4d..de291e3b77dd8 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

