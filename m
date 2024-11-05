Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556B0216209
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844889; cv=none; b=m8nHEYsIHKFZ5QvNP/e0p3A5YAmXBPwGH6djRx9+WvxIcXdqRwLyg/luDQFaqJ0WNKg5AyftStyfrXVzGCOwl1hwFrf2NspYHnG9YBkw/6IfFlugXQW34HDXpkEaSG6MfyYhA9KPmjr36usfl5UY2ijN/a4ti2PxY/JhqRYkzlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844889; c=relaxed/simple;
	bh=2Nq70ziXD1UW7b3CyWHft1Typiy8Iy6IfUmyc5cz00I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOyDha0r/OyEHSjt1I0+FTkTuOXX3OnrNaw4XbFfnsGp/Pmn6hxQ/PkepVvZe2HoCwF3FuwalY0G1ezyr8RetedayuLFiac5m5woTUWpa6Aof0hFgh3ulbsuydFuID2wJ7UW/jM2EILsDXtb37fAXcahqjzZxyzoRyk/TzITntI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rm/Wq4U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rm/Wq4U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDD1C4CECF;
	Tue,  5 Nov 2024 22:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844889;
	bh=2Nq70ziXD1UW7b3CyWHft1Typiy8Iy6IfUmyc5cz00I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rm/Wq4U80I5nf/FxcE2tgObXykd29D7seCnEHz7Fga9Nppb3CvtfQ1Lz+HNrPiiDV
	 Jiy3OLmqCzyZ4ZtyGeJAtwX/9lxnV/r9FuI+G3taO05oi5qMI5dyE7CGLQzfmyrVJj
	 k2AvnZ0zm+3AolEUurwxJoODtTfcNu8hZu6mPzEe5c/n2A81cTRGaOKBDDZdy7/+P1
	 TOuqFqxF4K7m2vofTcHtonBgIfYf+HbE9TAF4HA4gAti+sWdmmOgE7hPBERK7x9RdQ
	 h3ZEwJpX3saghDy4YFGyfqaMf2u+PMpn1DcljzkQKoS5bjIENeUfmtRi0zFg9EMDae
	 88Vt96peaKa+A==
Date: Tue, 05 Nov 2024 14:14:48 -0800
Subject: [PATCH 09/16] xfs: return the busy generation from
 xfs_extent_busy_list_empty
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395424.1869491.2480576942197321919.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
References: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

This avoid having to poke into the internals of the busy tracking in
xrep_setup_ag_allocbt.

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

