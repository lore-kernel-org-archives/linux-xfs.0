Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCEA45629E;
	Thu, 24 Sep 2026 10:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244057; cv=none; b=oB83CWser1AWQzFsrjRoQHlvPmYErOvsS4fs5VIF+EEQN9ryOB4eNWuTwUnP5dTSLhg1eSLCaK2DY5GnDSHjfW/W28M/x91Rda3Guj5U1Gj9yGUmM0Qp3M1BMTTXIOcVoqesMMd7pC0mFGNrzc4QRpibr/IBRxppZqVvUvg/DFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244057; c=relaxed/simple;
	bh=hb6qu3QvpDSLLstnxqqpLld02faNtnPcwXVX5B5qY3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5AfyIxvTeIGeYNRTVFW/ETpNIJVo5cD5fn3t/evvlDo1gnLpjNRXPCRGqx+pxXlU57jE4AsOUtAyNa9F8qUSyMyumqOvNTb3kusPfbEek8YHRZMCxRLxJq6JFxWxZ3uRy2HCxAL7HMBWLg2L+w1IvzkTo6rcVKP3EelkzZPhsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uSNuxkSq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uSNuxkSq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Pt91NgxYd4s+PBZF+pX8rgDMUJ9hArGLSdrS83hZmvI=; b=uSNuxkSq1SCA+1nedP4P2QiBA/
	y2Pg5FLHy8SmUNnK+SX9xY1+Ckqptfl66o8wgrDNs6cZ2BbxmoMYB5HtKel1c42XDPZwr4qSxE68t
	Rcj7PRNV9i4+127DW9ij+/nAwhxeZv/Q1B+xhVfrNDTl+34ur5WrxmHfZ72FptSvQ+ka5aErONLM1
	tkJSSNZcMGVSWK3+24FJNeNICoXDZ8j7Q8jexNk/I/GZ+HVLaGEaFbc2cItUKKFJlXrj8Ay5SvOfv
	HTZBvk+hiUt+IaSJVeFFqT1ipaFigjPLJ+/B2oclA09HP1aIWyUzaVraJeHIL+nipzG0QvcNZjs5o
	54ZMO9qw==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gFu-0000000AeSZ-10Gg;
	Thu, 24 Sep 2026 10:00:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 01/21] block: export fs_bio_integrity_verify
Date: Thu, 24 Sep 2026 11:59:33 +0200
Message-ID: <20260924100032.2733101-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924100032.2733101-1-hch@lst.de>
References: <20260924100032.2733101-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Damien Le Moal <dlemoal@kernel.org>

XFS will need to call this in the iomap_write_ops.read_folio_range
implementation.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index c8e91ada8ca6..20d0a3d52932 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -74,6 +74,7 @@ int fs_bio_integrity_verify(struct bio *bio, struct bvec_iter *data_iter)
 		bio_integrity_bytes(bi, data_iter->bi_size >> SECTOR_SHIFT);
 	return blk_status_to_errno(bio_integrity_verify(bio, data_iter));
 }
+EXPORT_SYMBOL_GPL(fs_bio_integrity_verify);
 
 static int __init fs_bio_integrity_init(void)
 {
-- 
2.53.0

