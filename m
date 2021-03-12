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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44581C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 04:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0632C64F93
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 04:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhCLEZq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 23:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhCLEZS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 23:25:18 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB044C061574;
        Thu, 11 Mar 2021 20:25:17 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id p21so15040340pgl.12;
        Thu, 11 Mar 2021 20:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=j34L6WvUfG4y1tiZKOgfewghT0BSLNLv/xKvpS+TRWI=;
        b=RpIMnSxsD/bpx+qHyd/jm/T1omBxkQu5n672HQf81rfmJzU0BcxqqBjxIFrvZo7Yjn
         nSXYyNDPA4Q4ZwpQFsBSVQt1+vhsJE0C0H8V+rWlWgmVYTE+jKENioFjO1RrWbPplIHE
         HbruVXed0fpBbwbWf66iCXfRW4qndQ+P3fsZRMglhnjvE1V7lGMRDPl7H36SSG7eCRif
         YKxTG7JHQyovtLRUXnH5Ll6mmoXhFbI00xqpwXggibHedJ02je/SQsVwZ53bK/5zl5u8
         1tfHCtiqw+uzlyfMekkEf53/2/Oo52O8nyEPbJpU9OvDIMj1xu26E3MVhyDgrXvi13bs
         lumA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=j34L6WvUfG4y1tiZKOgfewghT0BSLNLv/xKvpS+TRWI=;
        b=BqXn3BtvySa5nDHWy0qK3182Cm09bMA4j8IBWd226gnWHkMMx+L1s9n+XT6oA5PWMh
         Jb7qi/t4mv1XtnzZQ/VK+xh7D7aFHnvugvaOMPS9gvJLjOZMuO7Q8NSII60N+VFkyCC3
         rxHeO1KHlO83aiKHVT90bcAhfONye2oRqYLXinCGti/g3XZtaAwcTc03nGMgQXO2wT51
         loUhvy/dXLpai0TlR/+NSvSaoZqBZwTkJXLpmZImFvV08IexximswcLyPmstCFZoTXBO
         KsedAjgj9z/KlD5D0UzNz156euDcL7cjs1IxnlJeJgUx8+1MGT+vb6SK6feST1Okzo+R
         e4jQ==
X-Gm-Message-State: AOAM531p5STCnpx0H1tBrZlPwpOnwEyUz7FkkJ5M4IFDVV+uTYDCNbEN
        VSRjAYWV5Cij3EhWmnRiATY=
X-Google-Smtp-Source: ABdhPJwg6RLuW6jsT5N/UYz4PemGYeQaJFAy3Xe+jsswewSIujYAJ7lNb7BaHVlcURFXdzAK78IDEg==
X-Received: by 2002:aa7:8681:0:b029:1fd:4dd2:5659 with SMTP id d1-20020aa786810000b02901fd4dd25659mr9645731pfo.8.1615523117415;
        Thu, 11 Mar 2021 20:25:17 -0800 (PST)
Received: from garuda ([122.179.18.33])
        by smtp.gmail.com with ESMTPSA id s19sm3840566pfh.168.2021.03.11.20.25.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 20:25:16 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526483668.1214319.17667836667890283825.stgit@magnolia> <87im5yc5dp.fsf@garuda>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 06/10] xfs: test quota softlimit warning functionality
In-reply-to: <87im5yc5dp.fsf@garuda>
Date:   Fri, 12 Mar 2021 09:55:13 +0530
Message-ID: <87im5xngly.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11 Mar 2021 at 16:40, Chandan Babu R wrote:
> On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
>> From: Darrick J. Wong <djwong@kernel.org>
>>
>> Make sure that quota softlimits work, which is to say that one can
>> exceed the softlimit up to warnlimit times before it starts enforcing
>> that.
>>
>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>> ---
>>  tests/xfs/915     |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/915.out |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/group   |    1
>>  3 files changed, 314 insertions(+)
>>  create mode 100755 tests/xfs/915
>>  create mode 100644 tests/xfs/915.out
>>
>>
>> diff --git a/tests/xfs/915 b/tests/xfs/915

[...]

>> +*** report initial settings
>> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
>> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
>> +
>> +*** push past the soft inode limit
>> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
>> +[NAME] 0 0 0 00 [--------] 4 3 500000 02 [7 days] 0 0 0 00 [--------]
>
> At this point in the test we have created 4 files.
> 1. softok{1,2,3}
> 2. softwarn1
>
> So we have exceeded the soft inode limit (i.e. 3) once. But the warning has
> been issued twice.
>
> _file_as_id() changes the project id of parent of each of the above files.  In
> this case all the above listed files have $SCRATCH_MNT as the parent. So by
> the time softok2 is created we have already reached the soft inode limit of 3
> (parent and the two softok{1,2} files) and creation of softok3 and softwarn1
> generates the two warnings listed above. If this explaination is correct,
> shouldn't 'Used' inode count have a value of 5 (including the inode associated
> with $SCRATCH_MNT)?

Sorry, I missed the fact that _file_as_id() reverts back the project id of
$SCRATCH_MNT just before returning.

The patch looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

-- 
chandan
