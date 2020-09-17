Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1BDC43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7A64221E7
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vuc6wQzk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgIQIHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgIQIHJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:07:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91FB5C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:07:04 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id v14so829979pjd.4
        for <linux-xfs@vger.kernel.org>; Thu, 17 Sep 2020 01:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VQur3iKCILufAnNuSuk965O7Xx/KX1alWztfY9xpECM=;
        b=Vuc6wQzkv3D3mBJq6d+m7wwfx0I35y330DfjYUR1b65XWNm18tljwglHx/A6PL5UAR
         tBW4V0o5/C+tkeLz2YBqmjQg8exfmwDB1rqWYtLm4hxkxd4ff9O6AyZ4y7R4P9G9YC4n
         Uow+iz5aqzbW3SvwZJHvBmVfiFcbtiQb9uEMitTzPUqQn6/Q7snb4TyzPSfaHwQbW0m2
         cONKOTbCxgIK9M5LU7jJq1EVBbP5GabfWoZczGaPmrqs7wkETHaOua26Cw+DIuWxlQ2q
         aGP4KWE+mljt0ePdY0u4AXmJMx9CQMetrXLRO5qw1FRRX1ikYIdhH6IrlYWmdFQ39PAv
         BIGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VQur3iKCILufAnNuSuk965O7Xx/KX1alWztfY9xpECM=;
        b=GvwqKePgz6JlAVpad59UGqcPwWZAmuhcKr+nNI8LxjxbbVW2bZfVLF/C+P3Mcr8jcY
         qv7e7SGTgiaT3f3KZSbIi3o4ETK+YGVpk2m8X3fnQvEYbgLmLCHByXTvCCHSPHL6/GWI
         PejaKC0fnudGjUc1YAkoeUvTAFr81+K3xt2G0eDi0WSAKfCuGxznkWv96Sa/pdWcKoFv
         tEGnKy2AAZEppKIpwU2CqiSr9vCu1yOL0oJNIoOOc6XHL4M+wcqvvzP+6Zv5UwrZu4Wr
         talc4TFMiuc04hdCaFnLRAYKYFCMMtGXzZJYByd45A2xLDqSfNBBFC0YCE+Q9rbwALA3
         N4rA==
X-Gm-Message-State: AOAM532XVGhFtgLEGjg5Uacf2GqaTK7qk4eIvd7tVFQL/5iH6I7zy/EC
        rIopIuKBjDlJsDiTQDglXQ==
X-Google-Smtp-Source: ABdhPJyUfqGj56SxMt1w7Z4azISCej2mIjOhNgH7Lzfe6j305sA4Lcem+VSPwxKH+fnteVF3WOdHbQ==
X-Received: by 2002:a17:90a:65ca:: with SMTP id i10mr7575340pjs.137.1600330024122;
        Thu, 17 Sep 2020 01:07:04 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id t15sm8291309pjq.3.2020.09.17.01.07.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 01:07:03 -0700 (PDT)
Subject: Re: [PATCH] xfs: do the assert for all the log done items in
 xfs_trans_cancel
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600255152-16086-1-git-send-email-kaixuxia@tencent.com>
 <1600255152-16086-5-git-send-email-kaixuxia@tencent.com>
 <20200917001042.GP7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <821838e0-cfe6-19f9-7bea-88dfefe31ef5@gmail.com>
Date:   Thu, 17 Sep 2020 16:06:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200917001042.GP7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/17 8:10, Darrick J. Wong wrote:
> On Wed, Sep 16, 2020 at 07:19:07PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We should do the assert for all the log done items if they appear
>> here. This patch also add the XFS_ITEM_LOG_DONE flag to check if
>> the item is a log done item.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_bmap_item.c     | 2 +-
>>  fs/xfs/xfs_extfree_item.c  | 2 +-
>>  fs/xfs/xfs_refcount_item.c | 2 +-
>>  fs/xfs/xfs_rmap_item.c     | 2 +-
>>  fs/xfs/xfs_trans.c         | 2 +-
>>  fs/xfs/xfs_trans.h         | 4 ++++
>>  6 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
>> index ec3691372e7c..2e49f48666f1 100644
>> --- a/fs/xfs/xfs_bmap_item.c
>> +++ b/fs/xfs/xfs_bmap_item.c
>> @@ -202,7 +202,7 @@ xfs_bud_item_release(
>>  }
>>  
>>  static const struct xfs_item_ops xfs_bud_item_ops = {
>> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>>  	.iop_size	= xfs_bud_item_size,
>>  	.iop_format	= xfs_bud_item_format,
>>  	.iop_release	= xfs_bud_item_release,
>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
>> index 6cb8cd11072a..f2c6cb67262e 100644
>> --- a/fs/xfs/xfs_extfree_item.c
>> +++ b/fs/xfs/xfs_extfree_item.c
>> @@ -307,7 +307,7 @@ xfs_efd_item_release(
>>  }
>>  
>>  static const struct xfs_item_ops xfs_efd_item_ops = {
>> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>>  	.iop_size	= xfs_efd_item_size,
>>  	.iop_format	= xfs_efd_item_format,
>>  	.iop_release	= xfs_efd_item_release,
>> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
>> index ca93b6488377..551bcc93acdd 100644
>> --- a/fs/xfs/xfs_refcount_item.c
>> +++ b/fs/xfs/xfs_refcount_item.c
>> @@ -208,7 +208,7 @@ xfs_cud_item_release(
>>  }
>>  
>>  static const struct xfs_item_ops xfs_cud_item_ops = {
>> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>>  	.iop_size	= xfs_cud_item_size,
>>  	.iop_format	= xfs_cud_item_format,
>>  	.iop_release	= xfs_cud_item_release,
>> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
>> index dc5b0753cd51..427f90ef4509 100644
>> --- a/fs/xfs/xfs_rmap_item.c
>> +++ b/fs/xfs/xfs_rmap_item.c
>> @@ -231,7 +231,7 @@ xfs_rud_item_release(
>>  }
>>  
>>  static const struct xfs_item_ops xfs_rud_item_ops = {
>> -	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
>> +	.flags		= XFS_ITEM_LOG_DONE_FLAG,
>>  	.iop_size	= xfs_rud_item_size,
>>  	.iop_format	= xfs_rud_item_format,
>>  	.iop_release	= xfs_rud_item_release,
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index 4257fdb03778..d33d0ba6f3bd 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -1050,7 +1050,7 @@ xfs_trans_cancel(
>>  		struct xfs_log_item *lip;
>>  
>>  		list_for_each_entry(lip, &tp->t_items, li_trans)
>> -			ASSERT(!(lip->li_type == XFS_LI_EFD));
>> +			ASSERT(!(lip->li_ops->flags & XFS_ITEM_LOG_DONE));
>>  	}
>>  #endif
>>  	xfs_trans_unreserve_and_mod_sb(tp);
>> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
>> index 7fb82eb92e65..b92138b13c40 100644
>> --- a/fs/xfs/xfs_trans.h
>> +++ b/fs/xfs/xfs_trans.h
>> @@ -85,6 +85,10 @@ struct xfs_item_ops {
>>   * intents that never need to be written back in place.
>>   */
>>  #define XFS_ITEM_RELEASE_WHEN_COMMITTED	(1 << 0)
>> +#define XFS_ITEM_LOG_DONE		(1 << 1)	/* log done item */
>> +
>> +#define XFS_ITEM_LOG_DONE_FLAG	(XFS_ITEM_RELEASE_WHEN_COMMITTED | \
>> +				 XFS_ITEM_LOG_DONE)
> 
> Please don't go adding more flags for a debugging check.
> 
> You /could/ just detect intent-done items by the fact that their item
> ops don't have unpin or push methods, kind of like what we do for
> detecting intent items in log recovery.
> 
> Oh wait, you mowed /that/ down too.

Yes, this patch and the next patch add two flags XFS_ITEM_LOG_INTENT and
XFS_ITEM_LOG_DONE to mark the log item is log intent item or log done item.

By now that we can use the struct xfs_item_ops methods to find the log
intent items and log done items, but I'm not sure if we will use these special
methods in other log items, for example, we use the iop_recover method in a log
item that is not a log intent item for a special purpose... Anyway, it's just
my half-thoughts:)

I will use the special methods to detect the log done items in the next version .

Thanks,
Kaixu 
> 
> --D
> 
>>  
>>  void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
>>  			  int type, const struct xfs_item_ops *ops);
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
