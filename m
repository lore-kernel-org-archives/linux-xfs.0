Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5160D46A5E8
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244391; cv=none; b=tZx9ZOEL5Bve0G5Y0Aqx0LB1jNylIPwSsKulDAjdDXSmLQH0yVC1Cwy4WP4SN3xV9uY9a7Ji8JErRTix8Wnf9/5KgyAFhot/zb0nqmgI+1m7SQa/MNDekngjsnU9IF8NkgQM+D81y3CEBMzAUZkHWt9N41lV9YX3pC20KqIc7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244391; c=relaxed/simple;
	bh=pwnjxCxH1BUKLPqGGLqjF+hyMR0udpoJQLNXTNJqBpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mli4RWw7rV4JzmzpaZ1LyjdoygHXkhR7X6WJb+Z/nw6asdaDnu9YNg78GZ9pciM3UMoRxIj6/Ms4tT/F4QQFmA/f+cGheH9KEh6p3gd9/4VtbMPsTxpDR+ikQ9CF5BOqRYjJRw9YNKgSEfmmF2TOG+yfdBAXodZ2G6gKXY4IXks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bsjhXcuo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bsjhXcuo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XfetnInZvOIdJdupgOhPOSJwejYvcvLCKShjQUEaoi0=; b=bsjhXcuoS0votl0n8N4MyH5J1J
	/OnKTr7dcWEZeFf3vr/y5w9fGEyLyC9jiExzpX1ZD8skb9kFr1AkPdM1JHFCN4/jVYcxwkYhYLwDm
	d47lVT4jcogiXJkyT8ro9KnfkDb5VWqEFNfcHBGBQpS+kOR4ayvr65se+3rkWdu7S8RP+f2p+4SFa
	WZSHTgL3WQQCLCRs5RG4sjdIMGXFMZBNulLAe1D3ir2pwoA76wyH3twvhYhMOEBil/kkJMpkmmHqq
	Fb4BqLNfZ03Vm9kG8GcV6dIY38323IqJbktHVUk2rMmPH7L5TG3k1zGUStRl7YBEIDgn7BfX3SFi+
	B66lieUw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gLQ-0000000AfNX-1D52;
	Thu, 24 Sep 2026 10:06:24 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/32] FIXUP
Date: Thu, 24 Sep 2026 12:04:08 +0200
Message-ID: <20260924100512.2733748-19-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100512.2733748-1-hch@lst.de>
References: <20260924100512.2733748-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

---
 mkfs/proto.c | 4 ++--
 repair/rt.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index bdd0fadda517..7ef8cc9d88a1 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -1099,12 +1099,12 @@ rtfreesp_init(
 	 * First zero the realtime bitmap and summary files.
 	 */
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, 0,
-			mp->m_sb.sb_rbmblocks, NULL);
+			mp->m_sb.sb_rbmblocks, 1, 0, NULL);
 	if (error)
 		fail(_("Initialization of rtbitmap inode failed"), error);
 
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, 0,
-			mp->m_rsumblocks, NULL);
+			mp->m_rsumblocks, 1, 0, NULL);
 	if (error)
 		fail(_("Initialization of rtsummary inode failed"), error);
 
diff --git a/repair/rt.c b/repair/rt.c
index 3e51c9b5eb4b..b0ff775bd339 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -381,7 +381,7 @@ fill_rtbitmap(
 		return;
 
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP,
-			0, rtg_mount(rtg)->m_sb.sb_rbmblocks,
+			0, rtg_mount(rtg)->m_sb.sb_rbmblocks, 1, 0,
 			rt_computed[rtg_rgno(rtg)].bmp);
 	if (error)
 		do_error(
@@ -403,7 +403,7 @@ fill_rtsummary(
 		return;
 
 	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY,
-			0, rtg_mount(rtg)->m_rsumblocks,
+			0, rtg_mount(rtg)->m_rsumblocks, 1, 0,
 			rt_computed[rtg_rgno(rtg)].sum);
 	if (error)
 		do_error(
-- 
2.53.0

