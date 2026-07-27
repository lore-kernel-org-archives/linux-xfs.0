Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9B0233723
	for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 05:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785129874; cv=none; b=O4KLtjnb8P291oSbdDIPyk487WWUG3S73KOwsu7O/UwLGcZVTajJHnne036oUvI8OYYXwWzeEILUFjhili6yw+S1eN/yWqhaKiG4BUp/msO71CpidEQi4Y/HKds/fS1Qziuqb3+ijGu2Qjct9hwNzBWAruGXz4cPn7wOOUa4VnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785129874; c=relaxed/simple;
	bh=4M3yQlzdPwgLHZxovAJJRKtKtQB5dtx9GcWjUX6oFbY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLXaq8371nX9GovJbESJeqDK8kend3XXdXqRsRP5q219DWtpcvbl9Un54bSCo9E4P9ZHnUu2UUVJ2Wk9K+gP1NDjpFYrzhUnF/zGwGI375uUauXtnE7MFgMsyZwsLqTLVcEX5UnTixecsHQrc6qgaQZud/BGU0uwqYw5J2TRRiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nr5AMVWL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nr5AMVWL"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F45E1F00A3F;
	Mon, 27 Jul 2026 05:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785129873;
	bh=zwrYr3dQ2vonDNl2K0x3xnEww735MPXPWWEzeC2bJRA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=Nr5AMVWLrFQMKZndOygLxF0XIjl1k6GMVs8Vn8bErsleKX3v0VqaLAEb/8iPDjc+d
	 QFZjUDksuFBaA+B1ddz+/auN/6NykMHyKhrroqMuoi6tP+Dm71OSnilc8uq4Ajkbdr
	 bloTksJk7NWlpD1r5G8DurO01pkznG7Fs6Y2/eaH4CtObid12S1TuFoBnDDHz1dnt2
	 FidLaiMPuTDsQkJTxih1NPyf1GM0/R+x46ENeOU2YFlWSp8UKWVZDhDbQ67vIemu3b
	 2qziioIvOWnQAZM//yMcS4mCA1opbyYZSPCnV6rmd4/wSDUcH7puhGZZ5vd3j9p+ae
	 BVTCFprQkQhIw==
Date: Sun, 26 Jul 2026 22:24:33 -0700
Subject: [PATCH 01/10] xfs: hoist per-bucket unlinked list check to helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org, hch@lst.de
Cc: linux-xfs@vger.kernel.org
Message-ID: <178512389618.1495075.113375778607440021.stgit@frogsfrogsfrogs>
In-Reply-To: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
References: <178512389537.1495075.1621818931849629575.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In the next patch we're going to make this loop more exciting, so hoist
the code to a helper function to reduce clutter in the resulting code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/agheader.c |   62 +++++++++++++++++++++++++++++++----------------
 1 file changed, 41 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 62ed5eaf08fbc1..cecf034ef989c7 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -932,6 +932,42 @@ xchk_agi_xref(
 	/* scrub teardown will take care of sc->sa for us */
 }
 
+/*
+ * Walk the incore unlinked list for a particular AGI bucket to construct
+ * the unlinked inode bitmap for later reconstruction of the unlinked list.
+ * Returns 1 if we should keep checking, or 0 to stop checking.
+ */
+static int
+xchk_iunlink_bucket(
+	struct xfs_scrub		*sc,
+	unsigned int			bucket,
+	xfs_agino_t			agino)
+{
+	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
+		if (agino % XFS_AGI_UNLINKED_BUCKETS != bucket) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		ip = xfs_iunlink_lookup(sc->sa.pag, agino);
+		if (!ip) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		if (!xfs_inode_on_unlinked_list(ip)) {
+			xchk_block_set_corrupt(sc, sc->sa.agi_bp);
+			return 0;
+		}
+
+		agino = ip->i_next_unlinked;
+	}
+
+	return 1;
+}
+
 /*
  * Check the unlinked buckets for links to bad inodes.  We hold the AGI, so
  * there cannot be any threads updating unlinked list pointers in this AG.
@@ -942,30 +978,14 @@ xchk_iunlink(
 	struct xfs_agi		*agi)
 {
 	unsigned int		i;
-	struct xfs_inode	*ip;
 
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
-		xfs_agino_t	agino = be32_to_cpu(agi->agi_unlinked[i]);
+		int		ret;
 
-		while (agino != NULLAGINO) {
-			if (agino % XFS_AGI_UNLINKED_BUCKETS != i) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			ip = xfs_iunlink_lookup(sc->sa.pag, agino);
-			if (!ip) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			if (!xfs_inode_on_unlinked_list(ip)) {
-				xchk_block_set_corrupt(sc, sc->sa.agi_bp);
-				return;
-			}
-
-			agino = ip->i_next_unlinked;
-		}
+		ret = xchk_iunlink_bucket(sc, i,
+				be32_to_cpu(agi->agi_unlinked[i]));
+		if (ret < 1)
+			return;
 	}
 }
 

