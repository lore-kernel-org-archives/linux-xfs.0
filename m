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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81728C433E2
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4155E21974
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 07:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ovMTXau/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgIQHDz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 03:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgIQHDl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:03:41 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD564C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:03:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f18so610855pfa.10
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 00:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ixskfE/CcGTzjJqgCfzb5vyKyI1MdMIrU1Nbvy5oWk8=;
        b=ovMTXau/nLp/J2mXoNbenactTqXr3WX6iyuem0T9NFM5F1/aE0ZrGGfZIbXyZ0dBSy
         RLx4t8SxFyB6O6iU0tTZSTostlnRvnAhD38WDvpXCZP7fzRbMDhv1sY0KbDCBM30tAue
         INkaoKQmezslM+6bVNv/zf8b7UKn2uQAJRGPFP5SW8Vs9eqM4PIvDjdbyeHB9EwQusqs
         YCSaxu7lh25xvF4PkQXmzMyNf7IYtWzrrIfu9ciaSDvbnxFFtnuSUXWUOXUAqo2uC5C8
         8ii11lawy+JdDqMA35kuzsdnN4TvGhY+encmxQiS2zx1gingEiB2R5fh5kod/DufUs3E
         uRag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ixskfE/CcGTzjJqgCfzb5vyKyI1MdMIrU1Nbvy5oWk8=;
        b=N7q4uAZdGQVI4Cxvgc8m9JJnHmzXV2vlFflcoCfXa+/jHcp98/OWZWZxCnz2FNaKQN
         IgNcSt+DB95qGmTptvrVnw6QEFcuCu2wws0JAxML1Vh83+98/lRku01mBsCXffyLQqQF
         IhzQmcUurlCkkEO9kNv7Sp7pXLItqihefeJbeONMo9YZD4wH1o7kk6cD+IzdhgVdBJAj
         ApjoUB0qvu5iRBs9VKtVYpbWyD7IXY61r0jpbVR4iyCI89szWDABRvz0DMzK58Gh6T9f
         ct5x598IslSWvEY4faIsmKh4jkRavsv8htAKEB4sU+lsmGjhScamu1mnphpdCHXmddEK
         ATaQ==
X-Gm-Message-State: AOAM532c4QaCFY4f+uIjKell1vKT3YjZ5s3BYLc062MpYkE3W5+/7O9c
        JelTQtmpLBnrqefum5iKfA==
X-Google-Smtp-Source: ABdhPJypL8E2Qw9r8CWbCB/XjcTtxK4DkF+iD//iLUCvGg+dKJ3H80WmfvZnGYd1DjvvrCNgwwjERQ==
X-Received: by 2002:a05:6a00:23cc:b029:142:2501:34e5 with SMTP id g12-20020a056a0023ccb0290142250134e5mr10123498pfc.62.1600326213983;
        Thu, 17 Sep 2020 00:03:33 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id d6sm4696193pjw.0.2020.09.17.00.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 00:03:33 -0700 (PDT)
Subject: Re: [PATCH] xfs: remove the repeated crc verification in
 xfs_attr3_rmt_verify
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-8-git-send-email-kaixuxia@tencent.com>
 <20200916184545.GI7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <faf768f0-8db1-0188-fbf2-73bc6538178d@gmail.com>
Date:   Thu, 17 Sep 2020 15:03:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916184545.GI7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/17 2:45, Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 07:19:10PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We already do the crc verification before calling the xfs_attr3_rmt_verify()
> 
> Nit: The function call you're removing does not itself do crc
> verification; it merely checks that the *crc feature* is set.  This
> commit message needs to make this distinction, because at first I
> thought "Why would you remove crc verification?"
> 
> IOWs...
> 
> "We already check that the crc feature is enabled before calling
> xfs_attr3_rmt_verify(), so remove the redundant feature check in that
> function."

Yes, right! The original commit message is confusing, will update it
in the next version.

Thanks,
Kaixu
> 
> --D
> 
>> function, and just return directly for non-crc buffers, so don't need
>> to do the repeated crc verification in xfs_attr3_rmt_verify().
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr_remote.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 3f80cede7406..48d8e9caf86f 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -96,8 +96,6 @@ xfs_attr3_rmt_verify(
>>  {
>>  	struct xfs_attr3_rmt_hdr *rmt = ptr;
>>  
>> -	if (!xfs_sb_version_hascrc(&mp->m_sb))
>> -		return __this_address;
>>  	if (!xfs_verify_magic(bp, rmt->rm_magic))
>>  		return __this_address;
>>  	if (!uuid_equal(&rmt->rm_uuid, &mp->m_sb.sb_meta_uuid))
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
