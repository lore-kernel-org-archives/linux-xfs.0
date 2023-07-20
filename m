Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3F9EB64DC
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 16:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjGTQ1U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjGTQ1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 12:27:15 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306F9123
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 09:27:14 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-785d3a53ed6so12536739f.1
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 09:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689870433; x=1690475233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNGQJK9GMxVIPezFWA0EfraPWR73FqaxU9vK05mP9fI=;
        b=caatJ6oNgwkpJATjzPpLBkPDFJ/2ZLKbMj+0F3E4Wv8xfZHz8JeWoaJsKvEbfbQioz
         i6lO9eVoq5ubHm0S+7/KjvRe87wvEtPUIopmjV/cNnykcl06mj+GHNEYLsjMqX6wgFM5
         14WYrNSNRX1+0Tf8CfUQw0WV7jDNNwxK7TZRZqv5YLs4KCBAQxc/6n3KCP4FBLtgVcCR
         NLzKUatIwuyN9mr0bg2lozzuPhwC4cYxPBFg8OycOcbshRuFs+duomZ6PHrbLKQE2Epp
         y4Z4+Clyu1+z5o6Eejdm1VnIREwzBzERocim9NYTuuzrVzrp/WdRsT16n5Y3SfjdU+h2
         +FLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689870433; x=1690475233;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNGQJK9GMxVIPezFWA0EfraPWR73FqaxU9vK05mP9fI=;
        b=UY8Tj4nJA4/dALoLWx9Jjr6RYZy2fBcICRVzBnpR5f/f+ojpsoqXVuvic47rYhFiIS
         iqR8+bknx/Cx2RkHmui5f55P8+DMCkEKW670iCs9Sg4QSjtrvrxm2bKvU2hpV66eRzsR
         1+4M5P2Skl1fjOPBficOyTwRRX7GFp/lxPcOxA+cvd7zFMIV4qBGW7qVGUBUxY5yWFK6
         eveHpB0hx9TUMoy4fNOXdsOKAYhoFHsB/cbzOhGaWDQkY4k3orjr7yrlib+lTR+OKa1U
         DvpTQmiuRHXw7QyfiImqe9USB3KPQSnJxYUyUGV30F3Zf4MiILOHx/ZfTNvakna7KVZ0
         0l8Q==
X-Gm-Message-State: ABy/qLb4b/Qbh2dUiktNN8+TNu3ojhxzPFtyopwMBAFa+kwQIpVyVEaV
        KuUk7hQHdAJsR5B+r3ZOQlLUKA==
X-Google-Smtp-Source: APBJJlGMrXJWL9ueuRWhdL5wz2y4wmJXFyjKdyLhiMFt39KtDC4ukPkUeRty+Qxv7SfCBi2iK58T6Q==
X-Received: by 2002:a05:6602:3423:b0:780:d65c:d78f with SMTP id n35-20020a056602342300b00780d65cd78fmr4357645ioz.2.1689870433460;
        Thu, 20 Jul 2023 09:27:13 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l4-20020a02cce4000000b0042b0ce92dddsm399918jaq.161.2023.07.20.09.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jul 2023 09:27:12 -0700 (PDT)
Message-ID: <5a329b36-ea97-e05d-fbf9-9225aabe1b8b@kernel.dk>
Date:   Thu, 20 Jul 2023 10:27:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6/6] iomap: support IOCB_DIO_DEFER
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org,
        andres@anarazel.de, david@fromorbit.com
References: <20230719195417.1704513-1-axboe@kernel.dk>
 <20230719195417.1704513-7-axboe@kernel.dk> <20230720045919.GD1811@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230720045919.GD1811@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/19/23 10:59?PM, Christoph Hellwig wrote:
>> +	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
>> +		/* only polled IO cares about private cleared */
>> +		iocb->private = dio;
> 
> FYI, I find this comment a bit weird as it comments on what we're
> not doing in a path where it is irreleant.  I'd rather only clear
> the private data in the path where polling is applicable and have
> a comment there why it is cleared.  That probably belongs into the
> first patch restructuring the function.

OK, that makes sense.

>> @@ -277,12 +308,15 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		 * data IO that doesn't require any metadata updates (including
>>  		 * after IO completion such as unwritten extent conversion) and
>>  		 * the underlying device supports FUA. This allows us to avoid
>> -		 * cache flushes on IO completion.
>> +		 * cache flushes on IO completion. If we can't use FUA and
>> +		 * need to sync, disable in-task completions.
> 
> ... because iomap_dio_complete will have to call generic_write_sync to
> do a blocking ->fsync call.

Will add to that comment.

>> @@ -308,6 +342,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>  		pad = pos & (fs_block_size - 1);
>>  		if (pad)
>>  			iomap_dio_zero(iter, dio, pos - pad, pad);
>> +
>> +		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
> 
> Why does zeroing disable the deferred completions?  I can't really
> think of why, which is probably a strong indicator why this needs a
> comment.

If zerooout is set, then it's a new or unwritten extent and we need
further processing at write time which may trigger more IO. I'll add a
comment.

-- 
Jens Axboe

