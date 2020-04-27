Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05BCC55199
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 745312051A
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 08:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="bo2OtiyU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbgD0IPQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 04:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgD0IPP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 04:15:15 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0527C061A41
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:15:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so19417921wrr.0
        for <linux-xfs@vger.kernel.org>; Mon, 27 Apr 2020 01:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=BhLLuuIGC1DhijRmpisdnmULVEF14r9n/Unp6QFSRm4=;
        b=bo2OtiyUXwwGOFh9qgBkyh5LISUr3k/gbB3xAzxrJqL2paNpAogjzR7TWA2+7jlY1s
         Lou45TLOd6jHgV08hvGI1EXycFfOBaZio25X8veUhQi5z9pFn/3HnwUL+ozQwpPC9vKz
         9xGZzr3eNT6hj+aqtCTa0Y2acqdPuXUpqLc/ZD/3qtjVLoV4KDMQwfsho9QX/6ikKxtf
         d51h6LyJsPeeAKcYSQaTFXPz3klBhurUr1CwkOjA29HXkyv+uM7S17QRi1Efa/mlKOeW
         JS8aDHfJRRqExLXE8qpyQ5Kx8MYiveOpH5w9UQBJyFsTGfWshp+l2a5/dfvrUaLgVeWG
         hsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BhLLuuIGC1DhijRmpisdnmULVEF14r9n/Unp6QFSRm4=;
        b=WjN017Fmfawgr0rA0PpOn7HRzajlSB4Phqw4gwzZ8ThETA9jNA/xS7CrJjHexxs1Xq
         c5p9+2j2PxLuxY6u4GWSEyu6mIwPn12OA1JOGEXrl93Odz8dyKZFBl/t85B0y5lpb65/
         MB/31O2CAlg+WtpiOem/ghK+sZ8MsDesljQD5cUtVRJni/donqysTmRqgtLdhIB4u4qk
         yrnhbQrlDpcnstcPdTaSUgmGgl0jG4W5ujHD3j7EZ8T6QlIpgRmkjFHTyU0fVzQN0L/4
         b8Qwnhalm6TuP08NVj5NSwjW0XovNM2DFi4Fe2w1luteZ6gmWPECpCXAue8YPm/JjFyp
         EJ2g==
X-Gm-Message-State: AGi0PuYmXFFNdk7fomiu13u4yb2Gm5IrFr3JZe3RlPGxPUw0rI+dpVum
        uL05ODRjNMaows9VqkMA0lFob5KCAx9vkvZK
X-Google-Smtp-Source: APiQypLqlhq+Mc2HmygZEcSY4yH9lw/XJlMjd2WsPjenBHiUsc9BaPgLVbFvnLqAwMPWIyHs/D/kwg==
X-Received: by 2002:adf:e541:: with SMTP id z1mr25836799wrm.218.1587975312114;
        Mon, 27 Apr 2020 01:15:12 -0700 (PDT)
Received: from ?IPv6:2001:16b8:4886:8400:6d4b:554:cd7c:6b19? ([2001:16b8:4886:8400:6d4b:554:cd7c:6b19])
        by smtp.gmail.com with ESMTPSA id z18sm19636935wrw.41.2020.04.27.01.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 01:15:11 -0700 (PDT)
Subject: Re: [RFC PATCH 6/9] iomap: use set/clear_fs_page_private
To:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        david@fromorbit.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20200426214925.10970-1-guoqing.jiang@cloud.ionos.com>
 <20200426214925.10970-7-guoqing.jiang@cloud.ionos.com>
 <20200427002631.GC29705@bombadil.infradead.org>
 <20200427055540.GC16709@infradead.org>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <fac074af-02e3-d384-fae0-3219ef83ef76@cloud.ionos.com>
Date:   Mon, 27 Apr 2020 10:15:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427055540.GC16709@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 4/27/20 7:55 AM, Christoph Hellwig wrote:
> On Sun, Apr 26, 2020 at 05:26:31PM -0700, Matthew Wilcox wrote:
>> On Sun, Apr 26, 2020 at 11:49:22PM +0200, Guoqing Jiang wrote:
>>> @@ -59,24 +59,18 @@ iomap_page_create(struct inode *inode, struct page *page)
>>>   	 * migrate_page_move_mapping() assumes that pages with private data have
>>>   	 * their count elevated by 1.
>>>   	 */
>>> -	get_page(page);
>>> -	set_page_private(page, (unsigned long)iop);
>>> -	SetPagePrivate(page);
>>> -	return iop;
>>> +	return (struct iomap_page *)set_fs_page_private(page, iop);
>>>   }
>> This cast is unnecessary.  void * will be automatically cast to the
>> appropriate pointer type.
> I also find the pattern eather strange.  A:
>
> 	attach_page_private(page, iop);
> 	return iop;
>
> explains the intent much better.

Thanks for the review, will do it.

Thanks,
Guoqing
