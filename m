Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E411A0AF7
	for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 14:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731941404; cv=none; b=vAXWU63WC/BeT/oLOwfwqlM9k7hfgBMuoWzmuCYup1xeUPC3Bldz/zB8soV+qzSnJSd4gm2VL2OkCVyhPuUns+HTYAEEz/2Qb6LMoBgJ4358GGJdMd/1TKbqKv3asdivT8z/Fc30k1bYnzSlcksMd6JXzv3NSoysrrPICADvPj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731941404; c=relaxed/simple;
	bh=jabCupIh1FJFAKWSdaG7M5rrT0Y7L0LAPYbB0FE65Q0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GclXt8QFCYGdtR5njBuD4Zf3K3D1WH7ouKvDFg7L88fiuGV3jFd0TB20rdUocTw7XWidyzZegF27qpY75tyBOG2Bs45o9IFEwIEicy4f7B5r1UTvYAxPxWnELkB2SuOttuKGcd914TFjGLGSJmlYh3ixcLW9Ph0AwXgWXPmRCFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=k0Is1buZ; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="k0Is1buZ"
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2968322f5feso380289fac.0
        for <linux-xfs@vger.kernel.org>; Mon, 18 Nov 2024 06:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731941400; x=1732546200; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=64rV6XVBsSRZD9lz1azW3sqQ1KWaD6KRPC47/eG5qsA=;
        b=k0Is1buZhEVRX8aA2YpNv8xH51kd3XdbQCdU6sjFm6apcmft7wlkZzhH7Mb9GK/+2G
         1ych5iZYYRNoEgNf/GkM0axLJb9fKsMg61umrjWEmu90EW9mrMb1789SRAbRJEhfjo6y
         Xmccgf3Vb9OQ5OYpKxWee2AxCS87/bX4pAKbglFrVIXGqo2Tj9/DNJukkN8cSrx9Vw6d
         GL5P2MEa+d1yuxxcKeDri93rmq7rjaGcTCBL87Ks5NGABsRSD9DPWYcfdy6Uhy0xWtZ5
         +SU85X3/ub2mgUOCY6QgZVRoxVXkkmtf+jTTNLtdabubJEcV5dBnSLlNhBBJk/jCdviS
         RnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731941400; x=1732546200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64rV6XVBsSRZD9lz1azW3sqQ1KWaD6KRPC47/eG5qsA=;
        b=OOA6sFOhRhO7DokHXoTVexSjkrmZXWdjgdBSovnFUnZWX/BWZh0tarqrxRFbkxYiVo
         ruqtmeh8oz/Fu7TUxRhOoTzbhe5t9j2J+0+vxw2E8KTwgb+cRaSC/HMM/v60DxI4BhnG
         V+wDOlRPjAooNXFqbI853X5atWXk5qwBxzs08OsnaQkfVNQ9U4NVwRFlB4fyk+1Kec5z
         84TJHP+lpQWc5X0Zkl4DmwjelmgfSi6O4MWnb/kNwoj+zxLOb8UD3bRQ3H4JZR/UJADh
         YeqTiM1mLDkQ9GkO/5XvQByrf2vRqXIAUENayxg4qTDp3ta11lTtzZmD4RcUHIkTUkgX
         Wbyg==
X-Forwarded-Encrypted: i=1; AJvYcCUQlwedAviYkU4JsGUynIwGSl+BPiIGzhoJCF6REGifIzwLLMGcfB2hg6k8nRtoAVmN4FawFDkgXqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8oOJ9hxchp/ZmjwnKGrMUcvaO3SHS8kCJKaujETiwONIibk31
	QhcoQ/1Li/KEu6iCUJ0wwqPV9BB1vCRVPCLjjQKMA7jAp4tkpv2imwkBrLljRRY=
X-Google-Smtp-Source: AGHT+IF4SYJY9kdWkwrKjlAiH5Z+Bn8SZkqEPmKpcyMndgMPRn4H9T8dbqU6Hyt3/gFfCCmMTdbpdA==
X-Received: by 2002:a05:6870:ab0b:b0:287:1b05:297d with SMTP id 586e51a60fabf-2962e01ad0dmr10557378fac.33.1731941400385;
        Mon, 18 Nov 2024 06:50:00 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29651852c27sm2626597fac.2.2024.11.18.06.49.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 06:49:59 -0800 (PST)
Message-ID: <c54063db-5f82-46d6-ba7b-5e4a0073ebf9@kernel.dk>
Date: Mon, 18 Nov 2024 07:49:58 -0700
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/17] mm/filemap: make buffered writes work with
 RWF_UNCACHED
To: Baokun Li <libaokun1@huawei.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
 clm@meta.com, linux-kernel@vger.kernel.org, willy@infradead.org,
 kirill@shutemov.name, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, bfoster@redhat.com,
 Yang Erkun <yangerkun@huawei.com>
References: <20241114152743.2381672-2-axboe@kernel.dk>
 <20241114152743.2381672-12-axboe@kernel.dk>
 <01fadf73-6b0f-44ff-9325-515fae37d968@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <01fadf73-6b0f-44ff-9325-515fae37d968@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 1:42 AM, Baokun Li wrote:
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 45510d0b8de0..122ae821989f 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -2877,6 +2877,11 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
>>                   (iocb->ki_flags & IOCB_SYNC) ? 0 : 1);
>>           if (ret)
>>               return ret;
>> +    } else if (iocb->ki_flags & IOCB_UNCACHED) {
>> +        struct address_space *mapping = iocb->ki_filp->f_mapping;
>> +
>> +        filemap_fdatawrite_range_kick(mapping, iocb->ki_pos,
>> +                          iocb->ki_pos + count);
>>       }
>>   
> 
> Hi Jens,
> 
> The filemap_fdatawrite_range_kick() helper function is not added until
> the next patch, so you should swap the order of patch 10 and patch 11.

Ah thanks, not sure how I missed that. I'll swap them for the next
posting, and also do a basic bisection test just to ensure I did't do
more of those...

-- 
Jens Axboe
