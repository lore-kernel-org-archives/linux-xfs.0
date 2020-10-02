Return-Path: <SRS0=RTOF=DJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EF15C4363D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 03:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBA88206DD
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Oct 2020 03:31:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOfEmRMo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387498AbgJBDbr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 23:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBDbr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 23:31:47 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE39C0613D0
        for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2020 20:31:46 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d13so585467pgl.6
        for <linux-xfs@vger.kernel.org>; Thu, 01 Oct 2020 20:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=65YQQDoFkov+nGUhyKFDm3gJ3yR1h/DV9Juy2cJRri8=;
        b=dOfEmRMoSeT67iCK5kVlpcyNoq16b1S+mMaL/CDzoI0ImKnJOyG+/cMc6cxnwEUUdA
         TLZl2lzsqlx0lKsjoZkRwvdOJ/QhAB1GHzwmG6HH8Ldrd3IkOstv4wBaWOLV4eExGajw
         Z8mgQR1clHGUtR0agSZr5U88oxKIYsZtyRUSTLbYwOvW+RRC1BMMYd4+NX5DkcnBSYpX
         aqGXoIVVBZ118HceLnfM7GnyMtnvRXz5My+Mr+M66Z+cwmHTqGfT+M98r8YQ7V5A1AqE
         Yb8Xab8G7JLxRISxvboxRg35X5jDxt86ElTTqjycvYoo+q2wL4uciOEPh0W88XS17iKS
         Gutw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=65YQQDoFkov+nGUhyKFDm3gJ3yR1h/DV9Juy2cJRri8=;
        b=a1AOnZamcRQ3/67VEDeJnbs+QNaLezmztVt6XfQG3ltmOHycgi9PHuowv/A1jCkYpX
         IaIMICbZ/EnffyRtpM1lOQ/S4ZpPRj/LyVq7Ow0/Vc1o+ZftbKF/IvqKxfRjVKtSGHwR
         Acn3DhUGDKHCkDqUSOz8KpaGHnth0cQZA+nfCbUS/KFSGJmHK1/9xEmXOrWtwVFdP/ok
         j2qbaM8s56PE3stgIhua4yjYP5m2FXlmlu1zh3loAHATbEyB0BcNv8cpZd66IR0gNucV
         bhPc75KUeoqvKpy+pJtDrb6SRIKV5ILcyCOs5kGwp92acK2fV4rStVWMckuDhCx2RdZs
         tdig==
X-Gm-Message-State: AOAM531aQ1iwxMnS736kh1btj97t+C9YXb2zF64gBP4DPpl0mxV5u2f1
        If3CCwwQBtg6/dgoVob3xw==
X-Google-Smtp-Source: ABdhPJx2pTgo3FekYOZsa7+5GseLEtoFl6UCaZaLcpbx/q//l2v6YSnxflFz+6bFTGdKxatA7/fIUA==
X-Received: by 2002:aa7:8a54:0:b029:142:2501:34f6 with SMTP id n20-20020aa78a540000b0290142250134f6mr338757pfa.79.1601609496473;
        Thu, 01 Oct 2020 20:31:36 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id m5sm58371pjn.19.2020.10.01.20.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 20:31:35 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] xfs: check tp->t_dqinfo value instead of the
 XFS_TRANS_DQ_DIRTY flag
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1601126073-32453-1-git-send-email-kaixuxia@tencent.com>
 <1601126073-32453-4-git-send-email-kaixuxia@tencent.com>
 <50bf4338-490e-b98d-321b-26dd08af98a0@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <fdff45c9-82ac-c053-3c10-ca8d8996630e@gmail.com>
Date:   Fri, 2 Oct 2020 11:31:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <50bf4338-490e-b98d-321b-26dd08af98a0@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2020/9/26 23:36, Eric Sandeen wrote:
> On 9/26/20 8:14 AM, xiakaixu1987@gmail.com wrote:
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
>> -
> 
> I can't tell from the commit log or from a very quick read of the code why these
> allocations are being removed.  Can we not get here with a NULL t_dqinfo?
> If not, why not?  This seems like a change unrelated to the proposed
> "t_dqinfo set == XFS_TRANS_DQ_DIRTY" change.

Yeah, remove these allocations because I want to allocate the t_dqinfo only
when the tp->t_dqinfo->dqs[XFS_QM_TRANS_{USR,GRP,PRJ}] values changed, that
is to say, only do the allocation in xfs_trans_mod_dquot() function. Actually,
original these allocations are repeated, for example, the xfs_trans_mod_dquot_byino()
function call the xfs_trans_mod_dquot(), but both of them do the allocation,
so remove one of them may be reasonable.  
> 
> Also, while it seems clear to say that !t_dqinfo == !XFS_TRANS_DQ_DIRTY, is the
> converse true?  Is it possible to have t_dqinfo set, but it's not dirty?> 
> I think the answer is that when we free the transaction we set t_dqinfo to
> NULL again, but I'm not certain, and it's not obvious from the changelog...

Now we do the allocation in xfs_trans_mod_dquot() function and only have t_dqinfo
set when it is dirty.

Thanks,
Kaixu
> 
> -Eric
> 

-- 
kaixuxia
