Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE74DC55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B6362087E
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="V4RZNddM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgD0IP5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgD0IPw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 04:15:52 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B47DC061A41
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:15:52 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u127so19364169wmg.1
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qlm8OKyOV/HJAu3bA65vWCOmmjrUcu0xP6huIGZIaXI=;
        b=V4RZNddMJEAgB0Qn4YXncrFVThel5CoJI0JvjTD4yCVslyZDfoC00sJ18gxjb/7TlZ
         zZbNFli1x2HY0TLBeb0L8vjk+QosxpivU29rt2XlFkLr8TjFWRMME6SbwkeR2v7qPyJ1
         znrGZzoLp/gCBLk9Ec9DYumtRr8V3V8rrBReqoo3OUjwBM7yrUe/epGDpYnew7il4dqd
         tENysIZaLdPITFGVxYLuV2QoSszSi9Ftu46BDFCiv5hDl+EURRawMmL2GnffWOcKRcV0
         jhvFxNLuTybjUjIOON7GVLvkwfKx8aCEUqbJGPXW3Wk5xJrLGQS2CtRBVFK2nqAQkj0y
         3qog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qlm8OKyOV/HJAu3bA65vWCOmmjrUcu0xP6huIGZIaXI=;
        b=WRlM+I6dgp9gYcPde40iSPf+5kL0E4OcLjDEN/OFX2ZRmY3KEsGnneNrGxaRrfHO0B
         +nW+297qrXTla82z+YMkYY7u19qBiH6CkpfD1l79a9IdcZdWM0YNZxQualTj0Nw7XtZz
         H30mkJrYSS2AHa1cjZwzW9D+pvNBd3hZ41y4qRsAGFNyEyZCITDPUzDN/wbqTKylEFnK
         LVebAIPVDjZjQY72Cp+Aj2IuRpNDi87gtyZgj2m9khrCrGgzlrf77pawuuzWCW8RKnej
         btGw2S9pfPNonn9YdtcPOKL8rRAktDQEJXBOfoFTtQZC5LJoYhyoTibIEKAtngexciwE
         TLag==
X-Gm-Message-State: AGi0PuYcvjIFsHYrn/4L1QjAynYHtZzlMNKIhktydOvA6n1YYw9qKhtf
        S07QWGLP7ptsmTtgo3oMNg9A6zAneyy6qppj
X-Google-Smtp-Source: APiQypJLrh0UqqOlDdSsFXIUtEpbttKfTwx7y9nZKrgMufKXVJacLLtgle1CJEcyUZwYphgSbLvU5Q==
X-Received: by 2002:a7b:c4d1:: with SMTP id g17mr8240890wmk.158.1587975351044;
        Mon, 27 Apr 2020 01:15:51 -0700 (PDT)
Received: from ?IPv6:2001:16b8:4886:8400:6d4b:554:cd7c:6b19? ([2001:16b8:4886:8400:6d4b:554:cd7c:6b19])
        by smtp.gmail.com with ESMTPSA id u127sm14786776wme.8.2020.04.27.01.15.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 01:15:50 -0700 (PDT)
Subject: Re: [RFC PATCH 6/9] iomap: use set/clear_fs_page_private
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
 <20200427002631.GC29705@bombadil.infradead.org>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <9dc98fe6-f65e-55ee-5e3e-94f4bbc0e2c7@cloud.ionos.com>
Date:   Mon, 27 Apr 2020 10:15:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427002631.GC29705@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/27/20 2:26 AM, Matthew Wilcox wrote:
> On Sun, Apr 26, 2020 at 11:49:22PM +0200, Guoqing Jiang wrote:
>> @@ -59,24 +59,18 @@ iomap_page_create(struct inode *inode, struct page *page)
>>   	 * migrate_page_move_mapping() assumes that pages with private data have
>>   	 * their count elevated by 1.
>>   	 */
>> -	get_page(page);
>> -	set_page_private(page, (unsigned long)iop);
>> -	SetPagePrivate(page);
>> -	return iop;
>> +	return (struct iomap_page *)set_fs_page_private(page, iop);
>>   }
> This cast is unnecessary.  void * will be automatically cast to the
> appropriate pointer type.
>
>> @@ -556,11 +550,9 @@ iomap_migrate_page(struct address_space *mapping, struct page *newpage,
>>   
>>   	if (page_has_private(page)) {
>>   		ClearPagePrivate(page);
>> -		get_page(newpage);
>> -		set_page_private(newpage, page_private(page));
>> +		set_fs_page_private(newpage, (void *)page_private(page));
>>   		set_page_private(page, 0);
>>   		put_page(page);
>> -		SetPagePrivate(newpage);
>>   	}
> Same comment here as for the btrfs migrate page that Dave reviewed.

Yes, thanks for the review.

Thanks,
Guoqing
