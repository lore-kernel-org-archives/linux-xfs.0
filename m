Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6F0C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 06:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D065214D9
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 06:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfIPGdo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 02:33:44 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:41136 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbfIPGdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 16 Sep 2019 02:33:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0TcRKNDV_1568615619;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0TcRKNDV_1568615619)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 16 Sep 2019 14:33:40 +0800
Date:   Mon, 16 Sep 2019 14:33:39 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     kaixuxia <xiakaixu1987@gmail.com>
Cc:     Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, newtongao@tencent.com,
        jasperwang@tencent.com
Subject: Re: [PATCH 2/2] xfs: test the deadlock between the AGI and AGF with
 RENAME_WHITEOUT
Message-ID: <20190916063339.GZ52397@e18g06458.et15sqa>
References: <58163375-dcd9-b954-c8d2-89fef20b8246@gmail.com>
 <20190913173624.GD28512@bfoster>
 <11df4cb7-c1d6-62a5-a3a2-c4dc7882f00b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11df4cb7-c1d6-62a5-a3a2-c4dc7882f00b@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 01:12:37PM +0800, kaixuxia wrote:
> 
> On 2019/9/14 1:36, Brian Foster wrote:
> > On Wed, Sep 11, 2019 at 09:17:08PM +0800, kaixuxia wrote:
> >> There is ABBA deadlock bug between the AGI and AGF when performing
> >> rename() with RENAME_WHITEOUT flag, and add this testcase to make
> >> sure the rename() call works well.
> >>
> >> Signed-off-by: kaixuxia <kaixuxia@tencent.com>
> >> ---
> >>  tests/xfs/512     | 99 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/xfs/512.out |  2 ++
> >>  tests/xfs/group   |  1 +
> >>  3 files changed, 102 insertions(+)
> >>  create mode 100755 tests/xfs/512
> >>  create mode 100644 tests/xfs/512.out
> >>
> >> diff --git a/tests/xfs/512 b/tests/xfs/512
> >> new file mode 100755
> >> index 0000000..754f102
> >> --- /dev/null
> >> +++ b/tests/xfs/512
> >> @@ -0,0 +1,99 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2019 Tencent.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 512
> >> +#
> >> +# Test the ABBA deadlock case between the AGI and AGF When performing
> >> +# rename operation with RENAME_WHITEOUT flag.
> >> +#
> >> +seq=`basename $0`
> >> +seqres=$RESULT_DIR/$seq
> >> +echo "QA output created by $seq"
> >> +
> >> +here=`pwd`
> >> +tmp=/tmp/$$
> >> +status=1	# failure is the default!
> >> +trap "_cleanup; exit \$status" 0 1 2 3 15
> >> +
> >> +_cleanup()
> >> +{
> >> +	cd /
> >> +	rm -f $tmp.*
> >> +}
> >> +
> >> +# get standard environment, filters and checks
> >> +. ./common/rc
> >> +. ./common/filter
> >> +. ./common/renameat2
> >> +
> >> +rm -f $seqres.full
> >> +
> >> +# real QA test starts here
> >> +_supported_fs xfs
> >> +_supported_os Linux
> >> +_require_scratch_nocheck
> > 
> > Why _nocheck? AFAICT the filesystem shouldn't end up intentionally
> > corrupted.
> 
> Will add the comment in the next version.
> > 
> >> +_requires_renameat2 whiteout
> >> +
> >> +prepare_file()
> >> +{
> >> +	# create many small files for the rename with RENAME_WHITEOUT
> >> +	i=0
> >> +	while [ $i -le $files ]; do
> >> +		file=$SCRATCH_MNT/f$i
> >> +		echo > $file >/dev/null 2>&1
> >> +		let i=$i+1
> >> +	done
> > 
> > Something like the following is a bit more simple, IMO:
> > 
> > 	for i in $(seq 1 $files); do
> > 		touch $SCRATCH_MNT/f.$i
> > 	done
> > 
> > The same goes for the other while loops below that increment up to
> > $files.
> > 
> >> +}
> >> +
> >> +rename_whiteout()
> >> +{
> >> +	# create the rename targetdir
> >> +	renamedir=$SCRATCH_MNT/renamedir
> >> +	mkdir $renamedir
> >> +
> >> +	# a long filename could increase the possibility that target_dp
> >> +	# allocate new blocks(acquire the AGF lock) to store the filename
> >> +	longnamepre=FFFsafdsagafsadfagasdjfalskdgakdlsglkasdg
> >> +
> > 
> > The max filename length is 256 bytes. You could do something like the
> > following to increase name length (leaving room for the file index and
> > terminating NULL) if it helps the test:
> > 
> > 	prefix=`for i in $(seq 0 245); do echo -n a; done`
> > 
> >> +	# now try to do rename with RENAME_WHITEOUT flag
> >> +	i=0
> >> +	while [ $i -le $files ]; do
> >> +		src/renameat2 -w $SCRATCH_MNT/f$i $renamedir/$longnamepre$i >/dev/null 2>&1
> >> +		let i=$i+1
> >> +	done
> >> +}
> >> +
> >> +create_file()
> >> +{
> >> +	# create the targetdir
> >> +	createdir=$SCRATCH_MNT/createdir
> >> +	mkdir $createdir
> >> +
> >> +	# try to create file at the same time to hit the deadlock
> >> +	i=0
> >> +	while [ $i -le $files ]; do
> >> +		file=$createdir/f$i
> >> +		echo > $file >/dev/null 2>&1
> >> +		let i=$i+1
> >> +	done
> >> +}
> > 
> > You could generalize this function to take a target directory parameter
> > and just call it twice (once to prepare and again for the create
> > workload).
> 
> Right.
> > 
> >> +
> >> +_scratch_mkfs_xfs -bsize=1024 -dagcount=1 >> $seqres.full 2>&1 ||
> >> +	_fail "mkfs failed"
> > 
> > Why -bsize=1k? Does that make the reproducer more effective?
> > 
> The smaller block size, the more frequently that the blocks are allocated
> when creating files...

If 1k block size is not a "must have", we could leave that part to
MKFS_OPTIONS and don't specify block size in the test, i.e. testing with
different MKFS_OPTIONS could cover various block sizes, e.g.

MKFS_OPTIONS="-bsize=1k,-m crc=1,reflink=1" ./check ...

> >> +_scratch_mount
> >> +
> >> +files=250000
> >> +
> > 
> > Have you tested effectiveness of reproducing the issue with smaller file
> > counts? A brief comment here to document where the value comes from
> > might be useful. Somewhat related, how long does this test take on fixed
> > kernels?
> 
> Hmm, 250000 is just a random number big enough for this test. The smaller
> file counts maybe is enough. Actually, the create_file() call run fast
> than the rename_whiteout() call, so we can choose two different file
> counts for them. Anyway, I would address the file counts problem in V3...

Yeah, it's good to figure out a small file count (no need to be
smallest) that could reproduce the deadlock reliably.

Thanks,
Eryu

> > 
> >> +prepare_file
> >> +rename_whiteout &
> >> +create_file &
> >> +
> >> +wait
> >> +echo Silence is golden
> >> +
> >> +# Failure comes in the form of a deadlock.
> >> +
> > 
> > I wonder if this should be in the dangerous group as well. I go back and
> > forth on that though because I tend to filter out dangerous tests and
> > the test won't be so risky once the fix proliferates. Perhaps that's
> > just a matter of removing it from the dangerous group after a long
> > enough period of time.
> > 
> > Brian
> > 
> >> +# success, all done
> >> +status=0
> >> +exit
> >> diff --git a/tests/xfs/512.out b/tests/xfs/512.out
> >> new file mode 100644
> >> index 0000000..0aabdef
> >> --- /dev/null
> >> +++ b/tests/xfs/512.out
> >> @@ -0,0 +1,2 @@
> >> +QA output created by 512
> >> +Silence is golden
> >> diff --git a/tests/xfs/group b/tests/xfs/group
> >> index a7ad300..ed250d6 100644
> >> --- a/tests/xfs/group
> >> +++ b/tests/xfs/group
> >> @@ -509,3 +509,4 @@
> >>  509 auto ioctl
> >>  510 auto ioctl quick
> >>  511 auto quick quota
> >> +512 auto rename
> >> -- 
> >> 1.8.3.1
> >>
> >> -- 
> >> kaixuxia
> 
> -- 
> kaixuxia
