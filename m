Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4C62BD04;
	Wed, 12 Mar 2025 06:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741761975; cv=none; b=NacVySNseuq8+ilQZIho9UfBayGG1FH9EI4glFcnUhIKr5IDqKpuperGvrb5baOdH1Ft5AAJECFnMVfTC3CkwyW6UJiZQk/ONnzGuaVR7rs2QJXPicuqTYCqK/2vwBheQvTUeu7YH3znvuH7isUcKvQ1xUDSjG9jpe9AXHqwLpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741761975; c=relaxed/simple;
	bh=djI54cs6Y27ELEuS935js1Ady9bp9dSUrgtkkRBZVHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unWbaWFizOFlYB/15bhiYrKVUq/JO1rSK2mJs8/PIIWR3wazPfIGSo1iHHHrjocd8D5XIlKOMn3F7s5tqyZDEznEYaECO7EH7i5Mkk6FMDUI3K16FrfPMvrwZx6W3SxpBAb2joUK21YE4wXcDnfdGQisANNbdwsOqQv4dMD3UjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xpzJ0A2C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xpzJ0A2C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XLcExoIypM6eS3i9VS+syGVAyQeAHMZsk/AiQmE07b8=; b=xpzJ0A2CuiiVUPMWrvMIEd6aGI
	R1CsMQysvvFcOYKHWWijJO9QWxaEGkmLLUq43kfrgzzLka13eYWpoDtDUQA+8IAU/oPPSINHrgSpm
	0kyUVY16KwQ4Lvr3HH5X/Z1q8x+QlLsutJOWvIuoEV9pDkpgULWG6MlMmkkZ9UlA92cMqKmXrMhWp
	ChHYdRIXQzWgWVD3EmZW9322PlIUndSNIsJ46gqcvqGzAfynEE1dmHfGs8MCifk2LIcyGyIG2Q2R3
	XhtG+mtDd0HzYGWiAlBvOyCQ1+6kFonqrSn0E5oji/i9DdUMDnyygXuI5rgN2Fg0xm8QA1aj/WRbr
	lj1eOcog==;
Received: from 2a02-8389-2341-5b80-f359-bc8f-8f56-db64.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f359:bc8f:8f56:db64] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tsFr3-00000007crf-2alh;
	Wed, 12 Mar 2025 06:46:13 +0000
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 11/17] xfs: handle zoned file systems in _scratch_xfs_force_no_metadir
Date: Wed, 12 Mar 2025 07:45:03 +0100
Message-ID: <20250312064541.664334-12-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250312064541.664334-1-hch@lst.de>
References: <20250312064541.664334-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Zoned file systems required the metadir feature.  If the tests are run
on a conventional block device as the RT device, we can simply remove
the zoned flag an run the test, but if the file systems sits on a zoned
block device there is no way to run a test that wants a non-metadir
file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 common/xfs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/common/xfs b/common/xfs
index 86953b7310d9..a18b721eb5cf 100644
--- a/common/xfs
+++ b/common/xfs
@@ -2054,6 +2054,12 @@ _scratch_xfs_find_metafile()
 # Force metadata directories off.
 _scratch_xfs_force_no_metadir()
 {
+	_require_non_zoned_device $SCRATCH_DEV
+	# metadir is required for when the rt device is on a zoned device
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+		_require_non_zoned_device $SCRATCH_RTDEV
+	fi
+
 	# Remove any mkfs-time quota options because those are only supported
 	# with metadir=1
 	for opt in uquota gquota pquota; do
@@ -2074,6 +2080,11 @@ _scratch_xfs_force_no_metadir()
 	if grep -q 'metadir=' $MKFS_XFS_PROG; then
 		MKFS_OPTIONS="-m metadir=0 $MKFS_OPTIONS"
 	fi
+
+	# zoned requires metadir
+	if grep -q 'zoned=' $MKFS_XFS_PROG; then
+		MKFS_OPTIONS="-m zoned=0 $MKFS_OPTIONS"
+	fi
 }
 
 # do not run on zoned file systems
-- 
2.45.2

