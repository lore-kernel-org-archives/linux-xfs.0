Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FAE0C6FA8F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 01:07:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238960AbjHXBHB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 21:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbjHXBG4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 21:06:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C61010F3
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 18:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692839163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xq6vs6SWerfeM/JoyghzHvsCvHs+FuE2XPhdX8X0ncc=;
        b=Q3UlozOfZEM+FgwljEZyNXKXOy0IKREdZ+z4ziMCBHtRAOgifxm1cjCLMa4Fbu9mjzLszX
        D/hBkKnljb/WylCp87MLgXJ1pmPMTYSswQzcr5tTr0Nt9yM9W5/zMbWxclZB6tv+WvitX/
        6NH/XYmmpj58XEPuq3sfkzD7sWRK+gU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-2oLHAdn-M6SyKcE9kNOPPA-1; Wed, 23 Aug 2023 21:06:01 -0400
X-MC-Unique: 2oLHAdn-M6SyKcE9kNOPPA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-68a2188f7fdso510833b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 18:06:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692839160; x=1693443960;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xq6vs6SWerfeM/JoyghzHvsCvHs+FuE2XPhdX8X0ncc=;
        b=KlPWMODySaK3uN1QhtVuP0n2m3NkAq9dB5vTkw8semDjt/kgS45FqUJhgPDeV/i9JD
         WeDDwexbUIcW6r3QOj6o1UMYWLiFWp+AzBB4ciSGBwMiqCNgEReJECDXkq6o1Aka4pSV
         b3CXijwaQxyhXmySjSK1Zu0ZkcfjAAzhJwgl20gd+BXe6T/4le9qyaYiYZF8aTbvnxQA
         o1Y4ZepK8sawlLKnbCCR/n7LVHm+RQ/CqkaLlMt8qxLCtapRoYOROimBeqGt0GJiCKHV
         zWNBXwEVOWpliBPsYElRnJ9p/CpHHFSkup6hqMOr89omcdnihidvUpQGehQJTYMjXmzG
         9j0w==
X-Gm-Message-State: AOJu0Yz2ttzPlcyYCMeJcra2h6X6/K18B/8KL26Hus/d6aLcD42pcMBG
        aEDXO3GO9xAT0BjcthxcBl31oMi+gmfCTJ5D9yCHXLPLANMPW4h/7LRuGsfVV/91YtBzvshp1Ad
        /VsgZczw6+jIScLX7crmKf31zxIoi
X-Received: by 2002:a05:6a20:1615:b0:13d:71f4:fd8a with SMTP id l21-20020a056a20161500b0013d71f4fd8amr19151052pzj.13.1692839160182;
        Wed, 23 Aug 2023 18:06:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHgIBWOj1OhtYr0z/MJ2IUiiR8eta5SvSSNl1rbrE2jey1HqZY/LtN50n4nqktbgvnKJnwkpw==
X-Received: by 2002:a05:6a20:1615:b0:13d:71f4:fd8a with SMTP id l21-20020a056a20161500b0013d71f4fd8amr19151024pzj.13.1692839159819;
        Wed, 23 Aug 2023 18:05:59 -0700 (PDT)
Received: from ?IPV6:2001:8003:4b08:fb00:e45d:9492:62e8:873c? ([2001:8003:4b08:fb00:e45d:9492:62e8:873c])
        by smtp.gmail.com with ESMTPSA id d5-20020aa78145000000b00687a4b70d1esm9989118pfn.218.2023.08.23.18.05.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Aug 2023 18:05:59 -0700 (PDT)
Message-ID: <1eb8b810-2578-0948-278a-9a99611eb83d@redhat.com>
Date:   Thu, 24 Aug 2023 11:05:54 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v2] xfsrestore: suggest -x rather than assert for false
 roots
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Pavel Reichl <preichl@redhat.com>
References: <20230807045357.360114-1-ddouwsma@redhat.com>
 <20230822183401.GD11263@frogsfrogsfrogs>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20230822183401.GD11263@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 23/8/23 04:34, Darrick J. Wong wrote:
> On Mon, Aug 07, 2023 at 02:53:57PM +1000, Donald Douwsma wrote:
>> If we're going to have a fix for false root problems its a good idea to
>> let people know that there's a way to recover, error out with a useful
>> message that mentions the `-x` option rather than just assert.
>>
>> Before
>>
>>    xfsrestore: searching media for directory dump
>>    xfsrestore: reading directories
>>    xfsrestore: tree.c:757: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth' failed.
>>    Aborted
>>
>> After
>>
>>    xfsrestore: ERROR: tree.c:791: tree_begindir: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.
>>    xfsrestore: ERROR: False root detected. Recovery may be possible using the `-x` option
>>    Aborted
>>
>> Fixes: d7cba7410710 ("xfsrestore: fix rootdir due to xfsdump bulkstat misuse")
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>>
>> ---
>> Changes for v2
>> - Use xfsprogs style for conditional
>> - Remove trailing white-space
>> - Place printf format all on one line for grepability
>> - use __func__ instead of gcc specific __FUNCTION__
>> ---
>>   restore/tree.c | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/restore/tree.c b/restore/tree.c
>> index bfa07fe..e959aa1 100644
>> --- a/restore/tree.c
>> +++ b/restore/tree.c
>> @@ -783,8 +783,15 @@ tree_begindir(filehdr_t *fhdrp, dah_t *dahp)
>>   	/* lookup head of hardlink list
>>   	 */
>>   	hardh = link_hardh(ino, gen);
>> -	if (need_fixrootdir == BOOL_FALSE)
>> -		assert(ino != persp->p_rootino || hardh == persp->p_rooth);
>> +	if (need_fixrootdir == BOOL_FALSE &&
>> +		!(ino != persp->p_rootino || hardh == persp->p_rooth)) {
>> +		mlog(MLOG_ERROR | MLOG_TREE,
> 
> Nit: Second line of the if test has the same level of indentation as the
> if body.

Urg, I cant unsee it now, will fix.

Thanks for the Review(s)
Don

> 
> With that fixed,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>> +"%s:%d: %s: Assertion `ino != persp->p_rootino || hardh == persp->p_rooth` failed.\n",
>> +			__FILE__, __LINE__, __func__);
>> +		mlog(MLOG_ERROR | MLOG_TREE, _(
>> +"False root detected. Recovery may be possible using the `-x` option\n"));
>> +		return NH_NULL;
>> +	}
>>   
>>   	/* already present
>>   	 */
>> -- 
>> 2.39.3
>>
> 

