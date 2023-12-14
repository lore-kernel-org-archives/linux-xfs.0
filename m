Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1GbypvW"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6927A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=pX1Mttkv8uDpMsgbLZ52iX9kCM0G7l2NLFXhapOyKPo=; b=B1GbypvW+w187J75/IDOIoAbcV
	T6L8GIFLmPUZxi0zNgO0LvqG3Ts5J5GqU4H39rySHQmcnkdJdPrfgW0b+1q6Om4DCUDQeecNdk+dv
	SXSr0Fke03+a2RmVTeBXhGRxfqn+5oZLU87UBEBdB6tDONnekUJgldPtHeSV3otWpVMStH5HckWfD
	RYeCPvftJXyMtOY3luxRdpbdxgTDt2gMgJzon33OcJBELbfmPoj53WcdeBHfF2VBlEjBGEeSew+Gl
	MTugiga2mcq4PKXa3enIgVCUG16wx1eh8exP+P9w/SH0qMiZAAvcdrPxDS0rPRmeA6XmM577nDD0i
	uHLDbrqw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJe-00GzUl-17;
	Thu, 14 Dec 2023 06:35:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 17/19] xfs: reorder the minlen and prod calculations in xfs_bmap_rtalloc
Date: Thu, 14 Dec 2023 07:34:36 +0100
Message-Id: <20231214063438.290538-18-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmap_rtalloc is a bit of a mess in terms of calculating the locally
need variables.  Reorder them a bit so that related code is located
next to each other - the raminlen calculation moves up next to where
the maximum len is calculated, and all the prod calculation is move
into a single place and rearranged so that the real prod calculation
only happens when it actually is needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 24d74c8b532e5f..595740d18dc4c3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1369,7 +1369,6 @@ xfs_bmap_rtalloc(
 
 	align = xfs_get_extsz_hint(ap->ip);
 retry:
-	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->offset, &ap->length);
@@ -1387,13 +1386,6 @@ xfs_bmap_rtalloc(
 	if (ap->offset != orig_offset)
 		minlen += orig_offset - ap->offset;
 
-	/*
-	 * If the offset & length are not perfectly aligned
-	 * then kill prod, it will just get us in trouble.
-	 */
-	div_u64_rem(ap->offset, align, &mod);
-	if (mod || ap->length % align)
-		prod = 1;
 	/*
 	 * Set ralen to be the actual requested length in rtextents.
 	 *
@@ -1404,6 +1396,7 @@ xfs_bmap_rtalloc(
 	 * adjust the starting point to match it.
 	 */
 	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
+	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -1432,7 +1425,16 @@ xfs_bmap_rtalloc(
 		start = 0;
 	}
 
-	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
+	/*
+	 * Only bother calculating a real prod factor if offset & length are
+	 * perfectly aligned, otherwise it will just get us in trouble.
+	 */
+	div_u64_rem(ap->offset, align, &mod);
+	if (mod || ap->length % align)
+		prod = 1;
+	else
+		prod = xfs_extlen_to_rtxlen(mp, align);
+
 	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
 	if (error == -ENOSPC) {
-- 
2.39.2

