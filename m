Return-Path: <SRS0=54mU=DR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61ECBC433E7
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 02:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CF542225D
	for <linux-xfs@archiver.kernel.org>; Sat, 10 Oct 2020 02:09:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8Lzs64y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgJJCJJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 9 Oct 2020 22:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbgJJBvU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 21:51:20 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3BCC0613D0
        for <linux-xfs@vger.kernel.org>; Fri,  9 Oct 2020 18:50:59 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w21so8356710pfc.7
        for <linux-xfs@vger.kernel.org>; Fri, 09 Oct 2020 18:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CuR7oEI1ZgFc/+WuMvCET5vfHyYsPZ3xqCbyxP69uvk=;
        b=h8Lzs64yBWjGDQFMcUQqJeGx2K0oNBcpJ1emynlmLXypp5iO/ZcMmUlICk5leegEUV
         QwWsy84ftP8CK/hMiTSV/3wPT5xWhgS9NzQ0EqMlDq+y2i9ZtM/gJSsqizCX56JYKGmu
         Xu1Le9IJvnlZh5zmwNn4SkOvWfMAmPrkz7i8q79I8PERz+GAUH9EJfpDHF35D47o27eF
         hYL40L3cAc776/e51yuRQ+G/jvavFpdrYdpAUHr1mifnPmrTEWqiBtgO7KbomXTi+fTb
         zNsuFbFxl/wE+N0E3lSSnlQ0jtcnrFbwnGUqz68adfGLP5QGGliG6Gx17h0dtIoRK5TU
         HNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CuR7oEI1ZgFc/+WuMvCET5vfHyYsPZ3xqCbyxP69uvk=;
        b=tkRE32qSrmHFG8pxb/7jYw/MG1NphF7KCddx/Tk4wOV9leFGH7RukUNiqx4uuLKvj6
         tzYUWuwXMQxtdimN02Hu+InR0FCJGw57Fh8l7z78YYnsGWFLftWGnvXexjcAtOk6taJ+
         46/akzPERrDtSiPJhRVvQ+s1aTsnlEmXIjISh2+rEAi5TEp0yCsBtEJZbrw+LasH8bSM
         2BIwZRW9wdsTkfwGw+q2DPXhs9rJDdCt6IvuKVCOFmqpcycIs8vv8gc/vS0gYxNGvqi/
         mMxmtixLJshAkEzdVXcc0HzRjXdakSKk/cfXdAJ+6LBm0j2Nzwn0g0uF9HWFX8px6/K8
         5y5g==
X-Gm-Message-State: AOAM5333xRJE7thrnf2ZvrTcMwVCcLheiC9vW1gNaUvFR98aKf9ZauDj
        p4k51UadJxISykQ+SSSJuQ==
X-Google-Smtp-Source: ABdhPJw3EPN8rj8VWnV1EFu32loA4YzFyKhYTYSta8OLayRc0vlwLFaVB++Ihse+pEzH4wdz64360A==
X-Received: by 2002:a17:90a:e553:: with SMTP id ei19mr7750325pjb.136.1602294659104;
        Fri, 09 Oct 2020 18:50:59 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id f12sm5001774pju.18.2020.10.09.18.50.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 18:50:58 -0700 (PDT)
Subject: Re: [PATCH v4 3/3] xfs: directly return if the delta equal to zero
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1602130749-23093-1-git-send-email-kaixuxia@tencent.com>
 <1602130749-23093-4-git-send-email-kaixuxia@tencent.com>
 <20201009113257.GE769470@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <0251951d-0829-ac7e-b629-f5c4a0ad4b22@gmail.com>
Date:   Sat, 10 Oct 2020 09:50:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201009113257.GE769470@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/9 19:32, Brian Foster wrote:
> On Thu, Oct 08, 2020 at 12:19:09PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The xfs_trans_mod_dquot() function will allocate new tp->t_dqinfo if it is
>> NULL and make the changes in the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}].
>> Nowadays seems none of the callers want to join the dquots to the
>> transaction and push them to device when the delta is zero. Actually,
>> most of time the caller would check the delta and go on only when the
>> delta value is not zero, so we should bail out when it is zero.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> ---
>>  fs/xfs/xfs_trans_dquot.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>> index 0ebfd7930382..3e37501791bf 100644
>> --- a/fs/xfs/xfs_trans_dquot.c
>> +++ b/fs/xfs/xfs_trans_dquot.c
>> @@ -194,6 +194,9 @@ xfs_trans_mod_dquot(
>>  	ASSERT(XFS_IS_QUOTA_RUNNING(tp->t_mountp));
>>  	qtrx = NULL;
>>  
>> +	if (!delta)
>> +		return;
>> +
> 
> Note that the calls in xfs_trans_dqresv() also check for delta != 0, so
> that could be removed with this patch. That aside:

Yeah, I'll do that in the next version.

Thanks,
Kaixu
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
>>  	if (tp->t_dqinfo == NULL)
>>  		xfs_trans_alloc_dqinfo(tp);
>>  	/*
>> @@ -205,10 +208,8 @@ xfs_trans_mod_dquot(
>>  	if (qtrx->qt_dquot == NULL)
>>  		qtrx->qt_dquot = dqp;
>>  
>> -	if (delta) {
>> -		trace_xfs_trans_mod_dquot_before(qtrx);
>> -		trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>> -	}
>> +	trace_xfs_trans_mod_dquot_before(qtrx);
>> +	trace_xfs_trans_mod_dquot(tp, dqp, field, delta);
>>  
>>  	switch (field) {
>>  	/* regular disk blk reservation */
>> @@ -261,8 +262,7 @@ xfs_trans_mod_dquot(
>>  		ASSERT(0);
>>  	}
>>  
>> -	if (delta)
>> -		trace_xfs_trans_mod_dquot_after(qtrx);
>> +	trace_xfs_trans_mod_dquot_after(qtrx);
>>  }
>>  
>>  
>> -- 
>> 2.20.0
>>
> 

-- 
kaixuxia
