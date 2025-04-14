Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269A1A01CC
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609049; cv=none; b=rSAllR2MTYEa7H/OsyU3njFkjPiIabdXSWKu/rlh+xDLbJOGCpK2N3TeqbUOMpISYggaN5YK4HU8XXOcTP3LlJunmDaA1MTDj06Nff+F1Iu8fsROBV+UkulsUBPZxBkuVtrtimcpjVmj9V6WYPd9P/ZeyhJBDywnHV5Wo1dCDFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609049; c=relaxed/simple;
	bh=P4BXHc6H+094c1oaKKEnpFSz5+ep4e/zmJRXtHx0XeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcNgJAjwcRJ2T42J+wOxPECtbwOPpyaMn0pTagFpkiP77UnmGclkh+cZUzGmj8Bmc4VbZ7Y8QKckL7qe099UcYIFkFoT1IrNB9F6XkKBnk381CYzr1pwIqI59wZR4Ww5Tmx0d5y/Vbe38STjw01WmtEGALhKN4F9VC8GADjRtW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F238Nokq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F238Nokq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4lf1LMu9CxCK6pA/naychXyePkPRmOyhe1oSaUYak2w=; b=F238NokqFIqu6AekCA0ERfxxS9
	JnJA+T3Uo39JR3+PtBveMj5NMgErJahWQlQjB4qHEnJualQN9RJCetqwVolG92CiTiWK+GOKJ1Ivq
	CtjVCbfQ38Xjhndw7PGber9kTHgj+l6mB8eEHC9X39QoSOVwNLByitvn5rzVtmb+dB43iZXxx99y0
	4BPCrnDApRbKxr2sa9KjNJN1sZVbYYWY1x2xdQcRtwRbYQAiiVUb2AKPdoCEJejcSxYzri8kZH0Zu
	8xWccEkQrBciw21lOxqD13DMpaclGGub31MvYKshB+qa41sUd/emhpBBQ8jEAUeBymCarPtSihS7D
	hWPGVlpQ==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVa-00000000iGN-3H11;
	Mon, 14 Apr 2025 05:37:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/43] xfs: add the zoned space allocator
Date: Mon, 14 Apr 2025 07:36:01 +0200
Message-ID: <20250414053629.360672-19-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 4e4d52075577707f8393e3fc74c1ef79ca1d3ce6

For zoned RT devices space is always allocated at the write pointer, that
is right after the last written block and only recorded on I/O completion.

Because the actual allocation algorithm is very simple and just involves
picking a good zone - preferably the one used for the last write to the
inode.  As the number of zones that can written at the same time is
usually limited by the hardware, selecting a zone is done as late as
possible from the iomap dio and buffered writeback bio submissions
helpers just before submitting the bio.

Given that the writers already took a reservation before acquiring the
iolock, space will always be readily available if an open zone slot is
available.  A new structure is used to track these open zones, and
pointed to by the xfs_rtgroup.  Because zoned file systems don't have
a rsum cache the space for that pointer can be reused.

Allocations are only recorded at I/O completion time.  The scheme used
for that is very similar to the reflink COW end I/O path.

Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtgroup.h | 22 +++++++++++++++++-----
 libxfs/xfs_types.h   |  1 +
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index e35d1d798327..5d8777f819f4 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -37,15 +37,27 @@ struct xfs_rtgroup {
 	xfs_rtxnum_t		rtg_extents;
 
 	/*
-	 * Cache of rt summary level per bitmap block with the invariant that
-	 * rtg_rsum_cache[bbno] > the maximum i for which rsum[i][bbno] != 0,
-	 * or 0 if rsum[i][bbno] == 0 for all i.
-	 *
+	 * For bitmap based RT devices this points to a cache of rt summary
+	 * level per bitmap block with the invariant that rtg_rsum_cache[bbno]
+	 * > the maximum i for which rsum[i][bbno] != 0, or 0 if
+	 * rsum[i][bbno] == 0 for all i.
 	 * Reads and writes are serialized by the rsumip inode lock.
+	 *
+	 * For zoned RT devices this points to the open zone structure for
+	 * a group that is open for writers, or is NULL.
 	 */
-	uint8_t			*rtg_rsum_cache;
+	union {
+		uint8_t			*rtg_rsum_cache;
+		struct xfs_open_zone	*rtg_open_zone;
+	};
 };
 
+/*
+ * For zoned RT devices this is set on groups that have no written blocks
+ * and can be picked by the allocator for opening.
+ */
+#define XFS_RTG_FREE			XA_MARK_0
+
 static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
 {
 	return container_of(xg, struct xfs_rtgroup, rtg_group);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 76f3c31573ec..dc1db15f0be5 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -243,6 +243,7 @@ enum xfs_free_counter {
 	 * Number of free RT extents on the RT device.
 	 */
 	XC_FREE_RTEXTENTS,
+
 	XC_FREE_NR,
 };
 
-- 
2.47.2

