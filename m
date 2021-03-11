Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FABEC433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 02:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D080664FC6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 02:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhCKCy6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Mar 2021 21:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbhCKCy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 21:54:28 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86193C061574;
        Wed, 10 Mar 2021 18:54:28 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t85so8239525pfc.13;
        Wed, 10 Mar 2021 18:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1v7GCMTbQVIYexLaeQhCjrZGJ9XTKr3ZQAKaEmI4eGE=;
        b=Ks0HsErcrZOI7L02ETepT4Z6ai4QTf0EmdyKJ9t2O3lVdQ+a/5kF3u22mKFSrN/Vtc
         pjOfpoxv5dMuacHUNJ+8+K6gKeHh4PNXicNWsN9niUelRpjoXWi/CBnQyw943NTRdPBv
         +6x7JHY9iwnE/wFiu6ug0clB28gdwuCL4v6NFxYKLQhAYUtkDe/VaHLoPkaO9OXJeJcp
         lxRe7VqKJAPzGxTee3LXufd0xz0Lvrqks8TAI6JY7jkjjFqpYs/5DXfOamIPauQ5VYuz
         kLza35aFK8HUUGSRtv94t36+uNk/uBIJUQ5LtiWkoAxHb2OIz1OyZuuGQ/0rUuU2kfkP
         CVdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1v7GCMTbQVIYexLaeQhCjrZGJ9XTKr3ZQAKaEmI4eGE=;
        b=nA+DbN2XogHkKPeQcqDXN7mCw1wFTPE3DrtjnEUhi30p/kl7dbTuX64gw3aRR9uy5g
         tbolxjwLIboJhAkj0I6lYNB0wLNJQKBYZlWYqd7UXSylqCUdcuZdcOu3fCQm8h5lo9MV
         MAdLkGO6oFbg5OtpaUBHoEfm4l+f4YUFMFvksHFmgP402r8Fg6ApVE7bt8r3ExjtcQlO
         9vCPflwp/bHePAI6HMz8DjfPOfahwqQIpAJRHcKoTXqUJ/kXZENEkq2vzHYqYJAxbKwJ
         vIHwYOIZgBxSoNKoPKLMeegkHBRMlAftRpPhFDVC/XxgJ57J+wxpt7kDa6MKZk4SOX1x
         ttvA==
X-Gm-Message-State: AOAM531apoV7AH0noxZzNvoArXs5YPbspyyAfxVsJGAJ7pfJpZPL0zXb
        W4KuCczvb9Lfpx5a07HqLtc=
X-Google-Smtp-Source: ABdhPJyMxSPiopdQo227qyajyCCLLVIfPYHrdOWh8BIhDf27lxeg9ql7zMbN8/cK6dx51vrhAJZ4Hw==
X-Received: by 2002:aa7:820b:0:b029:1f2:3050:cc6 with SMTP id k11-20020aa7820b0000b02901f230500cc6mr5736805pfi.52.1615431268041;
        Wed, 10 Mar 2021 18:54:28 -0800 (PST)
Received: from garuda ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id j3sm722059pgk.24.2021.03.10.18.54.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 18:54:27 -0800 (PST)
References: <20210309050124.23797-1-chandanrlinux@gmail.com> <20210309050124.23797-4-chandanrlinux@gmail.com> <148ab249-be7a-2686-7995-a256e34f292a@oracle.com>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        djwong@kernel.org
Subject: Re: [PATCH V6 03/13] common/xfs: Add helper to obtain fsxattr field value
In-reply-to: <148ab249-be7a-2686-7995-a256e34f292a@oracle.com>
Date:   Thu, 11 Mar 2021 08:24:24 +0530
Message-ID: <871rcm1jtr.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 10 Mar 2021 at 11:43, Allison Henderson wrote:
> On 3/8/21 10:01 PM, Chandan Babu R wrote:
>> This commit adds a helper function to obtain the value of a particular field
>> of an inode's fsxattr fields.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>   common/xfs | 9 +++++++++
>>   1 file changed, 9 insertions(+)
>>
>> diff --git a/common/xfs b/common/xfs
>> index 26ae21b9..130b3232 100644
>> --- a/common/xfs
>> +++ b/common/xfs
>> @@ -194,6 +194,15 @@ _xfs_get_file_block_size()
>>   	$XFS_INFO_PROG "$path" | grep realtime | sed -e 's/^.*extsz=\([0-9]*\).*$/\1/g'
>>   }
>>   +_xfs_get_fsxattr()
>> +{
>> +	local field="$1"
>> +	local path="$2"
>> +
>> +	local value=$($XFS_IO_PROG -c "stat" "$path" | grep "$field")
>> +	echo ${value##fsxattr.${field} = }
>> +}
>> +
> In fiddling with the commands here, I think I may have noticed a bug.
> I think you want to grep whole words only, or you may mistakenly match
> sub words. Example:
>
> root@garnet:/home/achender/work_area# field="extsize "
> root@garnet:/home/achender/work_area# xfs_io -c "stat"
> /mnt/scratch/test | grep "$field"
> fsxattr.extsize = 0
> fsxattr.cowextsize = 0
>
> I think if you add the -w to the grep that fixes it:
> root@garnet:/home/achender/work_area# xfs_io -c "stat"
> /mnt/scratch/test | grep -w "$field"
> fsxattr.extsize = 0
>
> I think that's what you meant to do right?
>

Yes, that was the intended behaviour. Thanks for catching the bug and
suggesting the appropriate solution.

I will fix this.

Also, Thanks for reviewing the entire patchset.

--
chandan
