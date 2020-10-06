Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F588C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 11:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B1AA207EA
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 11:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UFDIBXbC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJFLdh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 07:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgJFLdh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 07:33:37 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B80FC061755
        for <linux-xfs@vger.kernel.org>; Tue,  6 Oct 2020 04:33:37 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x5so1076298plo.6
        for <linux-xfs@vger.kernel.org>; Tue, 06 Oct 2020 04:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xueo/4Vgz54bn5rUf7hU35YehDk79zMtWhitXILn5d0=;
        b=UFDIBXbCkRmDXwPVJArpE0fZK2h+j9nnyYsKHw7MAxg7/bnMkt6F8fhKnF0dX90VQk
         Zdnmp9FMKd6qAbm/Pf/jY2q+6IePNBv5jGRxgQN/ABO0LyBsXTS5FnNRc6qbbJnDJ1ay
         W/P0ZwsyUFpF7zrTJPzPAvprl/Uwwr8hrTYuWAiKacMcdO13az0tt3a0NZpH6DB5WX3T
         3ZoIfpxisUiwdPUrIj2NDtnzmLmZA7saPs8sHXb5gmNTFxjjchnRBsC3VQmZ4AHr6hmB
         rrIZ1bRJvWEN6rg9tWO/Oe9PIYmHG7/u3Q3nmjRI0BNbbVJ+qIiaWYtdtodkTs3u9gdq
         qFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xueo/4Vgz54bn5rUf7hU35YehDk79zMtWhitXILn5d0=;
        b=O4Cs1LMXHkK+2R7anAbBasO61KF7ik79LtDKkBOEOjhIBp0ItUkhPto8DcDbCuzG/x
         ywTifecrTtTwokIfNVm6awzfUfd5DIAxTdR4Dg0/gZHYgqX7q3aPltqlhRW82nO8upy9
         Bc1JAIoXLzh1AlovihjiWbQml8CXpoPuaV6S4MUYuaBeaZ3HmbR85oeQKePErJeV616H
         fEPxYXLH+hy6d/irYH26H/FWCv2K21FAfdN2RxsCbKHRbbyjlkQck7qrc5ZImTP4Ohl+
         KoAp21icGtuwCVdC5aX4lIjkytMYNf61+zsD1GeePavMrZs0X3SvfUnP82CIsbrSxq8L
         gwfg==
X-Gm-Message-State: AOAM532y58Nyet95xtXXeDDrhc5foArJ3fhjuKn3fLojARUTg3iPkeGh
        sXWG7kPFKS2eAQPOaOa4PzBMnrg4UkCT
X-Google-Smtp-Source: ABdhPJyGNeBzgvPbwxjcAd+Z+r6aFBeiMu/e2d2z4YvaxyypX/1o3SaonyKl/SU7gIZWAk3kogVxhg==
X-Received: by 2002:a17:90a:890f:: with SMTP id u15mr3874255pjn.147.1601984016973;
        Tue, 06 Oct 2020 04:33:36 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id 131sm3412899pfy.5.2020.10.06.04.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 04:33:36 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
 <1601126073-32453-4-git-send-email-kaixuxia@tencent.com>
 <20201006044237.GV49547@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <dc859a28-330d-e031-6a28-f0649ca27cb3@gmail.com>
Date:   Tue, 6 Oct 2020 19:33:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201006044237.GV49547@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/6 12:42, Darrick J. Wong wrote:
> On Sat, Sep 26, 2020 at 09:14:32PM +0800, xiakaixu1987@gmail.com wrote:
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
>>  fs/xfs/xfs_trans_dquot.c   | 20 ++------------------
>>  3 files changed, 3 insertions(+), 26 deletions(-)
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
>> index fe45b0c3970c..0ebfd7930382 100644
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
>> @@ -143,9 +136,6 @@ xfs_trans_mod_dquot_byino(
>>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>>  		return;
>>  
>> -	if (tp->t_dqinfo == NULL)
>> -		xfs_trans_alloc_dqinfo(tp);
> 
> This change ought to be a separate clean patch.

Yeah, I'll do that in the next version.
> 
>> -
>>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
>> @@ -273,8 +263,6 @@ xfs_trans_mod_dquot(
>>  
>>  	if (delta)
>>  		trace_xfs_trans_mod_dquot_after(qtrx);
>> -
>> -	tp->t_flags |= XFS_TRANS_DQ_DIRTY;
>>  }
>>  
>>  
>> @@ -351,7 +339,7 @@ xfs_trans_apply_dquot_deltas(
>>  	int64_t			totalbdelta;
>>  	int64_t			totalrtbdelta;
>>  
>> -	if (!(tp->t_flags & XFS_TRANS_DQ_DIRTY))
>> +	if (!tp->t_dqinfo)
>>  		return;
>>  
>>  	ASSERT(tp->t_dqinfo);
>> @@ -493,7 +481,7 @@ xfs_trans_unreserve_and_mod_dquots(
>>  	struct xfs_dqtrx	*qtrx, *qa;
>>  	bool			locked;
>>  
>> -	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
>> +	if (!tp->t_dqinfo)
>>  		return;
>>  
>>  	for (j = 0; j < XFS_QM_TRANS_DQTYPES; j++) {
>> @@ -698,7 +686,6 @@ xfs_trans_dqresv(
>>  	 * because we don't have the luxury of a transaction envelope then.
>>  	 */
>>  	if (tp) {
>> -		ASSERT(tp->t_dqinfo);
>>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  		if (nblks != 0)
>>  			xfs_trans_mod_dquot(tp, dqp,
>> @@ -752,9 +739,6 @@ xfs_trans_reserve_quota_bydquots(
>>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>>  		return 0;
>>  
>> -	if (tp && tp->t_dqinfo == NULL)
>> -		xfs_trans_alloc_dqinfo(tp);
> 
> Um, who allocates the dqinfo in this case?

The function call chain here is xfs_trans_reserve_quota_bydquots()->
xfs_trans_dqresv()->xfs_trans_mod_dquot()(tp is non-null), thus the
dqinfo will be allocated in xfs_trans_mod_dquot() function. Actually,
now we do the allocation only in xfs_trans_mod_dquot() function when
the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values changed.

Thanks,
Kaixu
> 
> --D
> 
>> -
>>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>  
>>  	if (udqp) {
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
