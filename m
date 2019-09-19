Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BDAC3A5A6
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 09:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B61A621927
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 09:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsCu3Fdo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfISJIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 05:08:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34460 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730632AbfISJIJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Sep 2019 05:08:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so1312940plr.1;
        Thu, 19 Sep 2019 02:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UaTVqpHgFEipW6sqFFVLBqtYTSqFXnoYit7eFT5q0+s=;
        b=dsCu3FdoQi5TcFtK6JkASj9/9Q2AoEbTrbtImNLUWfPPHONoHkSyTqgSNGOxFOWjUq
         OGoKVJLFIo2GXFCaCvUPIfGjt2FLOuaqhapmX+WBPav1+TzBueYuEU04P5qTwEbAIKII
         +66OeL1vwDd4bnIWp2Qd1np+fG5fDQNSdE8GL6lBvpU6TEVfN4aKf+qxcFzG1VpKtSih
         Xvmd7tetB5fHnB3zZCe2YWce7PVM0lxsJu6BOMTErfzrC8DGvCjyCZx4itcrFFCviokF
         S1ViVgirFFDBFg5GqkIJtoYDxxgNU83I3FUWlr8bfEeyIAvbMtX2+OmAo3Jh/j6e7xnO
         DNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UaTVqpHgFEipW6sqFFVLBqtYTSqFXnoYit7eFT5q0+s=;
        b=YbysVUU/WfilYfa1Skcsagjya4cm0PBKNg3V5wX47zSZQQacy/RDG+x4Qd84Pg3+K4
         CNGW5LaqVV8kf2fZciPSxg8RFunXTuEJvEHdBhpz0KnfblUnKmBhCjYYNhGJTuzTfHsT
         XyL24QcRa10F9v+L/vZzd9IcCatuPE5WaekEcttsoPehT6cF09ns7iFgioaqpL67hq2t
         CeyS/w++MkeV7c6yLUCuSDvLsrZCBDiCkJqdbRhzb1fhIZlkip/NS4v786juNOK9DYso
         CtLvL2hP1d+KM4rpBCfErGIVITXsaPSerg9KbW6Dc/UM5QlVajPO6SuPmYAE2579KmPV
         RI0A==
X-Gm-Message-State: APjAAAWu8g4uxWDavJgajd02+8hRHlZllLpe0DRrThFADt2X9eYhbrPl
        HXuSYzGX3CScUOl5fBhS1HIMycQ=
X-Google-Smtp-Source: APXvYqwDuVK3qY0Iq9IMoVpNILODh/zoeJI3nEH60cUZ0Wi5GUlWpXN6EcwPRi7fT0eZPSkCy2jJqA==
X-Received: by 2002:a17:902:fe91:: with SMTP id x17mr8984714plm.106.1568884087869;
        Thu, 19 Sep 2019 02:08:07 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id z13sm9897843pfq.121.2019.09.19.02.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 02:08:07 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] xfs: test the deadlock between the AGI and AGF
 with RENAME_WHITEOUT
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <db6c5d87-5a47-75bd-4d24-a135e6bcd783@gmail.com>
 <20190918135947.GD29377@bfoster>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <8941c9b8-1589-4e1f-c20b-7d128225d7f6@gmail.com>
Date:   Thu, 19 Sep 2019 17:08:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190918135947.GD29377@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2019/9/18 21:59, Brian Foster wrote:
> On Wed, Sep 18, 2019 at 07:49:22PM +0800, kaixuxia wrote:
>> There is ABBA deadlock bug between the AGI and AGF when performing
>> rename() with RENAME_WHITEOUT flag, and add this testcase to make
>> sure the rename() call works well.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
> 
> FYI, for some reason your patch series isn't threaded on the mailing
> list. I thought git send-email did this by default. Assuming you're not
> explicitly using --no-thread, you might have to use the --thread option
> so this gets posted as a proper series.
> 
Yeah, thanks!
>>  tests/xfs/512     | 96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/512.out |  2 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 99 insertions(+)
>>  create mode 100755 tests/xfs/512
>>  create mode 100644 tests/xfs/512.out
>>
>> diff --git a/tests/xfs/512 b/tests/xfs/512
>> new file mode 100755
>> index 0000000..a2089f0
>> --- /dev/null
>> +++ b/tests/xfs/512
>> @@ -0,0 +1,96 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
>> +#
>> +# FS QA Test 512
>> +#
>> +# Test the ABBA deadlock case between the AGI and AGF When performing
>> +# rename operation with RENAME_WHITEOUT flag.
>> +#
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
>> +. ./common/renameat2
>> +
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_supported_os Linux
>> +# single AG will cause default xfs_repair to fail. This test need a
>> +# single AG fs, so ignore the check.
>> +_require_scratch_nocheck
>> +_requires_renameat2 whiteout
>> +
>> +filter_enospc() {
>> +	sed -e '/^.*No space left on device.*/d'
>> +}
>> +
>> +create_file()
>> +{
>> +	local target_dir=$1
>> +	local files_count=$2
>> +
>> +	for i in $(seq 1 $files_count); do
>> +		echo > $target_dir/f$i >/dev/null 2>&1 | filter_enospc
>> +	done
>> +}
>> +
>> +rename_whiteout()
>> +{
>> +	local target_dir=$1
>> +	local files_count=$2
>> +
>> +	# a long filename could increase the possibility that target_dp
>> +	# allocate new blocks(acquire the AGF lock) to store the filename
>> +	longnamepre=`$PERL_PROG -e 'print "a"x200;'`
>> +
>> +	# now try to do rename with RENAME_WHITEOUT flag
>> +	for i in $(seq 1 $files_count); do
>> +		src/renameat2 -w $SCRATCH_MNT/f$i $target_dir/$longnamepre$i >/dev/null 2>&1
>> +	done
>> +}
>> +
>> +_scratch_mkfs_xfs -d agcount=1 >> $seqres.full 2>&1 ||
>> +	_fail "mkfs failed"
> 
> This appears to be the only XFS specific bit. Could it be
> conditionalized using FSTYP such that this test could go under
> tests/generic?
> 
OK, I'll move this test to tests/generic by using FSTYP.

>> +_scratch_mount
>> +
>> +# set the rename and create file counts
>> +file_count=50000
>> +
>> +# create the necessary directory for create and rename operations
>> +createdir=$SCRATCH_MNT/createdir
>> +mkdir $createdir
>> +renamedir=$SCRATCH_MNT/renamedir
>> +mkdir $renamedir
>> +
>> +# create many small files for the rename with RENAME_WHITEOUT
>> +create_file $SCRATCH_MNT $file_count
>> +
>> +# try to create files at the same time to hit the deadlock
>> +rename_whiteout $renamedir $file_count &
>> +create_file $createdir $file_count &
>> +
> 
> When I ran this test I noticed that the rename_whiteout task completed
> renaming the 50k files before the create_file task created even 30k of
> the 50k files. There's no risk of deadlock once one of these tasks
> completes, right? If so, that seems like something that could be fixed
> up.
> 
> Beyond that though, the test itself ran for almost 19 minutes on a vm
> with the deadlock fix. That seems like overkill to me for a test that's
> so narrowly focused on a particular bug that it's unlikely to fail in
> the future. If we can't find a way to get this down to a reasonable time
> while still reproducing the deadlock, I'm kind of wondering if there's a
> better approach to get more rename coverage from existing tests. For
> example, could we add this support to fsstress and see if any of the
> existing stress tests might trigger the original problem? Even if we
> needed to add a new rename/create focused fsstress test, that might at
> least be general enough to provide broader coverage.
> 
Yeah, rename_whiteout task run faster than create_file task, so maybe
we can set two different files counts for them to reduce the test run
time. This test ran for 380s on my vm with the fixed kernel, but we
still need to find a way to reduce the run time, like the 19 minutes
case. Actually, in most cases, the deadlock happened when the
rename_whiteout task completed renaming hundreds of files. 50000
is set just because this test take 380s on my vm which is acceptable
and the reproduce possibility is near 100%. So maybe we can choose a
proper files count to make the test runs faster. Of course, I'll
also try to use fsstresss and the TIME_FACTOR if they can help to
reduce the run time.
 
> Alternatively, what if this test ran a create/rename workload (on a
> smaller fileset) for a fixed time of a minute or two and then exited? I
> think it would be a reasonable compromise if the test still reproduced
> on some smaller frequency, it's just not clear to me how effective such
> a test would be without actually trying it. Maybe Eryu has additional
> thoughts..
> 
> Brian
> 
>> +wait
>> +echo Silence is golden
>> +
>> +# Failure comes in the form of a deadlock.
>> +
>> +# success, all done
>> +status=0
>> +exit
>> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
>> new file mode 100644
>> index 0000000..0aabdef
>> --- /dev/null
>> +++ b/tests/xfs/512.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 512
>> +Silence is golden
>> diff --git a/tests/xfs/group b/tests/xfs/group
>> index a7ad300..ed250d6 100644
>> --- a/tests/xfs/group
>> +++ b/tests/xfs/group
>> @@ -509,3 +509,4 @@
>>  509 auto ioctl
>>  510 auto ioctl quick
>>  511 auto quick quota
>> +512 auto rename
>> -- 
>> 1.8.3.1
>>
>> -- 
>> kaixuxia

-- 
kaixuxia
