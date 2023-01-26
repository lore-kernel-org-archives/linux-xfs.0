Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38ADBC27C76
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Jan 2023 03:28:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjAZD2k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 25 Jan 2023 22:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjAZD2j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2023 22:28:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0E7469D
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 19:27:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674703676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lfyMAdwdPoNeG0rn/jUqa2cEVofY9+B2Qvz2SoqM+8E=;
        b=WCMZRYriB/Mo8gTTzXaBSQ/W+JukAlIRGe23v1vZiMXYlzpEDnGmXfsqApkmaGssnCuXeh
        ABUlwaoT+Vnd9tCsXroPRMdNkywK9w8Ajcot8e7Q0Ma6NhqVV1DDRWhE+/cA7h7DN6VBN/
        jBT9QoOjskoh5a9yL2RpFATj5/vBWOY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-223-LL2FNLbrOm2Nl-Gnlg7Xlg-1; Wed, 25 Jan 2023 22:27:54 -0500
X-MC-Unique: LL2FNLbrOm2Nl-Gnlg7Xlg-1
Received: by mail-pf1-f199.google.com with SMTP id s4-20020a056a00194400b0058d9b9fecb6so318488pfk.1
        for <linux-xfs@vger.kernel.org>; Wed, 25 Jan 2023 19:27:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfyMAdwdPoNeG0rn/jUqa2cEVofY9+B2Qvz2SoqM+8E=;
        b=OsHPUk8YZHBaZWx+hrumI6kT+OYUVWfrEO9Q/X30XPTBhfDf639Uk99ahCuId5qLep
         B5HXkryXSqeKdADS5lFSqtqrQXlDpQPOpo6rdyayq9hUP1GHTzT7ic3TT26sXSCY64Ey
         STvS9h03cOZHCFCYsqQqo+FNQgUA07JOAJDmW5if6cZc7vEMq/nn4MZlj8a/IEjyf68T
         Gn5EATl0djp6e6+H2yeP4gcfjkNBeBOe3HYXlGvpqCdvD4ACspRXqKJ/SNnSxjMAWOYE
         CSZz+Q+6z3kGxS+G+OUpd5Ifdr5nePOhtZPf1pfehv2CZzm9lNpHrsJ6BMBLealKQRYH
         Ng6w==
X-Gm-Message-State: AFqh2koC6vHeBq7771NZO66vyKRotbMw4/0pphXjnuP5m9s7c2GzFcRL
        E/mRZzF7RbloxtYA0t4tlPrmjh2PEmGmD8nbdJ604EtTJhAIR7N4kYRfLX1xMdveQ0/fxro1VoC
        YWDUzMtt4k8ShA+qcSGC1
X-Received: by 2002:a05:6a21:170d:b0:b6:3a0:6ec1 with SMTP id nv13-20020a056a21170d00b000b603a06ec1mr32240798pzb.25.1674703673534;
        Wed, 25 Jan 2023 19:27:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXudEsyqy5yGkt+YuN320jxkT5ezlGlK+9FyhfYDQYnaQ2601/Zv/CgsfhKS2UhUZHXGtz/rlg==
X-Received: by 2002:a05:6a21:170d:b0:b6:3a0:6ec1 with SMTP id nv13-20020a056a21170d00b000b603a06ec1mr32240777pzb.25.1674703673150;
        Wed, 25 Jan 2023 19:27:53 -0800 (PST)
Received: from ?IPV6:2001:8003:4800:1b00:4c4a:1757:c744:923? ([2001:8003:4800:1b00:4c4a:1757:c744:923])
        by smtp.gmail.com with ESMTPSA id k66-20020a633d45000000b00476d1385265sm3959721pga.25.2023.01.25.19.27.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 19:27:52 -0800 (PST)
Message-ID: <c8c9f731-a125-0c42-e814-da5eb3d219ca@redhat.com>
Date:   Thu, 26 Jan 2023 14:27:49 +1100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] xfs: allow setting full range of panic tags
Content-Language: en-AU, en-HK
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
References: <20230125050138.372749-1-ddouwsma@redhat.com>
 <Y9FVKelYL38Ka2mY@magnolia>
From:   Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <Y9FVKelYL38Ka2mY@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 26/01/2023 03:13, Darrick J. Wong wrote:
> On Wed, Jan 25, 2023 at 04:01:38PM +1100, Donald Douwsma wrote:
>> xfs will not allow combining other panic values with XFS_PTAG_VERIFIER_ERROR.
>>
>>   sysctl fs.xfs.panic_mask=511
>>   sysctl: setting key "fs.xfs.panic_mask": Invalid argument
>>   fs.xfs.panic_mask = 511
>>
>> Update to the maximum value that can be set to allow the full range of masks.
>>
>> Fixes: d519da41e2b78 ("xfs: Introduce XFS_PTAG_VERIFIER_ERROR panic mask")
>> Signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
>> ---
>>   Documentation/admin-guide/xfs.rst | 2 +-
>>   fs/xfs/xfs_globals.c              | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
>> index 8de008c0c5ad..e2561416391c 100644
>> --- a/Documentation/admin-guide/xfs.rst
>> +++ b/Documentation/admin-guide/xfs.rst
>> @@ -296,7 +296,7 @@ The following sysctls are available for the XFS filesystem:
>>   		XFS_ERRLEVEL_LOW:       1
>>   		XFS_ERRLEVEL_HIGH:      5
>>   
>> -  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 256)
>> +  fs.xfs.panic_mask		(Min: 0  Default: 0  Max: 511)
>>   	Causes certain error conditions to call BUG(). Value is a bitmask;
>>   	OR together the tags which represent errors which should cause panics:
>>   
>> diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
>> index 4d0a98f920ca..e0e9494a8251 100644
>> --- a/fs/xfs/xfs_globals.c
>> +++ b/fs/xfs/xfs_globals.c
>> @@ -15,7 +15,7 @@ xfs_param_t xfs_params = {
>>   			  /*	MIN		DFLT		MAX	*/
>>   	.sgid_inherit	= {	0,		0,		1	},
>>   	.symlink_mode	= {	0,		0,		1	},
>> -	.panic_mask	= {	0,		0,		256	},
>> +	.panic_mask	= {	0,		0,		511	},
> 
> Why not fix this by defining an XFS_PTAG_ALL_MASK that combines all
> valid flags and use that here?  That way we eliminate this class of bug.

Sure, perhaps XFS_MAX_PTAG to fit with its use in xfs_params?

> 
> Looking at d519da41e2b78, the maintainers suck at noticing these kinds
> of mistakes.

The interface is problematic in the field too, folks were using 256 to
mean all, and wondered why they weren't hitting anything, including
XFS_PTAG_SHUTDOWN_CORRUPT. I'll OR together the masks to be clear
with respect to the documentation.

Don

> 
> --D
> 
>>   	.error_level	= {	0,		3,		11	},
>>   	.syncd_timer	= {	1*100,		30*100,		7200*100},
>>   	.stats_clear	= {	0,		0,		1	},
>> -- 
>> 2.31.1
>>
> 

