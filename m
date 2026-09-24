Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6240F720
	for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2026 10:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244436; cv=none; b=Naqs5nxijgN5Xhq/LFM+kmC8riA1+rcA0mhfNIywiCgI0DKIv62unjwJHDQ2XrbXMc2B01LAMiTfKWSA1xdOLmk/YnaxDU+n501SyJha42KjJcH6rRwMKQsNW5uXdi0rpc0inD/bUr4nd7aaWRyHgCNgu/OgPk+Ka0QbEiZCy7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244436; c=relaxed/simple;
	bh=G4knGA0m9+WJ4qZPrN2WgYEm/hV0fNrupWqDlVCxS5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcdIT0aNI16tQrt0SRBzaOjFpDrvenfkR7jS8ORZt3Eg+JgFAajq8Le9gNbZV6Nq1VFHWOsihB3oDR98Rny0+Zifh71Cn4srRW4vVGCExWEhEa43YOSjCaJu/BtRhSxRspotvq5EzOEzEjCVmoCNvaZzmHGA+IojKQ/LFr6OoSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HjUiGZO7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HjUiGZO7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uXlpnsLVqfrWBZSfpejAWUxjImVwZKe1mggl3y8jkNc=; b=HjUiGZO7ctqcAGrxkU3xK1OWB1
	dlIxbbLNA/dq411F3v9ueo1Satpj8ei97GeSbvztnkJHWpyJG+1KiE3dJFuFdbPDUKkyMUZEEABEH
	e3qDEWDnFyujBj4RwbXcr9hPwdth86sldD/b8tDQBEk2c2QrcynWa1a5XWILsdDdxPELuyXYkaU8e
	XSbN/yBMCk/RvsKPecGccG3BumoIScUtAjPZQAE4aITlr5HKsRu9oUmkWCGxqFVVvdhrSlrrhc+nH
	61sQCu1gHVQ9DpsrLA8EPjlzLJngu2iJfcWlMoW/ZorjrWZYcSzlgvuFY4xnrDwDb/rAr8jtINx5D
	t2jbFRLA==;
Received: from 85-127-111-79.dsl.dynamic.surfer.at ([85.127.111.79] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9gM2-0000000AfVa-3Nis;
	Thu, 24 Sep 2026 10:07:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 26/32] man: document the rtcsum geom fields
Date: Thu, 24 Sep 2026 12:04:16 +0200
Message-ID: <20260924100512.2733748-27-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 man/man2/ioctl_xfs_fsgeometry.2 | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/man/man2/ioctl_xfs_fsgeometry.2 b/man/man2/ioctl_xfs_fsgeometry.2
index 6d30610b71be..97216df7525b 100644
--- a/man/man2/ioctl_xfs_fsgeometry.2
+++ b/man/man2/ioctl_xfs_fsgeometry.2
@@ -52,7 +52,10 @@ struct xfs_fsop_geom {
 	__u64         rgextents;
 	__u64         rtstart;
 	__u64         rtreserved;
-	__u64         reserved[14];
+	__u8          rtcsum_type;
+	__u8          rtcsum_blklog;
+	__u8          reserved_pad[6];
+	__u64         reserved[13];
 };
 .fi
 .in
@@ -159,8 +162,32 @@ This field is meaningful only if the flag
 .B  XFS_FSOP_GEOM_FLAGS_ZONED
 is set.
 .PP
+.I rtcsum_type
+Type of RT data checksum. This field is meaningful only if the flag
+.B  XFS_FSOP_GEOM_FLAGS_DATA_CSUM
+is set.
+The following values are defined:
+.RS 0.4i
+.TP
+.B XFS_CSUM_TYPE_NONE
+Not data checksum.
+.TP
+.B XFS_CSUM_TYPE_CRC32C
+CRC32c as per NVMe.
+.TP
+.B XFS_CSUM_TYPE_CRC64
+CRC64 as per NVMe.
+.TP
+.RE
+.PP
+.I rtcsum_blklog
+log(2) of the RT data checksum block size.
+This field is meaningful only if the flag
+.PP
+.I reserved_pad
+and
 .I reserved
-is set to zero.
+are set to zero.
 .SH FILESYSTEM FEATURE FLAGS
 Filesystem features are reported to userspace as a combination the following
 flags:
-- 
2.53.0

