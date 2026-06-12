Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1F735972;
	Fri, 12 Jun 2026 06:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247299; cv=none; b=koYiwPAEeXv8Rp/9pW2agRjy2FMd7UjhYEuyKVRxj+aMPmz5bMSrxzV26FWGrvQ95D+DYUQSRvhF4HSgbaIMr4zKjPzVyheKOfsUP/Vh2ewq/iAju5L5vb65sl36wX/wtbs86SFpj+OWzW27dYYQI44M0WpL/u/eQO24CtOj+uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247299; c=relaxed/simple;
	bh=x51neH/ryy+G7HZ7z9qnn4K+RvSZrCTJ0DBUY8jmH1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qzezSYH7qSKWef3wudA6dqrpRNKMrkKTTm5ppP3mHlk4VWY6QAsMVSOZHYD0TDx/uFQKhHhUApg92F3tta0h75HZ+FDro1/oPOgTyW4/xjiytdp/EYRIYy9yzEMuT6sq8bLAOL0Z8vFwRnH86vT5qnUy1gHBsf1QtI24wpSzYZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=c2wfyGbF; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="c2wfyGbF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781247289; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ZphKWwyl+WGH86LGIXqyFlQlvne4chYGQBsEKFLt2d0=;
	b=c2wfyGbFsnxPcJ4cmwIuBJW/9zpb82s+R1dEPtt12ger8u3X0lKxhJrIY+NHbyDCdMzFZSU91KudEkM34nLJoMZZly6Hy56+o3jFJrMsRz9X4gMzLwmva8qW/SKb131VvmeH2nvv08MyHaYfvq1c6a5jVPCSLwjAjvMtL3WMUMQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0X4hpKI3_1781247288;
Received: from 30.221.132.172(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X4hpKI3_1781247288 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Jun 2026 14:54:48 +0800
Message-ID: <62f6e9bc-cfb3-441c-a3b7-301b8649f0ae@linux.alibaba.com>
Date: Fri, 12 Jun 2026 14:54:47 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>
Cc: Yifan Zhao <zhaoyifan28@huawei.com>, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, yekelu1@huawei.com, jingrui@huawei.com,
 zhukeqian1@huawei.com, Ritesh Harjani <ritesh.list@gmail.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <aiumQL8LEWQX_Nag@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Christoph,

On 2026/6/12 14:25, Christoph Hellwig wrote:
> On Fri, Jun 12, 2026 at 11:42:38AM +0800, Gao Xiang wrote:
>>> Reported-by: Kelu Ye <yekelu1@huawei.com>
>>> Assisted-by: Codex:GPT-5.5
>>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>>
>> I think it's an iomap bug instead, see:
>>
>> iomap_bio_read_folio_range(), we should fix iomap instead.
> 
> Yes.  iomap should not try to build bios over iomap boundaries.
> caused various issues.  Ritesh ran into that with the ext2 port
> back in the day, and I actually ran into it again with an under
> development xfs feature.
> 
> Can you try this patch?

hmm, currently erofs could return block-sized iomap (if the chunk
size is 4k) even it can be merged with the following chunks.

Previously it was fairly good since consecutive chunks will be
added to the current bio if possible, but after this patch,
there will be a lot of 4k bios.

But if iomap goes into this way, I could make iomap_begin maps
more chunks in one shot, but that needs more changes in erofs,
it's fine anyway.

... I was thinking the following diff (space-damaged):

diff --git a/fs/iomap/bio.c b/fs/iomap/bio.c
index 4504f4633f17..241df96a16a6 100644
--- a/fs/iomap/bio.c
+++ b/fs/iomap/bio.c
@@ -142,6 +142,7 @@ int iomap_bio_read_folio_range(const struct iomap_iter *iter,

         if (!bio ||
             bio_end_sector(bio) != iomap_sector(&iter->iomap, iter->pos) ||
+           bio->bi_bdev != iter->iomap.bdev ||
             bio->bi_iter.bi_size > iomap_max_bio_size(&iter->iomap) - plen ||
             !bio_add_folio(bio, folio, plen, offset_in_folio(folio, iter->pos)))
                 iomap_read_alloc_bio(iter, ctx, plen);


but either way works fine with me since it's an iomap design
stuff.

Thanks,
Gao Xiang

> 
> ---
>  From 297230cc3c08cbfef3670b08c4e35813c18c523e Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Sun, 7 Jun 2026 08:53:20 +0200
> Subject: iomap: submit read bio after each extent
> 
> This keeps bios from crossing RTG boundaries in XFS and probably fixes
> all kinds of other stuff..
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   fs/iomap/buffered-io.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d55b936e6986..3642a11c102f 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -597,12 +597,13 @@ void iomap_read_folio(const struct iomap_ops *ops,
>   
>   	trace_iomap_readpage(iter.inode, 1);
>   
> -	while ((ret = iomap_iter(&iter, ops)) > 0)
> +	while ((ret = iomap_iter(&iter, ops)) > 0) {
>   		iter.status = iomap_read_folio_iter(&iter, ctx,
>   				&bytes_submitted);
> -
> -	if (ctx->read_ctx && ctx->ops->submit_read)
> -		ctx->ops->submit_read(&iter, ctx);
> +		if (ctx->read_ctx && ctx->ops->submit_read)
> +			ctx->ops->submit_read(&iter, ctx);
> +		ctx->read_ctx = NULL;
> +	}
>   
>   	if (ctx->cur_folio)
>   		iomap_read_end(ctx->cur_folio, bytes_submitted);
> @@ -664,12 +665,13 @@ void iomap_readahead(const struct iomap_ops *ops,
>   
>   	trace_iomap_readahead(rac->mapping->host, readahead_count(rac));
>   
> -	while (iomap_iter(&iter, ops) > 0)
> +	while (iomap_iter(&iter, ops) > 0) {
>   		iter.status = iomap_readahead_iter(&iter, ctx,
>   					&cur_bytes_submitted);
> -
> -	if (ctx->read_ctx && ctx->ops->submit_read)
> -		ctx->ops->submit_read(&iter, ctx);
> +		if (ctx->read_ctx && ctx->ops->submit_read)
> +			ctx->ops->submit_read(&iter, ctx);
> +		ctx->read_ctx = NULL;
> +	}
>   
>   	if (ctx->cur_folio)
>   		iomap_read_end(ctx->cur_folio, cur_bytes_submitted);

