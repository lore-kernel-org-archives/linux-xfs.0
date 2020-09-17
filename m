Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AB4C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB25B21973
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 06:47:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fuwen1kv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIQGrw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 02:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgIQGrw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 02:47:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56ABC06174A
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 23:47:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id y1so784493pgk.8
        for <linux-xfs@vger.kernel.org>; Wed, 16 Sep 2020 23:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vxH9fQGFQQ//o2Xfl62qe2J+RDkk3E20dPbsrDReiLc=;
        b=Fuwen1kvXZDif4LAnb7GMLDY2ji3PF7DTmoRpmhZZO6N0oOJ6txpdLkCHOVArJ6Jcg
         8k7mR+3kaxac3BYeZigIGjvOok3MSmhorHczfspW/b9XV0QfQiUBkhPj5ddPAsSLTev0
         3e4zr81dsXgOwd//98AGGY2FflcOtMdYy2rluJZZo04IdJjtvbjm7kPtJCJ9guvPEzwv
         /6hgkesRWF/cTOCHReaMCE9t0yzeTrzPc0GsrEiogzH6hdK+6HVlMcKsnkQxAJj/rkG6
         hYhhUd2KNg8pxcEYlK0s0v8ajXbPkY0HpdmTE9UCCCR/DYbBh0I9Lx2EHVdJC95LdMOk
         TK5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vxH9fQGFQQ//o2Xfl62qe2J+RDkk3E20dPbsrDReiLc=;
        b=Zj+QXm2fTFeDvxK6PfBh/+3Ch1vBKRwJk6ioemOZtXvJfXTBynLopnbE2E2cFVLTNQ
         /agi+okWNe/C+anIDt0UKqv/4tHNMqZLARXMblR3Eqz8QBi9v9Src0yCbx5U9l1Qh88M
         BkbKABa18413ai982yGO7OxaZMOngkSAilaKoyl83AVYC0wv6eYMN4r9vXAeX/Arg7sz
         N1cN9j9ZFaiOOUio4z/7fal3N1uzrha8O3fUXciyVl0yZUc0+/C9ReTVkU2nyaV/pJHf
         7y16NgQ+pLztrT9EnXgnGqqg69VX33LjvzW8MRWcWGKFctly56QmCqGAptMqO5bMXEyp
         LBbQ==
X-Gm-Message-State: AOAM530DTw3/DhBdOkIYMYJlrpR3vQrU0xD3jfoRBoEwrNegyLYgAu33
        P6v/UyOnXvjYwSKQJQs7bg==
X-Google-Smtp-Source: ABdhPJy1PJPVjUrA8Z0f1OObHHpzh3yGrYX1McZpCxkmXOVyQHr4cK5Sp7SU0ka0D3cboGMEOnF4bA==
X-Received: by 2002:a63:4e5e:: with SMTP id o30mr21192453pgl.254.1600325271360;
        Wed, 16 Sep 2020 23:47:51 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id y5sm18925891pge.62.2020.09.16.23.47.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 23:47:50 -0700 (PDT)
Subject: Re: [PATCH] xfs: remove the unnecessary variable error in
 xfs_trans_unreserve_and_mod_sb
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-7-git-send-email-kaixuxia@tencent.com>
 <20200916164522.GH7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <f3544c97-bda9-cb4f-0a2b-eb2fab9fb9a4@gmail.com>
Date:   Thu, 17 Sep 2020 14:47:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916164522.GH7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

On 2020/9/17 0:45, Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 07:19:09PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We can do the assert directly for the return value of xfs_mod_fdblocks()
>> function, and the variable error is unnecessary, so remove it.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_trans.c | 7 ++-----
>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index d33d0ba6f3bd..caa207220e2c 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -573,7 +573,6 @@ xfs_trans_unreserve_and_mod_sb(
>>  	int64_t			rtxdelta = 0;
>>  	int64_t			idelta = 0;
>>  	int64_t			ifreedelta = 0;
>> -	int			error;
>>  
>>  	/* calculate deltas */
>>  	if (tp->t_blk_res > 0)
>> @@ -596,10 +595,8 @@ xfs_trans_unreserve_and_mod_sb(
>>  	}
>>  
>>  	/* apply the per-cpu counters */
>> -	if (blkdelta) {
>> -		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
>> -		ASSERT(!error);
>> -	}
>> +	if (blkdelta)
>> +		ASSERT(!xfs_mod_fdblocks(mp, blkdelta, rsvd));
> 
> Um.... did you test this with ASSERTs disabled?  Because this compiles
> the free block counter update out of the function on non-debug kernels,
> which (AFAICT) will cause fs corruption...

Yes,thanks for pointing out... My fault...

> 
> --D
> 
>>  
>>  	if (idelta) {
>>  		percpu_counter_add_batch(&mp->m_icount, idelta,
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
