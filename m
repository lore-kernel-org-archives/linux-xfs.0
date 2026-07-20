Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FF94266AA;
	Mon, 20 Jul 2026 14:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556542; cv=none; b=dccadedezCqPkXX3Oe+uI7bmtQTcWny9SVPwfQDUuDTrplzuqtdWSMQS+AGZf957HzKSySw10Y3sDmCt7Z4RIdd1zpjuBKi+poeDmgjZEinPmsmPitlQICDcs7SeY5C+7UBLo7XBz9jr57G6OD4ajrELNxxyMre/D9/TyhH2TtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556542; c=relaxed/simple;
	bh=9ysr8N6rN0k2V36lqX+LnLwcs9nlXBUZGQmGUIjxgx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCj3aImgELkxNxHrmeCajIQYoHMKLh/ckkfjNQlY9jQOqutncgpO73UHKKjVCxqatFTiDTAvNVRQCwbYJs5GhWOcGrtz4wQX0J8mcemTXpwVVF995YxwLkYAn9kvJOFlYlStDt5vdZn8bpX6FUbH6hiTWH8cwjYAFCSeuPqMmmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EcntWVH3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EcntWVH3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VxnYXgWTyqi30XyKPnOeiKgKagllvyFCEXUtYm46rnU=; b=EcntWVH3fJpoUWlie3AtvQ9j+N
	M1IcnyGNjnrrQ3Ly2IMnPNZqlzbAg/mQpnfuRjCubeZr+O07GgPRS+htda3TQ9FOatyea9kDMo4xF
	QJ0TYdqkuxBUeSVpI1wYztfxt2h1zLbZ0Pu4NBRksfgGxSkIipDUYDJqccW+q82Yzm9NHSNx+qB85
	HvVPWvxMdDCtzmESClD9/fnfR3oBMjUbzi29U7BkkqINnHKoNT1F9b7KUMiphabqkMM+xhfFI06Li
	98P/YRCtxrtVyN2a4DgNzVaL27ROt/UOEljxkeI6bSh/wQDi6OGC+X3R3hPmJSMB4F4BdLas3BgY7
	HUBnDXQA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlofx-00000006uKy-03Qn;
	Mon, 20 Jul 2026 14:08:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	Filip Blagojevic <filip.blagojevic@wdc.com>,
	Matthew Wilcox <willy@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: update BDI {io,ra}_pages values based on the RT device limits
Date: Mon, 20 Jul 2026 16:08:47 +0200
Message-ID: <20260720140849.2269776-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720140849.2269776-1-hch@lst.de>
References: <20260720140849.2269776-1-hch@lst.de>
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

Fix this up by taking the RT settings into account at mount an restoring
the old settings at unmount time, unless the BDI settings have changed
from those set by XFS.

Reported-by: Filip Blagojevic <filip.blagojevic@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h |  7 ++++++
 fs/xfs/xfs_super.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 66a02d1b9ad7..216a38a354e7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -349,6 +349,13 @@ typedef struct xfs_mount {
 
 	/* Index of uuid record in the uuid xarray. */
 	unsigned int		m_uuid_table_index;
+
+	/*
+	 * Old io_pages/ra_pages valued in the main bdev BDI, and our initial
+	 * calculated values.
+	 */
+	unsigned long		m_old_io_pages, m_initial_io_pages;
+	unsigned long		m_old_ra_pages, m_initial_ra_pages;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8531d526fc44..63c4bcbe6c2b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -548,6 +548,52 @@ xfs_open_devices(
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
+	mp->m_old_io_pages = sb_bdi->io_pages;
+	mp->m_old_ra_pages = sb_bdi->ra_pages;
+
+	sb_bdi->io_pages = mp->m_initial_io_pages =
+		max(sb_bdi->io_pages, rt_bdi->io_pages);
+	sb_bdi->ra_pages = mp->m_initial_ra_pages =
+		max(sb_bdi->ra_pages, rt_bdi->ra_pages);
+}
+
+static void
+xfs_restore_bdi_rahead(
+	struct xfs_mount	*mp)
+{
+	struct backing_dev_info	*sb_bdi = mp->m_super->s_bdi;
+
+	if (sb_bdi->io_pages == mp->m_initial_io_pages)
+		sb_bdi->io_pages = mp->m_old_io_pages;
+	else
+		xfs_info(mp, "io_pages changed from %lu to %lu, not restoring.",
+				mp->m_initial_io_pages, sb_bdi->io_pages);
+	if (sb_bdi->ra_pages == mp->m_initial_ra_pages)
+		sb_bdi->ra_pages = mp->m_old_ra_pages;
+	else
+		xfs_info(mp, "ra_pages changed from %lu to %lu, not restoring.",
+				mp->m_initial_ra_pages, sb_bdi->ra_pages);
+}
+
 /*
  * Setup xfs_mount buffer target pointers based on superblock
  */
@@ -585,6 +631,7 @@ xfs_setup_devices(
 				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
 		if (error)
 			return error;
+		xfs_update_bdi_rahead(mp);
 	}
 
 	return 0;
@@ -2283,8 +2330,12 @@ static void
 xfs_kill_sb(
 	struct super_block		*sb)
 {
+	struct xfs_mount		*mp = XFS_M(sb);
+
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
+		xfs_restore_bdi_rahead(mp);
 	kill_block_super(sb);
-	xfs_mount_free(XFS_M(sb));
+	xfs_mount_free(mp);
 }
 
 static struct file_system_type xfs_fs_type = {
-- 
2.53.0

