Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDE2C4346E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 02:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674FB20BED
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 02:31:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvJhmNw5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgIYCbq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Sep 2020 22:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIYCbp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Sep 2020 22:31:45 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D5BC0613CE
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 19:31:45 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id fa1so1103187pjb.0
        for <linux-xfs@vger.kernel.org>; Thu, 24 Sep 2020 19:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yub0tLk5LkXFlfoI0Z1Q7MUrzUZJ2bduYqpSHmSFKSs=;
        b=CvJhmNw5SeL7hf3S7QKJul1vgfPEW1dL8LKDIq1QVVw/KuO6L3Klkxj/EM1obr+kXr
         GC7ot7BX0UF+8lbC6FO/vDF/TsofkkDPkFJNXAMlbzKcjNaooBF1H3i+HV5eLRCDNCuF
         dB9UVRvfqMJWHpewaTUR3bQYvnKWqsEydNF5kDDl8pkJGt579sKDe7R0SoyqhEz8aQ7V
         Y/Ry1ATXQNNHdtq8Jvh3iyjqPeBtuYrBcuvPXZ18ojDpCfXSNtXIRo7u8C6qbk1o5RqA
         IFTa7yPHVEv5oTNjdo4uhVJbq60qk8uYIqB617qio03IkZOBH323KzCjD88RJX481i4R
         N9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yub0tLk5LkXFlfoI0Z1Q7MUrzUZJ2bduYqpSHmSFKSs=;
        b=hnPDGTGeSeeCo256Dfd34Adu/ncmm50VKzcaSHuNx0Ja7ekd8fmqHiaFhigEmgL+Rp
         dhk33gBqudMWeNbGb0TjF5jUcRSryIRzqfYiLW6Ooi+tGmPWhACbVEt2WkmL8Acwpx8t
         3OfWinRFz0Uuv8J/Ob8+ddLzaO4FPQwIdHmV298/br1BD3NkONjCOeJ4SwB4PH1UQhDE
         MJtJvJ/EOxpVw8YWakIiF5YxedVDR5qZtngzv9BrhP7EZOCGXRewYsLgC17Teoj7fH8R
         hZtcDN+TxMOrKntpzpYnOjwmYfrf1/Mi/2gNmC3tFyVPx2kOvPyinUn54vfeKmu1n+PQ
         V8mw==
X-Gm-Message-State: AOAM531jl7wZR3ALeRgddhIFPAVZYzPWDDd0bzZ3vrQ6Kt9VJUQ+TVlx
        lwnNscCofGymPKGwMD5ZrrRbOReEqtA0GN4=
X-Google-Smtp-Source: ABdhPJwWVzMF299NE+cDsmF04GOCQe2kGeUZqSpjdghSl4tJpMMQAi17NtftLpQUluK9BmLCO3qcZw==
X-Received: by 2002:a17:90b:fc4:: with SMTP id gd4mr557862pjb.129.1601001105354;
        Thu, 24 Sep 2020 19:31:45 -0700 (PDT)
Received: from [10.76.92.41] ([103.7.29.7])
        by smtp.gmail.com with ESMTPSA id x198sm584832pgx.28.2020.09.24.19.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2020 19:31:44 -0700 (PDT)
Subject: Re: [RFC PATCH] xfs: directly call xfs_generic_create() for
 ->create() and ->mkdir()
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
References: <1600957817-22969-1-git-send-email-kaixuxia@tencent.com>
 <20200924150827.GF7955@magnolia>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <38979b48-7600-2abd-7e36-8c025184da37@gmail.com>
Date:   Fri, 25 Sep 2020 10:31:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924150827.GF7955@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2020/9/24 23:08, Darrick J. Wong wrote:
> On Thu, Sep 24, 2020 at 10:30:17PM +0800, xiakaixu1987@gmail.com wrote:
>> From: Kaixu Xia <kaixuxia@tencent.com>
>>
>> The current create and mkdir handlers both call the xfs_vn_mknod()
>> which is a wrapper routine around xfs_generic_create() function.
>> Actually the create and mkdir handlers can directly call
>> xfs_generic_create() function and reduce the call chain.
>>
>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
>> ---
>>  fs/xfs/xfs_iops.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
>> index 80a13c8561d8..b29d5b25634c 100644
>> --- a/fs/xfs/xfs_iops.c
>> +++ b/fs/xfs/xfs_iops.c
>> @@ -237,7 +237,7 @@ xfs_vn_create(
>>  	umode_t		mode,
>>  	bool		flags)
>>  {
>> -	return xfs_vn_mknod(dir, dentry, mode, 0);
>> +	return xfs_generic_create(dir, dentry, mode, 0, false);
>>  }
>>  
>>  STATIC int
>> @@ -246,7 +246,7 @@ xfs_vn_mkdir(
>>  	struct dentry	*dentry,
>>  	umode_t		mode)
>>  {
>> -	return xfs_vn_mknod(dir, dentry, mode|S_IFDIR, 0);
>> +	return xfs_generic_create(dir, dentry, mode|S_IFDIR, 0, false);
> 
> Might as well separate mode, the pipe, and S_IFDIR with a space...

Yeah, will fix it in the next version.

Thanks,
Kaixu
> 
> --D
> 
>>  }
>>  
>>  STATIC struct dentry *
>> -- 
>> 2.20.0
>>

-- 
kaixuxia
