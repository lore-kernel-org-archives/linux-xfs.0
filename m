Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947B6C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 05:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 547E6214D9
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 05:12:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZJAKu+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfIPFMl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 01:12:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46170 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728303AbfIPFMl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 01:12:41 -0400
Received: by mail-pg1-f194.google.com with SMTP id a3so1226108pgm.13;
        Sun, 15 Sep 2019 22:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UiI6bl/pU/vhwQET4+hl+m0vdPXeuUlaesTIGpUHiAg=;
        b=DZJAKu+Ei1SuzPbkQxfUDQL/JjITN9HhhDjK9CXShLvKQAJ8c20xx7zDHZjcbpDjNX
         y0SySYuSvwAz2uEMA/pMVFWBfVi2wSorVFdeZz4uKTyZD7OnFOtlT6cIP/53rMchJ0gS
         MSob2hTyJuqJxZmOSyn+QuXgw5cFeWmy6Weilbz6seQZNmTs61MxvelNjBBRzAUMISuz
         Tggoo2Uaq094ilDd13OqY9/YYr89rr9miH+pMYO97RY6WNq17ZDDQgt2XA+fhN4EjyQ6
         Sdx0G3omg8a2pbPEwy7iOy3/baGsULMAPE5F96r6evS2gOERvlxB0rULp0NbqltfR8oB
         6g6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UiI6bl/pU/vhwQET4+hl+m0vdPXeuUlaesTIGpUHiAg=;
        b=ku4z9PUlTP+MAcjBLcAmeRW/+bz990yJKRp4kTDdXLk12M3rcVOapKNbMhF/iUhOBW
         n6/icKneWQ8c/VcbWoReGI4HVrugbIyp3V3oOVQBsheiSmbghTDj/kiaTX29m06byl/8
         V/rHlbFUAPpkSi7ix2xgdahpb+PZvpN4pmMHk7WOTWyXmtTH9AHRfxcsJCaoTeV/8M1N
         RDjpe+AWKSs/1bZHTB8s0Ef2bj98vhkfzAT9E534Fj2jdHxcrht2bdVJmhsuLGdmG1IS
         ZYBkctEKpNDKsxZhE6CQ8bbLGbNMX+jvmU0HMHgcxG4aC7n0RyjF4zlDwdnE5RluQkrq
         +SFQ==
X-Gm-Message-State: APjAAAWu7Nc9WmOUqwGjVwUWLQ0RpA68BMqrxPIqmT6p8rdqfR4Cgow8
        A7h8clOIUMTbHLoTzGY99Q==
X-Google-Smtp-Source: APXvYqy7jc2roEzVtsltz9qpTmGeTPHXVTgYv5cRTdxBDb8pps9PR7sVp0H/vQhJ5roQoXyY8adbNA==
X-Received: by 2002:a63:1749:: with SMTP id 9mr8533096pgx.387.1568610760774;
        Sun, 15 Sep 2019 22:12:40 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id n3sm1146950pff.102.2019.09.15.22.12.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 15 Sep 2019 22:12:40 -0700 (PDT)
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: Re: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
To:     Brian Foster <bfoster@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
 <20190913173624.GD28512@bfoster>
Message-ID: <11df4cb7-c1d6-62a5-a3a2-c4dc7882f00b@gmail.com>
Date:   Mon, 16 Sep 2019 13:12:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190913173624.GD28512@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/9/14 1:36, Brian Foster wrote:
> On Wed, Sep 11, 2019 at 09:17:08PM +0800, kaixuxia wrote:
>> There is ABBA deadlock bug between the AGI and AGF when performing
>> rename() with RENAME_WHITEOUT flag, and add this testcase to make
>> sure the rename() call works well.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>>  tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/512.out |  2 ++
>>  tests/xfs/group   |  1 +
>>  3 files changed, 102 insertions(+)
>>  create mode 100755 tests/xfs/512
>>  create mode 100644 tests/xfs/512.out
>>
>> diff --git a/tests/xfs/512 b/tests/xfs/512
>> new file mode 100755
>> index 0000000..754f102
>> --- /dev/null
>> +++ b/tests/xfs/512
>> @@ -0,0 +1,99 @@
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
>> +_require_scratch_nocheck
> 
> Why _nocheck? AFAICT the filesystem shouldn't end up intentionally
> corrupted.

Will add the comment in the next version.
> 
>> +_requires_renameat2 whiteout
>> +
>> +prepare_file()
>> +{
>> +	# create many small files for the rename with RENAME_WHITEOUT
>> +	i=0
>> +	while [ $i -le $files ]; do
>> +		file=$SCRATCH_MNT/f$i
>> +		echo > $file >/dev/null 2>&1
>> +		let i=$i+1
>> +	done
> 
> Something like the following is a bit more simple, IMO:
> 
> 	for i in $(seq 1 $files); do
> 		touch $SCRATCH_MNT/f.$i
> 	done
> 
> The same goes for the other while loops below that increment up to
> $files.
> 
>> +}
>> +
>> +rename_whiteout()
>> +{
>> +	# create the rename targetdir
>> +	renamedir=$SCRATCH_MNT/renamedir
>> +	mkdir $renamedir
>> +
>> +	# a long filename could increase the possibility that target_dp
>> +	# allocate new blocks(acquire the AGF lock) to store the filename
>> +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
>> +
> 
> The max filename length is 256 bytes. You could do something like the
> following to increase name length (leaving room for the file index and
> terminating NULL) if it helps the test:
> 
> 	prefix=`for i in $(seq 0 245); do echo -n a; done`
> 
>> +	# now try to do rename with RENAME_WHITEOUT flag
>> +	i=0
>> +	while [ $i -le $files ]; do
>> +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
>> +		let i=$i+1
>> +	done
>> +}
>> +
>> +create_file()
>> +{
>> +	# create the targetdir
>> +	createdir=$SCRATCH_MNT/createdir
>> +	mkdir $createdir
>> +
>> +	# try to create file at the same time to hit the deadlock
>> +	i=0
>> +	while [ $i -le $files ]; do
>> +		file=$createdir/f$i
>> +		echo > $file >/dev/null 2>&1
>> +		let i=$i+1
>> +	done
>> +}
> 
> You could generalize this function to take a target directory parameter
> and just call it twice (once to prepare and again for the create
> workload).

Right.
> 
>> +
>> +_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
>> +	_fail "mkfs failed"
> 
> Why -bsize=1k? Does that make the reproducer more effective?
> 
The smaller block size, the more frequently that the blocks are allocated
when creating files...
>> +_scratch_mount
>> +
>> +files=250000
>> +
> 
> Have you tested effectiveness of reproducing the issue with smaller file
> counts? A brief comment here to document where the value comes from
> might be useful. Somewhat related, how long does this test take on fixed
> kernels?

Hmm, 250000 is just a random number big enough for this test. The smaller
file counts maybe is enough. Actually, the create_file() call run fast
than the rename_whiteout() call, so we can choose two different file
counts for them. Anyway, I would address the file counts problem in V3...
> 
>> +prepare_file
>> +rename_whiteout &
>> +create_file &
>> +
>> +wait
>> +echo Silence is golden
>> +
>> +# Failure comes in the form of a deadlock.
>> +
> 
> I wonder if this should be in the dangerous group as well. I go back and
> forth on that though because I tend to filter out dangerous tests and
> the test won't be so risky once the fix proliferates. Perhaps that's
> just a matter of removing it from the dangerous group after a long
> enough period of time.
> 
> Brian
> 
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
