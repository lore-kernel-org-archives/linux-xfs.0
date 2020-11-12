Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286E0C56201
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40B921734
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GC+MuD+P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728683AbgKLFiA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:38:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKLCdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Nov 2020 21:33:02 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F41C0613D6
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:32:58 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d3so2010329plo.4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QgoZuVaz6M6om7+srdocEngpgU3Bj2CD+b5mwRSU7bw=;
        b=GC+MuD+PWNFpGI8E+V34WcO07hpCOiC0P0yYrarcAI94lU7ZJtTh1yjEG8w3h/LFP/
         75dF4hs5epH2R5uK3YWRl5covBQZhn3NKUiSr8TMKyAYrmz0ou3Uyygqwohtaum6qrcb
         7FpiwRVU5H+lS3xoXHnDqLCFR1GFC+wtGTCr3k+HcIPFhYy5lhow1QX8/HfkXjvEZGf2
         7wslchTpi6fU1HQx8oDEq2SxkKT7XINxvy81oT1213xk0s+2XqhxErC5LK29gS3x1/0e
         X7JiRf72hh7XjSNtfjui/zdiYu2Ew0MGw3N/1vuPa7UjmQMMhnENVaLm4L8l4ZIt7lB0
         Zv+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QgoZuVaz6M6om7+srdocEngpgU3Bj2CD+b5mwRSU7bw=;
        b=Q7lcr1mWQ8VMtv7fWrnx6QbDhZiJT6OYmP1FAjh/sMdAl5ZBulI0PzKLH0XLk32fjp
         T889Iw/o8EJBGFHIkguKJNSaa3JQV5Un53tgtUP37P27EYxmMrFYCdNEC/qzWoahIp2h
         uHSnY7QGj6PyzuYhrvH2ZFULrveVTCBDxBMd+IISx+pktBYIQ67qApYS1DA/sHykzJ2+
         u+/1ze6/2ybHj1T2cJcKBw0ZlpZCVzaQdu9WVpN6cRtRw7gRxLUEOyA5r5W2Kl0ETZjI
         ivyDIpH1hx8YBLNOaFCTvB8GRUzfoDDROeCvPWnp2EfJ2jtPjI6a4S0KAS5sf7Js0wjG
         0C1A==
X-Gm-Message-State: AOAM533RuMOfZZNMXTgdWFe07BwFP5iDrnIhm4IKdU1CJWOe/lrDEm8Q
        NAviOZDo6agBS6+9BBoGJA==
X-Google-Smtp-Source: ABdhPJxDLp03GPOo0YmdnivvWyWEI6Qs2aVg+Il+AmcKEYS52DZJyjzcBtObEIuX7wL3vctX19ofeQ==
X-Received: by 2002:a17:902:6bc2:b029:d6:e0ba:f2ff with SMTP id m2-20020a1709026bc2b02900d6e0baf2ffmr509157plt.10.1605148378147;
        Wed, 11 Nov 2020 18:32:58 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id w131sm4188623pfd.14.2020.11.11.18.32.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 18:32:56 -0800 (PST)
Subject: Re: [RFC PATCH] xfs: remove unnecessary null check in
 xfs_generic_create
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1602232150-28805-1-git-send-email-kaixuxia@tencent.com>
 <20201009154501.GU6540@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <f57cc952-72df-c2e5-e700-46c6edcd4b46@gmail.com>
Date:   Thu, 12 Nov 2020 10:32:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201009154501.GU6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/9 23:45, Darrick J. Wong wrote:
> On Fri, Oct 09, 2020 at 04:29:10PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The function posix_acl_release() test the passed-in argument and
>> move on only when it is non-null, so maybe the null check in
>> xfs_generic_create is unnecessary.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> 
> Heh, yep.  Nice cleanup.
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Hi Darrick,

There are some patches that have been reviewed but not been merged
into xfs for-next branch, I will reply to them.
Sorry for the noise:)

Thanks,
Kaixu
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_iops.c | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 5e165456da68..5907e999642c 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -206,10 +206,8 @@ xfs_generic_create(
>>  	xfs_finish_inode_setup(ip);
>>  
>>   out_free_acl:
>> -	if (default_acl)
>> -		posix_acl_release(default_acl);
>> -	if (acl)
>> -		posix_acl_release(acl);
>> +	posix_acl_release(default_acl);
>> +	posix_acl_release(acl);
>>  	return error;
>>  
>>   out_cleanup_inode:
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
