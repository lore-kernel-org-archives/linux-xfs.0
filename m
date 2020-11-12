Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B10C2D0A3
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AD4421534
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Nov 2020 05:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sz13Xhk0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgKLFiB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 00:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbgKLCxu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Nov 2020 21:53:50 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7778C0613D1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:53:49 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id r10so2899545pgb.10
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 18:53:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7LR5R5fKUaSOdZXx1LOVnmUZug2O8Q7jTTQCXBUGAJo=;
        b=sz13Xhk0pBPk0pCUCjvmYADmi+Jn2wqHnDOuaTj09xE+uNxAMwOrA++nLe/vxw/Jcq
         ie14VeVSF3ArvaRe6GX0/FgfCkWi0tpvlnzX8ZVuX1dlFQOyRrpcCoJafsd8D74TUCvN
         S44gS6nQRsaE0YEvwXvzkR+Bqaqrus5cTV66Dxp/twNhwrTVsiKFbWpwNY9Mzdyhc8Up
         mS42799fhKAiPJ3+mN2kAtGbzdpeNyUhrj68wZ38iTiQ8s4LWcx0kkg6qoXuJhYgoTvy
         jqlqttg4cA7X+xiMwI8gvX/NlNxRBVDst/Tf9xkI9Q+0RMldOxijNJ6GZAOEECnKenFY
         XkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7LR5R5fKUaSOdZXx1LOVnmUZug2O8Q7jTTQCXBUGAJo=;
        b=pMhP26H2hhyxBe3EfIL0jKaA7oPoK+J8+metCwYROVBudslU2QK1HTCYs10BTaT4FB
         th5OzCP5T9pXW6mRuxVTI4/3Gh93wS5FnWpSvB3eEgjx/6n5Zz7x+yPzT0SqRAWaoqJ1
         LkdY/+v9GiTxJ4nnm5c8d12lQFtTLX2kvo6MqdXHBlFEZ1dX9zberllFMqV+064Rp97h
         7wMpqOWL22mYaWvQTvO2dWyIvOdm0NntBngU+uYHMC1NLMvQJLsgYFZVXYeupwXjcGb1
         +rpJBJF+1h0p2iGPnPjeZCpz/fCNrmMzGTMQLCJ/sZkHloRENiPyEsQVoZeGclyiFTU5
         1plA==
X-Gm-Message-State: AOAM530xEqnInyPqgMyCZC3hT91hC8HngW7D0cX5b99gsKAhvlPafTqL
        gFtqTykIn+yqdPd/QTW3fArO80DDMi1P
X-Google-Smtp-Source: ABdhPJxLqNNgKrbUQ3lll6IPklnF+VajDArgyxZLkCExhXNYPLUOZzirF7mZp6to+WVrht7dssSnKA==
X-Received: by 2002:a63:fc5f:: with SMTP id r31mr24072540pgk.90.1605149629170;
        Wed, 11 Nov 2020 18:53:49 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id i7sm3984857pjj.20.2020.11.11.18.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 18:53:47 -0800 (PST)
Subject: Re: [PATCH v6 1/3] xfs: delete duplicated tp->t_dqinfo null check and
 allocation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
 <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
 <20201026225226.GF347246@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <224e199b-36d1-401e-3f40-bd0e6c2b4c00@gmail.com>
Date:   Thu, 12 Nov 2020 10:53:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026225226.GF347246@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/27 6:52, Darrick J. Wong wrote:
> On Fri, Oct 16, 2020 at 11:38:26AM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The function xfs_trans_mod_dquot_byino() wraps around
>> xfs_trans_mod_dquot() to account for quotas, and also there is the
>> function call chain xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv
>> -> xfs_trans_mod_dquot, both of them do the duplicated null check and
>> allocation. Thus we can delete the duplicated operation from them.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> HAH this got all the way to v6, sorry I suck. :(
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Hi Darrick,

There are some patches that have been reviewed but not been merged
into xfs for-next branch, I will reply to them.
Sorry for the noise:)

Thanks,
Kaixu
> 
> --D
> 
>> ---
>>  fs/xfs/xfs_trans_dquot.c | 7 -------
>>  1 file changed, 7 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>> index fe45b0c3970c..67f1e275b34d 100644
>> --- a/fs/xfs/xfs_trans_dquot.c
>> +++ b/fs/xfs/xfs_trans_dquot.c
>> @@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
>>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>>  		return;
>>  
>> -	if (tp->t_dqinfo == NULL)
>> -		xfs_trans_alloc_dqinfo(tp);
>> -
>>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
>> @@ -698,7 +695,6 @@ xfs_trans_dqresv(
>>  	 * because we don't have the luxury of a transaction envelope then.
>>  	 */
>>  	if (tp) {
>> -		ASSERT(tp->t_dqinfo);
>>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  		if (nblks != 0)
>>  			xfs_trans_mod_dquot(tp, dqp,
>> @@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
>>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>>  		return 0;
>>  
>> -	if (tp && tp->t_dqinfo == NULL)
>> -		xfs_trans_alloc_dqinfo(tp);
>> -
>>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  
>>  	if (udqp) {
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
