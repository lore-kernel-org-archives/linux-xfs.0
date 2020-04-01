Return-Path: <SRS0=BKGZ=5R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F95C43331
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 01:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3C7B20CC7
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Apr 2020 01:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyFugIoU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731548AbgDABuq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Mar 2020 21:50:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38543 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731506AbgDABup (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Mar 2020 21:50:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id c21so10637992pfo.5
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2020 18:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4eg8apBhVcz98FQ5cTNrXQTmHz03j2+ajHEM4q1Qigc=;
        b=eyFugIoUyUMHut5fEdoGiSRjcWnSHAGSgsQL/tft1qrPSMijgTE9UmCYqtTS8W4R5V
         vf2EdcBiv32rXDOWASd6rPaTT1slBS+P4ma7AD+6WPBbVMwmfNhbvH9DpxmjeHDBvHu9
         6mXlCQq3S65ybQ6ILx7cx+yrApOYn2hoobQY3CkFuPlL0aSAKc2+tl0NLd0YM3OvxdVN
         wrWJQnGi3LhSR0sbhaStcxcLOiofs2KTCXMpdlz+z1MC1prKTc1AhLXBU1xmETYpFClw
         dKf9vouflq7tjOPnnmhI0oXYkwJHANVUM9HSzWZXQGQbgwTQdMStgSaBsrmh9V2fMI02
         5V3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4eg8apBhVcz98FQ5cTNrXQTmHz03j2+ajHEM4q1Qigc=;
        b=hXuvruJxkhA60Pf6fzrzjQKUNDctKDm5mPmcKJyFyrc1XD4IO4qMAZcWMuNg2VStuZ
         EAfo0FDHuYtMzORVWbyu1KVSLFMwvysCLgoi2/xr9Eh1a+eIJMSl1psAz572pGmr9fS1
         KvZsfU9F6WFEn4IMAFRuMMtOetRpx3Oo07oVOnhEhjUOZ7+cAqQaqL1vOLBM5o6lcvt5
         sH8k7nq9dvdlCrMDDfz7C4qGMx0YvDj7mB5FBUHO332o6gvyXNFlo6zYnaoqTJiMSbGF
         1RtZzdrENhbT0cyG9H8s1xyIlY+b5JS+Gm9hmIEpy22xvbLIrsW/jYmztPOR3wzXyjg4
         LhMg==
X-Gm-Message-State: AGi0PuYVsf/oxCwmadoRlah1BcqSlLn5D0bD/62yyE4GtdYFTC3QK/yN
        MTQUL43GAfpHT97+13Q3No/vTrVI3Q==
X-Google-Smtp-Source: APiQypKEDDzqh5kZmebc9xt/biur7d0SJGQtLW44aJfuPweWzLGpQN93Y4g9KpzKINEAUqOiszO0qA==
X-Received: by 2002:a63:296:: with SMTP id 144mr6882323pgc.110.1585705844603;
        Tue, 31 Mar 2020 18:50:44 -0700 (PDT)
Received: from [10.76.90.30] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id t3sm335384pfl.26.2020.03.31.18.50.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 18:50:44 -0700 (PDT)
Subject: Re: [PATCH] xfs: move trace_xfs_dquot_dqalloc() to proper place
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1585649387-22890-1-git-send-email-kaixuxia@tencent.com>
 <6b0892fe-0f5a-76dc-cd8e-c52333751436@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <436831f6-8f77-ed9d-4590-82b9285c1e49@gmail.com>
Date:   Wed, 1 Apr 2020 09:50:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6b0892fe-0f5a-76dc-cd8e-c52333751436@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/4/1 5:02, Eric Sandeen wrote:
> On 3/31/20 5:09 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The trace event xfs_dquot_dqalloc does not depend on the
>> value uq, so move it to proper place.
> 
> Long ago, the tracing did depend on uq (see 0b1b213fcf3a):
> 
>         if (uq)
> -               xfs_dqtrace_entry_ino(uq, "DQALLOC", ip);
> +               trace_xfs_dquot_dqalloc(ip);
> 
> and I agree that only tracing the inode if user quota is set seems wrong.
> 
> (FWIW, the old tracepoint traced much more than just the inode, it got all
> the information from the quota)

Yeah, the original tracepoint traced more data, and now it is just
the inode event.
> 
> However, I'm not completely sure about moving the tracepoint higher in the function;
> now it tells us that we entered the function but not if we successfully allocated
> the quota?
> 
> So my only concern is that it changes the meaning of this tracepoint a little bit,
> from "we completed the function" more to "we entered the function"
> 
> Not sure how much that matters in practice.
> 
> But that makes this change do 2 things in 1 patch:
> 
> 1) don't depend on uq, and
> 2) change when we trace
> 
> I'd rather see:
> 
> [PATCH] xfs: trace quota allocations for all quota types
> 
> -	if (uq)
> -		trace_xfs_dquot_dqalloc(ip);
> + 	trace_xfs_dquot_dqalloc(ip);
> 

Make more sense, thanks for your suggestion, will follow it in next version.

> and if there's a good reason to /move/ the tracepoint as well, do that separately.
> 
> -Eric
> 
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>m>
>> ---
>>  fs/xfs/xfs_qm.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
>> index 0b09096..5569af9 100644
>> --- a/fs/xfs/xfs_qm.c
>> +++ b/fs/xfs/xfs_qm.c
>> @@ -1631,6 +1631,8 @@ struct xfs_qm_isolate {
>>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>>  		return 0;
>>  
>> +	trace_xfs_dquot_dqalloc(ip);
>> +
>>  	lockflags = XFS_ILOCK_EXCL;
>>  	xfs_ilock(ip, lockflags);
>>  
>> @@ -1714,8 +1716,6 @@ struct xfs_qm_isolate {
>>  			pq = xfs_qm_dqhold(ip->i_pdquot);
>>  		}
>>  	}
>> -	if (uq)
>> -		trace_xfs_dquot_dqalloc(ip);
>>  
>>  	xfs_iunlock(ip, lockflags);
>>  	if (O_udqpp)
>>

-- 
kaixuxia
