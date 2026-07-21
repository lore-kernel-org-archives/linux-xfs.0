Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686E438C2A0
	for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2026 03:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784604306; cv=none; b=WghQ9JYGqhWAXkfr/EOD0HVU01QjOzxjVXL8NqLrUN9X0DlnkKgQF5BMdBFi6h9zIwXZQSzHhchjMI9QzImpxh3kn3AAAKOaZP5/7V920V2kiwuVTz1q00WypIC6VJPpBpE+M/89CvJPTKkAL2lquOzx289tujqtLnAvWj896/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784604306; c=relaxed/simple;
	bh=WrfJHI6m6i+taUmeO1u0L6hxRTWW3HDNnHRhG55RD0k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4bCeB5kw3BDxKGVAELYStOPU/QRrSEyHy1Qs/KLGmcpXVIky0PE3oXpHze/ydmpE2Ol3MGZZi2Xpymhfp92evMox0wn3HXZbdBECcDHXfhjv+O3s38LmoDIYqPeu2kR06UX1ymmPS1xTT6Bg+AsVChehl6wkCdC1dJWly/zWn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqUQ54MF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqUQ54MF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A42D81F000E9;
	Tue, 21 Jul 2026 03:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784604304;
	bh=rjT2lW0k8FIFVfF6+gQylxMJMTUuQyWj20SAiqPeex0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=gqUQ54MFCUw2LCk0eFHrIV6GWloHfBj73PL9Pb7bzaGvb2u9SAiAXsUUagDpLC8sX
	 eGNwOYZiYV6wF0GLjo9soLmWWG0Pmv5py793oAKMXomuRlfsvZpIIiT7OGQ6IQiSks
	 taM1H+Isa3dUUzksX3o7HAVYTXtxx4asQaFut3AxGk8y/Wd9lPWcDHFOuQzJ2XdoTn
	 tPcCoVrkMHWovMDK1tbVEW9MegXWDSAfpOLWMXc+Ta2y5MP1Yz3ylUGd1jL0SZ2aGM
	 3vqlPru2pzgvNPjWG4V43nf5O2/s1mO+fNMRK4FNz7bQQTtc3L4x6NOvD7WIs4BYfb
	 zsIDv60Ibwg8g==
Date: Mon, 20 Jul 2026 20:25:04 -0700
Subject: [PATCH 1/9] xfs: hoist per-bucket unlinked list check to helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <178460419511.830862.15214045306349407437.stgit@frogsfrogsfrogs>
In-Reply-To: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
References: <178460419438.830862.6755198157088208229.stgit@frogsfrogsfrogs>
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
 

