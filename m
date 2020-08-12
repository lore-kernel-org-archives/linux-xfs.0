Return-Path: <SRS0=vsMz=BW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 391E4C433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 127F520838
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="LDT4Fz/V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLP0z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgHLP0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Aug 2020 11:26:55 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184A4C061383
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:26:55 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 189so581580pgg.13
        for <linux-xfs@vger.kernel.org>; Wed, 12 Aug 2020 08:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L0boi8VPHTa9Om+AiteGzW6HeLsraIwcmq59nnQKmyg=;
        b=LDT4Fz/V8jqh+g71Hupbls3hi6r6Ic4VF6g6nancKWgYx2BAEDX2Z+8P6PS61EUHc9
         neOuNguw22XgeAcT7OXoallmxnOs+n8K9MmHjW8qDQD7WACAM/GYagcrebnonfd4DbPA
         cE46aFoJJrStxJWAP0Ptdyg9ojOsTE3xNKP7N35tHiSLYYVEmhwWZB1bPICmwL0yInWK
         ZdXg+IYjtuz5ZebHQ8X3YWY3/IqvAzeKTMIcP5Jhzur80OB9w6QcF843EcvvpG0Kopti
         3lzA8bW85PwSjcSXKY7DZDgwZVyShQUux0lp8kQOxL2JX8XeeDXnHPqcMbdw3dzvlX/B
         nqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L0boi8VPHTa9Om+AiteGzW6HeLsraIwcmq59nnQKmyg=;
        b=OjGnz0UMAF+UbwSKM9omylwEU1b93UwJaOT70fT65D5zGJwI+y5Uox7n57hMrJuaDr
         elWakxp3rWAMUc8GELD/RliVW7a6UqK819Hp/HQdvtfcg3wB8QWS/3yi8r4dkeBz9ZNg
         DYs4adX7jOTeJh/e7mE+hQAO9MWoO0CART/PAOz2Opr69sonoKD2UyDHzLngq9pAzxCu
         tCDQhD1uyivT7RA/k0lxNdHMbruhHDpKDMAZa6p111Dw50rUuPjJB0GIEGdnUqmexAp1
         CDyUYGJVYOjFTYqLxQ9bIgmFQq6OPjlxPd5vqj4wOsDLtR58TwtV/Do7flCYrh2qkq+m
         Sd3A==
X-Gm-Message-State: AOAM533E6y5EikR84Nn566x/LaUlpIj1DHR7J2O176Jg9p96tmBpzb9U
        6Qc038JSNwy9eOye270u6m5f4aThJIw=
X-Google-Smtp-Source: ABdhPJy+2adAhEUggphymTz6vZCXqbqI7AwUThbBrU0eGYizq+dpi73rokBiGbqeZ3l7c/SSmRu0GQ==
X-Received: by 2002:a63:464a:: with SMTP id v10mr5587981pgk.275.1597246013608;
        Wed, 12 Aug 2020 08:26:53 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u62sm2947469pfb.4.2020.08.12.08.26.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 08:26:53 -0700 (PDT)
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        bugzilla-daemon@bugzilla.kernel.org, linux-xfs@vger.kernel.org
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
 <20200810070807.GJ2114@dread.disaster.area>
 <20200810090859.GK2114@dread.disaster.area>
 <eeb0524b-3aa7-0f5f-22a6-f7faf2532355@kernel.dk>
 <1e2d99ff-a893-9100-2684-f0f2c2d1b787@kernel.dk>
 <cd94fcfb-6a8f-b0f4-565e-74733d71d7c3@kernel.dk>
 <x49zh70zyt6.fsf@segfault.boston.devel.redhat.com>
 <20200811220929.GQ2114@dread.disaster.area>
 <a36fb6bd-ed0b-6eda-83be-83c0e7b377ce@kernel.dk>
 <x49v9hnzy3s.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a40efc10-bfe6-f600-1bda-8d6440bc6fd4@kernel.dk>
Date:   Wed, 12 Aug 2020 09:26:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x49v9hnzy3s.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/20 9:24 AM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Yes, it would ideally wait, or at least trigger on the last one. I'll
>> see if I can improve that. For any of my testing, the amount of
>> triggered short reads is minimal. For the verify case that we just
>> ran, we're talking 8-12 ios out of 820 thousand, or 0.001% of them.
>> So nothing that makes a performance difference in practical terms,
>> though it would be nice to not hand back short reads if we can avoid
>> it. Not for performance reasons, but for usage reasons.
> 
> I think you could make the case that handing back a short read is a
> bug (unless RWF_NOWAIT was specified, of course).  At the very least,
> it violates the principle of least surprise, and the fact that it
> happens infrequently actually makes it a worse problem when it comes
> to debugging.

It's definitely on my list to ensure that we handle the somewhat
expected case by just retrying it internally, because I do agree that it
can be surprising. FWIW, this isn't a change with 5.9-rc, io_uring has
always potentially short buffered reads when when the io-wq offload was
done.

While it may happen infrequently with this specific test case, others
can trigger it more often.

-- 
Jens Axboe

