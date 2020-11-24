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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B19C2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 08:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44FDC2073C
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Nov 2020 08:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DTfJEjq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgKXIhX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Nov 2020 03:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726689AbgKXIhX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 03:37:23 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02D3C0613CF
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 00:37:21 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id j19so16814081pgg.5
        for <linux-xfs@vger.kernel.org>; Tue, 24 Nov 2020 00:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BVZHkHg2hcvXkzY+skQt0TOTUTRSWIM/QXLOwNYt7Mg=;
        b=DTfJEjq4zyc3KrSzsB61+ppu5vL8+I3ju0d+gqmllsN4taXSa7MvtTxCbgDK0pxpbX
         tb2KrJEAo8kNsrfGa86o9LWuDZC4v87FaU/+K6XwwcppFehSfIVh13XCMGwmaBgRdSPz
         a3FW/qa5AzKi85dM+EPn+7e4dzBwgKdAecr9lWmeHzC6AAS1LnViB8uyMTrrYKWKvWER
         +K9TPop8DXX/dhY6CQYDpDvFIdWnhAuKA9D+H4KWVS/0BgtzZMtpT6jhUk/Ts8VjbxUT
         DDuISYrO/NVw+OUhOgDntmX2qMw21Vwm79n1hpZ1/91Qx0P51VevYBW/SuqeHY9qzMiL
         qARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BVZHkHg2hcvXkzY+skQt0TOTUTRSWIM/QXLOwNYt7Mg=;
        b=iVc8JfsrCXR6dmnJrqgAFVDkyec2pCHWNa6VDaDrLdYRFu5b/6SocVkf1Lk7g33491
         OnUSjsl+FjnggJH2kjeStzqKslskKlZvWr3HZJJyP9gDgNRWQzOTLL7gL6YSaOl/rxwt
         yJwvuSmu28KiT8pO9KjBT13JS10ZrrlvuEiBtcK3Dy148frDdCjtrFj8SxMRDoH2pwJi
         EVl7Pk8C6Ssdstjpui7JEdM9tdD2E2f0YvNakHi1b7aferIm7tfcw7BCsk5NGqC9uQpG
         1WwcLoQWc2ILB2xSTQaBWWrBmXH8ONuOatKbOSFVgMIF5uxTUwPMddGhrqZ9occN8qGB
         /vRw==
X-Gm-Message-State: AOAM533h1KRzk8dVfQzDB61x8i8OMZBMTOwI9cjI1yOgBNGZ6Hpij+7d
        EOe57gcWN4cEiCEKY4rF4w==
X-Google-Smtp-Source: ABdhPJxF89csIAZbxw957HPaTnePdww0ar3sSqxRU7yS6KcXs4od6aW7SvblRU4ppxvdpYZ1qln/tA==
X-Received: by 2002:a05:6a00:8ca:b029:196:6dcb:14a4 with SMTP id s10-20020a056a0008cab02901966dcb14a4mr3156197pfu.12.1606207041393;
        Tue, 24 Nov 2020 00:37:21 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id n2sm1023424pfq.129.2020.11.24.00.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 00:37:20 -0800 (PST)
Subject: Re: [PATCH] xfs: show the proper user quota options
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1606124332-22100-1-git-send-email-kaixuxia@tencent.com>
 <20201124003028.GF7880@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <762983f4-6803-2bae-3e21-e7f1dfa95991@gmail.com>
Date:   Tue, 24 Nov 2020 16:37:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201124003028.GF7880@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/11/24 8:30, Darrick J. Wong wrote:
> On Mon, Nov 23, 2020 at 05:38:52PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The quota option 'usrquota' should be shown if both the XFS_UQUOTA_ACCT
>> and XFS_UQUOTA_ENFD flags are set. The option 'uqnoenforce' should be
>> shown when only the XFS_UQUOTA_ACCT flag is set. The current code logic
>> seems wrong, Fix it and show proper options.
> 
> This needs a regression test case to make sure that quota mount options
> passed in ==> quota options in /proc/mounts, wouldn't you say? ;)

Hi Darrick,

The simple test case as follows:

Before the patch:
 # mount -o uqnoenforce /dev/vdc1 /data1
 # cat /proc/mounts | grep xfs
/dev/vdc1 /data1 xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,usrquota 0 0

After the patch:
 # mount -o uqnoenforce /dev/vdc1 /data1
 # cat /proc/mounts | grep xfs
/dev/vdc1 /data1 xfs rw,relatime,attr2,inode64,logbufs=8,logbsize=32k,uqnoenforce 0 0

I'm not sure if a xfstest case is needed:)

Thanks,
Kaixu

> 
> --D
> 
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
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
