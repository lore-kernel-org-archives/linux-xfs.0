Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB91C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 21:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4521420855
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 21:28:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="XnJKUdpr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHFV2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 17:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgHFV2y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 17:28:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF4C061574
        for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2020 14:28:53 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mw10so3640206pjb.2
        for <linux-xfs@vger.kernel.org>; Thu, 06 Aug 2020 14:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2lJRJTwvENpDAW5AwuYPZPT385WPYs9MEp7IL4/DPVc=;
        b=XnJKUdprMfzxCjaz5Mp+ypgnNPEmyUdmYP2bZrClNW5XZgBhDpcwgX7CiSIc7Qn+LY
         cHcpL1vCehuqd9WlCMzUDzq0Cc7sYpWlSF8+aQwhqDgFn/XiwP2D6f8KMKXgfZtYVr6l
         WfG+qVcFeEIKkKT0aWXQ5ASQpxOVI+nWWGbO9+/scatNDkh+eAOsojbrc6jh19Cxir0/
         2+EonkdyKVwJeN7Z3h0WRSEWiZ85uGfxy+0WGDz72dhhSY0/B2Sjen9pY7aicMMhJV8T
         6v8xz0o3yqJmGEGHrHehcngf3c9XxDHuFwErg/qKdM792rcJMa44YUQfXE4SviUqa7FW
         dhMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2lJRJTwvENpDAW5AwuYPZPT385WPYs9MEp7IL4/DPVc=;
        b=qEVum5YGb9pgNpV2oM2Ag7nE7PQKScIaUGew6Uybi+ncsFD1MpgIY8IYlGUQ9iD18Z
         OJxyU36oaTZjz+86pygwZXGnLPUPfiC9B9QxOtLplMkKjTr5jJ/TYikaPVmzqoTWOGEs
         qvvc0eaBfinq62ZQ4fSEMC0LQifduhdvW2fU3DO6sPpFOLTLbxltavuMt0vRe8/QbiKo
         9I7lnFbqeKPwbZRFFG4WURBe4jLbne2paeIGjdFIyqbgjbiXSCp0FJ2xj7Rw0LHpe8pc
         gopo6ldYq+Yz0ajD9+hGSxuiT9XmjcRolIixkI6XZmekFbqJf0NEK7TbvAJOiNDlqvnS
         Akzg==
X-Gm-Message-State: AOAM533usYyZlv1pmcwkx+Q1y1hpciyAZp8Qp9P6iLGcZFuaMkFQzB6C
        OuExBLBinThw3R7oUW71ICR8eg==
X-Google-Smtp-Source: ABdhPJwy+rJvKCRaUwOO4BKsqLhD4Va9EKI3SIzQOljlTakdytgaT2CmeZym7V77h+qQyX2E50LMjg==
X-Received: by 2002:a17:90a:ff85:: with SMTP id hf5mr10028161pjb.79.1596749332986;
        Thu, 06 Aug 2020 14:28:52 -0700 (PDT)
Received: from Etsukata.local (p14232-ipngn10801marunouchi.tokyo.ocn.ne.jp. [122.24.13.232])
        by smtp.gmail.com with ESMTPSA id 207sm9334233pfz.203.2020.08.06.14.28.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Aug 2020 14:28:52 -0700 (PDT)
Subject: Re: [PATCH] xfs: Fix UBSAN null-ptr-deref in xfs_sysfs_init
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200806150527.2283029-1-devel@etsukata.com>
 <20200806151331.GD6107@magnolia>
From:   Eiichi Tsukata <devel@etsukata.com>
Openpgp: preference=signencrypt
Autocrypt: addr=devel@etsukata.com; keydata=
 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
Message-ID: <953af7c9-73bb-ccc4-bb69-083b585d1dd3@etsukata.com>
Date:   Fri, 7 Aug 2020 06:28:49 +0900
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20200806151331.GD6107@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Thanks, I sent it to linux-xfs ML. I had some trouble with gmail server.

Eiichi

On 2020/08/07 0:13, Darrick J. Wong wrote:
> On Fri, Aug 07, 2020 at 12:05:27AM +0900, Eiichi Tsukata wrote:
>> If xfs_sysfs_init is called with parent_kobj == NULL, UBSAN
>> shows the following warning:
> 
> This needs to be sent to the xfs mailing list, per get_maintainers.pl.
> 
> --D
> 
>>   UBSAN: null-ptr-deref in ./fs/xfs/xfs_sysfs.h:37:23
>>   member access within null pointer of type 'struct xfs_kobj'
>>   Call Trace:
>>    dump_stack+0x10e/0x195
>>    ubsan_type_mismatch_common+0x241/0x280
>>    __ubsan_handle_type_mismatch_v1+0x32/0x40
>>    init_xfs_fs+0x12b/0x28f
>>    do_one_initcall+0xdd/0x1d0
>>    do_initcall_level+0x151/0x1b6
>>    do_initcalls+0x50/0x8f
>>    do_basic_setup+0x29/0x2b
>>    kernel_init_freeable+0x19f/0x20b
>>    kernel_init+0x11/0x1e0
>>    ret_from_fork+0x22/0x30
>>
>> Fix it by checking parent_kobj before the code accesses its member.
>>
>> Signed-off-by: Eiichi Tsukata <devel@etsukata.com>
>> ---
>>  fs/xfs/xfs_sysfs.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
>> index e9f810fc6731..aad67dc4ab5b 100644
>> --- a/fs/xfs/xfs_sysfs.h
>> +++ b/fs/xfs/xfs_sysfs.h
>> @@ -32,9 +32,9 @@ xfs_sysfs_init(
>>  	struct xfs_kobj		*parent_kobj,
>>  	const char		*name)
>>  {
>> +	struct kobject *parent = parent_kobj ? &parent_kobj->kobject : NULL;
>>  	init_completion(&kobj->complete);
>> -	return kobject_init_and_add(&kobj->kobject, ktype,
>> -				    &parent_kobj->kobject, "%s", name);
>> +	return kobject_init_and_add(&kobj->kobject, ktype, parent, "%s", name);
>>  }
>>  
>>  static inline void
>> -- 
>> 2.26.2
>>
