Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ACE1D0E20
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031411; cv=none; b=hcPqPyH+9dQ+Fga6TINyac/GeG7SLeUVM2QtIvsvVUwL7SV9VCCwIzATXq64+BbdvuSv4V/Xle15i6NvUiHq6ZBjOBmeiq6ekkq0Nu1K8032mqlHDs+9Aj3OWwHgswA8jvHV/UcMbo3qu04pgMFqefBqABuRaUYNl+YRli6BQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031411; c=relaxed/simple;
	bh=xZstMUtmgvD5p7iddHvCNWPs4NERIJ3eNyULN8x9Weg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VozIOrMJMiDiSJ0+Av+OT+uhElGZOAhRPzysDytmGfCA8+vtV6vGzc5EhYLYyhAxYtChnIA/HP5pCh8eC5ylcVnOG0Mjd2YoRlGf30QMpyEDt2R+JqW2QPW2oNHlZuv7BZx2nFnERlEVU6UBaYOXwUhXgPPmO0H/1VV2sGqbt44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FTYiUG2m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FTYiUG2m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N1VxpOIU7Un4WgEyHgcC0gBz1uhyjRv89sajRLdWgbM=; b=FTYiUG2mqx2Mtdw76LTM+YJ4xg
	QtoLOurStGoP2MpYz7NDb2a9fknH59TN1AvhOUS3qi8xvZsroQQaXDNC6rC+N6CT+ymkVw5JkxpsI
	Sbi7fQVoc30eze2pyrSRWq4lxLY/jINmjOpJ8KOs45TH0qrRg2hl6sREBF9Za05FAiWvxeeS+3D2S
	47olWYAQttX5jyeifmPynBAwzMEQvm7C3ZnSkMgMAcx+YiesZVXF7LY/U41FvsRQp9wI66UR/9eNt
	j2AQ1PH054XjjLPy0aByqIs8XnnoTL9sNz48geMVWhdR/eiEdiRNGhD0H7Sa6z+O8Ebi6RWTV8/Pz
	bh97Utqg==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDQUS-0000000CveV-3Sd4;
	Tue, 19 Nov 2024 15:50:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: use the proper conversion helpers in xfs_rt_check_size
Date: Tue, 19 Nov 2024 16:49:48 +0100
Message-ID: <20241119154959.1302744-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119154959.1302744-1-hch@lst.de>
References: <20241119154959.1302744-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the proper helpers to deal with sparse rtbno encoding.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 90f4fdd47087..a991b750df81 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1233,13 +1233,13 @@ xfs_rt_check_size(
 	struct xfs_mount	*mp,
 	xfs_rfsblock_t		last_block)
 {
-	xfs_daddr_t		daddr = XFS_FSB_TO_BB(mp, last_block);
+	xfs_daddr_t		daddr = xfs_rtb_to_daddr(mp, last_block);
 	struct xfs_buf		*bp;
 	int			error;
 
-	if (XFS_BB_TO_FSB(mp, daddr) != last_block) {
+	if (xfs_daddr_to_rtb(mp, daddr) != last_block) {
 		xfs_warn(mp, "RT device size overflow: %llu != %llu",
-			XFS_BB_TO_FSB(mp, daddr), last_block);
+			xfs_daddr_to_rtb(mp, daddr), last_block);
 		return -EFBIG;
 	}
 
-- 
2.45.2

