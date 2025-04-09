Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC125A354
	for <linux-xfs@vger.kernel.org>; Wed,  9 Apr 2025 07:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744185450; cv=none; b=cTFelNaZX5TGNDTnT5bryf+G7lre1HfogRXzA0xkolRMXvewsKv6ksOACrIFHKV3DX2vXjsFZA1gCMatymCsnXgvwGYAqIN1vWiB7oXmm/DL9A4gDUgsvjd66M8lpvulXvE5frIL0494McuY63fi7hgJiPI2hB89M+LsjzyWrzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744185450; c=relaxed/simple;
	bh=KQugvugNIuMUuEdqcLaiYM+k4T7K3C/hBzLOZhH+uiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mx+vcbSNmBudocR+kowwmpuJTks7StnbVX+on60iUiYWUpDNt65xTmYiiuAQSDUpbqcDdvc0IwaIljrXNp8TtgvSDwozD2dZhDJKfV2uhwVsVEI2L7VFpmzi4H57PJU+DiC6/WXrP6fE5hBO9oRCk8Pyy2kHICCac2u5JH9uQJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lY2w60pt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lY2w60pt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GxBDnr+mkLaXuy6+50YQhCB8IMsEph/2W1RGWBuy3gA=; b=lY2w60ptI0yQdoSwWMUr85cqxz
	LWYxHylv4hp2MJEGxe3hwJ+HUhF0HxINzpXX1ucvZ6WKusZyCr+ReA1h8rpTrISO02EfS2Qhf5tO0
	1+W3m9UnqK1yghiMOE++aHgp/5f6lyTHdfy6gYLVTgWHaO9QuHq8U6KbAmrx2yEEVygT3AzEdNB7d
	Fqb6OZONYTtioiZWt5bMzQG/Td9scum9KIWLJJOGfi4y+B00o1ubgsia/RCaCsmXK6Qx0s5GVrmLB
	3zLIjtaVSJJfMRiD6K2kWE5v/txz+PMb3OwqlrQ0OVx4xvaqLkbY/mEqLwlwSfKvd9VM7PjZb1tEC
	scLvfRPw==;
Received: from 2a02-8389-2341-5b80-08b8-afb4-7bb0-fe1c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8b8:afb4:7bb0:fe1c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u2QJM-00000006UXW-1Kar;
	Wed, 09 Apr 2025 07:57:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/45] xfs: enable fsmap reporting for internal RT devices
Date: Wed,  9 Apr 2025 09:55:25 +0200
Message-ID: <20250409075557.3535745-23-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250409075557.3535745-1-hch@lst.de>
References: <20250409075557.3535745-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: e50ec7fac81aa271f20ae09868f772ff43a240b0

File system with internal RT devices are a bit odd in that we need
to report AGs and RGs.  To make this happen use separate synthetic
fmr_device values for the different sections instead of the dev_t
mapping used by other XFS configurations.

The data device is reported as file system metadata before the
start of the RGs for the synthetic RT fmr_device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_fs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 5e66fb2b2cc7..12463ba766da 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -1082,6 +1082,15 @@ struct xfs_rtgroup_geometry {
 #define XFS_IOC_COMMIT_RANGE	     _IOW ('X', 131, struct xfs_commit_range)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/*
+ * Devices supported by a single XFS file system.  Reported in fsmaps fmr_device
+ * when using internal RT devices.
+ */
+enum xfs_device {
+	XFS_DEV_DATA	= 1,
+	XFS_DEV_LOG	= 2,
+	XFS_DEV_RT	= 3,
+};
 
 #ifndef HAVE_BBMACROS
 /*
-- 
2.47.2

