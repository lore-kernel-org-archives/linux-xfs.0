Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDEC6306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022655; cv=none; b=sSBcd66BvIt26yda47IGmKByzPDSjlmRJJwS+xUnPfhUvdoR/WdamC9p5kljFFkUQp/2q4roacV73OI06nve8m08XKWLjbhCQd9iuGt3KoHtY9nDN0cxvjJAUow3RJ+IQlqyfmFp/Ax80ZfzXEvErAgnhQQmj1HqwgoDgRt2GFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022655; c=relaxed/simple;
	bh=ImQbkyJrQeD+bfCRzBsCElfAv6+OSa99h3hJaO9ctzE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q3w/8jXEMtL6s3CbgJQE5PuA90vDJeH6Mcb8zt+pJrNXCLc1qf7B5HT+nAgTevBPpCV067D6k98PzRQnsxQVdC0z7Pvo82vGRTwMQM5goCMAsYqadVMidcyLLBrFeXg5HFT6EI3J+He4ptdLj4rfov1ER2/RG0QL55ur5Xy3eXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lHX7vS6A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lHX7vS6A"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A85291F000E9;
	Thu,  2 Jul 2026 20:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022654;
	bh=45g9Qjpqs+JIv6Xan18fDSZeKkhaUg7w+aPPYZc75Lg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=lHX7vS6AjXHTq3lHArIbcW3uex/xWgSJTJ0bZVcN9nHk+kHxNVjN3A+zxLaMzvG06
	 mRyVAO03Wo8MgR3HOsX+EVGazgJ2BRjx62NLfmfXtM7EsrpvBYsTts0+txmlRgll4w
	 jWHhD0dD60BZJQbwPq+v4ubm7wNg3VMS1FjwFQilSv/RY6kFBuJS5culOjV/cES/sc
	 MBqphIkrmIM8gnv69vGwdTrJV+fzrtnIPl/9vklGjhVZ+mH3b4Y2l1A4QJdL+aJsSO
	 nHq6axpFa0N8DTv4fvT2B5dFt8pXOOVn2v4orMcgC7VTpv/8e5nhft8QpWSH8d8A9g
	 40p/BPOQLm7hQ==
Date: Thu, 02 Jul 2026 13:04:14 -0700
Subject: [PATCH 15/18] xfs: fix pointer arithmetic error on 32-bit systems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <178302226583.845537.11756085649028918072.stgit@frogsfrogsfrogs>
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

Source kernel commit: 84eec3f7fc73144d1a230c9e8ad92721e37dcaab

The translation of the old XFS_BMBT_KEY_ADDR macro into a static
function is not correct on 32-bit systems because the sizeof() argument
went from being a xfs_bmbt_key_t (i.e. a struct) to a (struct
xfs_bmbt_key *) (i.e. a pointer to the same struct).  On 64-bit systems
this turns out ok because they are the same size, but on 32-bit systems
this is catastrophic because they are not the same size.  So far there
have been no complaints, most likely because the xfs developers urge
against running it on 32-bit systems.  But this needs fixing asap.

Fixes: 79124b37400635 ("xfs: replace shouty XFS_BM{BT,DR} macros")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_bmap_btree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index b238d559ab0369..e0c870beaf670c 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -89,7 +89,7 @@ xfs_bmbt_key_addr(
 {
 	return (struct xfs_bmbt_key *)
 		((char *)block + xfs_bmbt_block_len(mp) +
-		 (index - 1) * sizeof(struct xfs_bmbt_key *));
+		 (index - 1) * sizeof(struct xfs_bmbt_key));
 }
 
 static inline xfs_bmbt_ptr_t *

