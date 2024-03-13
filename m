Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29134779E;
	Wed, 13 Mar 2024 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710344425; cv=none; b=diD2MORyjyF6BTYW4R9n9N0rtNY2w26elYq0Hhm62E17hozu0HPPibZe4RJS1oiqwbPALhO8aARpfQOSyrYO6pBNKTY78N99sQ0EGP1Hb55V0QWV9b9x1OISt1X7GzAKOGzZvCDllp8ASKs+nbjTapkngWeNNcxT7TELDCNxIFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710344425; c=relaxed/simple;
	bh=4oJHI0KfHtFW48aWPDA3mAGSBQe8ddaVpidCtCXY66c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMNsMInso/pZf54MJqlDMm8Yq6lmACjq5fhRM3F5CMfjG78md4WlO1TeJZaf8lzfv+0fSCQuuCzljszUoSlI+2KEU+7NNc0R/ZwCdFhVgo8X3bKQO/Q13ElwV8DmiTa9FPdBjesUQ1SMas8yVSQzU8nW7JNEI1i36Lr/URYaGEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kyPZrvut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kyPZrvut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C3EC433C7;
	Wed, 13 Mar 2024 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710344424;
	bh=4oJHI0KfHtFW48aWPDA3mAGSBQe8ddaVpidCtCXY66c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kyPZrvutV1rMvBM6CPZ6YdneIOaxMrU+MQB9zKY431uYWS7E8PUMD3VYPUUTQJPA/
	 /RJYvsuyBXKtnvjCwpeeaIVOCWWddhNIL5K6YxIuVs9R4QmYTF4YrNGjG/TS/B0IJe
	 P65yg0NF03klIR7w5fH2iGkInRgaOrKPVoGkDYPlvw1hue0GFj10WHZl6vvwvtjThs
	 JMmF8xQE4aDFjb/zY9qWiGYCWcJDd17XiAwwaXacdNfQodkOzhK0aleDQ4ovDgdttu
	 5pQFm0438fQpQ1mH7rQyOOnferj2EVI6wRiMrx6Szmvs0GOMYU1+yQiJ/4pHv/LgaB
	 EyjMrw6sli/3g==
Date: Wed, 13 Mar 2024 09:40:21 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] block: move discard checks into the ioctl handler
Message-ID: <ZfHI5Vr7BOU6__rv@kbusch-mbp>
References: <20240312144532.1044427-1-hch@lst.de>
 <20240312144532.1044427-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240312144532.1044427-2-hch@lst.de>

On Tue, Mar 12, 2024 at 08:45:27AM -0600, Christoph Hellwig wrote:
> @@ -95,6 +95,8 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
>  static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>  		unsigned long arg)
>  {
> +	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
> +	sector_t sector, nr_sects;
>  	uint64_t range[2];
>  	uint64_t start, len;
>  	struct inode *inode = bdev->bd_inode;
> @@ -105,18 +107,21 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>  
>  	if (!bdev_max_discard_sectors(bdev))
>  		return -EOPNOTSUPP;
> +	if (bdev_read_only(bdev))
> +		return -EPERM;
>  
>  	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
>  		return -EFAULT;
>  
>  	start = range[0];
>  	len = range[1];
> +	sector = start >> SECTOR_SHIFT;
> +	nr_sects = len >> SECTOR_SHIFT;
>  
> -	if (start & 511)
> +	if (!nr_sects)
>  		return -EINVAL;
> -	if (len & 511)
> +	if ((sector | nr_sects) & bs_mask)
>  		return -EINVAL;
> -
>  	if (start + len > bdev_nr_bytes(bdev))
>  		return -EINVAL;
>  
> @@ -124,7 +129,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>  	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
>  	if (err)
>  		goto fail;
> -	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
> +	err = blkdev_issue_discard(bdev, sector, nr_sects, GFP_KERNEL);
>  fail:
>  	filemap_invalidate_unlock(inode->i_mapping);
>  	return err;
> -- 

The incremental change I think you want atop this patch to keep the
previous behavior:

-- >8 --
diff --git b/block/ioctl.c a/block/ioctl.c
index 57c8171fda93c..e14388548ab97 100644
--- b/block/ioctl.c
+++ a/block/ioctl.c
@@ -95,7 +95,7 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
-	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
+	sector_t mask = bdev_logical_block_size(bdev) - 1;
 	sector_t sector, nr_sects;
 	uint64_t range[2];
 	uint64_t start, len;
@@ -120,7 +120,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 
 	if (!nr_sects)
 		return -EINVAL;
-	if ((sector | nr_sects) & bs_mask)
+	if ((start | len) & mask)
 		return -EINVAL;
 	if (start + len > bdev_nr_bytes(bdev))
 		return -EINVAL;
