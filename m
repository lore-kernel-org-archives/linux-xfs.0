Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9865D2ECD3A
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 20:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762288967; cv=none; b=tft8jV8/IswJFhc9ihJLt0Sy2SL89BmE1XOlFNGcYY1ZW+1TvnPIMCLPFkcElQgko9n07cXcHG698pdY2K+JucKFtbgw2yj1Bu25cIs07Rdc/6SYv6hUZqi4VSoCJHgvejvXwT/rhWlb39CfDiCHpIGmXx/D3mf24tV54/caS/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762288967; c=relaxed/simple;
	bh=JGsJhmJeF5q8J7Ype2nL15gIcp7qqgcNpRYXX2zKA1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hpn/jMg5uyUPdUzYPOIszUK8eZzBc4s2K291XEF6kdic1IsKo4mJE1QFh17osuggix6Ex4G9ZXOxMHJWhAD3l8mUxP/Kah6zN/GOQmVVLWLWaSGtYUQqmC9s5AD8LgAeXeC77AR96ZncTcaxRWHZB1PrEVUQa7hFWXSdvBNOGjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NF4B26cu; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NF4B26cu"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429c2f6a580so869884f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 12:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762288964; x=1762893764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3/I2a0uZTAnglwIVDCoK1EV+nWMPjHOXPCZYdwAgCYY=;
        b=NF4B26cuPHjv3gz17Rsd4oUx/nd3H2cVMGfdAtWNrXbFRIn90kvaIWFt3FX9h1quZJ
         kLLp5i6VaIXIirF0hn9FPubdMMfmwIMNzylZN3OiRuxw32b2UMKihBm8DYldouUrhFym
         2tqjhuNCieP75phG/5Dlp3EO/UP3JX5c/ckIbEo/zfl/KaTbCzNlVwJ8zwHt+CIsG2xM
         BbHYPVW3s4uJC6BrZ1ZN58sX2ZOp21+aJX+ytIjJG5vkbyhnIn9xz/tD7NXW599Y3jpK
         v8PhPVLh8vmgGdnZqIE6CobxZEn+jhXyhzFecnCon9lim+OttiR3GX6GdmzS77ICPWGM
         RCNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762288964; x=1762893764;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3/I2a0uZTAnglwIVDCoK1EV+nWMPjHOXPCZYdwAgCYY=;
        b=Hi/PnqSAwnbYMKPYdmhPgoc37QquoRCA63JfY9TXQ4JPzd7rDqay5MEiRj+NwUgn+Y
         6M0KShA//B0h4FKlMQwP49AeSNEnEfRqHT5gXBMS0R6vCiRm3Brw6G0bgTbYSlqIL423
         Y/i7Viq3pysQYpJ2kG7luEcKIcpQoI6UktRivLoxOe2zHPqR2hI7jgIRob9qd4DVE9Pc
         PU8qu/xBUdyED9Myr0GYKoyTITpCJ54+qY84tjBRVPz1qOqpxoHoG69WgqVRC0FbD0NE
         kUMSewTdh+IM5gbj6kb50jMmTndT41Z/qMgfpIGzNGOuCPIRj5DbwJj/e6bOtBpQlNMg
         NB0A==
X-Forwarded-Encrypted: i=1; AJvYcCUOaIuwuT0uX9C1xD9CqcWm+kOo4QgfB0u5g2esiwiQH1lUxEXvl8NV7J5ZiVxZjHVKIW9rRnttylw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWr+sg7PhrC6lNcZ5EHlpyDvy5T5XJYKhdhMeuuLtJI97rWgyT
	JNzZXePRBut3zw0SUYEcWAYpFUICpWb5LuX+eY1tzLMcXiEiOUe8ldQhSrZxDURiGtU=
X-Gm-Gg: ASbGnctSpTUK1v49kHqwvN7rERH+ix175uOstH3EUh5U1cNsxWfZVMkx0fmF/WNBnsF
	xQRVflgtE7qSx6cZAsxcRcN+7uKq+peuShM0H3YIKjVRovLUwXRgoROw+Xpprji5pN6bXVxErCF
	yDzuPywyfJvla+8aAXSg27cH9/UPlKWCuNrOMpDAz4UUkaJ/lRyzNo1zJNSDjGrXGxcfgHVQkMA
	GSXMhfAjL3SGNNRdS5nCGgwLwoc7cY4IttGZzEzw/SNGhouhva5kcI0Pewofq8+a4FqqwovfO5s
	gSvCR/wLNPVaLsTG5WUr55f2lCcl8Il2rF1je9J4HUvajOzu470wuNaf/gPtwzHlHeEtD94tiq+
	kDsllZl1eDJ6qjFMEWBmAoi7ZZPVy31HNa9/qFQU94u3uUZClLGVpP3j4ZGykJrT1OCmPaM5aHs
	FJpCeNjNeIOtyNZdxTzhAF0MNmrOSF
X-Google-Smtp-Source: AGHT+IG8Z203PhFCyhJhz48A8l8UhXjLU1AaikFIf0iJkmfVY5x+Gi/GZMr6bL+04r89yb9RlNQzVA==
X-Received: by 2002:a05:6000:26d3:b0:429:c851:69bc with SMTP id ffacd0b85a97d-429e32dd761mr472461f8f.8.1762288963767;
        Tue, 04 Nov 2025 12:42:43 -0800 (PST)
Received: from ?IPV6:2403:580d:fda1::e9d? (2403-580d-fda1--e9d.ip6.aussiebb.net. [2403:580d:fda1::e9d])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd3246e7bsm3976191b3a.8.2025.11.04.12.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Nov 2025 12:42:43 -0800 (PST)
Message-ID: <247c8075-60d3-4090-a76d-8d59d9e859ca@suse.com>
Date: Wed, 5 Nov 2025 07:12:38 +1030
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/8] btrfs: use super write guard in
 btrfs_reclaim_bgs_work()
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org>
 <20251104-work-guards-v1-2-5108ac78a171@kernel.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
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
In-Reply-To: <20251104-work-guards-v1-2-5108ac78a171@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/11/4 22:42, Christian Brauner 写道:
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>   fs/btrfs/block-group.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index 5322ef2ae015..8284b9435758 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -1850,7 +1850,7 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
>   	if (!btrfs_should_reclaim(fs_info))
>   		return;
>   
> -	sb_start_write(fs_info->sb);
> +	guard(super_write)(fs_info->sb);
>   
>   	if (!btrfs_exclop_start(fs_info, BTRFS_EXCLOP_BALANCE)) {
>   		sb_end_write(fs_info->sb);

This one is still left using the old scheme, and there is another one in 
the mutex_trylock() branch.

I'm wondering how safe is the new scope based auto freeing.

Like when the freeing function is called? Will it break the existing 
freeing/locking sequence in other locations?

For this call site, sb_end_write() is always called last so it's fine.

Thanks,
Qu

> @@ -2030,7 +2030,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
>   	list_splice_tail(&retry_list, &fs_info->reclaim_bgs);
>   	spin_unlock(&fs_info->unused_bgs_lock);
>   	btrfs_exclop_finish(fs_info);
> -	sb_end_write(fs_info->sb);
>   }
>   
>   void btrfs_reclaim_bgs(struct btrfs_fs_info *fs_info)
> 

