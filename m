Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BEB1862
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609031; cv=none; b=mMLQpdKpXyGp/U0wWxCU4Ai86CX/cmKi4pcmY4i3ASot0Qsz0eGtNsMcjFSE2EBkV7QvyQiSfRYx42Slj9h+4bhWCwnowyj7wx8Y9f12zCuX4GEwDA9HYEITP4KkElEHYwdnohSAGtDORxl/GDjeiqnhNve+4YSSrW/Uq7m/XWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609031; c=relaxed/simple;
	bh=FZd8QWIW/0JvWpnGK85IECAXnEbkxrzK7rmoNgUpQGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0RsGr0EAw+kypOyo1SNpEM8uAkheiKRdYQW9UTBrTCv3EuOT717zhX9r5nkGT8Si/S24JW7dlmROtQo4IAM98OsJiZsTfbvq4BPuxtZU1ZIjYNwez4ggV76F+MG1IdhFLGXcnN2VUufaQCKfRTCskXffFG1z3Xl8hvLjWi+gWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rY1xKdh2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rY1xKdh2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+B8pQMwni+IB+nxeBIE9w7ihhRWsUl5/esIb0Ea3Um8=; b=rY1xKdh22q1IE1p43/xTp0rzod
	6jSPRnIMc5admJuzo1m6sbr7TBHaLnAQQrUjJGuji8G5oLwM/LKYfmfOoO9M96B6tvNu3+eX1tFEt
	ZZqA8D2Mod/ietW9Rk6NW9mdB4EKzi/FIUk/4yloPDwUIimQXmDKjH0DUKH5HMPPmANwk2rsfZiHw
	KgKRYXCk0RvimlXdHZAKZNSxLZ0S1M3ZL0T+yEiAurUuw8DDP/H29TXRLujiLtakXrqxrBfFFPaHw
	YDvBNUOtwnO+uAiExs0eNcMpKM0+wsWOPJtXeDlGtRds2MQPW/HrbAvbK0MQbdVvsW3Nd3zKVpMaa
	KpceCXTA==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVI-00000000iCt-37n6;
	Mon, 14 Apr 2025 05:37:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/43] FIXUP: xfs: define the zoned on-disk format
Date: Mon, 14 Apr 2025 07:35:54 +0200
Message-ID: <20250414053629.360672-12-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/xfs_inode.h | 12 +++++++++++-
 include/xfs_mount.h | 12 ++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 5bb31eb4aa53..61d4d285a106 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -232,8 +232,13 @@ typedef struct xfs_inode {
 	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
 	prid_t			i_projid;	/* owner's project id */
 	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
-	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
+	/*
+	 * i_used_blocks is used for zoned rtrmap inodes,
+	 * i_cowextsize is used for other v3 inodes,
+	 * i_flushiter for v1/2 inodes
+	 */
 	union {
+		uint32_t	i_used_blocks;	/* used blocks in RTG */
 		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
 		uint16_t	i_flushiter;	/* incremented on flush */
 	};
@@ -361,6 +366,11 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 }
 #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
 
+static inline bool xfs_is_zoned_inode(struct xfs_inode *ip)
+{
+	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
+}
+
 /* inode link counts */
 static inline void set_nlink(struct inode *inode, uint32_t nlink)
 {
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 0acf952eb9d7..7856acfb9f8e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -207,6 +207,7 @@ typedef struct xfs_mount {
 #define XFS_FEAT_NREXT64	(1ULL << 26)	/* large extent counters */
 #define XFS_FEAT_EXCHANGE_RANGE	(1ULL << 27)	/* exchange range */
 #define XFS_FEAT_METADIR	(1ULL << 28)	/* metadata directory tree */
+#define XFS_FEAT_ZONED		(1ULL << 29)	/* zoned RT device */
 
 #define __XFS_HAS_FEAT(name, NAME) \
 static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
@@ -253,7 +254,7 @@ __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
 __XFS_HAS_FEAT(large_extent_counts, NREXT64)
 __XFS_HAS_FEAT(exchange_range, EXCHANGE_RANGE)
 __XFS_HAS_FEAT(metadir, METADIR)
-
+__XFS_HAS_FEAT(zoned, ZONED)
 
 static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 {
@@ -264,7 +265,9 @@ static inline bool xfs_has_rtgroups(const struct xfs_mount *mp)
 static inline bool xfs_has_rtsb(const struct xfs_mount *mp)
 {
 	/* all rtgroups filesystems with an rt section have an rtsb */
-	return xfs_has_rtgroups(mp) && xfs_has_realtime(mp);
+	return xfs_has_rtgroups(mp) &&
+		xfs_has_realtime(mp) &&
+		!xfs_has_zoned(mp);
 }
 
 static inline bool xfs_has_rtrmapbt(const struct xfs_mount *mp)
@@ -279,6 +282,11 @@ static inline bool xfs_has_rtreflink(const struct xfs_mount *mp)
 	       xfs_has_reflink(mp);
 }
 
+static inline bool xfs_has_nonzoned(const struct xfs_mount *mp)
+{
+	return !xfs_has_zoned(mp);
+}
+
 /* Kernel mount features that we don't support */
 #define __XFS_UNSUPP_FEAT(name) \
 static inline bool xfs_has_ ## name (const struct xfs_mount *mp) \
-- 
2.47.2

