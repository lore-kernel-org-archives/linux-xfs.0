Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E28921353
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425413; cv=none; b=gvE73QC4a6PkykZhuFjlNhsD4pRgC6zStd0FNZ7zJEDWfaHcO2wuo7FIqB5DBXK55efCaytrgnzvW87GuNbfzvaOTjq68nwZjWSZf8qD9yOP8QBnXojLCOz0VZqz6ocHRQ1BqbfFm1jIRHcUfq2vfEnJVyWHxgEcmZbb9RW+Uk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425413; c=relaxed/simple;
	bh=o9o6Z+xTLgCWztrQLV0tEG8cAejXzaWFN6RLkPkGKuU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTCHMyhbl4xQ5AQmtidUHgAXeb/yn/qJeFgqr72ViRvNTpkVlu+Bk6lpBYEKT4l6fO7XVvLSrLrXdw7JFACbDagTygo2zsQyVKBJzVZ+erQ5uo0+fTsXjx68QKOPSiViMd7buppQ+Yy5YxnIGd3+AhZcBZ+9jZO0aMq6+pWaFSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7jtJ+Kf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7jtJ+Kf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB37C433F1;
	Tue, 26 Mar 2024 03:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425412;
	bh=o9o6Z+xTLgCWztrQLV0tEG8cAejXzaWFN6RLkPkGKuU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=A7jtJ+KfcI+aELDRA5oPoIHHBwOTW92/H8rvuaF0eBMYbUadTX/5cXc0Zm0dZg4aD
	 yrVCEsVrFBFD1k8d/EVOMymxEmBDclyFlYaAS6dCPNwuzRkDgWrY8fGKAR/5XJ++Qa
	 5pXWmiuIT0U/sW2Qzc/2BXx/h8I+yNW2SokYdBn2g/MgPN9xUQylDoOmOZgHcdLHC3
	 1GEHO5T0RnvjI7qaQE78ECzn4EVf2rewHgU9PmN4RO7aD/v8tlP8L9GqW8XCZxUFyU
	 lxX5qe5/yFnSGI0KqskMcNiiwE+QVDNyN9YxWSraccF2iyirGBrJbrXAKRjexzRFIq
	 38uSxb1DFefGw==
Date: Mon, 25 Mar 2024 20:56:52 -0700
Subject: [PATCH 109/110] xfs: xfs_btree_bload_prep_block() should use
 __GFP_NOFAIL
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
 Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <171142132947.2215168.11486702118601747547.stgit@frogsfrogsfrogs>
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

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 3aca0676a1141c4d198f8b3c934435941ba84244

This was missed in the conversion from KM* flags.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 10634530f7ba ("xfs: convert kmem_zalloc() to kzalloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_btree_staging.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 52410fe4f2e4..2f5b1d0b685d 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -303,7 +303,7 @@ xfs_btree_bload_prep_block(
 
 		/* Allocate a new incore btree root block. */
 		new_size = bbl->iroot_size(cur, level, nr_this_block, priv);
-		ifp->if_broot = kzalloc(new_size, GFP_KERNEL);
+		ifp->if_broot = kzalloc(new_size, GFP_KERNEL | __GFP_NOFAIL);
 		ifp->if_broot_bytes = (int)new_size;
 
 		/* Initialize it and send it out. */

