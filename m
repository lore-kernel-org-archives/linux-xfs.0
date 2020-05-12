Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92BBEC47255
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 686152070B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 02:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RINKNLgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgELC1u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 22:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgELC1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 22:27:49 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32BC061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:27:48 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t16so4727340plo.7
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 19:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ROgcahKfcmtrbE1MHFZr+IrdHRYIm8g3EvCFgWDcseI=;
        b=RINKNLglXPbLtaCKZZAG+qDVgZvrPoztexmdOdtB0F6BROcELtr3bZxYfMRZ2wUnB6
         nwJmawF9EOY6+6mqaBZddVqqnEhydOjcRTEz1Stgrk1tnmCIX3uvFYvSzZau7ESTXYVP
         QksdVqhT5icFpjAb99MjJ36Op3e0rWABxU0hiQGVfnqXNaQ2KpGI/+fjy35XpQ0cZfcV
         tORBfR1CzE9pUx6L470s2V4UVbxdIB4gB9hQIORniA5jZvOBjPjes9J1I/U94H79Ygp7
         n9o4aMjwLYP8/bjLbxKlBvS2TkmHqfS6wDJiY/h7gNm7wwYRtTJhOtDtuP/YgxCVU82o
         jfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ROgcahKfcmtrbE1MHFZr+IrdHRYIm8g3EvCFgWDcseI=;
        b=lXtOtxtrAKz3/cA+je1GOx63G2irpf/5OalJ59cQaDv7NhYbDEvVfN9cUlLqOQ7/RD
         C2Y3APHAMWdMelrShhgGcKVPrrmt2IziuLMNJSdYskODi/6BF0goWVnzwyygvsj5Xr7R
         BVjjpws+yyY3M08ZYYAM/R/0QxG6sd7veAmL0ZIizWT9Zzmkafh4pJiHKYRegxTAn8J7
         cGAow6YMv/hfDR/lD4/n/A9hm2Oed7xRh5h1OIAB9ZwLMmuvkek1O/7LrJ40Ys2p5W3D
         6RZTpjhLASPnPH6Zeff9y1fRybMZT9Mww8XrfXqGTy3rtxg0pwaWWzxbdO042gHczduL
         l9lA==
X-Gm-Message-State: AGi0PuYmTeKdPAG2Gqwz2VWLCI0bCF1KZJ0Xalv48WXb1mPO+afV0qUQ
        DAztCwotILphYRFYkpkcNA==
X-Google-Smtp-Source: APiQypK4WjVQk0inrLOS52G8xlcNBI13OLsyBL0PW5D3uYekcx3OvI6BZZAp5rRmk3mFnLFv6dcrNg==
X-Received: by 2002:a17:90a:1f8f:: with SMTP id x15mr26030879pja.76.1589250467746;
        Mon, 11 May 2020 19:27:47 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.8])
        by smtp.gmail.com with ESMTPSA id u5sm10592951pfu.198.2020.05.11.19.27.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 19:27:47 -0700 (PDT)
Subject: Re: [PATCH] xfs: fix the warning message in xfs_validate_sb_common()
To:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1589036387-15975-1-git-send-email-kaixuxia@tencent.com>
 <20200511152748.GB6730@magnolia>
 <a3d25295-8ebe-a5fc-15e4-987bf3b72608@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <c25bf328-3671-fcff-0492-5b03bbac00b2@gmail.com>
Date:   Tue, 12 May 2020 10:27:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <a3d25295-8ebe-a5fc-15e4-987bf3b72608@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/5/12 3:39, Eric Sandeen wrote:
> 
> 
> On 5/11/20 10:27 AM, Darrick J. Wong wrote:
>> On Sat, May 09, 2020 at 10:59:47PM +0800, xiakaixu1987@gmail.com wrote:
>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>
>>> The warning message should be PQUOTA/GQUOTA_{ENFD|CHKD} can't along
>>> with superblock earlier than version 5, so fix it.
>>
>> Huh?
>>
>> Oh, I see, you're trying to fix someone's shortcut in the logging
>> messages.  This is clearer (to me, anyway):
>>
>> “Fix this error message to complain about project and group quota flag
>> bits instead of "PUOTA" and "QUOTA".”
>>
>> I'll commit the patch with the above changelog if that's ok?
> 
> Honestly the other message is pretty terrible too, while we're fixing things
> here:
> 
>         if (xfs_sb_version_has_pquotino(sbp)) {
>                 if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
>                         xfs_notice(mp,
>                            "Version 5 of Super block has XFS_OQUOTA bits.");
>                         return -EFSCORRUPTED;
>                 }
>         } else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>                                 XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>                         xfs_notice(mp,
> "Superblock earlier than Version 5 has XFS_[PQ]UOTA_{ENFD|CHKD} bits.");
>                         return -EFSCORRUPTED;
>         }
> 
> maybe we can at least agree that superblock is 1 word and doesn't need to
> be capitalized ;)
> 
> (and really, none of this information is going to be useful to the admin anyway,
> so how about just):
> 
>         if (xfs_sb_version_has_pquotino(sbp)) {
>                 if (sbp->sb_qflags & (XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD)) {
>                         xfs_notice(mp, "Quota flag sanity check failed");
>                         return -EFSCORRUPTED;
>                 }
>         } else if (sbp->sb_qflags & (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD |
>                                 XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD)) {
>                         xfs_notice(mp, "Quota flag sanity check failed");
>                         return -EFSCORRUPTED;
>         }
>
Yeah, this message is simple and clear, but maybe the original message can
give more information why superblock validate failed. 
 
> or some tidier version of that logic.
> -Eric
> 

-- 
kaixuxia
