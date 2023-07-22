Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF87C0015E
	for <linux-xfs@archiver.kernel.org>; Sat, 22 Jul 2023 03:12:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjGVDMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 23:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjGVDMa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 23:12:30 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76C23C23
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 20:12:23 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-682a5465e9eso555834b3a.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 20:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689995543; x=1690600343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NzKEmEok/2OOoDnIdQpEGF2p/Zz2ZgimlZ8kceob/xU=;
        b=uWYce6spsjNiA/OnQSZSjItQNbYMIGbpivmKkS1XY0pM4miLOHwl+55Y9X4E2rH6Hd
         B2Ly5ZheDJ0cZrg/1cmeaZg3jM/Kacscq3bHsoAKrSHCMkfVlDt6a3L+93uW/HodlWl7
         XnvH9+IuQI/1vdNg9MVNbdydbIRwAaGD6j9NdquDYcBJF9+oi6KIkdI0U3+t66zGlqCz
         WC61py8FgYBeu5TPqCZR/cBwbTC4tIY46E2jF9mpTcMJcqMmPwDzHNmnHD5EjR58a//i
         Ylyzd9i4nlawIxr82/WRbKf2U9uu21iVAcduHTRNsQANIvOp7pK2B8Y0CycGBM43e925
         soRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689995543; x=1690600343;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NzKEmEok/2OOoDnIdQpEGF2p/Zz2ZgimlZ8kceob/xU=;
        b=DG6v5wUsB5R/393KyN7IwqV8AV112V8dA1ROpOB1a+FtbmVe2O2UlUcblEmXIWkHf4
         uL2bHzbfCYT8TaJ814ITN1LUquPUc6BGrE7WMct1zayeCD68Dk/MmHYrHR9vT+nEHHsy
         i6w3sSQwcEQLjaJeCXPBYokB4hJ77fMjFlxUs1LxqzGcGs6/+2zzMItIO30JZ9AyIVX8
         MhGKNOMcjnmyOmPs7AJumMG1flIRXQiSUwxunYpcDuRO+VAFqBnxtNzFNOVlAfWj/30I
         ghwAhnb/SuQbkTHM2rFPcl7v1ysl8BtSWDKFf+Zg5RHk0FtQOq50DlHiukKqEzHSVwJE
         l/og==
X-Gm-Message-State: ABy/qLZVfiIRZ9ueUGzWcNaxgM5Kmq29v6liQVrCKE4amff6B2yq3/bX
        FeIcuPO0w48o7oxqNToWV8KeIg==
X-Google-Smtp-Source: APBJJlFS1kn5i/V20mT7wOr3cOMypDofWKs8CMi4KIjW+no6YjaGN1tIoOlZhETOOuZj55KRfPZ0wQ==
X-Received: by 2002:a05:6a20:8e19:b0:137:30db:bc1e with SMTP id y25-20020a056a208e1900b0013730dbbc1emr4203854pzj.3.1689995543249;
        Fri, 21 Jul 2023 20:12:23 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e23-20020a633717000000b0056368adf5e2sm3812299pga.87.2023.07.21.20.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 20:12:22 -0700 (PDT)
Message-ID: <a7b8a966-b679-b4bf-460f-294b1c6b9624@kernel.dk>
Date:   Fri, 21 Jul 2023 21:12:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 8/8] iomap: support IOCB_DIO_DEFER
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-9-axboe@kernel.dk>
 <ZLsBMGe/X62e92Tz@dread.disaster.area>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZLsBMGe/X62e92Tz@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 4:05?PM, Dave Chinner wrote:
> On Thu, Jul 20, 2023 at 12:13:10PM -0600, Jens Axboe wrote:
>> If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
>> and data for that callback. Rather than punt the completion to a
>> workqueue, we pass back the handler and data to the issuer and will get a
>> callback from a safe task context.
> ....
>> @@ -288,12 +319,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		 * after IO completion such as unwritten extent conversion) and
>>  		 * the underlying device either supports FUA or doesn't have
>>  		 * a volatile write cache. This allows us to avoid cache flushes
>> -		 * on IO completion.
>> +		 * on IO completion. If we can't use stable writes and need to
>> +		 * sync, disable in-task completions as dio completion will
>> +		 * need to call generic_write_sync() which will do a blocking
>> +		 * fsync / cache flush call.
>>  		 */
>>  		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
>>  		    (dio->flags & IOMAP_DIO_STABLE_WRITE) &&
>>  		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
>>  			use_fua = true;
>> +		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
>> +			dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>>  	}
>>  
>>  	/*
>> @@ -319,6 +355,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		pad = pos & (fs_block_size - 1);
>>  		if (pad)
>>  			iomap_dio_zero(iter, dio, pos - pad, pad);
>> +
>> +		/*
>> +		 * If need_zeroout is set, then this is a new or unwritten
>> +		 * extent. These need extra handling at completion time, so
>> +		 * disable in-task deferred completion for those.
>> +		 */
>> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
>>  	}
> 
> I don't think these are quite right. They miss the file extension
> case that I pointed out in an earlier patch (i.e. where IOCB_HIPRI
> gets cleared).
> 
> Fundamentally, I don't like have three different sets of logic which
> all end up being set/cleared for the same situation - polled bios
> and defered completion should only be used in situations where
> inline iomap completion can be run.
> 
> IOWs, I think the iomap_dio_bio_iter() code needs to first decide
> whether IOMAP_DIO_INLINE_COMP can be set, and if it cannot be set,
> we then clear both IOCB_HIPRI and IOMAP_DIO_DEFER_COMP, because
> neither should be used for an IO that can not do inline completion.
> 
> i.e. this all comes down to something like this:
> 
> -	/*
> -	 * We can only poll for single bio I/Os.
> -	 */
> -	if (need_zeroout ||
> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> -		dio->iocb->ki_flags &= ~IOCB_HIPRI;
> +	/*
> +	 * We can only do inline completion for pure overwrites that
> +	 * don't require additional IO at completion. This rules out
> +	 * writes that need zeroing or extent conversion, extend
> +	 * the file size, or issue journal IO or cache flushes
> +	 * during completion processing.
> +	 */
> +	if (need_zeroout ||
> +	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
> +		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
> +
> +	/*
> +	 * We can only used polled for single bio IOs or defer
> +	 * completion for IOs that will run inline completion.
> +	 */
> +	if (!(dio->flags & IOMAP_DIO_INLINE_COMP) {
> +		dio->iocb->ki_flags &= ~IOCB_HIPRI;
> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
> +	}
> 
> This puts the iomap inline completion decision logic all in one
> place in the submission code and clearly keys the fast path IO
> completion cases to the inline completion paths.

I do like the suggestion of figuring out the inline part, and then
clearing HIPRI if the iocb was marked for polling and we don't have the
inline flag set. That makes it easier to follow rather than juggling two
sets of logic.

I'll make that change.

-- 
Jens Axboe

