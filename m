Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0E61DED44;
	Thu, 17 Oct 2024 18:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191491; cv=none; b=gWlFuickA+Ad+b27XjXDl5KdwSDkydTlSWng1iwuAgcfwtJjHiPnm3sj0+n/on3t88+yYh2+qwSJdInV4fWSWCuiIhHdr0VDXuTcgFH05fIzN6xl7L/rLoMy1m3+/BcS9xfI26NyVAuDdXvFnv9tulGlZWXizOAN1k7ZFtKwLjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191491; c=relaxed/simple;
	bh=3xCmm/ozmDl6ayamaN5IqbYaI43YKYhBeLikoP0M3yk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VAPtjRxXO8h8UYgE3aWSsvH4OkJpRhtNLi5BgmEBCBzprOpmtxC0AlBc4xqI8OqY38lLswvsETCIs30NAN0imLUsgSXzKtJKvkip4taqC1gxaTX8PM1k7uxErC+Hawd87bHqh6U9Scsp8XAFJGdS9j7huxW4rS0jLq5UBjSi4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aehmR1Gn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aehmR1Gn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A01C4CEC3;
	Thu, 17 Oct 2024 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191490;
	bh=3xCmm/ozmDl6ayamaN5IqbYaI43YKYhBeLikoP0M3yk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aehmR1Gndo95vZfSdc4IU6ljxZkussaYBBgOaEatn/wWf3se6CiPxMSapnbZEeSmI
	 pPGDNHCbM7NLXOqKRGmMNYZ30mDlUGDTMfNm3pQX052oaUHyLOqhXdQSsoOuMtaEc+
	 DCr8cn4YBI4xX6VLlTiiTpnOJemKnCqMa1GQGF6uZaYJotfa7yHlqo0pMsHCsVgmcl
	 mKtzrhaQ37q1WnpVBRUPrvQ3H14UWWN9SjEDE877V8GvZ+AXPV34jIUEblOeMUeh/G
	 qsQakPXEP+GeKUxjL4aEqcPGZRyhAddh3HqIW9iI5xscooLD7G23pNf3UfhisFBFjI
	 RInjB6MLT8RUQ==
Date: Thu, 17 Oct 2024 11:58:10 -0700
Subject: [PATCH 20/29] xfs: don't fail repairs on metadata files with no attr
 fork
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919069796.3451313.2227454340362290952.stgit@frogsfrogsfrogs>
In-Reply-To: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
References: <172919069364.3451313.14303329469780278917.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Fix a minor bug where we fail repairs on metadata files that do not have
attr forks because xrep_metadata_inode_subtype doesn't filter ENOENT.

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 5a8e07e799721b ("xfs: repair the inode core and forks of a metadata inode")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/repair.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 3b4f6c207576a6..646ac8ade88d0b 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1083,9 +1083,11 @@ xrep_metadata_inode_forks(
 		return error;
 
 	/* Make sure the attr fork looks ok before we delete it. */
-	error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
-	if (error)
-		return error;
+	if (xfs_inode_hasattr(sc->ip)) {
+		error = xrep_metadata_inode_subtype(sc, XFS_SCRUB_TYPE_BMBTA);
+		if (error)
+			return error;
+	}
 
 	/* Clear the reflink flag since metadata never shares. */
 	if (xfs_is_reflink_inode(sc->ip)) {

