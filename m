Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD84C2BA19
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 05:08:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B6E92078E
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 05:08:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LljqQrxK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgDKFIZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 11 Apr 2020 01:08:25 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:52962 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgDKFIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 11 Apr 2020 01:08:25 -0400
Received: by mail-pj1-f65.google.com with SMTP id ng8so1528248pjb.2
        for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2020 22:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lZWO6huW6/V1Vbk7TRaCRdRefjVgqTYLKeEuF4Yp8J8=;
        b=LljqQrxK3K7cyvvAr1MIkIYwdW0WBK5kmuWQ5U433L6NoKjRAJOW9ZgKn/AFukbCUH
         zd86eRq1YmQNtgd3iNEJntFSDKyCbzhwq+M4c8Xrht8ZGQ1VedkBm4Lzm/T3bU7MUb8K
         UYOu+M/6ME2h5FcdZsdLch4jhdoe6Y0AXB2Pj54tHCzQfB5achysKOFn9QUhGhkj2hYS
         VmAAgDPxkMsZ3ExXyyXN/mRaP+QCetbceas5A+eBr7pJDjC9fl+21kwA5OxiijLMZBhz
         R4DpU2NP6N5cCk4ksjCrH7wlZgZaHWK3q83t0Jh6ErUis+8HIAdeGBsBieqRl6hWg2R4
         4W2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZWO6huW6/V1Vbk7TRaCRdRefjVgqTYLKeEuF4Yp8J8=;
        b=dYjJ0gIJc5TeTDWUnoBIU303Z72K4mehlyIS4BxpQSwPvm0o9sYTiL7OFOkEJGlPNe
         fZtF+x9zWgwuQn/MCq/yr9ile9rXLBHdaUltXrwjp/Yl/rEBdfelM7O8Vsbq2L8lhRYo
         ozacL6xMMEYGyYOYx0d69+qfx7jRymZOchFggw3qHef7lfJmqoHjK/6zOydaLuls0kOY
         MLQe9WxE15IXro0n8P9fPNVHmcTPitnGOMmqyh9DXQ2sTV54a1fXmAdhkD55Eq/GfSp/
         kUQH1eq+6TCuy7t66s0P3jLseApwEVGjWUBL6yvTrc8411XhJd8JMy77tXBuN1stW0Fo
         lViw==
X-Gm-Message-State: AGi0PuY54X9jkj8w9NcDT/B5EupQgI2Qqta3NySTfRIin3oz99gAP26Q
        kImh1I47NakjGLlogaTPaLrMjX4HpA==
X-Google-Smtp-Source: APiQypK2VeKdoJOaK8mKqUqNDu088rqbVIyTqgQQBpBJgYfMF4QlNDt6toVE9NnEZkzK5vyTGaKfQg==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr8511927pjb.96.1586581704731;
        Fri, 10 Apr 2020 22:08:24 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.8])
        by smtp.gmail.com with ESMTPSA id l190sm3211563pfl.212.2020.04.10.22.08.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 22:08:23 -0700 (PDT)
Subject: Re: [PATCH] xfs: simplify the flags setting in xfs_qm_scall_quotaon
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
 <20200410145138.GP6742@magnolia>
 <06737124-3742-e956-b715-0f1f7010170d@gmail.com>
 <20200411031838.GQ6742@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <2092decb-7bbe-cd6c-4242-9f1ee532237b@gmail.com>
Date:   Sat, 11 Apr 2020 13:08:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200411031838.GQ6742@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/4/11 11:18, Darrick J. Wong wrote:
> On Sat, Apr 11, 2020 at 09:09:57AM +0800, kaixuxia wrote:
>>
>> On 2020/4/10 22:51, Darrick J. Wong wrote:
>>> On Fri, Apr 10, 2020 at 04:57:04PM +0800, xiakaixu1987@gmail.com wrote:
>>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>>
>>>> Simplify the setting of the flags value, and only consider
>>>> quota enforcement stuff here.
>>>>
>>>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>>>> ---
>>>>  fs/xfs/xfs_qm_syscalls.c | 6 +++---
>>>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
>>>> index 5d5ac65..944486f 100644
>>>> --- a/fs/xfs/xfs_qm_syscalls.c
>>>> +++ b/fs/xfs/xfs_qm_syscalls.c
>>>> @@ -357,11 +357,11 @@
>>>
>>> No idea which function this is.  diff -p, please.
>>
>> Yeah, the changed function is xfs_qm_scall_quotaon().
>> Anyway, the result of diff -p as follows,
> 
> That was a request to generate your patches with diff -Naurp.

Got it, I will resend all the patches that have not been applied by
the xfs for-next branch with a single patchset.

> 
> --D
> 
>> *** fs/xfs/xfs_qm_syscalls.c	Sat Apr 11 08:32:03 2020
>> --- /tmp/xfs_qm_syscalls.c	Sat Apr 11 08:31:51 2020
>> *************** xfs_qm_scall_quotaon(
>> *** 357,367 ****
>>   	int		error;
>>   	uint		qf;
>>   
>>   	/*
>> ! 	 * Switching on quota accounting must be done at mount time,
>> ! 	 * only consider quota enforcement stuff here.
>>   	 */
>> ! 	flags &= XFS_ALL_QUOTA_ENFD;
>>   
>>   	if (flags == 0) {
>>   		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
>> --- 357,367 ----
>>   	int		error;
>>   	uint		qf;
>>   
>> + 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>>   	/*
>> ! 	 * Switching on quota accounting must be done at mount time.
>>   	 */
>> ! 	flags &= ~(XFS_ALL_QUOTA_ACCT);
>>   
>>   	if (flags == 0) {
>>   		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
>>
>>>
>>> Also, please consider putting all these minor cleanups into a single
>>> patchset, it's a lot easier (for me) to track and land one series than
>>> it is to handle a steady trickle of single patches.
>> Yeah, got it. Should I resend all of the patches that have been
>> reviewed or just resend the last two patches with a single patchset?
>>
>> The patches that have been reviewed as follows,
>> xfs: trace quota allocations for all quota types
>> xfs: combine two if statements with same condition
>> xfs: check if reserved free disk blocks is needed
>> xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
>>
>> The last two patches that have not been reviewed as follow,
>> xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
>> xfs: simplify the flags setting in xfs_qm_scall_quotaon
>>
>>>
>>> --D
>>>
>>>>  	int		error;
>>>>  	uint		qf;
>>>>  
>>>> -	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>>>>  	/*
>>>> -	 * Switching on quota accounting must be done at mount time.
>>>> +	 * Switching on quota accounting must be done at mount time,
>>>> +	 * only consider quota enforcement stuff here.
>>>>  	 */
>>>> -	flags &= ~(XFS_ALL_QUOTA_ACCT);
>>>> +	flags &= XFS_ALL_QUOTA_ENFD;
>>>>  
>>>>  	if (flags == 0) {
>>>>  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
>>>> -- 
>>>> 1.8.3.1
>>>>
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
