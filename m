Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AF7C4361B
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 03:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2296E22D06
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Dec 2020 03:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgLGDOa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 22:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgLGDOa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 22:14:30 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE4AC0613D0
        for <linux-xfs@vger.kernel.org>; Sun,  6 Dec 2020 19:13:50 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id s21so8375641pfu.13
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 19:13:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vhqty+rjuw112AEboGCraPINE4Ws+BBOXZd8up6pD5g=;
        b=s1WUoyplUEauttP51/t+c4AeaWqgBUPZ9y86nJ/vNHHyNT+UI3xziQJQ2gl3F4Lj3H
         0k4VbujKC3a9wWeRu4u2XIHXS1cHZYm5NQnGEPzVkmTqqcTIGvWa0bwNUgWgXSvQverv
         nOe86/lTyfxknPTrxM0hFxbDZSWFv3l1b7QUHinW54Rhdpb+8/cFvHTRxP2vEVfq7LZX
         v2hD0zejhlT6QXHiX8M6dhIgkH4+hueH6LmJT2ZHS2BGEyoFyVHNni6x0sctT8LXz2bq
         iRvkAtssflacrZnyT7zMudpkwvEXcgXG58qkdrvkglt8mkly7wb+fxFONHsD6cIplU6f
         xihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vhqty+rjuw112AEboGCraPINE4Ws+BBOXZd8up6pD5g=;
        b=GSdH0Flz2QK7fUNw9Bv83ppwntZ/SgsMzvW0LthbrnGlyvPlQ6ON0WvKjZj9SHLpOz
         +B20SWBwcF4jmB+jxf+Y7SeGuiFQ0uxFUnX5csOnwqOuloHzFBLKuy4nx63m/wh4R8pr
         78xvUlIlytyOubXzZ7aIYumWXxwSw7Il/c5a7RJz+n4W1o9vksGtqaMwwaj9nmQ1or6d
         wGC5+aWBRBAWmZnCWXkR3eXhxKN1kaoKOfcs0GM1OnW77XQ/OgtzAWAJ7UiCnSDDovFt
         rHC85A2FHFziNMsO6UaAEO7HaUWG646o0yBLOSn2dIEhZgViKe27+3nVHG5J+J2TFvwN
         3GgA==
X-Gm-Message-State: AOAM5323rwwMaum9eJxVxx75sCGSDKpLCFbi+e814WAQJD+igjcErUL6
        CrKiLJD7rVo/ZsUVtm3Sjg==
X-Google-Smtp-Source: ABdhPJw5G4Yy/cuiCTe54oAAsdGrlGe0t3u4Odx0wqZyQTIxzlLHZuLswcqRi8iFXZZDAeE11/9CRg==
X-Received: by 2002:a65:6401:: with SMTP id a1mr16786224pgv.149.1607310829766;
        Sun, 06 Dec 2020 19:13:49 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id q5sm12557816pff.36.2020.12.06.19.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 19:13:49 -0800 (PST)
Subject: Re: [PATCH] xfs: show the proper user quota options
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
 <20201206231201.GJ629293@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <648aa958-96a1-1349-c665-1954bc87681c@gmail.com>
Date:   Mon, 7 Dec 2020 11:13:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201206231201.GJ629293@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/12/7 7:12, Darrick J. Wong wrote:
> On Mon, Nov 23, 2020 at 05:38:52PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
>> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
>> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
>> seems wrong, Fix it and show proper options.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> 
> FWIW this causes a regression in xfs/513 since mount option uqnoenforce
> no longer causes 'usrquota' to be emitted in /proc/mounts.  Do you have
> a patch to fix fstests?

Yeah, I'll send the patches to fix the regression in xfs/513 and add the
xfstest case for this bug ASAP:)

Thanks,
Kaixu
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_super.c | 10 ++++++----
>>  1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>> index e3e229e52512..5ebd6cdc44a7 100644
>> --- a/fs/xfs/xfs_super.c
>> +++ b/fs/xfs/xfs_super.c
>> @@ -199,10 +199,12 @@ xfs_fs_show_options(
>>  		seq_printf(m, ",swidth=%d",
>>  				(int)XFS_FSB_TO_BB(mp, mp->m_swidth));
>>  
>> -	if (mp->m_qflags & (XFS_UQUOTA_ACCT|XFS_UQUOTA_ENFD))
>> -		seq_puts(m, ",usrquota");
>> -	else if (mp->m_qflags & XFS_UQUOTA_ACCT)
>> -		seq_puts(m, ",uqnoenforce");
>> +	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
>> +		if (mp->m_qflags & XFS_UQUOTA_ENFD)
>> +			seq_puts(m, ",usrquota");
>> +		else
>> +			seq_puts(m, ",uqnoenforce");
>> +	}
>>  
>>  	if (mp->m_qflags & XFS_PQUOTA_ACCT) {
>>  		if (mp->m_qflags & XFS_PQUOTA_ENFD)
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
