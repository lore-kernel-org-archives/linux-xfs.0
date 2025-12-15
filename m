Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3035A32B9A2
	for <linux-xfs@vger.kernel.org>; Mon, 15 Dec 2025 09:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765792141; cv=none; b=Jc5FpBEJCf69I5L7td8OBTjnbCiiyTgO8q9tcY/HWnC7wdDFibxNuri5tFXCKlPBoO61TJB9CNWtDEq0b0/seZmZxBNDZK5MQS6B10nXix1OKnc84B9Q7/JM7yw460LGjTJaWdwWlHTRPVzKKhYEne/xxmag0Dc9Xo0MaoHSDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765792141; c=relaxed/simple;
	bh=JcrjV9qHgyXtd71i7zCXe8tVVaL2KYiWD5abRzH2+IQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQhLGt+gv8EZoycOu53v20198auZW8Su2h8aWFKhdJ3erkA1BGhqjZEy4XEntLcbNT3ObNuN5dVZ3lfA/ihezFbotR855HDpwyLDE6j6bFcHkqA7TvQHaBVV5Rmfnh1OXJOgCealyaqvDUtj1HJx99mj+2ky6qFBhiE9tGSG1UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BC+jyXN+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BC+jyXN+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JckznK7EnKo3ozhTnFNFDiUaBgi26ANYS9OxedJGUbM=; b=BC+jyXN+Ro5gJHoyLVrrEm3Daf
	QQis0HL/C1odV0dqwSXQ4vbegdJvqmAa5iIkdfp8lHH0iRhV2clkRk+v0rWWCynwAeR9wq+QSXCbD
	0Tj9EHeL028RNZOnkVZI2L6gjeufxUkKpJtkiECycDpaC1vBOFBU4PhzQZkVBSdX1nFvUozcxN07J
	wGyQARBXKrT3nYDOK6pHwlVi0s1lttsbgll88tefoxMLSUWpHONaF00RkM97xu1C9yewgHM/3+6pL
	wNyhnSvkzk2AziaxIRFgCtDRh7oCrGDFPgjLEV8nKGwWdnWI2JGehu0PuwrpPkoUBpNd8tlxnmh9V
	QFl1pPcw==;
Received: from [2001:4bb8:2d3:f4f4:dcee:db:50a:ae71] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vV5CK-00000003Ol0-3vS5;
	Mon, 15 Dec 2025 09:48:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: fix the zoned RT growfs check for zone alignment
Date: Mon, 15 Dec 2025 10:48:37 +0100
Message-ID: <20251215094843.537721-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251215094843.537721-1-hch@lst.de>
References: <20251215094843.537721-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The grofs code for zoned RT subvolums already tries to check for zone
alignment, but gets it wrong by using the old instead of the new mount
structure.

Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 6907e871fa15..e063f4f2f2e6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1255,12 +1255,10 @@ xfs_growfs_check_rtgeom(
 	min_logfsbs = min_t(xfs_extlen_t, xfs_log_calc_minimum_size(nmp),
 			nmp->m_rsumblocks * 2);
 
-	kfree(nmp);
-
 	trace_xfs_growfs_check_rtgeom(mp, min_logfsbs);
 
 	if (min_logfsbs > mp->m_sb.sb_logblocks)
-		return -EINVAL;
+		goto out_inval;
 
 	if (xfs_has_zoned(mp)) {
 		uint32_t	gblocks = mp->m_groups[XG_TYPE_RTG].blocks;
@@ -1268,16 +1266,20 @@ xfs_growfs_check_rtgeom(
 
 		if (rextsize != 1)
 			return -EINVAL;
-		div_u64_rem(mp->m_sb.sb_rblocks, gblocks, &rem);
+		div_u64_rem(nmp->m_sb.sb_rblocks, gblocks, &rem);
 		if (rem) {
 			xfs_warn(mp,
 "new RT volume size (%lld) not aligned to RT group size (%d)",
-				mp->m_sb.sb_rblocks, gblocks);
-			return -EINVAL;
+				nmp->m_sb.sb_rblocks, gblocks);
+			goto out_inval;
 		}
 	}
 
+	kfree(nmp);
 	return 0;
+out_inval:
+	kfree(nmp);
+	return -EINVAL;
 }
 
 /*
-- 
2.47.3

