Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593282A1AA
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 02:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346737; cv=none; b=EsHy7cGuYvs9TxcuMMR60Ur32ZtlTqzzDyFfL82tjgHL6hgVub9EcimtnMjF6CcmWTpIF3AAQRkgJDbqWli2YseHzMifsu8sA8e+kTsd8JVw86VRXHWY5rEdnLGF6njNygzIPouz+c0vWQQPD95YiIOyrj5eEprqMOUKBtuQUFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346737; c=relaxed/simple;
	bh=UaWd68bejAnjPMxW8Chl1aoJ/4ZGiDAPgXS12g5TQ7w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kZIBwVKbeohc0ZeNwkJW4XOSJVnyk4rCHRmfNY04G5K9AgtSM1hqM4nMS8Y180uJ/+7PpH2Ox5ToaiHcxBaDEk9u6vNi/AXItyi5o5N10ZmOzYYjhkSHmARB5momZFmYvfi8dc3/nkNwkUTc/fnThCOM/0Tz6Ty1+owK6mYtF4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFK5iDga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFK5iDga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33667C2BD11;
	Wed, 22 May 2024 02:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716346737;
	bh=UaWd68bejAnjPMxW8Chl1aoJ/4ZGiDAPgXS12g5TQ7w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EFK5iDga59cSMzoIC4mNc5oE7shsNSICG34esm/knQRZ/ssKFchzJL1hbgHg3YlxD
	 l3FMsAn92gcaxT55tiTVVMrkJh7VmRncWutogG2bfLZh14Fmkxt+JOljWg+azFcS4o
	 YCpMeWWn40KUTOiVNBUDboGOt1QFjUGkwUm/Y5sL3KnZOJKfvGZhT/QObMAM+sCh/c
	 eIaidCKlJEu/jEWc1tAsBCcHanjWASbYEynVxejZW9jdGrgBCxfDmdQtZ2Lcbvo4jM
	 pc01b8lywfliuc+sMVQhYxfkY3ETahIgUygCsWnn0uktyAoteQe427D/s5PgNAvx5w
	 hSKY98ButLy4Q==
Date: Tue, 21 May 2024 19:58:56 -0700
Subject: [PATCH 039/111] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634532297.2478931.1583157878386084259.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7771f7030007e3faa6906864d01b504b590e1ca2

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_btree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 541f2336c..372a521c1 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1225,8 +1225,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*

