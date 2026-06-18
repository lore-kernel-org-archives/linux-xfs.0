Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8C15A85A;
	Thu, 18 Jun 2026 07:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781766978; cv=none; b=SSCQ0TwWAgMZNznfWnuviodNR1HirW6oPgbKX8RX8dEzSdkhxkJHf6/0US36R9sPslF2nHW65cJuy8QLEXQCRai9hnEZK68gKzRcUVCKGFndEqyN/21c7IAOMLunY4HW9T6FLik7rTij1ijcbKDg2fi4L5k50D9b0VcOGQW8Vcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781766978; c=relaxed/simple;
	bh=w/3BNTcQBKFtjztn37+d5ILCg+c+eAlCPFrNmILVFmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VXpY52GFct61ba7AqVCEKmcThdQOuTq6gtPYLlDxJAk0Sets1rANjPIvERarXdvjuGSAs2V6Ymy1GL+laG/wHXF+ETdAsXRWcPvHp7OjcUQfdjFFmVZ9b73S/VIybK0ZuKd6VdFvnv/7y6sAmRo2MkO0QnJocqqRcZY7AbTdGmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=R9JyEAlP; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="R9JyEAlP"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=iVdMWBlT662SrcMGF8y/JgT1w7kd5zj4BN+nKS7wNos=;
	b=R9JyEAlPmRphrW7FCV665S9w6GTNpkK1q8uUkDLokTNRvccCAjTIQHD4qtCa8uKgEFtAfitt6
	BakpTY9xfKqLembS9Ixw3nAcypVhIoTw5yAEgsGsHtCuQI9HjjiJmZoE0emPodtX/pU4o6OSaoz
	9fYw46eICuzrTpIRzynliaQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ggsJ26R11zKm4B;
	Thu, 18 Jun 2026 15:08:02 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 7042540562;
	Thu, 18 Jun 2026 15:16:04 +0800 (CST)
Received: from [100.102.28.251] (100.102.28.251) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 18 Jun 2026 15:16:03 +0800
Message-ID: <fbc281ab-09ba-4e3a-90cd-2babc708fdc4@huawei.com>
Date: Thu, 18 Jun 2026 15:16:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: don't merge bios over iomap boundaries, was: Re: [PATCH] erofs:
 prevent buffered read bio merges across device chunks
To: Christoph Hellwig <hch@infradead.org>, Gao Xiang
	<hsiangkao@linux.alibaba.com>
CC: <linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
	<yekelu1@huawei.com>, <jingrui@huawei.com>, <zhukeqian1@huawei.com>, Ritesh
 Harjani <ritesh.list@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>,
	<linux-xfs@vger.kernel.org>, Joanne Koong <joannelkoong@gmail.com>
References: <20260612033244.993507-1-zhaoyifan28@huawei.com>
 <58bef9af-0926-4948-b917-e38c3793f596@linux.alibaba.com>
 <aiumQL8LEWQX_Nag@infradead.org>
From: "zhaoyifan (H)" <zhaoyifan28@huawei.com>
In-Reply-To: <aiumQL8LEWQX_Nag@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)

Hi Christoph,


This patch works well under my workload (at least correctness-wise). Thanks.


Tested-by: Yifan Zhao <zhaoyifan28@huawei.com>


Thanks,

Yifan

On 2026/6/12 14:25, Christoph Hellwig wrote:
> On Fri, Jun 12, 2026 at 11:42:38AM +0800, Gao Xiang wrote:
>>> Reported-by: Kelu Ye <yekelu1@huawei.com>
>>> Assisted-by: Codex:GPT-5.5
>>> Signed-off-by: Yifan Zhao <zhaoyifan28@huawei.com>
>> I think it's an iomap bug instead, see:
>>
>> iomap_bio_read_folio_range(), we should fix iomap instead.
> Yes.  iomap should not try to build bios over iomap boundaries.
> caused various issues.  Ritesh ran into that with the ext2 port
> back in the day, and I actually ran into it again with an under
> development xfs feature.
>
> Can you try this patch?
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
