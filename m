Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0313081AB
	for <linux-xfs@vger.kernel.org>; Wed, 26 Nov 2025 02:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764124639; cv=none; b=PHGTJ0CdoJLGB9LlUEdxdaJOV53qm/t3hCKtpa0wHiWyh/8+p18LuCA6pGPox2J8ryKkOAQd7bD91H2EjPSK9dQlFLKMMMfURq05nf/BGzRtzBz4SeLLc2oqT8QJBUUpD115PqQTJpHp4K5hLRbvk+DHx8u2WalKp5vxigwPHEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764124639; c=relaxed/simple;
	bh=pxuO7lo4RNzUGyMrbTrssQJXkAqOwV8BIy37TFUn0yo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TI14WHR+Tk0p39bHNHVj4S5lOJy6O9BjbX7TFnhlAT8q06Yl/fov/5Em89GEMLnY5Oc1geo0V/o4pnAvlmc7ZnRGXOpdhNTaGvytIC8TgmYfR3983YE5QXXNVPn3+u9QNpUm/nTUy/zjj05Vo+JD20d7aM6G2ki2En9cB1eTh8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ePDQuscH; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ePDQuscH"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7a435a3fc57so6493172b3a.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Nov 2025 18:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764124637; x=1764729437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qt1MZpNKWoqgVDxQoUbhRRb+/kXBWmuaotwFheQ1vHc=;
        b=ePDQuscHlpeVYlTJjupu6ow0HHp3S8MZ7E2BF6UN689I9U0gWf7p3l2fOUrLSbMrvM
         cU4xbPXAaI/QtabkcyYat7C/pby0aVq5YbpwenEV3zVMH6yRYXDjb09w38JfSoL5PaDA
         E3G5cKs0ypI4vqifsWl+dI4BpqGoIYeboRTaAHNs3tXPBFOUGW13dgMh2bzj1VfE3YQh
         ydmjF8d2UCjbqhs6Y1UvOq6cFAk2dNmuNZw5VJA99TaM6vDgGf9XG1bmOAuZd1wOSNl4
         PfPLBdE+N1K+20tKWUPcPBpXOVOmnCJe+s2s+QtTfOZjpsZzxnKo3IJldP2Lxvkp9TJp
         W86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764124637; x=1764729437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qt1MZpNKWoqgVDxQoUbhRRb+/kXBWmuaotwFheQ1vHc=;
        b=SQguyDAoCF/ofkMZIeHGgZTx3ePgo11nMRH8CCtihmYRB67xyG0GUmJ98FBCNW3sqY
         rLEbibI1vb0v/T7KSgB0fjeEjE5ylgJOvkSCeBlfrUIqGMYASRiSAielCzLWJmQKsipS
         qafwMJ45N2RPCnE7rk70xkjLqEcvOzHLrKFtzDKpwQenHBIXgItuch6JvYnZy+yU+1Py
         qsMk0kuWl1UsufKmrMXkffzLhk5vOVU7vkmKU8AHaKvHbpZ9aqwE7e8vTKiJR1DUfH5d
         DnWER3xF7WxpIf+RhDM8N/n0j8Ey4vpegV+/RoBJ7+2/j/XBBVKnSSke5THC3GL56uKd
         /Oag==
X-Forwarded-Encrypted: i=1; AJvYcCVt9CTgglubtLoOL6keYlqEaTs/FHi9/JtisfotV0oud+8vE7did7KiWzB4ZthiKJMr8tIf+twTLX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvPDkVbImbURNwi6J1q6QrgQWRLhO1TwwPD8if28jZ7fsv4Zqo
	ayo3ufuIwdYNxQZeSjL4SEhjTySmDG4Yf81T6sjqxLi3imLgBBATmqN4
X-Gm-Gg: ASbGncvJY2mqjVAG8HNn6YJvo2NVCNGtw57+umIeyrHYdQaWi00c9vN+Hmiievlwj1L
	4eiCeuqNMRmjTV83bgqWPw+XfZBPOeCxN8VCL1+m6+hLFXCtQNc7fPdeYeZav4w6eUdOEzp64bC
	P+C6AvY9jCzjCBPfN1WU8CCWVIO6jDJpENr3USDtdRP6TtO4r8toWvK41maG+j2rrO4Bey8BTeA
	qjiO4oLLGaq+lWBWrPT9n1D0Sf3Aus19ZE1DuANGAlyppdSu3UlOLPnzGVSJTkgRTrsPKf+eIHX
	zRUS+es7bWiO05VmSmFj6uqT0QD2klBIoKV/vyl+SwP4+M5GILMO6OTV/hFDSbP5FLQ96Gr+mW8
	5oZCLlSZ50pchNtC+j2KwvyLnuwvPUDhLYkUrS43W82bSnBu/dltrnavqI04aBzc1ePqqFz4+hG
	F4Gd+usDS67rbb79N8U9LvDC/ZPkd8Zg==
X-Google-Smtp-Source: AGHT+IFMPVdPASuME6boYfK9CSm7iGISD/qVZKhPKWlRPsY/Zck4GXkccO8MN1rBK0lovp98a7V31w==
X-Received: by 2002:a05:6a00:3906:b0:77f:efd:829b with SMTP id d2e1a72fcca58-7c58e602dcdmr17676868b3a.22.1764124636518;
        Tue, 25 Nov 2025 18:37:16 -0800 (PST)
Received: from [10.189.138.37] ([43.224.245.241])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f1262364sm19518773b3a.58.2025.11.25.18.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 18:37:16 -0800 (PST)
Message-ID: <b18c489f-d6ee-4986-94be-a9aade7d3a47@gmail.com>
Date: Wed, 26 Nov 2025 10:37:10 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [f2fs-dev] [PATCH V3 6/6] xfs: ignore discard return value
To: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
 agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
 yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me, kch@nvidia.com,
 jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org
Cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
 bpf@vger.kernel.org, linux-xfs@vger.kernel.org,
 Yongpeng Yang <yangyongpeng@xiaomi.com>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com>
 <20251124234806.75216-7-ckulkarnilinux@gmail.com>
Content-Language: en-US
From: Yongpeng Yang <yangyongpeng.storage@gmail.com>
In-Reply-To: <20251124234806.75216-7-ckulkarnilinux@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/25/25 07:48, Chaitanya Kulkarni wrote:
> __blkdev_issue_discard() always returns 0, making all error checking
> in XFS discard functions dead code.
> 
> Change xfs_discard_extents() return type to void, remove error variable,
> error checking, and error logging for the __blkdev_issue_discard() call
> in same function.
> 
> Update xfs_trim_perag_extents() and xfs_trim_rtgroup_extents() to
> ignore the xfs_discard_extents() return value and error checking
> code.
> 
> Update xfs_discard_rtdev_extents() to ignore __blkdev_issue_discard()
> return value and error checking code.
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> ---
>   fs/xfs/xfs_discard.c | 27 +++++----------------------
>   fs/xfs/xfs_discard.h |  2 +-
>   2 files changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index 6917de832191..b6ffe4807a11 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -108,7 +108,7 @@ xfs_discard_endio(
>    * list. We plug and chain the bios so that we only need a single completion
>    * call to clear all the busy extents once the discards are complete.
>    */
> -int
> +void
>   xfs_discard_extents(
>   	struct xfs_mount	*mp,
>   	struct xfs_busy_extents	*extents)
> @@ -116,7 +116,6 @@ xfs_discard_extents(
>   	struct xfs_extent_busy	*busyp;
>   	struct bio		*bio = NULL;
>   	struct blk_plug		plug;
> -	int			error = 0;
>   
>   	blk_start_plug(&plug);
>   	list_for_each_entry(busyp, &extents->extent_list, list) {
> @@ -126,18 +125,10 @@ xfs_discard_extents(
>   
>   		trace_xfs_discard_extent(xg, busyp->bno, busyp->length);
>   
> -		error = __blkdev_issue_discard(btp->bt_bdev,
> +		__blkdev_issue_discard(btp->bt_bdev,
>   				xfs_gbno_to_daddr(xg, busyp->bno),
>   				XFS_FSB_TO_BB(mp, busyp->length),
>   				GFP_KERNEL, &bio);

If blk_alloc_discard_bio() fails to allocate a bio inside
__blkdev_issue_discard(), this may lead to an invalid loop in
list_for_each_entry{}. Instead of using __blkdev_issue_discard(), how
about allocate and submit the discard bios explicitly in
list_for_each_entry{}?

Yongpeng,

> -		if (error && error != -EOPNOTSUPP) {
> -			xfs_info(mp,
> -	 "discard failed for extent [0x%llx,%u], error %d",
> -				 (unsigned long long)busyp->bno,
> -				 busyp->length,
> -				 error);
> -			break;
> -		}
>   	}
>   
>   	if (bio) {
> @@ -148,8 +139,6 @@ xfs_discard_extents(
>   		xfs_discard_endio_work(&extents->endio_work);
>   	}
>   	blk_finish_plug(&plug);
> -
> -	return error;
>   }
>   
>   /*
> @@ -385,9 +374,7 @@ xfs_trim_perag_extents(
>   		 * list  after this function call, as it may have been freed by
>   		 * the time control returns to us.
>   		 */
> -		error = xfs_discard_extents(pag_mount(pag), extents);
> -		if (error)
> -			break;
> +		xfs_discard_extents(pag_mount(pag), extents);
>   
>   		if (xfs_trim_should_stop())
>   			break;
> @@ -496,12 +483,10 @@ xfs_discard_rtdev_extents(
>   
>   		trace_xfs_discard_rtextent(mp, busyp->bno, busyp->length);
>   
> -		error = __blkdev_issue_discard(bdev,
> +		__blkdev_issue_discard(bdev,
>   				xfs_rtb_to_daddr(mp, busyp->bno),
>   				XFS_FSB_TO_BB(mp, busyp->length),
>   				GFP_NOFS, &bio);
> -		if (error)
> -			break;
>   	}
>   	xfs_discard_free_rtdev_extents(tr);
>   
> @@ -741,9 +726,7 @@ xfs_trim_rtgroup_extents(
>   		 * list  after this function call, as it may have been freed by
>   		 * the time control returns to us.
>   		 */
> -		error = xfs_discard_extents(rtg_mount(rtg), tr.extents);
> -		if (error)
> -			break;
> +		xfs_discard_extents(rtg_mount(rtg), tr.extents);
>   
>   		low = tr.restart_rtx;
>   	} while (!xfs_trim_should_stop() && low <= high);
> diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
> index 2b1a85223a56..8c5cc4af6a07 100644
> --- a/fs/xfs/xfs_discard.h
> +++ b/fs/xfs/xfs_discard.h
> @@ -6,7 +6,7 @@ struct fstrim_range;
>   struct xfs_mount;
>   struct xfs_busy_extents;
>   
> -int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
> +void xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
>   int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
>   
>   #endif /* XFS_DISCARD_H */

