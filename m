Return-Path: <SRS0=H2w8=D3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A4BBC433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FB92223BF
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Oct 2020 02:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t4gD8ums"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729069AbgJTC73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Oct 2020 22:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729053AbgJTC73 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Oct 2020 22:59:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89549C0613CE
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 19:59:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id y14so146883pgf.12
        for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2020 19:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EVBSGP6+QCfT2Hy0wUMImPFpXc8yp7x/ca3T9oToD8I=;
        b=t4gD8umsLfyfwwvurPvZb4F4GUaeb9yav+G3cCGxK6RV7Pfr+b8lQYEDlj5zyBntCg
         QjhQMc+1PnGbEanfvAJ8cicFqiy+gO2oLMDq1SsCpHY/GPIJMHDS/oSGGfsvrrvrz8Pv
         hKwvCQHnOTilkUC9fRZnreEb9SPFCJooTNd8pGkyMgZg8KKmvcCwV87kYRIIspNxN7pk
         uih1Pne8zcC1Pihh9zd+OGRj6pUXUu+zaJ1ppow0ev1yQxGfxtwd2fgwARyuXe5xkUap
         /Laojqppwf4YWVq8qOT3BrJEn+38HIdpe6HmDv2aFl2Y744SG68eFENnxlzaQZqcIQqA
         uEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVBSGP6+QCfT2Hy0wUMImPFpXc8yp7x/ca3T9oToD8I=;
        b=NnhlrumutW0D/73Y8ax8/Bdj/2OwiKxNJ0EyfFezNVwcNoCjfl+Ks+DtQ28btFrwZG
         Wdwzy8I3B9wFM6Y6Gplk1TzNNh6ry+4fFpZN75g+h2YkJ5lwkB95R0zv0+QPFKVIW85n
         miIBo1KtHRWLBrdNQGlzbQgVoPogw7/se68eE9A8e7pc62JLrFTrETel4ybGQtjbNvqi
         kJ+yzq1DTKGuYzkvnmpAQLx5CvqmG/sLOHGVFVmh8tZysIn6LayikZxQaukrHsFyMfWb
         e7zh6Bx/NYiMA4omHuqYUgI65Oa+sIViwhzdO+ip4bsYPscGBTOkKMugEd1OxX6/FC94
         lN9A==
X-Gm-Message-State: AOAM531bLTHAKOx2OaZpPoJPS9n6JJomLjQN4WoXY0u0QyEVzN9CrWkS
        wpqPOvI5LPHAdhfU7i6l8A==
X-Google-Smtp-Source: ABdhPJyh5sTecJePR9fk/sAPqlcHYAoAcnX3l6VwGvsChplAAmvU2MjB/fZxejDNRcPBhVgJk0KJEA==
X-Received: by 2002:a62:9245:0:b029:156:4a19:a250 with SMTP id o66-20020a6292450000b02901564a19a250mr735731pfd.2.1603162769039;
        Mon, 19 Oct 2020 19:59:29 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.6])
        by smtp.gmail.com with ESMTPSA id h21sm192530pgi.88.2020.10.19.19.59.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2020 19:59:28 -0700 (PDT)
Subject: Re: [PATCH] xfs: remove the unused BBMASK macro
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
References: <1603100845-12205-1-git-send-email-kaixuxia@tencent.com>
 <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <90762d8f-8a42-a07d-fc52-9422eda780cd@gmail.com>
Date:   Tue, 20 Oct 2020 10:59:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <c1453fb1-3e84-677c-15ab-7f51ca758862@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/10/19 21:54, Eric Sandeen wrote:
> On 10/19/20 4:47 AM, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> There are no callers of the BBMASK macro, so remove it.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/libxfs/xfs_fs.h | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
>> index 2a2e3cfd94f0..8fd1e20f0d73 100644
>> --- a/fs/xfs/libxfs/xfs_fs.h
>> +++ b/fs/xfs/libxfs/xfs_fs.h
>> @@ -847,7 +847,6 @@ struct xfs_scrub_metadata {
>>   */
>>  #define BBSHIFT		9
>>  #define BBSIZE		(1<<BBSHIFT)
>> -#define BBMASK		(BBSIZE-1)
>>  #define BTOBB(bytes)	(((__u64)(bytes) + BBSIZE - 1) >> BBSHIFT)
>>  #define BTOBBT(bytes)	((__u64)(bytes) >> BBSHIFT)
>>  #define BBTOB(bbs)	((bbs) << BBSHIFT)
> 
> 
> This header is shared with userspace, and the macro is used there,
> though only once.
> 
> This header is also shipped as part of the "install-dev" fileset, and
> defines a public API, though I don't think BBMSK is actually used
> in any userspace interface.

Right...I didn't consider this situation, will drop this patch.

Thanks,
Kaixu
> 
> -Eric
> 

-- 
kaixuxia
