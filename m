Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5201A32856B
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040143; cv=none; b=gtZYIO+THJpfRuzeOQVmJVeuNZd1jmXfD4YzmPfcmQu+MHWzVidfZ5QfA4TBPu+MIIacsrv9RwVm008n1+MzX/sKU98Ev0ZQSofmOe+Ef8LYnD51N8LV3fyREcUmEEeHYo6d9IRzkZFfBWnaxbtY/51Z26+6uMMU2LnKRzdMU6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040143; c=relaxed/simple;
	bh=Cc9NU1Efc4F2SuUo7dRyr5soMFCxMPewECMmW/HQXY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wdc7Vb+cVByQYuQ6RoDuXPmSjdySN1gNJxXkxehwSuqw36tHBLq0gVZdE2O8DjOM8EJ16luZM35F+ag0PKVvvQKGvvmCQT83vJPDIpv9CvMitjfHDXHRZPWVAb03r8O1TuUtOpXBSBEsaISFxyM27hNAUovx2CX4NHCCa9S5YZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=O5LGhEsj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O5LGhEsj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lJojBIz11g1QX4CSEiEU/d+uERu7E4HTkqoCzxxSwRY=; b=O5LGhEsjKnoPzMiY8/OTccmp82
	mHlwg7zeck1YkEJBQAT5vD2fOgfaZpYR/OgBAyFSY0b137oX2wsCcGEaLxFDUS1beYztL86hqZEad
	SCHzLzqN0vy8DSvKjobi6HtIsik7pftM23lTaplwUjb40wQK245jj39zopPiPH4Ht1u8mOnJe9cbr
	Ak82khz8YQoVwM/FMWM27hLlrIevRF3236dEEC8OaFIKCn7BSwbb9TbhF3XVev994nFImQB1kJJeu
	E8YVaabJlDU+lx/CcSN42R2HXzUh4kG0WP6Fvl82z4ckIoMSQWVrscxzzKzqJw7VB28nTmBSdMvWh
	VlHb8IdA==;
Received: from [206.0.71.8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyYY9-00000008T46-2qi2;
	Tue, 16 Sep 2025 16:29:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 6/6] xfs: constify xfs_errortag_random_default
Date: Tue, 16 Sep 2025 09:28:19 -0700
Message-ID: <20250916162843.258959-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250916162843.258959-1-hch@lst.de>
References: <20250916162843.258959-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This table is never modified, so mark it const.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_error.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index ac895cd2bc0a..39830b252ac8 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -19,7 +19,7 @@
 #define XFS_ERRTAG(_tag, _name, _default) \
 	[XFS_ERRTAG_##_tag]	= (_default),
 #include "xfs_errortag.h"
-static unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
+static const unsigned int xfs_errortag_random_default[] = { XFS_ERRTAGS };
 #undef XFS_ERRTAG
 
 struct xfs_errortag_attr {
-- 
2.47.2

