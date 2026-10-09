Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0B35C6B8
	for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2026 23:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791589774; cv=none; b=awijToN8a3BMQgjgRj7/ok+aQgV7p4XOc8M/NscV2owgERKDTQOQ8mMyzhKCQl3eJ7OgEl9MOUQWOefqyJ3YWNME27gYiY1PgUPJfXCWr3b5InaDmtLQkSevVw6Bc117AN1iYSPBKhapJok+pVGUeGmAJlpvRfM8Zia64VfylAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791589774; c=relaxed/simple;
	bh=hj4ier3lnJ4W51CimprDuh10rtbbI7e88eSWXG8C1jk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7+wnmRMjmu/8ivCfU1IMBKjdKczejL6sGamq87/o+793UXkjIj3HId/sGe8H4QpEAIV6XDgvkl673LIvN46OFFwokGP71JMhQ7tmKoB5xhwBbt8BK8Geyn+P6pUtpWzfJ576TMHyWKsQixbWGiljIHaRKUwTi0X4mrP50yd+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jAjPBO4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jAjPBO4I"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B73271F000FF;
	Fri,  9 Oct 2026 23:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791589772;
	bh=ud7EOVfOjwvCE9RVJ0cy+rYmgAHUErZKK/bhtTymGpg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=jAjPBO4IBUmUdlIaBLMa3JnK67bmSonulnuTHfdy701esKSSrGp4DadJtccKzzAFG
	 pL5KRz4KzEY9BbYTm3LAGPGxO1bs7ZYb7gMLJd0rXQLhiM1OVB9rf/jqmYeJDQmuvR
	 cYsMymSj9m/H3hozn1DoQnImeWcMaXOmbbFpDnkGyyKZBNMU/cEk803l+0tk4RT1aM
	 yTjrA19kXNxQ3gPCHUfDiGVqtvVMZrahHQyH398L22IsLse/oeXzwwUJjSWZYqsDiE
	 D1edXxpPaoYwpVOD9WVfY2dSvtRt7IiKofacPt02PoX0T0rxmpkL50bF9wRkmEavrA
	 92c6ftyu6c8Ig==
Date: Fri, 09 Oct 2026 16:49:32 -0700
Subject: [PATCH 15/26] xfs: correct the parent pointer space reservation
 comment
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, floss@jetm.me, linux-xfs@vger.kernel.org
Message-ID: <179158947641.3719791.2285916688932690351.stgit@frogsfrogsfrogs>
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

From: Javier Tia <javier@peridio.com>

Source kernel commit: 6c0fc3cb4e879927b338b4fcb6de6a25c0a67608

The comment on xfs_parent_calc_space_res() claims parent pointers are
"always the first attr in an attr tree".  They are not: a parent pointer
is recorded per dirent, so by the Nth hardlink the attr fork is already
in leaf or node format.  The reservation is still correct, because
XFS_DAENTER_SPACE_RES() covers a split at every level of a maximum-depth
attr dabtree whatever format the fork is in, but anyone auditing a
shortfall here is led by the comment to look for a bug that is not
there.

Rewrite the comment to state what actually bounds the result, and record
why the double split allowance and the extent-add term differ from
xfs_attr_calc_size().

Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_trans_space.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 9b8f495c9049cc..c4cd547033e584 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -22,8 +22,23 @@ xfs_parent_calc_space_res(
 	unsigned int		namelen)
 {
 	/*
-	 * Parent pointers are always the first attr in an attr tree, and never
-	 * larger than a block
+	 * A parent pointer is recorded per dirent, so an inode with N links
+	 * carries N of them and the attr fork can already be in leaf or node
+	 * format when one is added.  That does not affect the reservation:
+	 * XFS_DAENTER_SPACE_RES covers a split at every level of a
+	 * maximum-depth attr dabtree, whatever format the fork is in now.
+	 *
+	 * The name is a dirent name and the value is a struct xfs_parent_rec,
+	 * so the leaf entry is always local and never exceeds 272 bytes.
+	 * Parent pointers require V5, hence a 1k minimum block size, so the
+	 * entry always stays under half a block and this needs none of the
+	 * double split allowance that xfs_attr_calc_size() makes.
+	 *
+	 * The second term hands a byte count to a macro whose parameter counts
+	 * mappings, so it asks for more extent-add allowance than the single
+	 * mapping a parent pointer adds - how much more depends on the block
+	 * size.  It over-reserves either way, which is why it is left alone:
+	 * correcting the unit would shrink a reservation that is only generous.
 	 */
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);

