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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CF0C4363D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64B822068D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 03:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rIZ5iELV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgIWD0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Sep 2020 23:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbgIWD0q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Sep 2020 23:26:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BAC061755
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:26:46 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 7so13489731pgm.11
        for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2020 20:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lAzIOsO+hDpTfWGcrrFUMTd7QphIklKpbz8eO7lCk3k=;
        b=rIZ5iELVnyifM/tMTI1FmNtoqXJlQwMNRtKS+ATSdh/TPEiJYOOO950P8eQl2WKIzh
         HNsoPnkCnqoZncBq1neUSk+nnYOQtp7qaGttO1dKmbXnERF1ilDAF/73dp9iDlkTKdmK
         74atZm8U1hzUM/x70kBTlUBV1tH6PjhOxO5jRlE7EhLHtTrxMUefbiCmUlu1I/MV1k/s
         OVona2UtYVHH7KcTyFTyZPzvLk0V8JIz6SEMr75Yi+7zUFfu+jI+bNeEMNN78QjUqz+w
         LhwBJ/hP0s3031ooV0fQB0px+NlHasg51xYbU3p6T3aoUHOX0yjpiawA6TbhR3JhL7Ne
         LaBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lAzIOsO+hDpTfWGcrrFUMTd7QphIklKpbz8eO7lCk3k=;
        b=iX3vitQHZO+j0KNbwRAeazIO/ZmEvWdoOH+S5e67oi8tiNkfYeUZ1dZzHjxN4vmX97
         4beeet7FcFOceq+POIMKaHpUsYx+tAUDUGyyM2t2qPMmYuil7VSH6xcl+FnSXO6zPPpJ
         pIMghhfbuC9AZzFTzAt5tJDU1qbe2k5XlDK7OkKOsA5EC08kxiSHXNWopST1awYUTDps
         mjaZroXE/QvlPZgAJwJGOkpTzF6sVhGKKsYTFm1b1dfxpWfP7uoQ9RTrkZ4lpMUPkWZN
         S0xdOh+ZVnJn8Ck/GhZgPg9i//lzS04SYGyppBKgtPR3CUB7FLuYOrPDEQkJw7ynrF0i
         WoZQ==
X-Gm-Message-State: AOAM5305mQk3jJP7UHXMLrrZGKvFsPjcZzdVbcwUZ5DCtVPNlpRdV+Ef
        LDYElYPxzPY1CTKE2lvcN2dQ4+J5KCf0sVY=
X-Google-Smtp-Source: ABdhPJyfTAZEFz5qZFrqlb91iBzrrEm0B+BIs+Z1JvDkEWQeHBNQoJpga8mZkpF/gez+cw/jpLfw4g==
X-Received: by 2002:a63:ff5d:: with SMTP id s29mr1521199pgk.442.1600831605962;
        Tue, 22 Sep 2020 20:26:45 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.9])
        by smtp.gmail.com with ESMTPSA id t7sm3651041pgh.25.2020.09.22.20.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 20:26:45 -0700 (PDT)
Subject: Re: [PATCH v2 4/7] xfs: do the assert for all the log done items in
 xfs_trans_cancel
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1600342728-21149-1-git-send-email-kaixuxia@tencent.com>
 <1600342728-21149-5-git-send-email-kaixuxia@tencent.com>
 <20200919062708.GA13501@infradead.org>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <c978b255-54db-c060-7ce9-2666e2741eb3@gmail.com>
Date:   Wed, 23 Sep 2020 11:26:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200919062708.GA13501@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/19 14:27, Christoph Hellwig wrote:
> On Thu, Sep 17, 2020 at 07:38:45PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> We should do the assert for all the log intent-done items if they appear
>> here. This patch detect intent-done items by the fact that their item ops
>> don't have iop_unpin and iop_push methods.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_trans.c | 9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
>> index ca18a040336a..0d5d5a53fa5a 100644
>> --- a/fs/xfs/xfs_trans.c
>> +++ b/fs/xfs/xfs_trans.c
>> @@ -925,6 +925,13 @@ xfs_trans_commit(
>>  	return __xfs_trans_commit(tp, false);
>>  }
>>  
>> +/* Is this a log intent-done item? */
>> +static inline bool xlog_item_is_intent_done(struct xfs_log_item *lip)
>> +{
>> +	return lip->li_ops->iop_unpin == NULL &&
>> +	       lip->li_ops->iop_push == NULL;
>> +}
> 
> I think this helper should go into xfs_trans.h, next to the
> xfs_log_item log item definition.  And xlog_item_is_intent should
> be moved there as well.
> 
Yeah，make more sense, will move them to xfs_trans.h in the next version.

Thanks,
Kaixu

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
kaixuxia
