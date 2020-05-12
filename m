Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4375AC54E8D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BCC52071A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:17:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CRn22QoV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgELCRs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 22:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727892AbgELCRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 22:17:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6532FC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:17:48 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id f15so4724992plr.3
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cHzTU6SsKJjIN0hxKTOt2NilxUhbuktKMFKGi7O4BN8=;
        b=CRn22QoVmyfhyU7VjAZuy6qvmudDp+q4lxMkyaONDPznJS1ilIIk38wrUlmyCrF6Ti
         /q8+EzNslRiw5pGMOVc3RnAz+Z4UM2lYXLb/oDXZhtFL4TKUhFpuhJ9Q3Y8zwbPSImrW
         Kwxg41rksTJ3tf51DaXhBrMNtIaddazyzG+ilXcl+q/7jun7kh1h82NLUCHYSDPXwWD1
         I+V49PHYOAF3zcvwfkUaN2T7rESYC5c0ecIeaxUbqb4og470jcC/coRIAUa0qB3oate9
         sdHTW6e/W5EtU5eedNVcEbNtiRo4GVgXwb7saJ8IKw5Ebrl4Xe8n3QPq7oBdi1tuCN2U
         KorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cHzTU6SsKJjIN0hxKTOt2NilxUhbuktKMFKGi7O4BN8=;
        b=S1okXKqX3z5aHUCRbX35vyvZoswtL7duh6eg9625m4i5lGmM6jM8at98R8SbOkOyrU
         DZKN4yDDMG+YUf6MPQAQl8/eYGQGAfsOAqRa2XaqzqZNNKX5eqwLq8Sihyc374zFaroM
         fhwnKGmg6n4u07MCyunWg4YP9UY6BPhzTjvuoZVGMyf3kdzD+LVmaS6AEDP62DqDKx/l
         moL1TfTnWMa3FtZHWHXmuuiAVTCJO9CocqDkzp0VBLWbwC5kgWW+f88I+V4ntZuq/G5I
         S0k2fl+JL9slcpcclPFIabSScsbo63V2NaVJU2C9wmo/561duPdPVE3dxf5u41v4yBXb
         5BxQ==
X-Gm-Message-State: AGi0PuaXqGnHUgyHt6tauNy3yqzqDeNPdujKbnQhkstCFV8DVyBvZ1iG
        Vyytb+03RhxA9xHkwrpcXQ==
X-Google-Smtp-Source: APiQypKU6PWU29XNXbYDSwTwwKrAi15KI8UICP1gDJEhw9v9kbVGvhKjkLhGiwNGM3yWV5ppDw4//A==
X-Received: by 2002:a17:902:8b88:: with SMTP id ay8mr17775581plb.235.1589249867946;
        Mon, 11 May 2020 19:17:47 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.8])
        by smtp.gmail.com with ESMTPSA id e11sm10179096pfl.85.2020.05.11.19.17.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 19:17:47 -0700 (PDT)
Subject: Re: [PATCH] xfs: fix the warning message in xfs_validate_sb_common()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
 <20200511152748.GB6730@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <a2285c1e-2b96-c3ea-e2d7-720e7cb7c345@gmail.com>
Date:   Tue, 12 May 2020 10:17:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511152748.GB6730@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/5/11 23:27, Darrick J. Wong wrote:
> On Sat, May 09, 2020 at 10:59:47PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The warning message should be PQUOTA/GQUOTA_{ENFD|CHKD} can't along
>> with superblock earlier than version 5, so fix it.
> 
> Huh?
> 
> Oh, I see, you're trying to fix someone's shortcut in the logging
> messages.  This is clearer (to me, anyway):
> 
> “Fix this error message to complain about project and group quota flag
> bits instead of "PUOTA" and "QUOTA".”
> 
> I'll commit the patch with the above changelog if that's ok?

Thanks for your comments! Yes, please. This changelog is more cleaer.
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D
> 
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/libxfs/xfs_sb.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
>> index c526c5e5ab76..4df87546bd40 100644
>> --- a/fs/xfs/libxfs/xfs_sb.c
>> +++ b/fs/xfs/libxfs/xfs_sb.c
>> @@ -243,7 +243,7 @@ xfs_validate_sb_common(
>>  	} else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>>  				XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>>  			xfs_notice(mp,
>> -"Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
>> +"Superblock earlier than Version 5 has XFS_{P|G}QUOTA_{ENFD|CHKD} bits.");
>>  			return -EFSCORRUPTED;
>>  	}
>>  
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
