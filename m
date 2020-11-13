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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A05C2D0E4
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C3522201
	for <linux-xfs@archiver.kernel.org>; Fri, 13 Nov 2020 03:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NVlHo8oq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKMD04 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Nov 2020 22:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgKMD0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 22:26:55 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2E4C0613D1
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 19:26:55 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id 62so5956200pgg.12
        for <linux-xfs@vger.kernel.org>; Thu, 12 Nov 2020 19:26:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Brl/bsgU7Zo4xhxkNUeqXZ7NABraEXFuphuMGJUaXYg=;
        b=NVlHo8oqC1LBc4HyZUNO1wp0yvL3FsShP3x/5+9KNwForo2hUdtQCFoaXvd3iC1HB6
         Vncp0i2beuYu9y0mZyItokJ672dTUuvfphdwvJgubenYfg0afAFZNw/eYgW8ik90v1a+
         rSGMrEpZprvcsFExHWV0yRlUfGDwBhR5JJXDCTzJoSeaTYAEs2H8sI2TcJNgiEvgNGyA
         ng1MMoc0U6HAjsustgHB73DlV4Sg4/2gInQHYsOJoqNdwxkSvYHQsh5hWLhGnW7ibbMX
         /5xhkZ88PAXmjl5FXkY5X4+5CMH60BNN9kAQ3vxYgeEWPYBXw+KkGcG9yuA8w1bSK/8P
         y2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Brl/bsgU7Zo4xhxkNUeqXZ7NABraEXFuphuMGJUaXYg=;
        b=m9OKOJRaMcECJnqvxydpxJ9pvhoIgwreLhStlBLcUnsWSAy/2dI8Kdlt025ONT9kYV
         A8X13/OZTJIzg25Amus12Q6+Y8gDsXM8lrgL2PNavraqocgXyI79Q9QRnmgSiMHYE+jm
         549zbrFegZfkaMvEEhEWxoYxA8bWdfwodwnO+1lx6FD48m51+7/pT19PzErC+ZCPzBn2
         m8iOI0L676UjS7NFh8M/kZnaVlygAHWfxcTzYAfiKe+fvZmPSqtdKkp3cKEVvsjLvOF6
         IHIQ7c19WC9tdigR+ZqmnUw5Ht5mRrGx22Q9LjOA9jFmxkpLK3pjHo5mtdCdIuU5LV+Z
         mzjA==
X-Gm-Message-State: AOAM530x5s1wNPYPPr3u9VTWX8bAnHivgC1f7LFXlswLb4gspxkBgnOC
        AhqfLxEogFWezMBkLU28wh7FwNujBg4V
X-Google-Smtp-Source: ABdhPJySNSCfvcOVpH6UNB6ZVTBDejCVKUY47zxJUN72RYf3eUkKcC4wU3ZqP44OD8yfaE4Va6kJ0g==
X-Received: by 2002:a17:90a:178b:: with SMTP id q11mr532131pja.132.1605238015379;
        Thu, 12 Nov 2020 19:26:55 -0800 (PST)
Received: from [10.76.131.47] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id w4sm8267297pjh.47.2020.11.12.19.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 19:26:54 -0800 (PST)
Subject: Re: [PATCH v6 1/3] xfs: delete duplicated tp->t_dqinfo null check and
 allocation
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1602819508-29033-1-git-send-email-kaixuxia@tencent.com>
 <1602819508-29033-2-git-send-email-kaixuxia@tencent.com>
 <20201026225226.GF347246@magnolia>
 <224e199b-36d1-401e-3f40-bd0e6c2b4c00@gmail.com>
 <20201113015511.GW9695@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <0a87fd48-23e6-8c64-613c-7da5dc8c9e3d@gmail.com>
Date:   Fri, 13 Nov 2020 11:26:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201113015511.GW9695@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/11/13 9:55, Darrick J. Wong wrote:
> On Thu, Nov 12, 2020 at 10:53:39AM +0800, kaixuxia wrote:
>>
>>
>> On 2020/10/27 6:52, Darrick J. Wong wrote:
>>> On Fri, Oct 16, 2020 at 11:38:26AM +0800, xiakaixu1987@gmail.com wrote:
>>>> From: Kaixu Xia <kaixuxia@tencent.com>
>>>>
>>>> The function xfs_trans_mod_dquot_byino() wraps around
>>>> xfs_trans_mod_dquot() to account for quotas, and also there is the
>>>> function call chain xfs_trans_reserve_quota_bydquots -> xfs_trans_dqresv
>>>> -> xfs_trans_mod_dquot, both of them do the duplicated null check and
>>>> allocation. Thus we can delete the duplicated operation from them.
>>>>
>>>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>>
>>> HAH this got all the way to v6, sorry I suck. :(
>>>
>>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> Hi Darrick,
>>
>> There are some patches that have been reviewed but not been merged
>> into xfs for-next branch, I will reply to them.
>> Sorry for the noise:)
> 
> Same situation here -- these are 5.11 cleanups and I'm still working on
> bug fixes for 5.10.  If you have time to review patches, can you please
> have a look at the unreviewed patches in the series "xfs: fix various
> scrub problems", please?
> Hi Darrick,

Thank you for the invitation! I am very interested and happy to review
these patches. I will review them when I have time:)

Thanks,
Kaixu

> --D
> 
>> Thanks,
>> Kaixu
>>>
>>> --D
>>>
>>>> ---
>>>>  fs/xfs/xfs_trans_dquot.c | 7 -------
>>>>  1 file changed, 7 deletions(-)
>>>>
>>>> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
>>>> index fe45b0c3970c..67f1e275b34d 100644
>>>> --- a/fs/xfs/xfs_trans_dquot.c
>>>> +++ b/fs/xfs/xfs_trans_dquot.c
>>>> @@ -143,9 +143,6 @@ xfs_trans_mod_dquot_byino(
>>>>  	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
>>>>  		return;
>>>>  
>>>> -	if (tp->t_dqinfo == NULL)
>>>> -		xfs_trans_alloc_dqinfo(tp);
>>>> -
>>>>  	if (XFS_IS_UQUOTA_ON(mp) && ip->i_udquot)
>>>>  		(void) xfs_trans_mod_dquot(tp, ip->i_udquot, field, delta);
>>>>  	if (XFS_IS_GQUOTA_ON(mp) && ip->i_gdquot)
>>>> @@ -698,7 +695,6 @@ xfs_trans_dqresv(
>>>>  	 * because we don't have the luxury of a transaction envelope then.
>>>>  	 */
>>>>  	if (tp) {
>>>> -		ASSERT(tp->t_dqinfo);
>>>>  		ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>>>  		if (nblks != 0)
>>>>  			xfs_trans_mod_dquot(tp, dqp,
>>>> @@ -752,9 +748,6 @@ xfs_trans_reserve_quota_bydquots(
>>>>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>>>>  		return 0;
>>>>  
>>>> -	if (tp && tp->t_dqinfo == NULL)
>>>> -		xfs_trans_alloc_dqinfo(tp);
>>>> -
>>>>  	ASSERT(flags & XFS_QMOPT_RESBLK_MASK);
>>>>  
>>>>  	if (udqp) {
>>>> -- 
>>>> 2.20.0
>>>>
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
