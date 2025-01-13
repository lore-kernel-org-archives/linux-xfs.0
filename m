Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66BC23ED51
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777587; cv=none; b=VDqRSe5onDhrwR9RURqAe0QhID+cikJO+F/vc+1klPZxP2ZZd75h28fvubp2Jg/SZVd1DXrtZN5e2xLuQyIRyKNSLhOualvYzzrSNNJGN2l0xBXRyvnaM3mS/Z/X/6KFMMWTejfr2knCTfltQtgYLv+lh8slL2cjKJW/X/K417s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777587; c=relaxed/simple;
	bh=b7gOS5xIZHUvFmzqQcMaXJL/bHCafbcqLoGRAlAHBAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CUPfoNXZocGlg5kOWjePcQPIGYUAojXzTPNdtxmuW+LR6Y6RC2eu5wKA5lsjHomzr27mR7Jsu4RYKp3ja1AoGn/P5gdkCUGGss3qA4GgSCCgdB3yR+0dlzPmiX4WgkPgbOS5atxKNvsbhml9XGj4t4g4tcjI5LOQyiQIqvF+zt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bzj7Svmg; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bzj7Svmg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vHcoHAVocY4x5Duk/NaMjHBmXk2zNmKiNTDp/Yo3/E0=; b=Bzj7Svmg5Lg97sq9uRoAIrYIWc
	fQMJGed6fb6jjGvGmCxryd+7unXCbsrCVnOWMdk+KEJtsVHX9UEjkrURRd9Zt/+bwPGYJrbb3DsqR
	Eq6Ea9sOij1ehRkMaVXAIz6RUnB00xUxgAcla7Bq2wBAght4uvumAevITBB9s+WOE6j+G68mkQtOW
	OlvjWj4AnHJB4DVyrX3C1sDzlHuzfbgVGbpFjQ861oClCBObzCIfcasoSmtNwDkeQffhlwTAHSdK4
	I6+gVzTeMvBWZa4FJFy5XVoNAJfyh8Tpgmn3b2hFayLN0ZC3ciu4qfisTUD/bd2wNvjCIEVYBswSy
	jorYFCZA==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBh-00000005MsH-3p55;
	Mon, 13 Jan 2025 14:13:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/15] xfs: remove the extra buffer reference in xfs_buf_submit
Date: Mon, 13 Jan 2025 15:12:15 +0100
Message-ID: <20250113141228.113714-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Nothing touches the buffer after it has been submitted now, so the need for
the extra transient reference went away as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e0a34c2aaaaf..49d087d9ba48 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1643,13 +1643,6 @@ xfs_buf_submit(
 		return;
 	}
 
-	/*
-	 * Grab a reference so the buffer does not go away underneath us. For
-	 * async buffers, I/O completion drops the callers reference, which
-	 * could occur before submission returns.
-	 */
-	xfs_buf_hold(bp);
-
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
 
@@ -1672,20 +1665,13 @@ xfs_buf_submit(
 		goto done;
 
 	xfs_buf_submit_bio(bp);
-	goto rele;
+	return;
 
 done:
 	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
 		xfs_buf_ioend(bp);
 	else
 		xfs_buf_ioend_async(bp);
-rele:
-	/*
-	 * Release the hold that keeps the buffer referenced for the entire
-	 * I/O. Note that if the buffer is async, it is not safe to reference
-	 * after this release.
-	 */
-	xfs_buf_rele(bp);
 }
 
 void *
-- 
2.45.2

