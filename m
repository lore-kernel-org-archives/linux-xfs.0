Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96962CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609093; cv=none; b=JzP5Vk7KLrNfKprUs6/NgLO3nWGEioheRKGWO3NFrtZr7fA1OlyhHw+/0p8+cYTKt1qmTj8Sc1DpSa4D8rfss1thQC7GcVa8XKfLjCadt0VOpPZM3AONac1PhGRIcEECKoxTWfb+7VOKl8wYaJBi5Lrsa6aQ7uKW8NLTwayfG9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609093; c=relaxed/simple;
	bh=t/57KNJ7E4hdmeX5zInFpzwI6JdseeheGsq9JJahJ4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svfy0M2x1YU8yIjktzpbPJV7lymeeF8N93kLUcUDeydMNS8vOGEFiDtSwYRPZQJNdX3VGg5fQbpehk1H38oi/9S0mumVy1X+x51ogqh/sq1e4vRDbeR952I+bh/T6ZpPHmqN1NMhSldDY73gtplG8Rk39LHOnfLLGRzadVNIVpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ivaDH46H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ivaDH46H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c7aMkKJNMZuJ63yZ9nV45fJS/f8kf812YvXnHrevk+4=; b=ivaDH46H+GE1dl6RVYgZKkAc+z
	zy417rBJqHF8esLpEOrNOkH5SZTcHRRXT40UALJmbvMPlQ1DT7pZtJRcrAmokI8hM1HR13Bingfhr
	5lzkSNJ9Wz8D2l4QZ7lw5WiKDTE12idtu6Erjl5Oo9wpmTRJALhrpb1vVeaSOLYgyfY694G+b+wHN
	I7s1y39E7pwo3JaCf1TjUDXp2fOHeZRt83iTa/ypSGrSPG97UZ9O7/J2cWwsjXwGZKDhW2k1FSxLL
	yHM6L1huOGWEIMqtt/AOMEnRgUq/A0Q80rsBQ3p+PHNbK2Qt3lFszx888TTLN7IWix7TBGaN005h+
	nYVZr7Fw==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CWJ-00000000iPZ-0slf;
	Mon, 14 Apr 2025 05:38:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 35/43] xfs_mkfs: document the new zoned options in the man page
Date: Mon, 14 Apr 2025 07:36:18 +0200
Message-ID: <20250414053629.360672-36-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add documentation for the zoned file system specific options.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/mkfs.xfs.8.in | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index 37e3a88e7ac7..bc80493187f6 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -1248,6 +1248,23 @@ The magic value of
 .I 0
 forces use of the older rtgroups geometry calculations that is used for
 mechanical storage.
+.TP
+.BI zoned= value
+Controls if the zoned allocator is used for the realtime device.
+The value is either 0 to disable the feature, or 1 to enable it.
+Defaults to 1 for zoned block device, else 0.
+.TP
+.BI start= value
+Controls the start of the internal realtime section.  Defaults to 0
+for conventional block devices, or the start of the first sequential
+required zone for zoned block devices.
+This option is only valid if the zoned realtime allocator is used.
+.TP
+.BI reserved= value
+Controls the amount of space in the realtime section that is reserved for
+internal use by garbage collection and reorganization algorithms.
+Defaults to 0 if not set.
+This option is only valid if the zoned realtime allocator is used.
 .RE
 .PP
 .PD 0
-- 
2.47.2

