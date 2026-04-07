Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F5233AD9D;
	Tue,  7 Apr 2026 18:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775587081; cv=none; b=bm7mXBisP7yklWHtoH3ThfSkObGbbjFGX02XTqzEaW+phqPxpged7eGUWe41BMnQ63zwG008cig1DC/nVjyMYJjHrJHHIp22tcbxDXOzn0uUofl5ZUsGRuNhxgL1Fe5zBDoYfHEvcCiEzqNYQdHOoz6NDV4AbpMEivRRgJWIcRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775587081; c=relaxed/simple;
	bh=HcDQS5ebeH7ZieOVm0mj4e8Ylamz97Bs61GYx75xD0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hncguWe6EQ6iasTqYK/KguaXkEU1UNWjL5ZfY1GUaon6co4hGawVcuaNxDI8AiDV0ytSDkoaWLFg3N7YzhSuAWiff63GI6NxrL/W+PFM43B9+3ghITOWjd1Qox2+X+2OjAUso0yy5ATC/wad1N+i/cKE9Y846msJjcTNHo1mJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=qhNOQLQ/; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="qhNOQLQ/"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fqw1N02k7z1XMG56;
	Tue,  7 Apr 2026 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1775587074; x=1778179075; bh=MGl7phjuS++wdWPeaaMrSIv4
	kIoMoCzHze4rIjNFHzQ=; b=qhNOQLQ/vdcCawHnlyuyL5NBP2Gm3y5rj2rzDcbu
	7YfB4X/7F7cF602Gz9SjrgOmk43wnI1bvOjyvHfP1TV335yIBs0UzDSdaJZCJA+e
	Xdh1FqoI1OkxbA2fBRpncH6VjVqARz+FpqiyTn3upYbGM6Wfs3YMfTcnWiDGTK7v
	sEzC+el58i2eu7wkBOK1ezpg09H+Wl419I3TEeFyl0TM1zb/3PEF+mwh1aJseXM2
	0jcLJbAxfKftrusLuCk53eYVGOrtcjrjgANYMZp+BYResqhfh+5hF8QiNtIVdGGJ
	rOhbgwZ5Oq/ejwX0k+GVkXa7eNuXguy2qWgvocYln2VWrg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PJLtKzVIv03M; Tue,  7 Apr 2026 18:37:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fqw1D1V85z1XMFjb;
	Tue,  7 Apr 2026 18:37:51 +0000 (UTC)
Message-ID: <b2e8e413-39bf-4255-8aad-a30d7fd676ea@acm.org>
Date: Tue, 7 Apr 2026 11:37:50 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] block: add a bio_submit_or_kill helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
 linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20260407140538.633364-1-hch@lst.de>
 <20260407140538.633364-5-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260407140538.633364-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 4/7/26 7:05 AM, Christoph Hellwig wrote:
> diff --git a/block/ioctl.c b/block/ioctl.c
> index 0b04661ac809..fc3be0549aa7 100644
> --- a/block/ioctl.c
> +++ b/block/ioctl.c
> @@ -153,13 +153,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>   	nr_sects = len >> SECTOR_SHIFT;
>   
>   	blk_start_plug(&plug);
> -	while (1) {
> -		if (fatal_signal_pending(current)) {
> -			if (prev)
> -				bio_await_chain(prev);
> -			err = -EINTR;
> -			goto out_unplug;
> -		}
> +	while (!fatal_signal_pending(current)) {
>   		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
>   				GFP_KERNEL);
>   		if (!bio)
> @@ -167,12 +161,11 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
>   		prev = bio_chain_and_submit(prev, bio);
>   	}
>   	if (prev) {
> -		err = submit_bio_wait(prev);
> +		err = bio_submit_or_kill(prev, BLKDEV_ZERO_KILLABLE);
>   		if (err == -EOPNOTSUPP)
>   			err = 0;
>   		bio_put(prev);
>   	}
> -out_unplug:
>   	blk_finish_plug(&plug);
>   fail:
>   	filemap_invalidate_unlock(bdev->bd_mapping);

Without this change, if a fatal signal is pending before the loop 
starts, -EINTR is returned. With this patch applied, 0 is returned,
isn't it?

Thanks,

Bart.
