Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835CC36A341
	for <linux-xfs@vger.kernel.org>; Wed, 10 Jun 2026 05:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781068065; cv=none; b=b4uDwcOEfrEwYVd+arNeCXZqE6zMQuqAUt4HvVUvVGMNZgswnL0WDcxmHEndAJXNJR58pb4+aSXhK5yhmTN3XU8pWsmdvH+/VKZTNkmHgaQSosqFJUxWeQZPJZT5iMDcaDAYBejRO4TMHaBcho+9x5d7EnSXPLzNSmA1Fdb5gFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781068065; c=relaxed/simple;
	bh=zGM39euMQEFtsk2slA09q+bX/Ujr8oBg14z/W5hyel8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+oQLZGe2G6cPQqg+4F5K4sWi99LuN/bXRm0lEv0NI9TAszhQ3wJ3xeaFzbzPXWQkDDUtYy+M6iVqVI1mWJctL9VL+2+OctUsR2OvQmxyLIF+VsrQlRyhWg7wMdaaELVsRC6spaYAFupatSe2mVziRknr/dgsStBg5kkLnuiXWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F+QhFA6K; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F+QhFA6K"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4KDnxZ14+0nWv8WjcvJo0rhKlgKxL7qvpA2Tn7kCpCA=; b=F+QhFA6KKZBtqtwEHKxmEVEXY5
	NZ9M3UVapd52XM3wCNdydvi/XFYsBqz7XI27XTs4WQ/xVSqRPi2vwgqGu1XPI75QDem6l8gjtZaFJ
	mGtUWebq9wrUYtpeljM+oOfqq+CNZTBPnYnWAE2iqo2tFUQ7lMvCmp+QXlr2HhXP0OV7Ro2PQtdZ0
	5BgJMVfX4wKU+WD1dHJiClQ2dkaBhxFaTLwn167lknVz4qf97BTK4dvEBuTZSvxWqelaqNVB9b9vs
	OHf1wxSv5Hvh/89/dK6OiBmbfWSvZgymaTviWW7UGVbXucjfOQSHxZ3o1CNJ5UXJN+UdID1k6cHBJ
	XaZqJsag==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXBAF-00000006o8A-37Su;
	Wed, 10 Jun 2026 05:07:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: only log freed extents for the current RTG in zoned growfs
Date: Wed, 10 Jun 2026 07:07:21 +0200
Message-ID: <20260610050731.1906760-4-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260610050731.1906760-1-hch@lst.de>
References: <20260610050731.1906760-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Otherwise a power fail or crash during growfs could lead to an
elevated sb_rblocks counter.

Note that the step function is much simpler compared to the classic RT
allocator as zoned RT sections must be aligned to real time group
boundaries.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index debbcefdf07f..7a3f97686989 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -890,8 +890,7 @@ xfs_growfs_rt_sb_fields(
 
 static int
 xfs_growfs_rt_zoned(
-	struct xfs_rtgroup	*rtg,
-	xfs_rfsblock_t		nrblocks)
+	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_mount	*nmp;
@@ -903,7 +902,8 @@ xfs_growfs_rt_zoned(
 	 * Calculate new sb and mount fields for this round.  Also ensure the
 	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
 	 */
-	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks,
+	nmp = xfs_growfs_rt_alloc_fake_mount(mp,
+			xfs_rtgs_to_rfsbs(mp, rtg_rgno(rtg) + 1),
 			mp->m_sb.sb_rextsize);
 	if (!nmp)
 		return -ENOMEM;
@@ -1226,7 +1226,7 @@ xfs_growfs_rtg(
 	}
 
 	if (xfs_has_zoned(mp)) {
-		error = xfs_growfs_rt_zoned(rtg, nrblocks);
+		error = xfs_growfs_rt_zoned(rtg);
 		goto out_rele;
 	}
 
-- 
2.53.0

