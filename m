Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B30326A0FC
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 10:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751366511; cv=none; b=r/q3/jdMmpAEsvDuJnfm29gtEa8H5Qmac8PlNKVW1pLyafSr+9MNGqzlaX+niBMOsX7dWbXJUNlbrwJ2OneaRIjUX8wG65rMW9QF5igwWq7YC1yugcFRjg+ZdmjXIgEFtBw8IYNVzMNdIGznge23dq6+Rz5vT6nlbigKI8eRzLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751366511; c=relaxed/simple;
	bh=5KKNkETKC7Loc2zNul+0w8PQDplg2PcjVoFvg+xLidg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeP4jAepYEtBH1vON2wfBsmAMJ2c3EthMGQIaLKxVZTnJBejs2KdbvHfvxhRQd4ezamtzoi1j+Yq4/Nqi9xB00IGoLDrjDe8xT9h57geYnYzXLEV9rt2ouKAfTI1QjJEfsUfdBHO+vz/zlaVxp7rAjksZNPE1bm2nqS5NZwKBFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=00W8jx16; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="00W8jx16"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wOaN2ZeyAXsvcSDMfoVj96zhLMBXvtmCeOUU83lPMaQ=; b=00W8jx16DlBILbV+mOPSxCxQKr
	LtU2Wn64iy9H6As+RloJJ0wl+kZYYua3+MtnBxDtKr9tHlwBqb0+Hird/mpedZhZxNxrWwW75mQbc
	gqd13sKY0VOH0Did5BAQrm0K1GMRyUvFh7fqt7GVBKYqRw9BNOgkpG4+74FvAEhSQVCfJYaB507UH
	uQam0jUCvBONC6hFDpoVqH0wbe66R3gc8BLN0DW73mhsyBHxOy0o41869DIBZSKKC250I6TSA6GKQ
	Uvufnq2nvlrA2B/FFctWjsi1GpMzE+wwk6KkZK/r5EZ83gGNtOEOr4AeXNZou6IuWmaP8OeZgQICC
	o61cbVIg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uWYQv-00000004m2K-1W6t;
	Tue, 01 Jul 2025 10:41:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: remove the bt_bdev_file buftarg field
Date: Tue,  1 Jul 2025 12:40:40 +0200
Message-ID: <20250701104125.1681798-7-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250701104125.1681798-1-hch@lst.de>
References: <20250701104125.1681798-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

And use bt_file for both bdev and shmem backed buftargs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 4 ++--
 fs/xfs/xfs_buf.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 661f6c70e9d0..b73da43f489c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1683,7 +1683,7 @@ xfs_free_buftarg(
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 	/* the main block device is closed by kill_block_super */
 	if (btp->bt_bdev != btp->bt_mount->m_super->s_bdev)
-		bdev_fput(btp->bt_bdev_file);
+		bdev_fput(btp->bt_file);
 	kfree(btp);
 }
 
@@ -1802,7 +1802,7 @@ xfs_alloc_buftarg(
 	btp = kzalloc(sizeof(*btp), GFP_KERNEL | __GFP_NOFAIL);
 
 	btp->bt_mount = mp;
-	btp->bt_bdev_file = bdev_file;
+	btp->bt_file = bdev_file;
 	btp->bt_bdev = file_bdev(bdev_file);
 	btp->bt_dev = btp->bt_bdev->bd_dev;
 	btp->bt_daxdev = fs_dax_get_by_bdev(btp->bt_bdev, &btp->bt_dax_part_off,
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7987a6d64874..b269e115d9ac 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -94,7 +94,6 @@ void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
  */
 struct xfs_buftarg {
 	dev_t			bt_dev;
-	struct file		*bt_bdev_file;
 	struct block_device	*bt_bdev;
 	struct dax_device	*bt_daxdev;
 	struct file		*bt_file;
-- 
2.47.2

