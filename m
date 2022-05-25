Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DEEBC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 25 May 2022 00:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiEYAcz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 20:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiEYAcy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 20:32:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749FD5A140;
        Tue, 24 May 2022 17:32:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34DE5B81BFC;
        Wed, 25 May 2022 00:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90EFC34100;
        Wed, 25 May 2022 00:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653438770;
        bh=aDXZe1hvb//RevgzzClKytRNOdDTDRUDHpvCcnggLIY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nmgzyov8xZJvp8bt5v2PCH0YjjbV/OjzcolU84XTuoX8yiOHe6i2m1O7jndMNXGzX
         x8UUgl0RF8bkBQCzfYf8rWa3xUHgVvN00pK//Hka0oz8dqaG9o1p8y5uyCuTPs8e4Y
         u+975+nvtGYMq1Oz7GmVf9VpeWwdQmh9wm0E1TK/SNqkjgvBVQrcBCeFHtCg5xM+yl
         gj1lnTGRR5FesytAeMp8r8uge6PUQeZZhA6lxTL5heQdH7fiR79LXqFHMvClUM5h5p
         gVMc2gE6/Iahc48rC3uSXlFXxZrDVcFEtviGrCiOxzGoz4X5+p2YsF2uXfzLHt711K
         aI6FbfzywGIPA==
Date:   Tue, 24 May 2022 17:32:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <Yo15MqcT0mLcXqOx@magnolia>
References: <Yo03mZ12X1nLGihK@magnolia>
 <20220524234426.GQ2306852@dread.disaster.area>
 <Yo1vCizXEK7+AkZi@magnolia>
 <20220525002413.GT2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220525002413.GT2306852@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 10:24:13AM +1000, Dave Chinner wrote:
> On Tue, May 24, 2022 at 04:49:30PM -0700, Darrick J. Wong wrote:
> > On Wed, May 25, 2022 at 09:44:26AM +1000, Dave Chinner wrote:
> > > On Tue, May 24, 2022 at 12:52:57PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This is a regression test that exercises the mkfs.xfs code that creates
> > > > log sizes that are very close to the AG size when stripe units are in
> > > > play and/or when the log is forced to be in AG 0.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/843     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/843.out |    2 ++
> > > >  2 files changed, 58 insertions(+)
> > > >  create mode 100755 tests/xfs/843
> > > >  create mode 100644 tests/xfs/843.out
> > > > 
> > > > diff --git a/tests/xfs/843 b/tests/xfs/843
> > > > new file mode 100755
> > > > index 00000000..3384b1aa
> > > > --- /dev/null
> > > > +++ b/tests/xfs/843
> > > > @@ -0,0 +1,56 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test 843
> > > > +#
> > > > +# Now that we've increased the default log size calculation, test mkfs with
> > > > +# various stripe units and filesystem sizes to see if we can provoke mkfs into
> > > > +# breaking.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto mkfs
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	cd /
> > > > +	rm -r -f $tmp.* $testfile
> > > > +}
> > > 
> > > I'd omit this completely.
> > > 
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs xfs
> > > > +_require_test
> > > > +
> > > > +testfile=$TEST_DIR/a
> > > > +rm -f $testfile
> > > > +
> > > > +test_format() {
> > > > +	local tag="$1"
> > > > +	shift
> > > > +
> > > > +	echo "$tag" >> $seqres.full
> > > > +	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
> > > > +	local res=$?
> > > > +	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
> > > 
> > > What breakage are you trying to provoke? Just the log size
> > > calculation? If so, why do we need to actually write the filesystem
> > > to disk? Won't "-N" still calculate everything and fail if it's
> > > broken or quit with success without needing to write anything to
> > > disk?
> > 
> > It will, but...
> > 
> > > > +}
> > > > +
> > > > +# First we try various small filesystems and stripe sizes.
> > > > +for M in `seq 298 302` `seq 490 520`; do
> > > > +	for S in `seq 32 4 64`; do
> > > > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
> > > > +	done
> > > > +done
> > > > +
> > > > +# log so large it pushes the root dir into AG 1
> > > > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0
> > 
> > ...this particular check in mkfs only happens after we allocate the root
> > directory, which an -N invocation doesn't do.
> 
> Ok, so for this test can we drop the -N? We don't need to do 30 IOs
> and write 64MB logs for every config we test - I think there's ~35 *
> 8 invocations of test_format in the loop above before we get here...
> 
> Also, why do we need a 6.3TB filesystem with 2.1GB AGs and a 2GB log
> to trigger this? That means we have to write 2GB to disk, plus
> ~20,000 write IOs for the AG headers and btree root blocks before we
> get to the failure case, yes?

So long as the test filesystem is itself XFS and a reasonably new
vintage, mkfs.xfs will call FALLOC_FL_ZERO_RANGE to zero the log, which
means we're not writing 2GB to storage with every format.

> Why not just exercise the failure case with something like this:
> 
> # mkfs.xfs -d agcount=2,size=64M -l size=8180b,agnum=0 -d file,name=test.img
> meta-data=test.img               isize=512    agcount=2, agsize=8192 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=0 inobtcount=0
> data     =                       bsize=4096   blocks=16384, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=8180, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> mkfs.xfs: root inode created in AG 1, not AG 0
> # echo $?
> 1
> #
> 
> Otherwise I don't exactly understand what this specific case is
> supposed to be testing, so maybe some more explaining is necessary?

To be honest, I hadn't thought of that; this test encodes all the weird
scenarios that Eric and I came up with over many hours of bluejeans
chatting to see if we could trip up all the mkfs log sizing code and
related fixes.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
