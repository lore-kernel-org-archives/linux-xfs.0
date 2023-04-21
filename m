Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0489C77B76
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Apr 2023 22:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbjDUWhH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 21 Apr 2023 18:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbjDUWhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Apr 2023 18:37:06 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAD63C0D
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:36:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-24b276ee13bso493059a91.1
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2023 15:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682116578; x=1684708578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=15RShbsbHafAtkHP7bE1KcywW8eNaWBCC5WwysBd87o=;
        b=X268rOQmAauSwpFpkoX8A+VMI3nbTHDxHe03vObHL12UvaNQ9OZDDghjH9vFasft+g
         PYxDZ2ddlEnrBvSZCCswbGQjuj0a4dR+kh2mJ0z22UZa2NwQu3fbel/NVm1GcQyaY2D+
         O50k+TmBf4HHRjAIC8Ls3kC3p1dwuD7vfBIye6nZ4HPWbaqWdHXW444BirS8nDiLAtUU
         iCsGJUjimDoRzGfcImcCPFqeDTmyul4Bzysh1Fcv0SrV/e/frNSAMaHCrzc2xVjC/QHk
         wid15bGQMFWU0GREAmCPjVoJuZjI3Ed7vrEJlHnKEii0hoXezMgBGw0KFsqu2RUatHhR
         JkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682116578; x=1684708578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15RShbsbHafAtkHP7bE1KcywW8eNaWBCC5WwysBd87o=;
        b=J1ciUKnpUmxULkwgQT5qx63U6P5ZmE0oM42NPaJGWRC+bOgCQ+lP8y6/lc4ZasVnfx
         o5AjDIwq25ZJDIcU22bLl9SQ4apOvmWI8YZFW7aUNcxNfgEVxzvKP9fcfLLZcpbCuken
         ph0k5NR7dARIP45Jd5si5icHy6ipNvaPajEF4RI2wuICXRDCw/vmCrNG1XPq8hvIm4tO
         LPXRoxMNOETxXTtHZjD3V2TfviDF80ICH4oe93ri3SQ8apSOnotX8WzGtDCujKIDlDT4
         R8htVFxIDvdPPY/VeK/E2oqpgbYBBRw+znXt0sMW48RReRqq1g1r8iYhtqAYHsH5dZjJ
         7lSg==
X-Gm-Message-State: AAQBX9emLtaETR1u5ZRKwq58m3ifzhjFvNXepJX/Dj2ZqU2Pcc+B2Jk3
        Hv+m4oCfhoTZ0sTeg5uFbv/h5w==
X-Google-Smtp-Source: AKy350Y1d3Fo78/V0SBbMlTnA/KEzF4Q+15jV06Q1VNcWOt1KOIozBpCp75pUHwmvH01uVtRJ4USXg==
X-Received: by 2002:a17:90a:195d:b0:247:446f:7d05 with SMTP id 29-20020a17090a195d00b00247446f7d05mr6076988pjh.0.1682116578148;
        Fri, 21 Apr 2023 15:36:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id il7-20020a17090b164700b00247150f2091sm5021149pjb.8.2023.04.21.15.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:36:17 -0700 (PDT)
Message-ID: <e032f210-f8cc-6441-2481-3c5341f8e72f@kernel.dk>
Date:   Fri, 21 Apr 2023 16:36:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, agk@redhat.com,
        snitzer@kernel.org, philipp.reisner@linbit.com,
        lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
        hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
        senozhatsky@chromium.org, patches@lists.linux.dev,
        linux-block@vger.kernel.org, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-kernel@vger.kernel.org, hare@suse.de, p.raghav@samsung.com,
        da.gomez@samsung.com, kbusch@kernel.org
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
 <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
 <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/21/23 4:30?PM, Luis Chamberlain wrote:
> On Fri, Apr 21, 2023 at 04:24:57PM -0600, Jens Axboe wrote:
>> On 4/21/23 4:02?PM, Luis Chamberlain wrote:
>>> On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
>>>> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
>>>>> Just use the PAGE_SECTORS generic define. This produces no functional
>>>>> changes. While at it use left shift to simplify this even further.
>>>>
>>>> How is FOO << 2 simpler than FOO * 4?
>>>>
>>>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>>>> +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
>>>
>>> We could just do:
>>>
>>>
>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>> +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,
>>>
>>> The shift just seemed optimal if we're just going to change it.
>>
>> It's going to generate the same code, but the multiplication is arguably
>> easier to read (or harder to misread).
> 
> Then let's stick with the 4 * PAGE_SECTORS. Let me know if you need another
> patch.

Just send out a v2 at some point, you've also got a number of cases
where there are superfluous parenthesis, at least in patch 4, and Willy
pointed one out in an earlier patch too. Didn't check the last one.

This will be 6.5 anyway I think, I already sent out the changes for the
6.4 merge window.

-- 
Jens Axboe

