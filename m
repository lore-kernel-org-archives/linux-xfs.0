Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566D52D46DD;
	Tue, 18 Nov 2025 08:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763453075; cv=none; b=bRcdIYdqa+X49PxiHzvFtBLtimTfQTbWFVNlHZ3bM2Il4m8tAlSEW+Loa6zOGZCfKqU29xNZ5ktQoPoHn1jhVkOCc2s3KK4DxeL6pAVdZp60U3zagFw3e4t+YK6H1jC3Jg4mtcRBI14/txwzrvQWgDooURKsHRzNEJxP7c5q5EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763453075; c=relaxed/simple;
	bh=mPXKpqB6qHKnSgcmE9DJEPoUQXkPovVQvUnM+auWdpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4M2pO5GI0qRikNgWDkabhUka5MInyQGhO5+C+3apZH8OufYKW0ctNbOce1hH1H7BpmjO/SqwEcYVlwCsWEmzeLFW/XQkRGVBklPRbk2hNsAi2Vm04OgNI6RhbLnP1ObsY/zHZxWOyyxPEFbx5cWAp1/PUqevBQa0dk2w71XeP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C26167373; Tue, 18 Nov 2025 09:04:27 +0100 (CET)
Date: Tue, 18 Nov 2025 09:04:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com,
	hch@lst.de, sagi@grimberg.me, kch@nvidia.com, jaegeuk@kernel.org,
	chao@kernel.org, cem@kernel.org
Subject: Re: [RFC PATCH] block: change __blkdev_issue_discard() return type
 to void
Message-ID: <20251118080427.GA26299@lst.de>
References: <20251118074243.636812-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251118074243.636812-1-ckulkarnilinux@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 17, 2025 at 11:42:43PM -0800, Chaitanya Kulkarni wrote:
> Due to involvement of all the subsystem making it as an RFC, ideally
> it shuoldn't be an RFC.

I think best would be a series that drops error checking first,
and then changes the return type.  That way we can maybe get all
the callers fixed up in this merge window and then drop the return
value after -rc1.
>  			gfp_mask)))
>  		*biop = bio_chain_and_submit(*biop, bio);
> -	return 0;
>  }
>  EXPORT_SYMBOL(__blkdev_issue_discard);
>  
> @@ -90,8 +89,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
>  	int ret;
>  
>  	blk_start_plug(&plug);
> -	ret = __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);
> -	if (!ret && bio) {
> +	__blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask, &bio);

ret now needs to be initialized to 0 above.

> index 8d246b8ca604..f26010c46c33 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -366,16 +366,11 @@ static u16 nvmet_bdev_discard_range(struct nvmet_req *req,
>  		struct nvme_dsm_range *range, struct bio **bio)
>  {
>  	struct nvmet_ns *ns = req->ns;
> -	int ret;
>  
> -	ret = __blkdev_issue_discard(ns->bdev,
> +	__blkdev_issue_discard(ns->bdev,
>  			nvmet_lba_to_sect(ns, range->slba),
>  			le32_to_cpu(range->nlb) << (ns->blksize_shift - 9),
>  			GFP_KERNEL, bio);
> -	if (ret && ret != -EOPNOTSUPP) {
> -		req->error_slba = le64_to_cpu(range->slba);
> -		return errno_to_nvme_status(req, ret);
> -	}
>  	return NVME_SC_SUCCESS;

nvmet_bdev_discard_range can return void now.

> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index b45eace879d7..e6078176f733 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1346,7 +1346,7 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
>  		if (time_to_inject(sbi, FAULT_DISCARD)) {
>  			err = -EIO;
>  		} else {
> -			err = __blkdev_issue_discard(bdev,
> +			__blkdev_issue_discard(bdev,
>  					SECTOR_FROM_BLOCK(start),
>  					SECTOR_FROM_BLOCK(len),
>  					GFP_NOFS, &bio);

Please fold the following 'if (err)' block directly into the injection
one, and either initialize err to 0, or use a direct return from that
block to skip the last branch in the function checking err.

>  	blk_finish_plug(&plug);
>  
> -	return error;
> +	return 0;

Please drop the error return for xfs_discard_extents entirely.

