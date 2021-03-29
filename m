Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B47C433C1
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 02:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C96056023C
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 02:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhC2CPI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 22:15:08 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45764 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229645AbhC2CO2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 22:14:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=eguan@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UTbnKBO_1616984066;
Received: from localhost(mailfrom:eguan@linux.alibaba.com fp:SMTPD_---0UTbnKBO_1616984066)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 29 Mar 2021 10:14:26 +0800
Date:   Mon, 29 Mar 2021 10:14:26 +0800
From:   Eryu Guan <eguan@linux.alibaba.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Eryu Guan <guan@eryu.me>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>
Subject: Re: [RFC PATCH v3 2/3] xfs: basic functionality test for shrinking
 free space in the last AG
Message-ID: <20210329021426.GK95214@e18g06458.et15sqa>
References: <20210315111926.837170-1-hsiangkao@redhat.com>
 <20210315111926.837170-3-hsiangkao@redhat.com>
 <YGCvp6QJherSSOGk@desktop>
 <20210328200603.GB3213575@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210328200603.GB3213575@xiangao.remote.csb>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 04:06:03AM +0800, Gao Xiang wrote:
> On Mon, Mar 29, 2021 at 12:32:39AM +0800, Eryu Guan wrote:
> > On Mon, Mar 15, 2021 at 07:19:25PM +0800, Gao Xiang wrote:
> > > Add basic test to make sure the functionality works as expected.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > >  tests/xfs/990     | 70 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/990.out | 12 ++++++++
> > >  tests/xfs/group   |  1 +
> > >  3 files changed, 83 insertions(+)
> > >  create mode 100755 tests/xfs/990
> > >  create mode 100644 tests/xfs/990.out
> > > 
> > > diff --git a/tests/xfs/990 b/tests/xfs/990
> > > new file mode 100755
> > > index 00000000..3c79186e
> > > --- /dev/null
> > > +++ b/tests/xfs/990
> > > @@ -0,0 +1,70 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2021 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 990
> > > +#
> > > +# XFS shrinkfs basic functionality test
> > > +#
> > > +# This test attempts to shrink with a small size (512K), half AG size and
> > > +# an out-of-bound size (agsize + 1) to observe if it works as expected.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1    # failure is the default!
> > > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +test_shrink()
> > > +{
> > > +	$XFS_GROWFS_PROG -D"$1" $SCRATCH_MNT >> $seqres.full 2>&1
> > > +	ret=$?
> > 
> > I'm not sure what's the output of xfs_growfs when shrinking filesystem,
> > if it's easy to do filter, but it'd be good if we could just dump the
> > output and let .out file match & check the test result.
> 
> Not quite sure if it's of some use (e.g. also need to update expected output
> when output changed), since I think just make sure the shrinked size is as
> expected and xfs_repair won't argue anything on the new size, that would be
> enough.
> 
> > 
> > > +
> > > +	_scratch_unmount
> > > +	_repair_scratch_fs >> $seqres.full
> > 
> > _repair_scratch_fs will fix corruption if there's any, and always return 0 if
> > completes without problems. Is _check_scratch_fs() what you want?
> 
> I didn't notice this, will update.
> 
> > 
> > > +	_scratch_mount >> $seqres.full
> > > +
> > > +	$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> > > +	. $tmp.growfs
> > > +	[ $ret -eq 0 -a $1 -eq $dblocks ]
> > 
> > Just dump the expected size after shrink if possible.
> 
> er... my idea is that I don't want to continue the test case
> if any fails... if dump the expected size to output, I need to
> fix blocksize as well, not sure if it's necessary.
> 
> > 
> > > +}
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > 
> > Still missing _require_scratch
> 
> No, _require_xfs_shrink will include that, just as _require_xfs_scratch_rmapbt.

Then include the "scratch" part in the helper name, so it's clear that
it requires the SCRATCH_DEV, i.e. _require_xfs_scratch_shrink

> 
> > 
> > > +_require_xfs_shrink
> > > +
> > > +rm -f $seqres.full
> > > +echo "Format and mount"
> > > +_scratch_mkfs -dsize="$((512 * 1024 * 1024))" -dagcount=3 2>&1 | \
> > > +	tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > 
> > Better to explain why mkfs with agcount=3
> 
> just because agcount = 1 is forbidden on purpose, and I need to make sure
> shrinking to 2 AG is not possible yet. So agcount = 3 is the minimum number.
> 
> It's just a functionality test, so agcount = 3 also makes the result
> determinatively.

Yeah, I'd guess the reason, but it'd be great to make it clear in
comments.

> 
> > 
> > > +. $tmp.mkfs
> > > +t_dblocks=$dblocks
> > > +_scratch_mount >> $seqres.full
> > > +
> > > +echo "Shrink fs (small size)"
> > > +test_shrink $((t_dblocks-512*1024/dbsize)) || \
> > > +	_fail "Shrink fs (small size) failure"
> > 
> > If it's possible to turn test_shrink to .out file matching way, _fail is
> > not needed and below.
> 
> The same as above. I could try to fix blocksize if the opinion is strong.
> 
> > 
> > > +
> > > +echo "Shrink fs (half AG)"
> > > +test_shrink $((t_dblocks-agsize/2)) || \
> > > +	_fail "Shrink fs (half AG) failure"
> > > +
> > > +echo "Shrink fs (out-of-bound)"
> > > +test_shrink $((t_dblocks-agsize-1)) && \
> > > +	_fail "Shrink fs (out-of-bound) failure"
> > > +[ $dblocks -ne $((t_dblocks-agsize/2)) ] && \
> > > +	_fail "dblocks changed after shrinking failure"
> > > +
> > > +$XFS_INFO_PROG $SCRATCH_MNT >> $seqres.full
> > > +echo "*** done"
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/990.out b/tests/xfs/990.out
> > > new file mode 100644
> > > index 00000000..812f89ef
> > > --- /dev/null
> > > +++ b/tests/xfs/990.out
> > > @@ -0,0 +1,12 @@
> > > +QA output created by 990
> > > +Format and mount
> > > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > > +         = sunit=XXX swidth=XXX, unwritten=X
> > > +naming   =VERN bsize=XXX
> > > +log      =LDEV bsize=XXX blocks=XXX
> > > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > > +Shrink fs (small size)
> > > +Shrink fs (half AG)
> > > +Shrink fs (out-of-bound)
> > > +*** done
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index e861cec9..a7981b67 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -525,3 +525,4 @@
> > >  525 auto quick mkfs
> > >  526 auto quick mkfs
> > >  527 auto quick quota
> > > +990 auto quick growfs
> > 
> > Maybe it's time to add a new 'shrinkfs' group?
> 
> not sure if it needs, since shrinkfs reuses growfs ioctl.

Ok, I have no strong preference on this, just think it's a bit easier to
run only shrink tests by ./check -g shrinkfs.

Thanks,
Eryu
