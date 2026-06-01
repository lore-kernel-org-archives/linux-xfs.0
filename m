Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D13783AE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jun 2026 12:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780317869; cv=none; b=W5ioJwRgVNOLkH35HMAXJZUfSo5QpJuiHjjQ0me/35ZYeYHRIaQUZpBQRcXsCGgd2E++/6KG47FgpjKDr0OeG+eSxMfW/Nzb9TliG/NA4dfAU62DSBGQ/yo9KZF99EJx9o6gnI68flvIhOAy47SuIGETdNmXw92gwXR9AdS1ZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780317869; c=relaxed/simple;
	bh=4Jr0dJCUNiw7tyG+tmaivModrIj0ELFy8ZxZrXJBFsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ar81upc2EzCU3z6tJ8AypGqBzYWGXwkbZSoJ02nUWY2VWXlwHwa6QHZnWIApn09uE2bQriygQ5mZVOM/EuzegsbFpOSIovwTYU+Oa3Js9pRVX2P6lcVxqP9kJ0iUPS3O2OESLtR/JdNRgF3Y1hmv22AtNzkGPMTXKhdb9GnrGS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u25YEB5v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u25YEB5v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NQTvgj7wfbWpJtRggSn823dCTjwKK70DBoRMI+bHgUw=; b=u25YEB5vICZb9mHEqJE+C4QyZc
	iYuBynikFBE93D5zKCqdZ3206vO+AsImU1vHDuNswAwV00ZehSApU4mQgbVW0DaOBn5wIuzzbNgpu
	O1m2MUPVrWOMxJ/nk1v1Cje3ORyDSQeqSgIE6Dh7rYeukL7PL6ubjgcf/eYAYxnCVWInwy3WSZutb
	01tr3VFIW1n+DMmZ1K/8R4TgtFC0kIlNPi569Y1BQ+hvjCcFL6XzNUCCq2eoNofAv2AqYTOT70mlO
	ARu7LgjttValf72eG3rOC6DH7exbqKeeU+8s2c6Tt0B3VDZ/2MlV5vlzc4DpdHoRjN19w8j/WjeaR
	DPm0LBJA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU20J-0000000BA2n-1n0X;
	Mon, 01 Jun 2026 12:44:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] xfs: mark struct xfs_imap as __packed
Date: Mon,  1 Jun 2026 14:43:51 +0200
Message-ID: <20260601124410.3508980-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601124410.3508980-1-hch@lst.de>
References: <20260601124410.3508980-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This returns 2 bytes of padding at the to struct xfs_inode into which
this structure is embedded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index 57192adc7744..f3624532b023 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,7 +16,7 @@ struct xfs_dinode;
 struct xfs_imap {
 	xfs_agblock_t	im_agbno;	/* starting agbno of inode cluster */
 	unsigned short	im_boffset;	/* offset in inode cluster in bytes */
-};
+} __packed;
 
 int	xfs_read_icluster(struct xfs_perag *pag, struct xfs_trans *tp,
 		xfs_agblock_t agbno, struct xfs_buf **bpp);
-- 
2.53.0

