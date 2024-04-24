Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA024339A1
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928292; cv=none; b=eJr0oLvj8va9PE6+o4IgYuZc7DU3KoEbigoTAYIlTEOvOXl5anAQ9kG6ldZsg/98J/GKg0186xKzmUqEN7b7pwcd35k7PI4RhYy/w4+NVCkmqiblwsHy+8pgZcbFawShYc+DTIv+cNcJa2B7+6K+fItKRD2omsvsIBJmfKIMB8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928292; c=relaxed/simple;
	bh=c/sQlu1U0TmoQ83cm9fcD+DZn4J4RSYPUn0Sd17J+8E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DNf54G0C/YzsYO7b+Ff25tiSM/ti8GyLcXW+FmIOLATW5kuQEwDWHZMzq0Rcyk8mgzF9GnxQRmFTdJ3vK+523CeZtEJME+UxQwXgBEvdC5f/OAmXfLncTiyt1E5AqvRj1ztmxdrMg/INb8/faUH4+v7AbtK2gtoYdiUtNEgehWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgvHbPk1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgvHbPk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8EFC3277B;
	Wed, 24 Apr 2024 03:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928292;
	bh=c/sQlu1U0TmoQ83cm9fcD+DZn4J4RSYPUn0Sd17J+8E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YgvHbPk1HDE+EO/eSdy2RmIh6xdo3VTwgJO4caUPqIrIKg7AjdRyJ3dVj8w/+pUZF
	 L6gwNni7FMA0AmtdXddVWwDOVTnRdh8X5qKGnuX+z3bIaxX60g+1Py1dgdzLraKoBf
	 0a1qyrCd32NvCZ8j8rwnO7TKjrXSGfBjKL20R+BjIuANmhe3va7oSUI5cx7lslSwYL
	 soi7lhE87LvqCPAgFlj3iQb694Nv8u6SwQD+tUZbkuSiTitDbdkPhrN6n4w/YCISyu
	 tq02umZIvEaOXtox7xUCVKNii8cRgi7c/X/AHn8v4MbtBmSJSyPa6zaDm+stwz6Qin
	 2/afnpGti0PBg==
Date: Tue, 23 Apr 2024 20:11:32 -0700
Subject: [PATCH 10/14] xfs: always set args->value in xfs_attri_item_recover
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782741.1904599.13209325759933716829.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index ebd6e98d9c66..8a13e2840692 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -572,6 +572,8 @@ xfs_attri_recover_work(
 	args->name = nv->name.i_addr;
 	args->namelen = nv->name.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -580,8 +582,6 @@ xfs_attri_recover_work(
 	switch (xfs_attr_intent_op(attr)) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

