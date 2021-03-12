Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5056C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9054864FE2
	for <linux-xfs@archiver.kernel.org>; Fri, 12 Mar 2021 16:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCLQhR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232288AbhCLQhO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Mar 2021 11:37:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C35CC64F8D;
        Fri, 12 Mar 2021 16:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615567033;
        bh=dK7hFQftpklfAvTSZ2lTk+cdmLQsTVchdY7zay9VkSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/00Kxgvmptj/rbQCrH/UJv4nXB1RpG9U5eDebvHXSPywcfBdJcIJQS7SdqdPXlt3
         2NyxXqFoj+qwGChesic3L7GGf8tUqDuVwj9PU8ffRSy1FUjbpfNyLqjnyxnZxyuHQr
         gVj8ZnbUYTP2W3jG+qO61wQSFacnhrU4Fdes/0lJTo6YQC5zqd04DITVIBgfIifg+I
         IwbY6hgRUll1o593IMqnhoBrvFduN9e36+Wdx3V2uqTRck0d4IoAawVv2olw1mccG3
         aO41ndVqfj8dB4Prf+Lm+hYPAttwfJahfBLWTkCJg7216BqiejfFoS+unwEwvTy8HK
         daEt8Mz4IQTAA==
Date:   Fri, 12 Mar 2021 08:37:13 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/3] xfs: stress test for shrinking free space in
 the last AG
Message-ID: <20210312163713.GC8425@magnolia>
References: <20210312132300.259226-1-hsiangkao@redhat.com>
 <20210312132300.259226-4-hsiangkao@redhat.com>
 <20210312161755.GL3499219@localhost.localdomain>
 <20210312161744.GB276830@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312161744.GB276830@xiangao.remote.csb>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Mar 13, 2021 at 12:17:44AM +0800, Gao Xiang wrote:
> On Sat, Mar 13, 2021 at 12:17:55AM +0800, Zorro Lang wrote:
> > On Fri, Mar 12, 2021 at 09:23:00PM +0800, Gao Xiang wrote:
> > > This adds a stress testcase to shrink free space as much as
> > > possible in the last AG with background fsstress workload.
> > > 
> > > The expectation is that no crash happens with expected output.
> > > 
> > > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > > ---
> > > Note that I don't use _fill_fs instead, since fill_scratch here mainly to
> > > eat 125M to make fsstress more effectively, rather than fill data as
> > > much as possible.
> > 
> > As Darrick had given lots of review points to this case, I just have
> > 2 picky questions as below:)
> > 
> > > 
> > >  tests/xfs/991     | 121 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/991.out |   8 +++
> > >  tests/xfs/group   |   1 +
> > >  3 files changed, 130 insertions(+)
> > >  create mode 100755 tests/xfs/991
> > >  create mode 100644 tests/xfs/991.out
> > > 
> > > diff --git a/tests/xfs/991 b/tests/xfs/991
> > > new file mode 100755
> > > index 00000000..22a5ac81
> > > --- /dev/null
> > > +++ b/tests/xfs/991
> > > @@ -0,0 +1,121 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2020-2021 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 991
> > > +#
> > > +# XFS online shrinkfs stress test
> > > +#
> > > +# This test attempts to shrink unused space as much as possible with
> > > +# background fsstress workload. It will decrease the shrink size if
> > > +# larger size fails. And totally repeat 2 * TIME_FACTOR times.
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +
> > > +create_scratch()
> > > +{
> > > +	_scratch_mkfs_xfs $@ | tee -a $seqres.full | \
> > > +		_filter_mkfs 2>$tmp.mkfs >/dev/null
> > > +	. $tmp.mkfs
> > > +
> > > +	if ! _try_scratch_mount 2>/dev/null; then
> > > +		echo "failed to mount $SCRATCH_DEV"
> > > +		exit 1
> > > +	fi
> > > +
> > > +	# fix the reserve block pool to a known size so that the enospc
> > > +	# calculations work out correctly.
> > > +	_scratch_resvblks 1024 > /dev/null 2>&1
> > > +}
> > > +
> > > +fill_scratch()
> > > +{
> > > +	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
> > > +}
> > > +
> > > +stress_scratch()
> > > +{
> > > +	procs=3
> > > +	nops=$((1000 * LOAD_FACTOR))
> > > +	# -w ensures that the only ops are ones which cause write I/O
> > > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > > +	    -n $nops $FSSTRESS_AVOID`
> > > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > > +}
> > > +
> > > +# real QA test starts here
> > > +_supported_fs xfs
> > > +_require_scratch
> > > +_require_xfs_shrink
> > > +_require_xfs_io_command "falloc"
> > 
> > Do I miss something? I only found you use xfs_io "resvsp", why you need "falloc" cmd?
> 
> As I mentioned before, the testcase was derived from xfs/104 with some
> modification.
> 
> At a quick glance, this line was added by commit 09e94f84d929 ("xfs: don't
> assume preallocation is always supported on XFS"). I have no more background
> yet.

Why not use xfs_io falloc in the test?  fallocate is the successor to
resvsp.

--D

> > 
> > > +
> > > +rm -f $seqres.full
> > > +_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
> > > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > > +
> > > +decsize=`expr  42 \* 1048576`	# shrink in chunks of this size at most
> > > +endsize=`expr 125 \* 1048576`	# stop after shrinking this big
> > > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > > +
> > > +nags=2
> > > +totalcount=$((2 * TIME_FACTOR))
> > > +
> > > +while [ $totalcount -gt 0 ]; do
> > > +	size=`expr 1010 \* 1048576`	# 1010 megabytes initially
> > > +	logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> > > +
> > > +	create_scratch -lsize=${logblks}b -dsize=${size} -dagcount=${nags}
> > > +
> > > +	for i in `seq 125 -1 90`; do
> > > +		fillsize=`expr $i \* 1048576`
> > > +		out="$(fill_scratch $fillsize 2>&1)"
> > > +		echo "$out" | grep -q 'No space left on device' && continue
> > > +		test -n "${out}" && echo "$out"
> > > +		break
> > > +	done
> > > +
> > > +	while [ $size -gt $endsize ]; do
> > > +		stress_scratch
> > > +		sleep 1
> > > +
> > > +		decb=`expr $decsize / $dbsize`    # in data blocks
> > > +		while [ $decb -gt 0 ]; do
> > > +			sizeb=`expr $size / $dbsize - $decb`
> > > +
> > > +			$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT \
> > > +				>> $seqres.full 2>&1 && break
> > > +
> > > +			[ $decb -gt 100 ] && decb=`expr $decb + $RANDOM % 10`
> > > +			decb=`expr $decb / 2`
> > > +		done
> > > +
> > > +		wait
> > > +		[ $decb -eq 0 ] && break
> > > +
> > > +		# get latest dblocks
> > > +		$XFS_INFO_PROG $SCRATCH_MNT 2>&1 | _filter_mkfs 2>$tmp.growfs >/dev/null
> > > +		. $tmp.growfs
> > > +
> > > +		size=`expr $dblocks \* $dbsize`
> > > +		_scratch_cycle_mount
> > > +	done
> > > +
> > > +	_scratch_unmount
> > > +	_repair_scratch_fs >> $seqres.full
> > > +	totalcount=`expr $totalcount - 1`
> > > +done
> > > +
> > > +echo "*** done"
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/991.out b/tests/xfs/991.out
> > > new file mode 100644
> > > index 00000000..e8209672
> > > --- /dev/null
> > > +++ b/tests/xfs/991.out
> > > @@ -0,0 +1,8 @@
> > > +QA output created by 991
> > > +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> > > +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> > > +         = sunit=XXX swidth=XXX, unwritten=X
> > > +naming   =VERN bsize=XXX
> > > +log      =LDEV bsize=XXX blocks=XXX
> > > +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> > > +*** done
> > > diff --git a/tests/xfs/group b/tests/xfs/group
> > > index a7981b67..b479ed3a 100644
> > > --- a/tests/xfs/group
> > > +++ b/tests/xfs/group
> > > @@ -526,3 +526,4 @@
> > >  526 auto quick mkfs
> > >  527 auto quick quota
> > >  990 auto quick growfs
> > > +991 auto quick growfs
> > 
> > Is this "stress" test case really "quick" :)
> 
> ok, will update.
> 
> Thanks,
> Gao Xiang
> 
> > 
> > > -- 
> > > 2.27.0
> > > 
> > 
> 
