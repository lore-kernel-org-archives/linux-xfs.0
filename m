Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F04735C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589836; cv=none; b=tRY6+LxGWCHiGnJRmNm+blgbQd7owaBmCjxznT0oCpYp4W26I+tJUWnvZ0m+9HQQin+By4jUdqwMv+i1AjeQaWSi1RgzvOOkjmHg8+uzyujklaMkUuZOVq4Iw+U0/ECcyelC1g5WCAZ7V0BHzZFkXMf6KgN3e1LxujPaqLQ7alM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589836; c=relaxed/simple;
	bh=vAUqV29IwGMeql0BckaDLGAWUkXrTWO7OPpU25k0pCg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNqikZU2KPzzKB+DgFc5wSvmUNkN/MYomQITNKTs+iICTeOMP7N/zyVGe7rQObU3vzQx+PnVXaPuVQVdz+YTMy/IgTMzao+EF6PQNvfBHP3boilYec8OjrmbRBekWdQON9pDDuBgvuCOG301MJ09BMaUqt4EsvsoGBMKo7nDaK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpBFvOUN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpBFvOUN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4831A1F000FF;
	Fri,  9 Oct 2026 23:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589835;
	bh=ZOy1MiG5dHqb1cttGARvw4X12D18RKAWzdbYbTci01w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=bpBFvOUNmptQVEmvlQSw3rgni+Bmr/+h14YnXNH0Zl28ptjLuf7ODCa7b+GzN0Q/C
	 mGXw7Qk4hFuu/FRj/nbrIe0rqFVhdbBjMiLd3p8tWlcP/pjWdVMvL2UtZ5Bkz5Zn7j
	 3ozt77B4GUz2aOiaqUedwZa4kk6mdcpSSkCVtKHIGJlS6mZDn8SAASisKAiSCfhxfA
	 hJRxrSLaOF1d99ldsqk1qt6X4lsRaKuT5gGiZnFvkYCxbZJmg1NUom8oVuQtdiRheu
	 W3H6mUrgYWSm+aljT9c80jilL/u/oDYtNpH5h1t/EXetZYB2vsfdo3r+QK+mstOuJV
	 H2GBNgvPj1Alg==
Date: Fri, 09 Oct 2026 16:50:34 -0700
Subject: [PATCH 19/26] xfs: fix xfs_rtrmapbt_mem_cursor for non-rmap
 filesystems
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <179158947716.3719791.6239040012212820785.stgit@frogsfrogsfrogs>
In-Reply-To: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
References: <179158947238.3719791.8405495844046466765.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 022d5f5fce7f0b6125d404eb74044e6238aef369

It's possible to construct an in-memory rtrmap btree for filesystems
that don't have the rmap feature enabled.  The kernel doesn't do this,
but xfs_repair will, if asked to reindex a filesystem that has rtreflink
enabled but not rtrmap.  Therefore, we must create the cursor with
enough levels to handle a maximally sized btree possible.

Note that the rtrmapbt btree cursor slab creates objects large enough to
handle xfs_rtrmap_maxlevels_ondisk() levels, so setting bc_nlevels to
the same value isn't costing us any extra memory.

Fixes: 4a61f12eb11958 ("xfs: create a shadow rmap btree during realtime rmap repair")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtrmap_btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 0cb2113d5b4045..a15e460a1ec7f4 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -618,7 +618,7 @@ xfs_rtrmapbt_mem_cursor(
 	struct xfs_btree_cur	*cur;
 
 	cur = xfs_btree_alloc_cursor(mp, tp, &xfs_rtrmapbt_mem_ops,
-			mp->m_rtrmap_maxlevels, xfs_rtrmapbt_cur_cache);
+			xfs_rtrmapbt_maxlevels_ondisk(), xfs_rtrmapbt_cur_cache);
 	cur->bc_mem.xfbtree = xfbt;
 	cur->bc_nlevels = xfbt->nlevels;
 	cur->bc_group = xfs_group_hold(rtg_group(rtg));

