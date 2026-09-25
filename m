Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9A4052A6
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 05:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313239; cv=none; b=SHIY/swasIFSnOzPfOFFEaB4bCXvMdQm94/VMDhGQ6plOCbX7RCzXFKrKK8qfDuKYiD+GYx+yzVDc8JFt0R62SPj7Buq5Ll+j+VdFh9GVK3PW6zwZDyHxxzemM4LYB7JMjYsI6go3OX5UYGrcH77/qEbOPyGVq9CB3vu6nFhzVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313239; c=relaxed/simple;
	bh=qBJO+EmNXHaaVh6OveI0l+21BH/x+YqDj90pKgLZEG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tR+TeJz1OvIvb3o1clHYUEAHakzvR9c6KGY56xndXZ/3YJakx/BmZgWKg06LHS1nRsxjyNVHmcvvgGpRL520tynBKMrIdQwIXRJm0ew56JllhAEnVPoo/IruSdXFZe+xQckqOhtWoel7zKfSOEHiAflUxFnH6bz7SspYphj4wyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EJchCt2+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EJchCt2+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=12TjpQp3skr4O+rNInF4q1jBZHbAjXQBiS3GOhaUWEo=; b=EJchCt2+YAUy2MqPvgK9FLaTyd
	YCN5+0N9jcaErgKuHqENVH6NMaLfPy6urJWPEY0t13MZNthRC6TKL/VFHM+1NtH83ul99KRJJIXB5
	cjbrXPsdR+PEXMJLFR/64HQIuWeJanvb6OrMBDijtXo1tJQpQGNs8yaC0+SQkkzdOOV+EsV2ck2Nc
	9usX1xHbnve2VWpHu+USErI4yIwo6M2CucZetip55Q4HVKpph8rQzenA1UCx3YxP9RNkUh6BvurK5
	G5/tF8mzkPnWxQWRuxY1i3Ndh44rXEraPDl58EMu59w4nviBI8gr/fToJEGAuVP8bV3Eaj4ewwCQ4
	cHYVggAA==;
Received: from 2a02-8389-2301-9f00-b711-947d-6c5b-1af5.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b711:947d:6c5b:1af5] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9yFu-0000000Cgby-0Srf;
	Fri, 25 Sep 2026 05:13:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 05/10] libxfs: make the size check in rtmount_init internal RT device aware
Date: Fri, 25 Sep 2026 07:12:51 +0200
Message-ID: <20260925051336.2997014-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260925051336.2997014-1-hch@lst.de>
References: <20260925051336.2997014-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add rtstart handling.  This is currently masked by broken setup of
the rtdev targp to the ddev one for internal devices.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/init.c b/libxfs/init.c
index 65dadb1a23f7..85e0b3402bb2 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -330,7 +330,9 @@ rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -1;
 	}
-	error = libxfs_buf_read(mp->m_rtdev_targp, d - XFS_FSB_TO_BB(mp, 1),
+	error = libxfs_buf_read(mp->m_rtdev_targp,
+			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rtstart) +
+				d - XFS_FSB_TO_BB(mp, 1),
 			XFS_FSB_TO_BB(mp, 1), 0, &bp, NULL);
 	if (error) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
-- 
2.53.0

