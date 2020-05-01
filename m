Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA730C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 06:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2AEF208C3
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 06:38:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="igdtu79l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbgEAGiO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 02:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAGiN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 02:38:13 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31990C035494
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:38:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so4988542wmc.2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2020 23:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yXj2pdVP6i0fMstqZTjDinycQd6wkFMj6gwQt+noc8s=;
        b=igdtu79luKbp0ncnMlpcPUIFNLj09t5tdmXwPOynxALpGplpYNsCsKZ3TMVWdo9ixy
         9qcOgMNngF70aGp/iq6J334SDsCf0WvF+bfW4ShsvDr629zl7TV4YC0prPgNyXbEyMlW
         M1MwzmBX6wDzWgAHYgOPvyB2hfLG8XFlbXCydufpud/SGQ7MyIDh9SGccBouiyk8JPOD
         omSXRwL5PxUpdYANBC8EaED7ZmqMAkT/hWOPDTwnPPbIIdyI/RNn8FsVhdOgRXUne/0n
         FwcvzYyQzXR4siAZrRLlP9gvSaclMgDv8B/Qn8UpHmV/KeKMdWJCewHZdztoi6lv5/pf
         x8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yXj2pdVP6i0fMstqZTjDinycQd6wkFMj6gwQt+noc8s=;
        b=rX1YsANy/ywuyY1flKQidj0s+Hp7VtDg6mBZ17nZfsSiztmQzfvtwi5hFEofCXdZay
         FopmNyGnJmSyBvSU8HfPKEdeahr0AQSkONevszesoPfuGO3jztNx0rWEsPxcsZnyvS4T
         1RD6h8nMeJv6+uKKfHLMsXSH0FxPNmH6N3Xv6LnWcjN4l7XvNYlwclqYBIpmMEKi4h0Y
         yCBzQiX6a6dSC+2YS4GiMfBi8ChmXHPnHt60jR5ozVyL2nJOIrypaA2OlmjQbHMnDx7L
         9gMGXzRe339wj7rpKM/ii1eo1ZBKe26cxf4BMvpn7ZNP3FKhZyd7u0Ip1tNN7mAWGsB4
         rbKg==
X-Gm-Message-State: AGi0PuarKPdEqSr2TQ0z4H1TiXYvsz0+JROunQpoqA1CyDRj2+olms4z
        prgHxUvRB7YPI1rGDvRO4D9XPg==
X-Google-Smtp-Source: APiQypLtkGYIGGJq5BI6MtIPNjHZ3SCz/+s0PPQHI2w9oHJ8euTDIGJUWlFRjsunZB9rB6pxQ8UjcA==
X-Received: by 2002:a7b:cdf7:: with SMTP id p23mr2451834wmj.33.1588315091678;
        Thu, 30 Apr 2020 23:38:11 -0700 (PDT)
Received: from ?IPv6:2001:16b8:48db:9b00:e80e:f5df:f780:7d57? ([2001:16b8:48db:9b00:e80e:f5df:f780:7d57])
        by smtp.gmail.com with ESMTPSA id x13sm2886685wmc.5.2020.04.30.23.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 23:38:11 -0700 (PDT)
Subject: Re: [RFC PATCH V2 1/9] include/linux/pagemap.h: introduce
 attach/clear_page_private
To:     =?UTF-8?Q?Andreas_Gr=c3=bcnbacher?= <andreas.gruenbacher@gmail.com>
Cc:     Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, willy@infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Yafang Shao <laoar.shao@gmail.com>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        linux-ntfs-dev@lists.sourceforge.net,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        devel@lists.orangefs.org, Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Gushchin <guro@fb.com>,
        Andreas Dilger <adilger@dilger.ca>
References: <20200430214450.10662-1-guoqing.jiang@cloud.ionos.com>
 <20200430214450.10662-2-guoqing.jiang@cloud.ionos.com>
 <CAHpGcMKdzSBGZTRwuoBTuCFUX44egmutvCr9LcjYW7KpWxmhHA@mail.gmail.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <05178e19-8971-0f3d-69de-5542fcb6a2a8@cloud.ionos.com>
Date:   Fri, 1 May 2020 08:38:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAHpGcMKdzSBGZTRwuoBTuCFUX44egmutvCr9LcjYW7KpWxmhHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 5/1/20 12:10 AM, Andreas Grünbacher wrote:
> Hi,
>
> Am Do., 30. Apr. 2020 um 23:56 Uhr schrieb Guoqing Jiang
> <guoqing.jiang@cloud.ionos.com>:
>> The logic in attach_page_buffers and  __clear_page_buffers are quite
>> paired, but
>>
>> 1. they are located in different files.
>>
>> 2. attach_page_buffers is implemented in buffer_head.h, so it could be
>>     used by other files. But __clear_page_buffers is static function in
>>     buffer.c and other potential users can't call the function, md-bitmap
>>     even copied the function.
>>
>> So, introduce the new attach/clear_page_private to replace them. With
>> the new pair of function, we will remove the usage of attach_page_buffers
>> and  __clear_page_buffers in next patches. Thanks for the new names from
>> Christoph Hellwig.
>>
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
>> Cc: William Kucharski <william.kucharski@oracle.com>
>> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>> Cc: Andreas Gruenbacher <agruenba@redhat.com>
>> Cc: Yang Shi <yang.shi@linux.alibaba.com>
>> Cc: Yafang Shao <laoar.shao@gmail.com>
>> Cc: Song Liu <song@kernel.org>
>> Cc: linux-raid@vger.kernel.org
>> Cc: Chris Mason <clm@fb.com>
>> Cc: Josef Bacik <josef@toxicpanda.com>
>> Cc: David Sterba <dsterba@suse.com>
>> Cc: linux-btrfs@vger.kernel.org
>> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
>> Cc: Chao Yu <chao@kernel.org>
>> Cc: linux-f2fs-devel@lists.sourceforge.net
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: linux-xfs@vger.kernel.org
>> Cc: Anton Altaparmakov <anton@tuxera.com>
>> Cc: linux-ntfs-dev@lists.sourceforge.net
>> Cc: Mike Marshall <hubcap@omnibond.com>
>> Cc: Martin Brandenburg <martin@omnibond.com>
>> Cc: devel@lists.orangefs.org
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> Cc: Roman Gushchin <guro@fb.com>
>> Cc: Andreas Dilger <adilger@dilger.ca>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>> ---
>> RFC -> RFC V2:  Address the comments from Christoph Hellwig
>> 1. change function names to attach/clear_page_private and add comments.
>> 2. change the return type of attach_page_private.
>>
>>   include/linux/pagemap.h | 35 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index a8f7bd8ea1c6..2e515f210b18 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -205,6 +205,41 @@ static inline int page_cache_add_speculative(struct page *page, int count)
>>          return __page_cache_add_speculative(page, count);
>>   }
>>
>> +/**
>> + * attach_page_private - attach data to page's private field and set PG_private.
>> + * @page: page to be attached and set flag.
>> + * @data: data to attach to page's private field.
>> + *
>> + * Need to take reference as mm.h said "Setting PG_private should also increment
>> + * the refcount".
>> + */
>> +static inline void attach_page_private(struct page *page, void *data)
>> +{
>> +       get_page(page);
>> +       set_page_private(page, (unsigned long)data);
>> +       SetPagePrivate(page);
>> +}
>> +
>> +/**
>> + * clear_page_private - clear page's private field and PG_private.
>> + * @page: page to be cleared.
>> + *
>> + * The counterpart function of attach_page_private.
>> + * Return: private data of page or NULL if page doesn't have private data.
>> + */
>> +static inline void *clear_page_private(struct page *page)
>> +{
>> +       void *data = (void *)page_private(page);
>> +
>> +       if (!PagePrivate(page))
>> +               return NULL;
>> +       ClearPagePrivate(page);
>> +       set_page_private(page, 0);
>> +       put_page(page);
>> +
>> +       return data;
>> +}
>> +
> I like this in general, but the name clear_page_private suggests that
> this might be the inverse operation of set_page_private, which it is
> not. So maybe this can be renamed to detach_page_private to more
> clearly indicate that it pairs with attach_page_private?

Yes, the new name is better, thank you!

Cheers,
Guoqing
