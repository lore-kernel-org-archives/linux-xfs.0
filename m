Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 495F4C433E7
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 00:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E477120882
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 00:54:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cE0kEY4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJHAyQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 20:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgJHAyQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 20:54:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65E3C061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 17:54:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so2809190pgl.2
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 17:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/cQm6cN9GQitctbnOvjqoxpJZUr1XQgSvLMZXrtmT5s=;
        b=cE0kEY4tcg23GnYa+Jw6W55/3Tjsq8YsaDTi8y7kXEu3J5ZCTJZB7X/u6u6yMKcge2
         v6nxsZPVmYZstpq+6U2dPaBKDLojfUekg39AI05NH4ttJb61ZzWJ3yEtKdG/MCItz24a
         yoZwxGIwfq1z2FkEObpgegwRUhPQbxGcHmQMuRfF3C6SyKZroUJr3yb8hkWjdyeiP/Dg
         rXsGVOoeGT4csdcgDB1TIe6V+yuWB0I8HmOioNO3TBHrBdOIWRCIQHlFQ1bUfGK/2Jgt
         +wFoRy9tJYyt2djp9otMCbEHCgDQeh8A0JZ+84M//FmieXxwele3YFZBpTKP13ZAxzc+
         nt8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/cQm6cN9GQitctbnOvjqoxpJZUr1XQgSvLMZXrtmT5s=;
        b=AWxrkUlJBvEs/zgETG0hUoWlNhpfjL9KtEh799ZdGimnLmk4HoOV+kNea4FzDPaNZP
         hKr9iE2ztW13kk7EuRyjesrBU1FFbWe6DpKccUsU8gG2DOi4ilfwUSQR/JoDrMLzwP39
         0V0xP02VJz5z16f4j/weRuhHMI/N6fiotUqcbzHL7or+RUPEeWUzt3sCrj+nYn1ccvaM
         +IJViSmLUsezxQOeoDFEeXdshCdWuo7WSpSaJPzncTmRe60nl2A6k/5RO54PmbCuWocm
         MOXyYrS8qPwUNYg0EcfpvRdxV3O3UwWn71dgxHr3O9WRmOYJ7qE0DxXHTluXGX+PldOk
         32pQ==
X-Gm-Message-State: AOAM533Weh5SyiZAk3gjuFpr80CrZCuC7d3NiMMm407IrMmelkTHP8I4
        dDRY1gp1iKw5/F1tZ9y9jw==
X-Google-Smtp-Source: ABdhPJwKfpPnAiL1sxhhX48gi1fwtCdquW/qVgTwmiQNSZcMYHJvwTDNIbyVtMqTNxiK4xCoHVQoYg==
X-Received: by 2002:aa7:9492:0:b029:152:545f:90d with SMTP id z18-20020aa794920000b0290152545f090dmr5229255pfk.9.1602118454185;
        Wed, 07 Oct 2020 17:54:14 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id i2sm3809503pjk.12.2020.10.07.17.54.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2020 17:54:13 -0700 (PDT)
Subject: Re: [PATCH v3 4/5] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1602082272-20242-1-git-send-email-kaixuxia@tencent.com>
 <1602082272-20242-5-git-send-email-kaixuxia@tencent.com>
 <20201007220456.GC6540@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <adbea2ca-a7e5-ede3-9c47-cba42209f6a2@gmail.com>
Date:   Thu, 8 Oct 2020 08:54:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201007220456.GC6540@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/8 6:04, Darrick J. Wong wrote:
> On Wed, Oct 07, 2020 at 10:51:11PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> Nowadays the only things that the XFS_TRANS_DQ_DIRTY flag seems to do
>> are indicates the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values
>> changed and check in xfs_trans_apply_dquot_deltas() and the unreserve
>> variant xfs_trans_unreserve_and_mod_dquots(). Actually, we also can
>> use the tp->t_dqinfo value instead of the XFS_TRANS_DQ_DIRTY flag, that
>> is to say, we allocate the new tp->t_dqinfo only when the qtrx values
>> changed, so the tp->t_dqinfo value isn't NULL equals the XFS_TRANS_DQ_DIRTY
>> flag is set, we only need to check if tp->t_dqinfo == NULL in
>> xfs_trans_apply_dquot_deltas() and its unreserve variant to determine
>> whether lock all of the dquots and join them to the transaction.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/libxfs/xfs_shared.h |  1 -
>>  fs/xfs/xfs_inode.c         |  8 +-------
>>  fs/xfs/xfs_trans_dquot.c   | 17 ++---------------
>>  3 files changed, 3 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
>> index c795ae47b3c9..8c61a461bf7b 100644
>> --- a/fs/xfs/libxfs/xfs_shared.h
>> +++ b/fs/xfs/libxfs/xfs_shared.h
>> @@ -62,7 +62,6 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
>>  #define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
>>  #define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
>>  #define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
>> -#define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
>>  #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
>>  #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
>>  #define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 49624973eecc..9108eed0ea45 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -941,7 +941,6 @@ xfs_dir_ialloc(
>>  	xfs_buf_t	*ialloc_context = NULL;
>>  	int		code;
>>  	void		*dqinfo;
>> -	uint		tflags;
>>  
>>  	tp = *tpp;
>>  	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
>> @@ -1000,12 +999,9 @@ xfs_dir_ialloc(
>>  		 * and attach it to the next transaction.
>>  		 */
>>  		dqinfo = NULL;
>> -		tflags = 0;
>>  		if (tp->t_dqinfo) {
>>  			dqinfo = (void *)tp->t_dqinfo;
>>  			tp->t_dqinfo = NULL;
>> -			tflags = tp->t_flags & XFS_TRANS_DQ_DIRTY;
>> -			tp->t_flags &= ~(XFS_TRANS_DQ_DIRTY);
>>  		}
>>  
>>  		code = xfs_trans_roll(&tp);
>> @@ -1013,10 +1009,8 @@ xfs_dir_ialloc(
>>  		/*
>>  		 * Re-attach the quota info that we detached from prev trx.
>>  		 */
>> -		if (dqinfo) {
>> +		if (dqinfo)
>>  			tp->t_dqinfo = dqinfo;
>> -			tp->t_flags |= tflags;
>> -		}
>>  
>>  		if (code) {
>>  			xfs_buf_relse(ialloc_context);
>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>> index 1b56065c9ff1..0ebfd7930382 100644
>> --- a/fs/xfs/xfs_trans_dquot.c
>> +++ b/fs/xfs/xfs_trans_dquot.c
>> @@ -84,13 +84,6 @@ xfs_trans_dup_dqinfo(
>>  
>>  	xfs_trans_alloc_dqinfo(ntp);
>>  
>> -	/*
>> -	 * Because the quota blk reservation is carried forward,
>> -	 * it is also necessary to carry forward the DQ_DIRTY flag.
>> -	 */
>> -	if (otp->t_flags & XFS_TRANS_DQ_DIRTY)
>> -		ntp->t_flags |= XFS_TRANS_DQ_DIRTY;
>> -
>>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>>  		oqa = otp->t_dqinfo->dqs[j];
>>  		nqa = ntp->t_dqinfo->dqs[j];
>> @@ -270,8 +263,6 @@ xfs_trans_mod_dquot(
>>  
>>  	if (delta)
>>  		trace_xfs_trans_mod_dquot_after(qtrx);
>> -
>> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>>  }
>>  
>>  
>> @@ -348,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>>  	int64_t			totalbdelta;
>>  	int64_t			totalrtbdelta;
>>  
>> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
>> +	if (!tp->t_dqinfo)
>>  		return;
>>  
>>  	ASSERT(tp->t_dqinfo);
>> @@ -490,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>>  	struct xfs_dqtrx	*qtrx, *qa;
>>  	bool			locked;
>>  
>> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
>> +	if (!tp->t_dqinfo)
>>  		return;
>>  
>>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>> @@ -695,7 +686,6 @@ xfs_trans_dqresv(
>>  	 * because we don't have the luxury of a transaction envelope then.
>>  	 */
>>  	if (tp) {
>> -		ASSERT(tp->t_dqinfo);
>>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  		if (nblks != 0)
>>  			xfs_trans_mod_dquot(tp, dqp,
>> @@ -749,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
>>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>>  		return 0;
>>  
>> -	if (tp && tp->t_dqinfo == NULL)
>> -		xfs_trans_alloc_dqinfo(tp);
>> -
> 
> This also should be a separate patch (or I guess the previous one?)
> in which the commit log points out that the allocation is already
> covered by the chain xfs_trans_reserve_quota_bydquots ->
> xfs_trans_dqresv -> xfs_trans_mod_dquot.

Yeah, make more sense, I'll follow it in the next version.

Thanks,
Kaixu
> 
> --D
> 
>>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  
>>  	if (udqp) {
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
