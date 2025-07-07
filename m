Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5C28935D
	for <linux-xfs@vger.kernel.org>; Mon,  7 Jul 2025 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751893124; cv=none; b=kg5VggpsH/l3jJKyl7r9ouCSq43vMSJHwqg8Veahu9jD09MJKx3UT6BOcAPw+yf5pMyzqc8D9TyVwrkJSp/W7YHQqmbcXODbycoDk/q6Z7buMLNhIbZtFBq+xVV592vwfgjMOP1SxsLeKdHcH9gTa2GVlgVlII3e9yrC9dE7PYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751893124; c=relaxed/simple;
	bh=fPHXW9SM5a/QoaX2ISKJ6pdk7smRDAB3CSS7eHHrcJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iFypmtnkcB7ApkUmYRha8A55TbOijL5xGw0md/O7AcI/vgmBfAIMPSfy6NHkpca+Toyw9L3H3IMKZKrhYqvvS2oim0HcqYtIOLifV3cASvfjZNV1Z1dZnU4RzVYyIjg4u5DYIgKpNYug0Z34psEPz1ijfVfVFo5I/SwVTseQwsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 233A768C7B; Mon,  7 Jul 2025 14:58:37 +0200 (CEST)
Date: Mon, 7 Jul 2025 14:58:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH 6/5] xfs: remove the bt_bdev_file buftarg field
Message-ID: <20250707125836.GA24721@lst.de>
References: <20250707125323.3022719-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250707125323.3022719-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

Date: Fri, 23 May 2025 14:31:28 +0200

And use bt_file for both bdev and shmem backed buftargs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c | 4 ++--
 fs/xfs/xfs_buf.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index edae4733a72f..f9ef3b2a332a 100644
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
 
@@ -1798,7 +1798,7 @@ xfs_alloc_buftarg(
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

