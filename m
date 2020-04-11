Return-Path: <SRS0=7tHi=53=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086CEC2D0EC
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 01:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2CB220753
	for <linux-xfs@archiver.kernel.org>; Sat, 11 Apr 2020 01:10:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z38a+kZp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgDKBKG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 21:10:06 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41199 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbgDKBKG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Apr 2020 21:10:06 -0400
Received: by mail-pl1-f194.google.com with SMTP id d24so1200167pll.8
        for <linux-xfs@vger.kernel.org>; Fri, 10 Apr 2020 18:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThJmG/Y9ogfMT6+bDKLBufLQVQGVF72+KVl1C0BqyGc=;
        b=Z38a+kZpUGoDnfvyJ6Av3b8XK0uffnoNXeFG2iSs/IYG1QaQLSLJSrPNXxcPDkcmQD
         7zsDR0cLJtWONZIj3ENwJF/rsmUOmrU12w2FrZy7lmStP/HrQ2nBjoVMEqhnDrfqNahm
         xGig4tXmwvWmMjEXDGSGek21WfetvFouRP+LDFoCnnz/3ms+zp3N2iunosc15nQ6aNUW
         ifElYjpZSuQb3/buoO3+/+sXarqRC2s8wUCHsym6Vwn1vfYvqvzfbf7kHh+Nnvje2m73
         lQ2Y8SUOpr7iYbulq6vpt2+/o2KhdXoBYywKZsnkRZ3et5xBc3YhpqmIg089Z6WucICN
         Ks+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThJmG/Y9ogfMT6+bDKLBufLQVQGVF72+KVl1C0BqyGc=;
        b=QLk/jB5ai3ljaD+LjpqVXF5WIko5bnT3FF3q/wprre/2bTonxC026pOm7VVNfl0ZHj
         3SlKeta1dH/234LAojboahRlFBQnsMsJJI520BprwISs05LCp5gF/f1bTk4fnDFQPaFJ
         yifYYjJeq/Imu2SjfONdezewRFY8muxNsfUqLuQccGAdS2qMARaD0By5Su8gWrW4X3KY
         A2GsQakgUIPzMVDXmdCgnvWI52olTJP+rkzzE+Jy2oppOeYwRlcBBSyhbVd1wx/buYo9
         tze58G9r1PQNfuT9B0NcFToapnXvWLHndJxGx6RJaYY056h7s02yD3mzg3vqSOcqGSd3
         elJw==
X-Gm-Message-State: AGi0PuantvOvDrXjgU8I37mEc3Rb0qiddbJQaZYzRo7IxIFtbyAyjTCX
        CXHPPf7EOuEHz3Qj5YABuHDgriS+HA==
X-Google-Smtp-Source: APiQypKWEtRJEXth/KxWAXuc1jSOjSSg6/71Gi8EchELitWuONMwjrQ0TmzTGXrJeIQjQwINqt6cSQ==
X-Received: by 2002:a17:90a:7f96:: with SMTP id m22mr223976pjl.56.1586567406338;
        Fri, 10 Apr 2020 18:10:06 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.8])
        by smtp.gmail.com with ESMTPSA id i124sm2805491pfg.14.2020.04.10.18.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Apr 2020 18:10:05 -0700 (PDT)
Subject: Re: [PATCH] xfs: simplify the flags setting in xfs_qm_scall_quotaon
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1586509024-5856-1-git-send-email-kaixuxia@tencent.com>
 <20200410145138.GP6742@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <06737124-3742-e956-b715-0f1f7010170d@gmail.com>
Date:   Sat, 11 Apr 2020 09:09:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200410145138.GP6742@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/4/10 22:51, Darrick J. Wong wrote:
> On Fri, Apr 10, 2020 at 04:57:04PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> Simplify the setting of the flags value, and only consider
>> quota enforcement stuff here.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_qm_syscalls.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
>> index 5d5ac65..944486f 100644
>> --- a/fs/xfs/xfs_qm_syscalls.c
>> +++ b/fs/xfs/xfs_qm_syscalls.c
>> @@ -357,11 +357,11 @@
> 
> No idea which function this is.  diff -p, please.

Yeah, the changed function is xfs_qm_scall_quotaon().
Anyway, the result of diff -p as follows,

*** fs/xfs/xfs_qm_syscalls.c	Sat Apr 11 08:32:03 2020
--- /tmp/xfs_qm_syscalls.c	Sat Apr 11 08:31:51 2020
*************** xfs_qm_scall_quotaon(
*** 357,367 ****
  	int		error;
  	uint		qf;
  
  	/*
! 	 * Switching on quota accounting must be done at mount time,
! 	 * only consider quota enforcement stuff here.
  	 */
! 	flags &= XFS_ALL_QUOTA_ENFD;
  
  	if (flags == 0) {
  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
--- 357,367 ----
  	int		error;
  	uint		qf;
  
+ 	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
  	/*
! 	 * Switching on quota accounting must be done at mount time.
  	 */
! 	flags &= ~(XFS_ALL_QUOTA_ACCT);
  
  	if (flags == 0) {
  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",

> 
> Also, please consider putting all these minor cleanups into a single
> patchset, it's a lot easier (for me) to track and land one series than
> it is to handle a steady trickle of single patches.
Yeah, got it. Should I resend all of the patches that have been
reviewed or just resend the last two patches with a single patchset?

The patches that have been reviewed as follows,
xfs: trace quota allocations for all quota types
xfs: combine two if statements with same condition
xfs: check if reserved free disk blocks is needed
xfs: remove unnecessary variable udqp from xfs_ioctl_setattr

The last two patches that have not been reviewed as follow,
xfs: remove unnecessary assertion from xfs_qm_vop_create_dqattach
xfs: simplify the flags setting in xfs_qm_scall_quotaon

> 
> --D
> 
>>  	int		error;
>>  	uint		qf;
>>  
>> -	flags &= (XFS_ALL_QUOTA_ACCT | XFS_ALL_QUOTA_ENFD);
>>  	/*
>> -	 * Switching on quota accounting must be done at mount time.
>> +	 * Switching on quota accounting must be done at mount time,
>> +	 * only consider quota enforcement stuff here.
>>  	 */
>> -	flags &= ~(XFS_ALL_QUOTA_ACCT);
>> +	flags &= XFS_ALL_QUOTA_ENFD;
>>  
>>  	if (flags == 0) {
>>  		xfs_debug(mp, "%s: zero flags, m_qflags=%x",
>> -- 
>> 1.8.3.1
>>

-- 
kaixuxia
