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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733C6C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 02:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 284AE20773
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 02:42:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gX6wwGf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgIWCmT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 22:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgIWCmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 22:42:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A29C061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 19:42:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id v14so2395422pjd.4
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 19:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Nr3dOqZfKJL6YV9nWGsReAFmfaRW7zpccB94QzuQAc=;
        b=gX6wwGf5wLD7OmDRi4M5xVrWl1/SlGqiWfqGs822iun6V0u2tYmLhrS+0kE94KpxNb
         ELYzt8kAGoL9YIrDQSnAN+SiTOVDY8j0J1AhF1nlNlQAogpyvXNAwf9+q4oleVBiGRiV
         RHIw7Ae+4iIdJoxhFr5BjATQ7D72wMvuBAYoJoMOMjBVIsVm/9pz5V0AN06GPVjmrRtV
         gHBu6tRYwgoOt2Ri2d469qVuWKQ5gt1J+tnGegGHBOf6YD8Ni/N32fIi+EXWGOqG7kU0
         3bxsq3H7ga6s1IMfB1SsXRoYgyUrAA6oLUTywMTnDJobvsQ6DMYdqQ632V5YuPtQTiTA
         V+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Nr3dOqZfKJL6YV9nWGsReAFmfaRW7zpccB94QzuQAc=;
        b=JL/xzTrY6Y/mtZR+YK9Dd2mAKNmNOrDsJNDrN59tH/u3yLoroC/3s1/Y0it5yXoYC8
         BYAWRMAp+IKVwDr3GWb3pZf6d/R0AsOzobUZ9F8nr/4ac+a/xOK89FYBsTr2ekHuCJNN
         yO2G8Vg2Oqtdqfew+3I/Z1Yn6htdegIL0Q/wLyg2935WG9wyWiJw6Yrv2X3FAwY2nuvg
         lZchgzGsxbsnpY4C5Q3Ljb3kOwDGuMCxGtSyHgbeRNTVW6gLqsWHa/Km66UxuQne0hvI
         nezyvYanEbp2L6wBDZIqTpXfMtYbpNGgHGyPvfKThZEb0Pfk+jSBdTuCIY0Jow3ufyOj
         j1OA==
X-Gm-Message-State: AOAM532Uv7sbKxBA74GAcrRKKPdfQtOEtLuOyVtiP2dV+oe+eroCebr7
        m1NVgOLI3Gy339HLLWbA2env2/6cO/G3HRI=
X-Google-Smtp-Source: ABdhPJxmtzxz6MkLFYQXc57Pnd+y/zZ8foOEMc6qbnkjcsY80IQ6vBcAAHzfXMULtGNWTyaC8/oJ5w==
X-Received: by 2002:a17:90a:d3cd:: with SMTP id d13mr6723478pjw.70.1600828939065;
        Tue, 22 Sep 2020 19:42:19 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id 25sm15917694pfj.35.2020.09.22.19.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:42:18 -0700 (PDT)
Subject: Re: [PATCH 1/3] xfs: directly return if the delta equal to zero
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1600765442-12146-1-git-send-email-kaixuxia@tencent.com>
 <1600765442-12146-2-git-send-email-kaixuxia@tencent.com>
 <20200922174347.GG2175303@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <2818363e-a860-99e4-5b55-9721abb5058a@gmail.com>
Date:   Wed, 23 Sep 2020 10:42:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200922174347.GG2175303@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/23 1:43, Brian Foster wrote:
> On Tue, Sep 22, 2020 at 05:04:00PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> It is useless to go on when the variable delta equal to zero in
>> xfs_trans_mod_dquot(), so just return if the value equal to zero.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>> index 133fc6fc3edd..23c34af71825 100644
>> --- a/fs/xfs/xfs_trans_dquot.c
>> +++ b/fs/xfs/xfs_trans_dquot.c
>> @@ -215,10 +215,11 @@ xfs_trans_mod_dquot(
>>  	if (qtrx->qt_dquot == NULL)
>>  		qtrx->qt_dquot = dqp;
>>  
>> -	if (delta) {
>> -		trace_xfs_trans_mod_dquot_before(qtrx);
>> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>> -	}
>> +	if (!delta)
>> +		return;
>> +
> 
> 
> This does slightly change behavior in that this function currently
> unconditionally results in logging the associated dquot in the
> transaction. I'm not sure anything really depends on that with a delta
> == 0, but it might be worth documenting in the commit log.
>> Also, it does seem a little odd to bail out after we've potentially
> allocated ->t_dqinfo as well as assigned the current dquot a slot in the
> transaction. I think that means the effect of this change is lost if
> another dquot happens to be modified (with delta != 0) in the same
> transaction (which might also be an odd thing to do).
>
Since the dquot value doesn't changes if the delta == 0, we shouldn't
set the XFS_TRANS_DQ_DIRTY flag to current transaction. Maybe we should
do the judgement at the beginning of the function, we will do nothing if
the delta == 0. Just like this,

 xfs_trans_mod_dquot(
 {
   ...
   if (!delta)
     return;
   if (tp->t_dqinfo == NULL)
     xfs_trans_alloc_dqinfo(tp);
   ...
 }

I'm not sure...What's your opinion about that?

Thanks,
Kaixu

> Brian
> 
>> +	trace_xfs_trans_mod_dquot_before(qtrx);
>> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>>  
>>  	switch (field) {
>>  
>> @@ -284,8 +285,7 @@ xfs_trans_mod_dquot(
>>  		ASSERT(0);
>>  	}
>>  
>> -	if (delta)
>> -		trace_xfs_trans_mod_dquot_after(qtrx);
>> +	trace_xfs_trans_mod_dquot_after(qtrx);
>>  
>>  	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>>  }
>> -- 
>> 2.20.0
>>
> 

-- 
kaixuxia
