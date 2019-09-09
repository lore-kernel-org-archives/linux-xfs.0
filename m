Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15785C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 09:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D546F21924
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 09:06:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZNxRolv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfIIJGO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 05:06:14 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33051 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726585AbfIIJGO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Sep 2019 05:06:14 -0400
Received: by mail-pg1-f194.google.com with SMTP id n190so7468982pgn.0;
        Mon, 09 Sep 2019 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dfs/httby8H28wRJGP6/Fx+C3QzQZ5nOCr4NNy0x0E4=;
        b=EZNxRolvWAPgvF+3m3Q4ndv6MBw81Ykpa7lVGPs7z2nzyCbSo2KTZeLvWhHTuDlZvP
         26JttB7TOoZmgFwmG0q4B/x7RTHW1386/gOfHrioGN2zGJPrv+JNTWQphiuTu7v9fJC7
         +R88YPGqBEhx/4SP9DCpdA+lk3n11HG+KW4JkMO22gAdMH514ocqckvJxwu841JfHZRs
         RWbhycbduYSXgVVMuknZK5vAtc3VY+EhKfSbVwZiFv4YLtDU2l37X18r6LVtyOBrkoja
         iyymaN1g04j+9P11fYsuScaU0ToVB0eyq3XjKgdTjXTz+ZRC/r2AK1RUqLJcEQOkbLB9
         M2YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfs/httby8H28wRJGP6/Fx+C3QzQZ5nOCr4NNy0x0E4=;
        b=csn68pLELk14X4ENF5uGlJUh67dDQW7LC/8wqKyq0CMX+Hrdo3Rn0kJW/Ra5LJwj+z
         eS002IyTVnLCVLJEcZNHLjjXGEnErgLlr6zbJkEkxCt831ElfxQqB4Im8PnYYOF0X0WG
         USHzPe29jAtU38myw5O7K9z18pLLBmfJVjJe3nE9VHYsIWll8CFeB49Emxssr6kJWaA7
         1pLQYDP+nrI64DE6V7YBOQw0sxlmB0BH6oNH05I/RZyyKKmRgs7mWdM+hh4w7NWX3V5R
         bJvN62V+4lZfreZyHfiGXKSCzjfxoXtFowsByx3rb0neC+Clr9hotlfpHmBCaYH39N8D
         5GEw==
X-Gm-Message-State: APjAAAV+giJhYW88TjWyLo/C8v/J2aF7SMz7XbjIjR2c1zyiHn0hHf96
        11KY4P01hYZf0c9G9COB8A==
X-Google-Smtp-Source: APXvYqwWOjJ5nbNrjoNoBhMqAxHg89+ZApyRsTSEY7vxPBsz5aUOl9/a0bdU0bcQCArvqOrA9AMgFg==
X-Received: by 2002:a65:6557:: with SMTP id a23mr20849687pgw.439.1568019973227;
        Mon, 09 Sep 2019 02:06:13 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id 202sm26201461pfu.161.2019.09.09.02.06.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 02:06:12 -0700 (PDT)
Subject: Re: [PATCH] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
References: <59006cf8-f825-d33f-c860-111189689e2e@gmail.com>
 <20190908123939.GG2622@desktop>
From:   kaixuxia <xiakaixu1987@gmail.com>
Message-ID: <0aca3514-2857-7c3a-c3ad-6f92b13957f2@gmail.com>
Date:   Mon, 9 Sep 2019 17:06:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190908123939.GG2622@desktop>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 2019/9/8 20:39, Eryu Guan wrote:
> On Wed, Sep 04, 2019 at 06:01:27PM +0800, kaixuxia wrote:
>> There is ABBA deadlock bug between the AGI and AGF when performing
>> rename() with RENAME_WHITEOUT flag, and add this testcase to make
>> sure the rename() call works well.
>>
>> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
>> ---
>>  tests/xfs/512     | 100 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/xfs/512.out |   2 ++
>>  tests/xfs/group   |   1 +
>>  3 files changed, 103 insertions(+)
>>  create mode 100755 tests/xfs/512
>>  create mode 100644 tests/xfs/512.out
>>
>> diff --git a/tests/xfs/512 b/tests/xfs/512
>> new file mode 100755
>> index 0000000..0e95fb7
>> --- /dev/null
>> +++ b/tests/xfs/512
>> @@ -0,0 +1,100 @@
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
>> +
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +_supported_fs xfs
>> +_supported_os Linux
>> +_require_scratch
> 
> Only _require_scratch_nocheck is suffiecient.

Yeah, will fix it.
> 
>> +
>> +# Single AG will cause default xfs_repair to fail. This test need a
>> +# single AG fs, so ignore the check.
>> +_require_scratch_nocheck
> 
> Also need to 
> 
> . ./common/rename
> ...
> 
> _requires_renameat2
> 
> Also, this test requires RENAME_WHITEOUT, I'd suggest enhance
> src/renameat2.c to support check for if a given rename flag is supported
> by kernel, and refactor the checks in generic/02[45] and generic/078
> into _requires_renameat2 to use the new functionality. e.g.
> 
> # without option, behavior stays unchanged, check for renameat2 syscall
> # support
> _requires_renameat2
> 
> # check if renameat2 upports RENAME_WHITEOUT flag
> _requires_renameat2 whiteout
> 
> # check if renameat2 upports RENAME_EXCHANGE flag
> _requires_renameat2 exchange
> 

Right, this testcase requires RENAME_WHITEOUT, it is necessary that check
whether the given rename flag is supported by kernel. I will try to refactor
the corresponding tests and functions.
>> +
>> +prepare_file()
>> +{
>> +	# create many small files for the rename with RENAME_WHITEOUT
>> +	i=0
>> +	while [ $i -le $files ]; do
>> +		file=$SCRATCH_MNT/f$i
>> +		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
>> +		let i=$i+1
> 
> Creating 250000 4k files take a long time. Does file content really
> matters? I guess racing RENAME_WHITEOUT with file creation is enough, is
> it possible to just create many empty files? e.g.
> 
> 		echo > $file
> 
> this saves a lot time.

Yeah, create empty files is better.
> 
>> +	done
>> +}
>> +
>> +rename_whiteout()
>> +{
>> +	# create the rename targetdir
>> +	renamedir=$SCRATCH_MNT/renamedir
>> +	mkdir $renamedir
>> +
>> +	# just get a random long name...
>> +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
> 
> Better to explain why long file name is required.
> 
Will add the explanation. The long file name will increase the possibility
that target_dp allocate new blocks(acquire the AGF lock) to store the
filename. 
>> +
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
>> +		$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 4k' $file >/dev/null 2>&1
>> +		let i=$i+1
>> +	done
> 
> Same here, does creating empty files work?

Yeah.
> 
>> +}
>> +
>> +_scratch_mkfs_xfs -bsize=512 -dagcount=1 >> $seqres.full 2>&1 ||
> 
> This doesn't work because crc is on by default, as crc requires minimum
> 1k block size. Is 512 block size really needed?
> 
>> +	_fail "mkfs failed"
>> +_scratch_mount
>> +
>> +files=250000
> 
> If we could reduce file number to create, test could run faster as well.
> Running test with less than 250000 files couldn't reproduce the
> deadlock?

I used this magic number in my local test environment and reproduced
the deadlock every time. Creating empty files would reduce the 
run time...

Thanks.
> 
> Thanks,
> Eryu
> 
>> +
>> +prepare_file
>> +rename_whiteout &
>> +create_file &
>> +
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
