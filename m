Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 757C2CA0EF3
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 15:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjILPmA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 11:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjILPl7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 11:41:59 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A27510E7
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 08:41:55 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-79536bc669dso193167539f.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 08:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1694533315; x=1695138115; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VDNK5jWxgoHKOmCCzn/tqxPBEH7/Kr3vTPO3bSps3Zg=;
        b=ar0Gv4rqwm03m6JYF5GycaXqqUfDX8SojcG3rn8HEBK5RJ6NA6+9HGv1AXlmCIMN+g
         Z+V+4/vAFiRlROiuKWCXYEknJCNeFMU1J3sKWqsekcCCM68cpGtjG57GIGiUc86NoKL9
         sFfbKim3s8W5AthyetrxndmqC02Mt7ui4LrNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694533315; x=1695138115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDNK5jWxgoHKOmCCzn/tqxPBEH7/Kr3vTPO3bSps3Zg=;
        b=oWwY8LatRR6dG1SLyiQb0KmCVoFUiQKYlyF/HmLlRi8caDcycHS5njsHdKtkCs+Twm
         8rTGq7FrSXnTBppfkcRlwUpu+d84cAOmmHmLi3o2VRUBA1hhsObIpckLstbdTZXhtomU
         7QMP3Ml/n2+nHAnT+URaeNrtvUFVU0ExgDjVGRTYshHUdUMFKzA8EWMbuYdTMreRljpv
         BVoxnppkG0gV2u5bcQlqWVeimnJVKtGv+/+khKkF9bhOWDrKfv/12ROwQcJIMrqsZNOb
         GlbuaD1eMIYkK9seYFiaU0DVza8OLsYjfDlDenFLJT1CvR+m5Y1S8t1Ico4LRO2lFTAo
         NA+Q==
X-Gm-Message-State: AOJu0Yy9NT43BfP/zqEySimxTZniB0C1QtO410U/eIGoU47PfuLVME9j
        c63JHp7iq0dglZrObb8XfJ+NptoaWW8VGZNcIMU=
X-Google-Smtp-Source: AGHT+IHhqB2YJjwIaI0yHXnKZwS98a5YXRBDK9CZv/ud4lMLOjHhuOSeE6ucAS6gLtpMRtSQWOD4WA==
X-Received: by 2002:a5d:9c4f:0:b0:798:3e95:274f with SMTP id 15-20020a5d9c4f000000b007983e95274fmr121547iof.19.1694533314846;
        Tue, 12 Sep 2023 08:41:54 -0700 (PDT)
Received: from [172.22.22.28] (c-98-61-227-136.hsd1.mn.comcast.net. [98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id e2-20020a05660222c200b00777b7fdbbffsm2897139ioe.8.2023.09.12.08.41.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 08:41:54 -0700 (PDT)
Message-ID: <e575bbf3-f0ba-ec39-03c5-9165678d1fc7@ieee.org>
Date:   Tue, 12 Sep 2023 10:41:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH] xfs: delete some dead code in xfile_create()
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        linux-xfs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1429a5db-874d-45f4-8571-7854d15da58d@moroto.mountain>
 <20230912153824.GB28186@frogsfrogsfrogs>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20230912153824.GB28186@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/12/23 10:38 AM, Darrick J. Wong wrote:
> On Tue, Sep 12, 2023 at 06:18:45PM +0300, Dan Carpenter wrote:
>> The shmem_file_setup() function can't return NULL so there is no need
>> to check and doing so is a bit confusing.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>> ---
>> No fixes tag because this is not a bug, just some confusing code.
> 
> Please don't re-send patches that have already been presented here.
> https://lore.kernel.org/linux-xfs/20230824161428.GO11263@frogsfrogsfrogs/

FWIW, I side with Dan's argument.  shmem_file_setup() *does not*
return NULL.  If it ever *did* return NULL, it would be up to the
person who makes that happen to change all callers to check for NULL.

The current code *suggests* that it could return NULL, which
is not correct.

					-Alex

> 
> --D
> 
>>   fs/xfs/scrub/xfile.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
>> index d98e8e77c684..71779d81cad7 100644
>> --- a/fs/xfs/scrub/xfile.c
>> +++ b/fs/xfs/scrub/xfile.c
>> @@ -70,8 +70,6 @@ xfile_create(
>>   		return -ENOMEM;
>>   
>>   	xf->file = shmem_file_setup(description, isize, 0);
>> -	if (!xf->file)
>> -		goto out_xfile;
>>   	if (IS_ERR(xf->file)) {
>>   		error = PTR_ERR(xf->file);
>>   		goto out_xfile;
>> -- 
>> 2.39.2
>>

