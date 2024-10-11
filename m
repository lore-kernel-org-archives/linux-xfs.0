Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACA44A06
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607593; cv=none; b=m1Rz34zDr6QA+qy9gQkPEO887PPwo83ysP7gMqfEtnpBUaMYxDjC2qHzSOezW4XoaxbkFeR6bDwfQ/aeN/RUsi0WuTS6Z66ueXsQShGcNCZxZ6kGeHRqA/9nT+LeCbToXWfYEb+aOWShUe6CLv4f1FfVS1DxUohOfPK24hlrD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607593; c=relaxed/simple;
	bh=fVmm6l+3R0x3aJUgDKtb/s04NxeReHb++8pCoPgJUps=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTHOSmHfPIG0SaE0OvXhBXTaUQV4AsArjDO/WKYgxqUr+VrN+L1Iip3TO2jo2o8iE+eawa1+Jx7/dxxObNdlYS50faP9+FNs5neJn9h/E+2kFKDEUQfAzx3IoJxXk9hXBjVnTF3DJfVEpGqG+126BU1oBvMZsBPQR2ZB4CG/Mts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H53UTeUF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H53UTeUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ADDC4CEC5;
	Fri, 11 Oct 2024 00:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607593;
	bh=fVmm6l+3R0x3aJUgDKtb/s04NxeReHb++8pCoPgJUps=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=H53UTeUFum6FnJSJij1IDgzpLT3AjgbOidGArv+DoRfoefLyRuLJUQk0Sw+qN1lbQ
	 o9iENsv1NJGt5cfv3AiYUI+9NRppAeD94piH/rLXjLbaF4Ac6IcKNuhJ/APVf4xHjN
	 VAUSJXm1pZxLJ1IpUp8Lyekj5iNklwaKa7KZ8qYS9VqG+VaVLmRKrL+40K5ilF7xLN
	 NRmFFEc5gm6GX+IOgPkWct1nruk0JyaP1nXEOd183el9AS+9k+oB2b4G5LFn2cP9gA
	 fnUSXCLwcwakGrEhH9V2+s+a7QJ07BBrUnHbOXj89NuuY3/8XHIo73XD+x9oXVphKH
	 VMgCBMish8Jlw==
Date: Thu, 10 Oct 2024 17:46:33 -0700
Subject: [PATCH 09/16] xfs: return the busy generation from
 xfs_extent_busy_list_empty
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641418.4176300.11993858546243767891.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

This avoid having to poke into the internals of the busy tracking in
ẋrep_setup_ag_allocbt.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc_repair.c |    9 +++------
 fs/xfs/xfs_extent_busy.c    |    4 +++-
 fs/xfs/xfs_extent_busy.h    |    2 +-
 3 files changed, 7 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index ab0084c4249657..f07cd93012c675 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -132,16 +132,12 @@ int
 xrep_setup_ag_allocbt(
 	struct xfs_scrub	*sc)
 {
-	unsigned int		busy_gen;
-
 	/*
 	 * Make sure the busy extent list is clear because we can't put extents
 	 * on there twice.
 	 */
-	busy_gen = READ_ONCE(sc->sa.pag->pagb_gen);
-	if (xfs_extent_busy_list_empty(sc->sa.pag))
+	if (xfs_extent_busy_list_empty(sc->sa.pag, &busy_gen))
 		return 0;
-
 	return xfs_extent_busy_flush(sc->tp, sc->sa.pag, busy_gen, 0);
 }
 
@@ -849,6 +845,7 @@ xrep_allocbt(
 {
 	struct xrep_abt		*ra;
 	struct xfs_mount	*mp = sc->mp;
+	unsigned int		busy_gen;
 	char			*descr;
 	int			error;
 
@@ -869,7 +866,7 @@ xrep_allocbt(
 	 * on there twice.  In theory we cleared this before we started, but
 	 * let's not risk the filesystem.
 	 */
-	if (!xfs_extent_busy_list_empty(sc->sa.pag)) {
+	if (!xfs_extent_busy_list_empty(sc->sa.pag, &busy_gen)) {
 		error = -EDEADLOCK;
 		goto out_ra;
 	}
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 3d5a57d7ac5e14..2806fc6ab4800d 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -667,12 +667,14 @@ xfs_extent_busy_ag_cmp(
 /* Are there any busy extents in this AG? */
 bool
 xfs_extent_busy_list_empty(
-	struct xfs_perag	*pag)
+	struct xfs_perag	*pag,
+	unsigned		*busy_gen)
 {
 	bool			res;
 
 	spin_lock(&pag->pagb_lock);
 	res = RB_EMPTY_ROOT(&pag->pagb_tree);
+	*busy_gen = READ_ONCE(pag->pagb_gen);
 	spin_unlock(&pag->pagb_lock);
 	return res;
 }
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index 7241035ce4ef9d..c803dcd124a628 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -83,6 +83,6 @@ static inline void xfs_extent_busy_sort(struct list_head *list)
 	list_sort(NULL, list, xfs_extent_busy_ag_cmp);
 }
 
-bool xfs_extent_busy_list_empty(struct xfs_perag *pag);
+bool xfs_extent_busy_list_empty(struct xfs_perag *pag, unsigned int *busy_gen);
 
 #endif /* __XFS_EXTENT_BUSY_H__ */

