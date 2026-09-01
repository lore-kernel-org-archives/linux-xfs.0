Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4034746A9
	for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2026 22:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302889; cv=none; b=Goui4DJKQ58Th62d0DWSHC2PF01cCrhDX3XH4hpBu7TdIjNRXdjxgldzQcFxB3CkCS+zhaSIwBhFNHUCGXQVO67WcNEwpHmq4aUpiNy9Y9djdp8rLxj/fCOLJndRoH9N6oBjY6xKXIfY2pkNhOHUY+YzLvv6sg4LAtIjp2OEJXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302889; c=relaxed/simple;
	bh=Sxys1El2AdbC5BPLtJn7nDep01mPe6M5nNRkznLybko=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=hFS/7mvNZ1mqJzNpuNKSqvw1RUGDt+PCmRtKTcUdQsSzbzfEFHjDidaK4LA58pVEb2ZtFxG3jwjnSq8XOdgKr7O/kz9sUq+ssGZPgJMC2bvpKnbi9PXBWnxC8/lqntwjZc4AJXGsc0+RZ/V1TqcMJHQrXeIVLNFObxa9jBjZYxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UOCVzLsq; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UOCVzLsq"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49b0d78a801so2498395e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2026 15:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788302885; x=1788907685; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YSE7rzaBghN/yxc71rTbjJSYX2omJ+FxWh2N/oRuN/g=;
        b=UOCVzLsquVmqvhGHWrjSWMMdAYFt+loYg1ImyHFdH2yOhj110Abp/0/a5WB0eVRTlr
         s/fSugGWV7hNWy2FTgA5DhxMJNWIywpFGSjCmFBY3/ifwc4nkgqOwVt6UD2ZARCXSpyM
         cHbHW3QTm8XM7693FbD4kVfnGmQ5hgMzuwRoBhC68OhjED4v7yBH+SZY/AHx979beMpH
         nCxyQ6h7oieosLrD21Af8S6lWXrhypi/QziEB1ydrpzY5b+lIaXZMAmdX+3tr5Kh64+e
         C0xuDlxkVPdYSzp5qs1xGuOYOkKPIGDp70sNTp6xxugErv+7C3HnLifCJVZIE+j7ki72
         RVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788302885; x=1788907685;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YSE7rzaBghN/yxc71rTbjJSYX2omJ+FxWh2N/oRuN/g=;
        b=Eg3wSajjp8eninMR17Qd5WGBGw1WFBNFLowWwTVKZYqQm6NoiLPggoraKkcjvMV8r4
         QOt2gSZxR9ZgNUyLgQrIwh+rBPSIR5UVOYqOZDKzcDPYYWdwp0OnxmN59Q87FXWETqRa
         a6VDmiOKxiDbiEd+N26TV+G8BRB2mK5DsHooR+6HAolhQ4kZFTnlDgMsx8Oy1oKBaRgi
         43oNWSYtL7DCAeZ5hGD5W6FP+G7/dxRGOJrAkIEmvp0uC+G4Nl0VfsMx2ksFyna7/Cpp
         6XWyznUDf4eCKzMnj0Wb1Gl4t8hVR3UH2Ni1AxNHsgJYLylrWKlrtlfxQoT8yki5Kq0w
         wFeQ==
X-Forwarded-Encrypted: i=1; AHgh+RppfAQA8AOX0vqMAiahaL6U82kMN5p/dFWYEFnu91DknWBsDwr3BpHMB52IQSyva8qdLLhN1JyAq4g=@vger.kernel.org
X-Gm-Message-State: AFuF++kWMj4UegPPaTL652QQpUNRmblBiSLDgdG9iFEhI9biY41453KW
	5RugETqn6sRirCPbwCCPtdwyUQmtFqRiWa9+fthP/eiGYOt/9K+iXZ6tkcaoPuqLxaQ=
X-Gm-Gg: AR+sD12ZEdiE1QSpmwIk+Ha7uNqsRa34j5/OaYpsXlRWKDwN4Nzta7ziLeBWaZ4/QjH
	I8Dy/z68gxo9vKOF/jCrF8PqvDNC9cUDIXD35zDwupM107E8BrvHBctMOGlwXv4QUK+fATD9/xt
	SfgdixJFuE7XFWj5XEgpomliruG8oieDMhynh3/LBuq/NoBO1UsN68q+qDCNpeBdCr0vkR6KG0W
	4fZdS75rlIf38iRPx6uTyBZtwfiTXDOTdVdWv4g9n7f3/xV4KqUrzoxUxb06kiIvaZJHD315igq
	Ta513tTh/yTYdjmY2byGsMyZrE1ggPKUS6cPS6jG78a81zy0e0Tu0UYKd8XWNtaezg9NGKTZx4r
	835dO9X/kWOczMyChDThntwsS2PBM/b3qeVcoJlShU0elaGJ4XtX3xJI+qCr4cjzWKkPL9ay+//
	q4iGNH/Nwl8aufnPErBwwO6P3o0Umvn6Gje0FEGMTt462+kr7t+Vuc
X-Received: by 2002:a05:600c:34d0:b0:499:49f3:77b1 with SMTP id 5b1f17b1804b1-49ce57ebafdmr13885645e9.3.1788302885003;
        Tue, 01 Sep 2026 15:48:05 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae380d7casm1704676a91.10.2026.09.01.15.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 15:48:03 -0700 (PDT)
Message-ID: <ef11b205-9e5d-410e-be9f-ae4221126ce6@suse.com>
Date: Wed, 2 Sep 2026 08:17:59 +0930
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] iomap: follow the alignment requirement for
 iomap_dio_hole_iter()
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, Christian Brauner <brauner@kernel.org>
References: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
Content-Language: en-US
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <73bd4d9b39e821453028ca8e567eaad2ebe0fc18.1785880740.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Gentle ping?

This patch has multiple reviewed-by tags, but I still didn't see it in 
the upstream rc1 nor vfs.all branch.

Thanks,
Qu

在 2026/8/5 07:29, Qu Wenruo 写道:
> [BUG]
> On the latest development branch, btrfs with 8K block size on 4K page
> sized systems will fail all test cases that run fsstress.
> 
> One very short example would be:
> 
>   # $fsstress -n 4 -d $mnt -s 1785675805 -v
>   0/0: dwrite - no filename
>   0/1: creat f0 x:0 0 0
>   0/1: creat add id=0,parent=-1
>   0/2: write dontcache f0[259 1 0 0 0 0] [816411,3620] 0
>   0/3: dread - xfsctl(XFS_IOC_DIOINFO) f0[259 1 0 0 32 820031] return 25, fallback to stat()
>   0/3: dread f0[259 1 0 0 32 820031] [483328,81920] 0
> 
> Which triggered the following ASSERT():
> 
>   assertion failed: IS_ALIGNED(state->start, blocksize) && IS_ALIGNED(state->end + 1, blocksize), in fs/btrfs/extent-io-tree.c:346 (unaligned extent state, blocksize=8192 start=487424 end=565247 state=0x0)
>   ------------[ cut here ]------------
>   kernel BUG at fs/btrfs/extent-io-tree.c:346!
>   Oops: invalid opcode: 0000 [#1] SMP
>   CPU: 4 UID: 0 PID: 648 Comm: fsstress Tainted: G            E       7.2.0-rc5-custom+ #431 PREEMPT(full)  7c507bd40d65e4d871e698b22d80f1306bbec543
>   Tainted: [E]=UNSIGNED_MODULE
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS unknown 02/02/2022
>   RIP: 0010:validate_extent_state.part.0.isra.0.cold+0x24/0x26 [btrfs]
>   Call Trace:
>    <TASK>
>    insert_state+0x34/0x1a0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    set_extent_bit+0x440/0x8d0 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    btrfs_lock_extent_bits+0x58/0x380 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    btrfs_dio_iomap_begin+0x319/0xb70 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    iomap_iter+0x1a2/0x370
>    __iomap_dio_rw+0x236/0x8d0
>    iomap_dio_rw+0x12/0x30
>    btrfs_direct_read+0x15f/0x290 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    btrfs_file_read_iter+0x42/0x90 [btrfs 6924944583e4bc91a7c5183a1e7908e745a9b0c8]
>    vfs_read+0x25e/0x380
>    ksys_read+0x73/0xe0
>    do_syscall_64+0xe1/0x790
>    entry_SYSCALL_64_after_hwframe+0x4b/0x53
>   RIP: 0033:0x7fc3f129318e
>    </TASK>
> 
> [CAUSE]
> iomap_dio_hole_iter() is responsible for zeroing out the buffer for a
> hole, which calls iov_iter_zero() to zero the range.
> 
> However btrfs disables page fault during its __iomap_dio_rw() call, so
> iov_iter_zero() can fail at any page boundary.
> 
> When the fs block size is larger than page size, iov_iter_zero() may
> only have zeroed one page, which is not aligned to the fs block size.
> 
> Such one page long range is passed back to btrfs, which triggers the
> above ASSERT().
> 
> [FIX]
> For iomap_dio_hole_iter() round down the copied length, and revert
> any excessive range that is beyond the aligned copied length.
> Also use @aligned_copied for the size increment and iter advancement.
> 
> This should only affect btrfs, which is the only fs utilizing iomap dio
> with page fault disabled.
> 
> Fixes: 001397f5ef49 ("iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> v4:
> - Always align down to fs block size
> 
> v3:
> - Fix a NULL pointer dereference where @bdev can be NULL for holes
> 
> v2:
> - Rebased to the latest vfs tree
> 
> - Slightly rewords the reproducer
>    In fact no special reproducer needed, any test case running fsstress
>    can easily trigger it.
> 
>    The example provided is just the shortest sequence I used to debug the
>    crash.
> ---
>   fs/iomap/direct-io.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index b3368d64e81b..01f26fb3b3b2 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -594,12 +594,19 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>   
>   static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>   {
> -	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
> +	loff_t copied = iov_iter_zero(iomap_length(iter), dio->submit.iter);
> +	unsigned int bs = i_blocksize(iter->inode);
> +	loff_t aligned_copied = round_down(copied, bs);
>   
> -	dio->size += length;
> -	if (!length)
> +	/*
> +	 * If fs block size is larger than page size, page fault failure
> +	 * can cause @copied to be page aligned but not fs block aligned.
> +	 */
> +	iov_iter_revert(dio->submit.iter, copied - aligned_copied);
> +	dio->size += aligned_copied;
> +	if (!aligned_copied)
>   		return -EFAULT;
> -	return iomap_iter_advance(iter, length);
> +	return iomap_iter_advance(iter, aligned_copied);
>   }
>   
>   static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)

