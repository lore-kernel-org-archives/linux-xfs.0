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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97780C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FBC72083B
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:17:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pWn84cLB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgIQHRj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726106AbgIQHRj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:17:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29789C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:17:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mm21so788669pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6RSpEfof9ZUMWmtVrnH8hz1PD5/c+I8/5a5hyKpMAV0=;
        b=pWn84cLBC8/FSNzSniBG1cxJ61siOFQ+5Curms45N/r9/+kpZaM6AWQnsIpak1r/5I
         qTOTB8kqtK9DV3hAmSBzVPsBq6LTP8+g1IbZzHVmndFPXfhAej676vmWd/yOcRENno4h
         7FLO+1dGuxX9CQi3i5Hbj1BDXH5jlm5PUIXHTHHgNVbW7iAfAidVInQR88Vacn9vPSS8
         p0UCwYd0OY49HASRmIsMmUNg4lQCz/5dsrezDdL0TDTcVTrl4hm6COpFKDpfLL42i7aw
         lh9eDSWrPBeYcU/Z7eulfI6z1aajviAIyCvkuJxMg2N/gwd0qbFgBn00xl6lBJ3XTDVP
         6gKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6RSpEfof9ZUMWmtVrnH8hz1PD5/c+I8/5a5hyKpMAV0=;
        b=HpLlqFg49rAh2pWSHuta9vFwXL1izp4y3biMITCukRTSCXZzK2V/aLyQYSwJsETKha
         wQIW6HDTO0rzoCEBqgIbptjU0R0fM6/Wajjb+1QwXji3XBlwKiXDIhmgi5XQ1/7me7VY
         DqBIvGgVTRJhkG9jz375tq+C4DJOfIr6q58m7qUWpFgnM7EUjBWgDgZvZQtHUPjGLo/W
         RWWkg/wOVet2jaHaiVXnZSuZyrpbfyEyxWXqcqt9odejWm8/68Lrl7Xihcn6Wo91QT0c
         PbeeQtveQFuW7bVyr/tOsvKMuaNWLeLjAw/axcnU4PZWatnWCXQfAS/rcU/wKYvlxudv
         gruw==
X-Gm-Message-State: AOAM533ltNcPBKgBCHgYdoYKwQ8pBh2WIqh5uT7AcJ9mBoyHoNAQ91oM
        fVmoN7/5YptvLRvqa8TWLQ==
X-Google-Smtp-Source: ABdhPJzXQI04AX4JKvCi0RYLCwa11qr78PZIvfGFY2O3xXUXaC/3OSIATykZmSRDQSlRI4c9TU9hBw==
X-Received: by 2002:a17:902:b60a:b029:d1:f2ad:439c with SMTP id b10-20020a170902b60ab02900d1f2ad439cmr5218912pls.82.1600327058711;
        Thu, 17 Sep 2020 00:17:38 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id n2sm19366266pfe.208.2020.09.17.00.17.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 00:17:38 -0700 (PDT)
Subject: Re: [PATCH] xfs: cleanup the useless backslash in
 xfs_attr_leaf_entsize_remote
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-9-git-send-email-kaixuxia@tencent.com>
 <20200916185028.GJ7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <3b0bb669-d52e-f9b1-a52c-03e4bc1ea1ef@gmail.com>
Date:   Thu, 17 Sep 2020 15:17:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916185028.GJ7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/17 2:50, Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 07:19:11PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The backslash is useless and remove it.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
>> index b40a4e80f5ee..4fe974773d85 100644
>> --- a/fs/xfs/libxfs/xfs_da_format.h
>> +++ b/fs/xfs/libxfs/xfs_da_format.h
>> @@ -746,7 +746,7 @@ xfs_attr3_leaf_name_local(xfs_attr_leafblock_t *leafp, int idx)
>>   */
>>  static inline int xfs_attr_leaf_entsize_remote(int nlen)
>>  {
>> -	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) + \
>> +	return ((uint)sizeof(xfs_attr_leaf_name_remote_t) - 1 + (nlen) +
>>  		XFS_ATTR_LEAF_NAME_ALIGN - 1) & ~(XFS_ATTR_LEAF_NAME_ALIGN - 1);
> 
> If you're going to go mess with these, you might as well clean up the
> typedef usage, the unnecessary parentheses, and the open-coded round_up
> call:
> 
> static inline int xfs_attr_leaf_entsize_remote(int nlen)
> {
> 	return round_up(sizeof(struct xfs_attr_leaf_name_remote) - 1 + nlen,
> 			XFS_ATTR_LEAF_NAME_ALIGN);
> }
> 
> (and similar for xfs_attr_leaf_entsize_local().)
> 
Okay, will do these code cleanups in the next version:)

Thanks,
Kaixu

> --D
> 
>>  }
>>  
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
