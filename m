Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A4F1401C
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609061; cv=none; b=nbkYedOmG3DLjdTkjnh6OfDVnF8Tjp2LujOGIQkyyqOYjBefcD6yEIMbfh/v152G2SvQGvoKte/1HTDi7n25fgFV0ZcBLFfWLzD/pUH+SctHK3zPL5JDLIxwJQsuQCQD5bEPkSxB22gMrje7lMiK3oMrqWze44hSnXXu6fxeg+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609061; c=relaxed/simple;
	bh=KQugvugNIuMUuEdqcLaiYM+k4T7K3C/hBzLOZhH+uiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHFdi2VyY5dmj3sexgU4sexhjnuSHsFZn+tntQmBRqPDkN0dUvT6xoqt6vdaMJ+3Qw5OOr7Yf5Pn0kfzZMQon05WJcgBfXFr++VzkY0PF6sq6u5sUFXNPcyTqJPs/NeAmNmJ739L9I3sQmPHLJSnUfq0+Z+UIozhLAUVyBnvjmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xk8i4PcM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xk8i4PcM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GxBDnr+mkLaXuy6+50YQhCB8IMsEph/2W1RGWBuy3gA=; b=xk8i4PcM3xLWrLI09M1WFRxK+U
	MmlJMS/KHB1ZAkyzXRPMGc8wLo3Og2qExXlO4yF+wWNxZCYqv2es5Wj/xhYGjmt/b+HaV6HZrxsVY
	xX285nAKpuhHPcVKxBsuJNz/rxYKE2kfqLj86jQhNVW6wIFK5TOCrFBZt6bXTbP1/yJo79jUHZLwM
	yrJMEsjD5eHy0s27v3DE4kynKb4iGB1NOJOr2cDGtteNVNXcNdEW6pJRnELpatNiWGJmSVS9VsjjD
	Z3xrcniz0zCC+QuhqorWZ2NprtgPEVAzRTo0lvQqySpieFHIHV3O9J4kJatqxIpBxc/fkoOFUgK8P
	0Zy2c7mg==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CVk-00000000iIe-3r6w;
	Mon, 14 Apr 2025 05:37:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 22/43] xfs: enable fsmap reporting for internal RT devices
Date: Mon, 14 Apr 2025 07:36:05 +0200
Message-ID: <20250414053629.360672-23-hch@lst.de>
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

