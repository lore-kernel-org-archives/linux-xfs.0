Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CA5EB64DC
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Jul 2023 16:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjGUQaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjGUQa2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2023 12:30:28 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E10A4206
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:28:30 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3461b58c61dso2680185ab.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2023 09:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956838; x=1690561638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ahIwLnlD7cr1aBwhJXa2haUworAGpZ2mINQou78VDu0=;
        b=kBchZozexoXJ18KlGDkAVrvIjopBR6UbqhqhmZBCWTlfv+s9mxQSa6rsA1ygC+JnqP
         gFllWoUzcqOZOkrVu4APmgIXh29nyu2VfvHnXYEpy1qH9SfMZVF+rlEkBQQ81MBV9yug
         Tw7B7uBn1+7rK/kyMGpJq11vEQPoC/QxbiK47MoLWrzt1MhP2tEV1bsosv7minWeuZ/h
         xLqMVp+VXPQSX5Tws9SSN0x4ZlJSNRjFk8eedx001nQKDh5e+V3CFO8NdWzum77xcYvk
         mWBQbMAvT3izkyGhmF6Yn62dSpQuCrmGQfOm1dPkY8Pr8JnpTkD1RFNQFLwmWW1b+avm
         jyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956838; x=1690561638;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ahIwLnlD7cr1aBwhJXa2haUworAGpZ2mINQou78VDu0=;
        b=Ia9IKaBGtIlLBHrM/Yu+FVodXleP34ZEkY1szzbZiws7yt//CO7iW8ddRw3lhFpMZ4
         83TmieWRkTOR+EFNxjN5VS3Ta9X22jQWRS3m2wiFIMPBGfXqNf+qUspID9nXwptJwZMi
         EfmIg7b0qvnuJfaQQ1dBA1IQ9ELVg6xNiuXvCQR8wF20HuBIvZgsrmt/yTccbHTHoRV3
         /Nmxx7UObJmGrWCVZXY9z/nSxZh7zpj+nZRJSm3tGkO1V7idYy/x3paSTS9QoGtoztxy
         xavf2WnS0HuSRjLjaaKjI8GCmv+BBctjpFc6DDNWn/APwvxo09k4Yqb9uTriflQcK71L
         4L4Q==
X-Gm-Message-State: ABy/qLZhOnG/VOX1ZNKs7+no3HKrSWKHNSYQMHRdNyYWIFNWiFS/Dbq9
        UMiA+LeyIDS7ijVxlIYad4k/1Q==
X-Google-Smtp-Source: APBJJlHyDmJ6heC6rQgvSlxNOq/BYAOkCm+9EuNUvAih72hZqnStNzY3DW2e7C3MZSglmBhNYdWLXg==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2393302iob.1.1689956838086;
        Fri, 21 Jul 2023 09:27:18 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a20-20020a029f94000000b0042b34d4d07fsm1098840jam.156.2023.07.21.09.27.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:27:17 -0700 (PDT)
Message-ID: <4fcc44be-f2da-9a7c-03ca-f7e38ac147cb@kernel.dk>
Date:   Fri, 21 Jul 2023 10:27:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230721161650.319414-1-axboe@kernel.dk>
 <20230721161650.319414-4-axboe@kernel.dk>
 <20230721162553.GS11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721162553.GS11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/21/23 10:25?AM, Darrick J. Wong wrote:
>> @@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  
>>  		       /*
>>  			* For datasync only writes, we optimistically try
>> -			* using FUA for this IO.  Any non-FUA write that
>> -			* occurs will clear this flag, hence we know before
>> -			* completion whether a cache flush is necessary.
>> +			* using WRITE_THROUGH for this IO. Stable writes are
> 
> "...using WRITE_THROUGH for this IO.  This flag requires either FUA
> writes through the device's write cache, or a normal write..."
> 
>> @@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
>>  		iomap_dio_set_error(dio, ret);
>>  
>>  	/*
>> -	 * If all the writes we issued were FUA, we don't need to flush the
>> +	 * If all the writes we issued were stable, we don't need to flush the
> 
> "If all the writes we issued were already written through to the media,
> we don't need to flush..."
> 
> With those fixes,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

If you're queueing up this series, could you just make those two edits
while applying? I don't want to spam resend with just a comment change,
at least if I can avoid it...

-- 
Jens Axboe

