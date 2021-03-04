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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121C0C433E6
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 12:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C37FC64F11
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Mar 2021 12:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240426AbhCDMXN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 07:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240421AbhCDMXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Mar 2021 07:23:07 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCCDC061574;
        Thu,  4 Mar 2021 04:22:27 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id o38so18786453pgm.9;
        Thu, 04 Mar 2021 04:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=P72hWZ6bxe/qX8KwDrcb7vaiIBeNdBv/gKA9k1NIQrI=;
        b=pQwD97EeWbH2q0nG2wYdwDdVUhCQtGHSWOmEj1+gyahi1bctfhDkF/G2960iMjGEOm
         yqLSIYqFkJ7kIgtUZuPhCnH3vr2YCWhi3qvAT5BepM7V+oKauO1Gb/lcFpzRStfNTnup
         Fss+rovph/nAtiHwN/pNKI/jlelNqFVnYMXsSweiA9PaVbKnGbFuSzq3JwqPUg5uMYZ+
         pK0RU0iGT4JUgz08q0nQHef41EJUVct5ItA5zzpwvzX8BkXDNMMItK+hXGcB98hBhCfR
         g9JQT9cZBuKgYsXBJMNnFwunpedSuvCEyWjjPpj/djL7QZqZvWB5BIo4qQKB6OPY5KnD
         EtYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=P72hWZ6bxe/qX8KwDrcb7vaiIBeNdBv/gKA9k1NIQrI=;
        b=KjZbSVyqAuzGCdehSwH36mwE2P9uIEpY+fxURqEBnXetIcn8BzrHyHg0K6s82iIp+a
         ajtGKx69jcPOQ5ttRgFv+FZCB+dqM9TBIahHWhonVuKuVaTX/+CBm83366dJog1RKe77
         2ilCfFPHkLPU3iAxY6l17u90zXmhoQaJXlrDoKEMdpzQuANf6n7OAasI/kS4jiPeDt6C
         kY0HiLXm6KfkgYERwlYe/LlBYQ+pwVYbIgD6soyj6p7tKpp3uS4YWBrsLAa6BeojrcYE
         cfGCLWXptIhSr/Ph7s08htJCI8zUB2FTSsUvmg91r7jmjIh89xLUIeNioB25KuTJzuf2
         8sLw==
X-Gm-Message-State: AOAM530q6IwALR5dq+KEyaoUSXsLTDF3CK0EzCcxtkKg/FME+UbRLbCH
        Hk4C+LBgN4q2ODaynalWZ51T3HzOik4=
X-Google-Smtp-Source: ABdhPJzkmjRB/VOngXhM/+kJDoUDrpPPRG4bRLsl9m3G86paaI+HgOXiXb/9+ZNISUNRcyeNOtwhiA==
X-Received: by 2002:a62:2e83:0:b029:1db:8bd9:b8ad with SMTP id u125-20020a622e830000b02901db8bd9b8admr3743255pfu.74.1614860547373;
        Thu, 04 Mar 2021 04:22:27 -0800 (PST)
Received: from garuda ([122.179.119.194])
        by smtp.gmail.com with ESMTPSA id n24sm2826469pgl.27.2021.03.04.04.22.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Mar 2021 04:22:26 -0800 (PST)
References: <20210118062022.15069-1-chandanrlinux@gmail.com> <20210118062022.15069-7-chandanrlinux@gmail.com> <20210303180154.GN7269@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        darrick.wong@oracle.com
Subject: Re: [PATCH V4 06/11] xfs: Check for extent overflow when adding/removing dir entries
In-reply-to: <20210303180154.GN7269@magnolia>
Date:   Thu, 04 Mar 2021 17:52:23 +0530
Message-ID: <87pn0fp0qo.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 03 Mar 2021 at 23:31, Darrick J. Wong wrote:
> On Mon, Jan 18, 2021 at 11:50:17AM +0530, Chandan Babu R wrote:
>> This test verifies that XFS does not cause inode fork's extent count to
>> overflow when adding/removing directory entries.
>>
>> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
>> ---
>>  tests/xfs/526     | 186 ++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/526.out |  17 +++++
>>  tests/xfs/group   |   1 +
>>  3 files changed, 204 insertions(+)
>>  create mode 100755 tests/xfs/526
>>  create mode 100644 tests/xfs/526.out
>>
>> diff --git a/tests/xfs/526 b/tests/xfs/526
>> new file mode 100755
>> index 00000000..5a789d61
>> --- /dev/null
>> +++ b/tests/xfs/526
>> @@ -0,0 +1,186 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2020 Chandan Babu R.  All Rights Reserved.
>> +#
>> +# FS QA Test 526
>> +#
>> +# Verify that XFS does not cause inode fork's extent count to overflow when
>> +# adding/removing directory entries.
>> +seq=`basename $0`
>> +seqres=$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=`pwd`
>> +tmp=/tmp/$$
>> +status=1	# failure is the default!
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +	cd /
>> +	rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +. ./common/inject
>> +. ./common/populate
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs xfs
>> +_require_scratch
>> +_require_xfs_debug
>> +_require_test_program "punch-alternating"
>> +_require_xfs_io_error_injection "reduce_max_iextents"
>> +_require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>> +
>> +_scratch_mkfs_sized $((1024 * 1024 * 1024)) | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
>> +. $tmp.mkfs
>> +
>> +# Filesystems with directory block size greater than one FSB will not be tested,
>> +# since "7 (i.e. XFS_DA_NODE_MAXDEPTH + 1 data block + 1 free block) * 2 (fsb
>> +# count) = 14" is greater than the pseudo max extent count limit of 10.
>> +# Extending the pseudo max limit won't help either.  Consider the case where 1
>> +# FSB is 1k in size and 1 dir block is 64k in size (i.e. fsb count = 64). In
>> +# this case, the pseudo max limit has to be greater than 7 * 64 = 448 extents.
>> +if (( $dbsize != $dirbsize )); then
>> +	_notrun "FSB size ($dbsize) and directory block size ($dirbsize) do not match"
>> +fi
>
> But what about the case where fsb is 1k and dirblocks are 4k? :)
>
> I admit I'm reacting to my expectation that we would _notrun here based
> on the output of a more computation, not just fsb != dirblocksize.  But
> I dunno, maybe you've already worked that out?

Ok. I will replace the above with the following,

if (( $dirbsize > $dbsize )); then
        _notrun "Directory block size ($dirbsize) is larger than FSB size ($dbsize)"
fi

>
> (The rest of the test looks good to me.)
>
> --D

--
chandan
