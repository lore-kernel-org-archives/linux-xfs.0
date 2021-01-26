Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB280C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798502072C
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Jan 2021 10:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313716AbhAZXDm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 18:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbhAZFPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jan 2021 00:15:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61EB1C0613D6
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 21:14:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gx1so1548796pjb.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Jan 2021 21:14:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cvJFgK303n7g5tx1YwxSnRa/yjajOXj4FJweAAdQFOI=;
        b=edH1TzTnTU0z+STB/8g1/HfkXK31ljdfR7xrcX2JA3xqJTtQP2VlAuPjmXOAQq4jok
         2pjrqhPQCvk0OOY3ZePgZZvhY6vIw7BoCBF92n/mD9e62Ny2lwPLcGX8jJGjMcmYJtfS
         QxqQl1wv/N7LoXyHfEhAOgH1DSCcULs2IElDOkR2Yov/oVYRlFQqMvzBKnvboiOUA+Ht
         A/ky02BP8D4i8Bd474QHLCxVwX/iprZqP5tm+tYVUbPzqSPU4vMWPARAyR1eAO4feUux
         M5m+V3cnWm5fbRhNupcKFPZCdCd8KQniyDvMH3GTSjdn0T+Oadl63907eseG0PmUcvD9
         WjGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cvJFgK303n7g5tx1YwxSnRa/yjajOXj4FJweAAdQFOI=;
        b=YmewCNeZJejhnWXnUdfeTdByNl9gNkuqz5oRtvdqd3yXGRLgZJgB4Xc3saoQPN98EQ
         5YelVH+7ousH92heH73dXwWwgHu33FNwmlKh72WerUQb2aX50yFwTnVnmfbPHvTX2UJf
         6B10lsqzGorlrGi5o5MBZ0KoeqQPoys74CLZBaS5Prue8hsP/9PIhfJpmyuXJPOQZ2Q8
         UX6aFU8+DKMB7Sru3ymVEWTebfcX4jfDB3yo28Ecmpj314jQRujtDBcAzCpVqH56Ow5P
         CNitXB06sQKtEtz87siAr1ghp8sygpSRFPGfAfN0cwaSy2HsNkCsi0JkqydPUf5UoeMp
         I3Yg==
X-Gm-Message-State: AOAM53369HpFkHMvppGDoxliNASDwxLOQk8ZaUUX1sRDxtNe0aLPsUDR
        KVtL2qH9Ni2HuNc6vr8gvVPdi6U0w6Q=
X-Google-Smtp-Source: ABdhPJzWdr9ZljO7f+HyYCZ0+a8QhJU3f+v/aOepD9fI9PNWJAvarzsWjcFz4Iw4KHxd6AyL1BVJPA==
X-Received: by 2002:a17:902:9f8b:b029:e0:a90:b62 with SMTP id g11-20020a1709029f8bb02900e00a900b62mr4137948plq.70.1611638087844;
        Mon, 25 Jan 2021 21:14:47 -0800 (PST)
Received: from garuda ([122.167.33.191])
        by smtp.gmail.com with ESMTPSA id a188sm19143252pfb.108.2021.01.25.21.14.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Jan 2021 21:14:47 -0800 (PST)
References: <20210125095809.219833-1-chandanrlinux@gmail.com> <da50be67-cc9a-8a99-84dc-a4ae3ee4fd73@sandeen.net>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfsprogs: xfs_fsr: Interpret arguments of qsort's compare function correctly
In-reply-to: <da50be67-cc9a-8a99-84dc-a4ae3ee4fd73@sandeen.net>
Date:   Tue, 26 Jan 2021 10:44:44 +0530
Message-ID: <87lfcgcm9n.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 25 Jan 2021 at 19:47, Eric Sandeen wrote:
> On 1/25/21 3:58 AM, Chandan Babu R wrote:
>> The first argument passed to qsort() in fsrfs() is an array of "struct
>> xfs_bulkstat". Hence the two arguments to the cmp() function must be
>> interpreted as being of type "struct xfs_bulkstat *" as against "struct
>> xfs_bstat *" that is being used to currently typecast them.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>
> Yikes. Broken since 5.3.0, and the structures have different sizes and
> different bs_extents offsets. :(
>
> Fixes: 4cca629d6 ("misc: convert xfrog_bulkstat functions to have v5 semantics")
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
> At least it's only affecting the whole-fs defragment which is generally not
> recommended, but is still available and does get used.
>
> I wonder if it explains this bug report:
>
> Jan 07 20:52:44 <Tharn>	hey, quick question... the first time I ran xfs_fsr last night, it ran for 2 hours and looking at the console log, it ended with a lot of "start inode=0" repeating

With my limited understanding of xfs_fsr code, looks like the bug reporter saw
the logs corresponding to the default (i.e. 10) number of passes that xfs_fsr
executes on the inodes of the filesystem. Sorry, I couldn't be of much help in
this case.

>
>> ---
>>  fsr/xfs_fsr.c | 5 ++---
>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
>> index 77a10a1d..635e4c70 100644
>> --- a/fsr/xfs_fsr.c
>> +++ b/fsr/xfs_fsr.c
>> @@ -702,9 +702,8 @@ out0:
>>  int
>>  cmp(const void *s1, const void *s2)
>>  {
>> -	return( ((struct xfs_bstat *)s2)->bs_extents -
>> -	        ((struct xfs_bstat *)s1)->bs_extents);
>> -
>> +	return( ((struct xfs_bulkstat *)s2)->bs_extents -
>> +	        ((struct xfs_bulkstat *)s1)->bs_extents);
>>  }
>>
>>  /*
>>


--
chandan
