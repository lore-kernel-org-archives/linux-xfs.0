Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726978AbfBIV4a (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 9 Feb 2019 16:56:30 -0500
Date: Sat, 9 Feb 2019 16:56:27 -0500
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190209215627.GB69686@sasha-vm>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190206040559.GA4119@sasha-vm>
 <20190206215454.GG14116@dastard>
 <20190208060620.GA31898@sasha-vm>
 <20190208221726.GM11489@garbanzo.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190208221726.GM11489@garbanzo.do-not-panic.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Fri, Feb 08, 2019 at 02:17:26PM -0800, Luis Chamberlain wrote:
>On Fri, Feb 08, 2019 at 01:06:20AM -0500, Sasha Levin wrote:
>> Sure! Below are the various configs this was run against. There were
>> multiple runs over 48+ hours and no regressions from a 4.14.17 baseline
>> were observed.
>
>In an effort to consolidate our sections:
>
>> [default]
>> TEST_DEV=/dev/nvme0n1p1
>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/nvme0n1p2"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)
>> MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
>
>This matches my "xfs" section.
>
>> USE_EXTERNAL=no
>> LOGWRITES_DEV=/dev/nve0n1p3
>> FSTYP=xfs
>>
>>
>> [default]
>> TEST_DEV=/dev/nvme0n1p1
>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/nvme0n1p2"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)
>> MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1,'
>
>This matches my "xfs_reflink"
>
>> USE_EXTERNAL=no
>> LOGWRITES_DEV=/dev/nvme0n1p3
>> FSTYP=xfs
>>
>>
>> [default]
>> TEST_DEV=/dev/nvme0n1p1
>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/nvme0n1p2"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)
>> MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=1024,'
>
>This matches my "xfs_reflink_1024" section.
>
>> USE_EXTERNAL=no
>> LOGWRITES_DEV=/dev/nvme0n1p3
>> FSTYP=xfs
>>
>>
>> [default]
>> TEST_DEV=/dev/nvme0n1p1
>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/nvme0n1p2"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)
>> MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0,'
>
>This matches my "xfs_nocrc" section.
>
>> USE_EXTERNAL=no
>> LOGWRITES_DEV=/dev/nvme0n1p3
>> FSTYP=xfs
>>
>>
>> [default]
>> TEST_DEV=/dev/nvme0n1p1
>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/nvme0n1p2"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)
>> MKFS_OPTIONS='-f -m crc=0,reflink=0,rmapbt=0, -i sparse=0, -b size=512,'
>
>This matches my "xfs_nocrc_512" section.
>
>> USE_EXTERNAL=no
>> LOGWRITES_DEV=/dev/nvme0n1p3
>> FSTYP=xfs
>>
>>
>> [default_pmem]
>> TEST_DEV=/dev/pmem0
>
>I'll have to add this to my framework. Have you found pmem
>issues not present on other sections?

Originally I've added this because the xfs folks suggested that pmem vs
block exercises very different code paths and we should be testing both
of them.

Looking at the baseline I have, it seems that there are differences
between the failing tests. For example, with "MKFS_OPTIONS='-f -m
crc=1,reflink=0,rmapbt=0, -i sparse=0'", generic/524 seems to fail on
pmem but not on block.

>> TEST_DIR=/media/test
>> SCRATCH_DEV_POOL="/dev/pmem1"
>> SCRATCH_MNT=/media/scratch
>> RESULT_BASE=$PWD/results/$HOST/$(uname -r)-pmem
>> MKFS_OPTIONS='-f -m crc=1,reflink=0,rmapbt=0, -i sparse=0'
>
>OK so you just repeat the above options vervbatim but for pmem.
>Correct?

Right.

>Any reason you don't name the sections with more finer granularity?
>It would help me in ensuring when we revise both of tests we can more
>easily ensure we're talking about apples, pears, or bananas.

Nope, I'll happily rename them if there are "official" names for it :)

>FWIW, I run two different bare metal hosts now, and each has a VM guest
>per section above. One host I use for tracking stable, the other host for
>my changes. This ensures I don't mess things up easier and I can re-test
>any time fast.
>
>I dedicate a VM guest to test *one* section. I do this with oscheck
>easily:
>
>./oscheck.sh --test-section xfs_nocrc | tee log-xfs-4.19.18+
>
>For instance will just test xfs_nocrc section. On average each section
>takes about 1 hour to run.

We have a similar setup then. I just spawn the VM on azure for each
section and run them all in parallel that way.

I thought oscheck runs everything on a single VM, is it a built in
mechanism to spawn a VM for each config? If so, I can add some code in
to support azure and we can use the same codebase.

>I could run the tests on raw nvme and do away with the guests, but
>that loses some of my ability to debug on crashes easily and out to
>baremetal.. but curious, how long do your tests takes? How about per
>section? Say just the default "xfs" section?

I think that the longest config takes about 5 hours, otherwise
everything tends to take about 2 hours.

I basically run these on "repeat" until I issue a stop order, so in a
timespan of 48 hours some configs run ~20 times and some only ~10.

>IIRC you also had your system on hyperV :) so maybe you can still debug
>easily on crashes.
>
>  Luis
