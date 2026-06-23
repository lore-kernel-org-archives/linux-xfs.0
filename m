Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA60363C64;
	Tue, 23 Jun 2026 14:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782224480; cv=none; b=Zo3bhCUmPKRX6znXZ1J0F73IyCwr4eESfq5is0uMJrdh/1+HcsQkxuwiHHWS6PgiJHzL+8LKWd7Cu06b5sdR0nwXs2Qq4VNBYL8XU7hjJ5hZaF135IZp18eUsbQKZYzsQIdNd3yRlSTfy//dGq5Phem60T1ZJ42gpYFD9dDOAOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782224480; c=relaxed/simple;
	bh=iPiq1X5Mo8oVDnos0ad125FWMVF7pLmQXXfqzZLZNgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDPRVLkjIZIkz5fPa3/c9rnmgovV3uAkoTSGpvGN1BFDtxOzTf/MEURBljuGYvWEYW2KIrj8VpQA9/E/xjOzwVb56u+vD19IfIC/P9psN712PMS/Xx/JqM7gE5SvTjyqdZ+jnTCOEVhrPKVrclRS1dBE7vouoNpjG8YGN6bTyBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hkYdE3g/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hkYdE3g/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gdX6E56iqUBRJfgCN3pwtbfugiYVuanyaqXEHjqBfY0=; b=hkYdE3g/UU4sVEp90NMYbQHwLU
	hwmS/P6rpKV8fLz/cVCoJiu9MuCZvdUnbtcWNLoMv5HfWTDBsRAJdKlZSGgEQxAuak6yTeUz2RyJ6
	LxTcjjfVRIWp1puaVrA+X8nI9WR88WOSnn90yOWbGqDA7YRK/UqNhJYQsZ8/KrmRz366yaOFJCb/p
	1z+AkG2MHNGFGcuUV+s5rOw3wNZysljn4FLxtOHcbU0gWOOPvoog/VuOe757RNFZNCme2qZ96hFdP
	bARYIX5u9m49fkLCyYdZtZs7+glZhi7lCGmjX3k6tI1xX2YZ38QMTooHtOx01ay6Azqx5MtLBssn2
	QztSg9nA==;
Received: from [2001:4bb8:2f6:ef61:5b2b:8638:3844:9408] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc205-00000006Qbf-1jxg;
	Tue, 23 Jun 2026 14:21:17 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT device limits
Date: Tue, 23 Jun 2026 16:21:06 +0200
Message-ID: <20260623142109.1838702-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623142109.1838702-1-hch@lst.de>
References: <20260623142109.1838702-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When using XFS with a main device on an SSD that stores metadata and a RT
device to store data on a HDD, we fail to take the I/O sizes for the RT
device into accounting, leading to up to 5% slower read performance when
using an SSD for metadata vs storing data and metadata on the HDD.

Fix this up by taking the RT settings into account.  Note that this
updates the BDI owned by the main device, and leaves those settings in
place even when the file system is unmounted.  This is a bit unexpected
but not different from manual tuning through sysfs (although that is only
possible for the ra_pages value).

Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_super.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e6781f86d867..88edd3822872 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -546,6 +546,29 @@ xfs_open_devices(
 	return error;
 }
 
+/*
+ * When using a RT device some or all data I/O is using the RT device, but
+ * the BDI is inherited from the main data device.  When the underlying block
+ * device for the RT device has larger I/O sizes, the BDI settings might be
+ * incorrect, which is especially bad if the main device is a SSD and the
+ * RT device is a HDD, as the io_opt fixup in blk_apply_bdi_limits is missing
+ * for this case.
+ *
+ * Update the BDI values to the max of the data and RT device to cover our
+ * bases.
+ */
+static void
+xfs_update_bdi_rahead(
+	struct xfs_mount	*mp)
+{
+	struct backing_dev_info	*rt_bdi =
+		mp->m_rtdev_targp->bt_bdev->bd_disk->bdi;
+	struct backing_dev_info	*sb_bdi = mp->m_super->s_bdi;
+
+	sb_bdi->ra_pages = max(sb_bdi->ra_pages, rt_bdi->ra_pages);
+	sb_bdi->io_pages = max(sb_bdi->io_pages, rt_bdi->io_pages);
+}
+
 /*
  * Setup xfs_mount buffer target pointers based on superblock
  */
@@ -583,6 +606,7 @@ xfs_setup_devices(
 				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
 		if (error)
 			return error;
+		xfs_update_bdi_rahead(mp);
 	}
 
 	return 0;
-- 
2.53.0

