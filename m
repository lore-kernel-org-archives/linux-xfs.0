Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B89FC4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:11:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22ADF20773
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:11:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILPFR952"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbgIWDLW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 23:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbgIWDLW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 23:11:22 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F3BC061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:11:22 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so9354720pfo.12
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ylHJU6KBYCPUtH8wl+u3EU9kOaodxq4KruiYgWtcuUg=;
        b=ILPFR952dop5h+YDxqpd39F2aIpShomjxEWg4xw0Dmr9h+dpXHlb8Os8MIq+0+zPcb
         S+XTVj0n+srHEy06p0nPf3Do1lK62BI+jm0kKgZzlcs0tEBSwE5ML6Fk6wTZ8rCuJblI
         c8BWVGKInXoAnMwXpasqDu8VZYSSgV7lTQfhU1gaE/rSViaDaQEtUsf+dDCrQr/3nMZO
         WfxDy8264DyETOv9B+CuMHHEH/7yTzc8QAiTqqkq8a6+vjP+mAqI/UOh+QFachV0JSqd
         YQt2VkHp0d9UBzNUax6EwxhIuoL9trAWcjR7+oBUxnHcmPru/E4xNSIX28Y6stxUjCEJ
         q9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ylHJU6KBYCPUtH8wl+u3EU9kOaodxq4KruiYgWtcuUg=;
        b=Au3xjNPKJStZuYl8moFHtuSmKRlkaeeAXpzy50e+Ci3HC1nJ/yBnGvRgzGeGw8htve
         /i0681qYXErZxczS0V/8XlE9l6i33tYye90iRbM+Xp1bKGVWZVQ9BKQNVvTm0kOFuiBN
         DFpWqBgdNxMFzV1XoRLk0dPKZ+iq+3iPDQXaVaAPfBjDD9/X6+biYUqaicGsJWaKEAlV
         czIILlAMwyVunSXRzfKg57tc0xITLBu4+r22aIJBp6oOPRFN/hvpPTMR222RzqVr+jSA
         aK/NF3YeC/EAI4EQzU70yxWH0FX9WoLKvbTdMBPOxvsUjnhIfFmc27aCcF8I/KtT93XZ
         NrrA==
X-Gm-Message-State: AOAM533I67mQGWp7nGntUDsrald6uv0zQlozl9K/pwEQMWLksaSXFBOv
        UPwIOVW8fokNW3qO+CdIPA==
X-Google-Smtp-Source: ABdhPJx2+WeGUa71yuLYC2VvUxTHW3AJ35mfUtYKE91vclUxpvCDccKRTLOGNrPH/eJKKaj69PHcKQ==
X-Received: by 2002:a05:6a00:1507:b029:13e:d13d:a13c with SMTP id q7-20020a056a001507b029013ed13da13cmr6820762pfu.36.1600830681944;
        Tue, 22 Sep 2020 20:11:21 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id l24sm109547pgh.93.2020.09.22.20.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 20:11:21 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: only do dqget or dqhold for the specified dquots
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-4-git-send-email-kaixuxia@tencent.com>
 <20200922161843.GH7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <c80061cc-01db-26bc-ea63-61f1e9a9a4db@gmail.com>
Date:   Wed, 23 Sep 2020 11:11:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922161843.GH7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/23 0:18, Darrick J. Wong wrote:
> On Tue, Sep 22, 2020 at 05:04:02PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We attach the dquot(s) to the given inode and return udquot, gdquot
>> or pdquot with references taken by dqget or dqhold in xfs_qm_vop_dqalloc()
>> funciton. Actually, we only need to do dqget or dqhold for the specified
>> dquots, it is unnecessary if the passed-in O_{u,g,p}dqpp value is NULL.
> 
> When would a caller pass in (for example) XFS_QMOPT_UQUOTA, a different
> uid than the one currently associated with the inode, but a null
> O_udqpp?  It doesn't make sense to say "Prepare to change this file's
> uid, but don't give me the dquot of the new uid."
> 
> None of the callers do that today, so I don't see the point of this
> patch.  Perhaps the function could ASSERT the arguments a little more
> closely?

Yeah, ASSERT the arguments is better, will do that in the next version.

Thanks,
Kaixu
 
> 
> --D
> 
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_qm.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index 44509decb4cd..38380fc29b4d 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -1661,7 +1661,7 @@ xfs_qm_vop_dqalloc(
>>  		}
>>  	}
>>  
>> -	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
>> +	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp) && O_udqpp) {
>>  		if (!uid_eq(inode->i_uid, uid)) {
>>  			/*
>>  			 * What we need is the dquot that has this uid, and
>> @@ -1694,7 +1694,7 @@ xfs_qm_vop_dqalloc(
>>  			uq = xfs_qm_dqhold(ip->i_udquot);
>>  		}
>>  	}
>> -	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
>> +	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp) && O_gdqpp) {
>>  		if (!gid_eq(inode->i_gid, gid)) {
>>  			xfs_iunlock(ip, lockflags);
>>  			error = xfs_qm_dqget(mp, from_kgid(user_ns, gid),
>> @@ -1711,7 +1711,7 @@ xfs_qm_vop_dqalloc(
>>  			gq = xfs_qm_dqhold(ip->i_gdquot);
>>  		}
>>  	}
>> -	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
>> +	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp) && O_pdqpp) {
>>  		if (ip->i_d.di_projid != prid) {
>>  			xfs_iunlock(ip, lockflags);
>>  			error = xfs_qm_dqget(mp, prid,
>> @@ -1733,16 +1733,11 @@ xfs_qm_vop_dqalloc(
>>  	xfs_iunlock(ip, lockflags);
>>  	if (O_udqpp)
>>  		*O_udqpp = uq;
>> -	else
>> -		xfs_qm_dqrele(uq);
>>  	if (O_gdqpp)
>>  		*O_gdqpp = gq;
>> -	else
>> -		xfs_qm_dqrele(gq);
>>  	if (O_pdqpp)
>>  		*O_pdqpp = pq;
>> -	else
>> -		xfs_qm_dqrele(pq);
>> +
>>  	return 0;
>>  
>>  error_rele:
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
