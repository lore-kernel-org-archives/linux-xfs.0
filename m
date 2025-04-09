Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81A8725A2DC
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185511; cv=none; b=nbphPgvJYiaQ8D+XFsmwiGszrRq5Zxp9K10yjQa4XkCGMnq+DmS1IpOSTOfSJoSVhuZ4Bqh74bXfAlP4BVNmTAb4arNcNXg6rhM3EYWFlYnbKfirPkqcTbxacJBzGwhwAg/JxKqNUwFkXzI3l8vg4V3T3doV4XxsYCMwC2awbtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185511; c=relaxed/simple;
	bh=r913IQ9ggpO4nepO15ob0k1AS6iG4H6jtPy8/5wnORo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhM4Caw63phgSKJWBASaNejsadz/lJybOgmTsVKcrFSKRykfikmiCS7TqRtnc7ic4TVW5/56McxdMMx7MrGx9oy1/d4B2BHiMsDFtq7vh5PK9Guv+dqPNvzj0z5Uf4X3ndmV83tIEPYW/4CMV+P/3Yvy8z1B59ik3GBc3C1fYkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eiQqI/39; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eiQqI/39"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tatPkHVoPp36twkq2WBu/5kODCpUqVnOk8PZqcy89cY=; b=eiQqI/395C31ivlOrdwdhfbxiA
	aNJFaYMBvQOmF9b6HrjpR5jwDwxK++wF4ETtXMV2IKSVZAoDzzTAid4icwpoywaw8guHDdgjcHfxs
	J2gxtM0xLMXisFb8QCyEQb+ahgWyg4GtwSHIg5p1u11B9lVbHoydcgJaSTHzjec4HU/JMm6SPFAIv
	tMIGlNj7fYEN8pLFgRip6SlmWeJXQol52skI4hMSu3nSMLhouPZ73Grv9qAWFHghpypEaIXJe1yW1
	R/XLUhUE2X3Txy61aVwiguUyxkUVT2REFqj7O+pCNs479Mjx0GrPIn44efs0qtHbJSBaoqD0CToxw
	Yt+RavCQ==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QKL-00000006UiV-2OWk;
	Wed, 09 Apr 2025 07:58:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 37/45] xfs_io: correctly report RGs with internal rt dev in bmap output
Date: Wed,  9 Apr 2025 09:55:40 +0200
Message-ID: <20250409075557.3535745-38-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Apply the proper offset.  Somehow this made gcc complain about
possible overflowing abuf, so increase the size for that as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 io/bmap.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/io/bmap.c b/io/bmap.c
index b2f6b4905285..944f658b35f0 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -257,18 +257,21 @@ bmap_f(
 #define	FLG_BSW		0000010	/* Not on begin of stripe width */
 #define	FLG_ESW		0000001	/* Not on end   of stripe width */
 		int	agno;
-		off_t	agoff, bbperag;
+		off_t	agoff, bbperag, bstart;
 		int	foff_w, boff_w, aoff_w, tot_w, agno_w;
-		char	rbuf[32], bbuf[32], abuf[32];
+		char	rbuf[32], bbuf[32], abuf[64];
 		int	sunit, swidth;
 
 		foff_w = boff_w = aoff_w = MINRANGE_WIDTH;
 		tot_w = MINTOT_WIDTH;
 		if (is_rt) {
+			bstart = fsgeo.rtstart *
+				(fsgeo.blocksize / BBSIZE);
 			bbperag = bytes_per_rtgroup(&fsgeo) / BBSIZE;
 			sunit = 0;
 			swidth = 0;
 		} else {
+			bstart = 0;
 			bbperag = (off_t)fsgeo.agblocks *
 				  (off_t)fsgeo.blocksize / BBSIZE;
 			sunit = (fsgeo.sunit * fsgeo.blocksize) / BBSIZE;
@@ -298,9 +301,11 @@ bmap_f(
 						map[i + 1].bmv_length - 1LL));
 				boff_w = max(boff_w, strlen(bbuf));
 				if (bbperag > 0) {
-					agno = map[i + 1].bmv_block / bbperag;
-					agoff = map[i + 1].bmv_block -
-							(agno * bbperag);
+					off_t bno;
+
+					bno = map[i + 1].bmv_block - bstart;
+					agno = bno / bbperag;
+					agoff = bno % bbperag;
 					snprintf(abuf, sizeof(abuf),
 						"(%lld..%lld)",
 						(long long)agoff,
@@ -387,9 +392,11 @@ bmap_f(
 				printf("%4d: %-*s %-*s", i, foff_w, rbuf,
 					boff_w, bbuf);
 				if (bbperag > 0) {
-					agno = map[i + 1].bmv_block / bbperag;
-					agoff = map[i + 1].bmv_block -
-							(agno * bbperag);
+					off_t bno;
+
+					bno = map[i + 1].bmv_block - bstart;
+					agno = bno / bbperag;
+					agoff = bno % bbperag;
 					snprintf(abuf, sizeof(abuf),
 						"(%lld..%lld)",
 						(long long)agoff,
-- 
2.47.2

