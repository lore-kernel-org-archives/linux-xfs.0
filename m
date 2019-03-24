Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:53496 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfCXGdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Mar 2019 02:33:03 -0400
Date: Sat, 23 Mar 2019 23:32:52 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/12] xfs: test xfs_copy and xfs_mdrestore on the
 populate images
Message-ID: <20190324063252.GA6537@magnolia>
References: <155304267647.31707.14180452399822113095.stgit@magnolia>
 <155304274924.31707.623436868976936668.stgit@magnolia>
 <20190324023653.GX2824@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190324023653.GX2824@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Mar 24, 2019 at 10:36:53AM +0800, Eryu Guan wrote:
> On Tue, Mar 19, 2019 at 05:45:49PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Make sure that copy, metadump, and mdrestore work on a filesystem with
> > all known metadata types.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  tests/xfs/740     |   97 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/740.out |   12 +++++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 110 insertions(+)
> >  create mode 100755 tests/xfs/740
> >  create mode 100644 tests/xfs/740.out
> > 
> > 
> > diff --git a/tests/xfs/740 b/tests/xfs/740
> > new file mode 100755
> > index 00000000..0ff548cb
> > --- /dev/null
> > +++ b/tests/xfs/740
> > @@ -0,0 +1,97 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0+
> > +# Copyright (c) 2019 Oracle, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 740
> > +#
> > +# Populate a XFS filesystem and ensure that metadump, mdrestore, and copy
> > +# all work properly.
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -rf $tmp.* $testdir
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/populate
> > +
> > +testdir=$TEST_DIR/test-$seq
> > +
> > +# real QA test starts here
> > +_supported_os Linux
> > +_supported_fs xfs
> > +
> > +_require_scratch_nocheck
> > +_require_populate_commands
> > +
> > +echo "Format and populate"
> > +_scratch_populate_cached nofill > $seqres.full 2>&1
> > +
> > +mkdir -p $testdir
> > +metadump_file=$testdir/scratch.md
> > +metadump_file_a=${metadump_file}.a
> > +metadump_file_g=${metadump_file}.g
> > +metadump_file_ag=${metadump_file}.ag
> > +copy_file=$testdir/copy.img
> > +
> > +echo metadump
> > +_scratch_metadump $metadump_file
> > +
> > +echo metadump a
> > +_scratch_metadump $metadump_file_a
> > +
> > +echo metadump g
> > +_scratch_metadump $metadump_file_g
> > +
> > +echo metadump ag
> > +_scratch_metadump $metadump_file_ag
> 
> I may miss something here, but I'm a bit confused, what's the difference
> between all these metadump files? Looks like scratch device is just
> dumped multiple times to different dump files? And later restored
> multiple times?

Bah, that was *supposed* to be a test of the different flavors of
metadump (copy entire blocks or not; obfuscate names or not) but clearly
I thinko'd the metadump commands. :(

Where is this AI programming future where I can simply express a desire
to test all the major format-altering metadump variants and the computer
will figure out what needs to be done, rather than me having to write
that idea in triplicate in the form of a log message, a file name, and a
command line switch?

It's times like these I really hate programming. <grumble>

--D

> Thanks,
> Eryu
> 
> > +
> > +echo copy
> > +$XFS_COPY_PROG $SCRATCH_DEV $copy_file >> $seqres.full
> > +_check_scratch_fs $copy_file
> > +
> > +echo recopy
> > +$XFS_COPY_PROG $copy_file $SCRATCH_DEV >> $seqres.full
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore
> > +xfs_mdrestore $metadump_file $SCRATCH_DEV
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore a
> > +xfs_mdrestore $metadump_file_a $SCRATCH_DEV
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore g
> > +xfs_mdrestore $metadump_file_g $SCRATCH_DEV
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +echo mdrestore ag
> > +xfs_mdrestore $metadump_file_ag $SCRATCH_DEV
> > +_scratch_mount
> > +_check_scratch_fs
> > +_scratch_unmount
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/740.out b/tests/xfs/740.out
> > new file mode 100644
> > index 00000000..0c979dc4
> > --- /dev/null
> > +++ b/tests/xfs/740.out
> > @@ -0,0 +1,12 @@
> > +QA output created by 740
> > +Format and populate
> > +metadump
> > +metadump a
> > +metadump g
> > +metadump ag
> > +copy
> > +recopy
> > +mdrestore
> > +mdrestore a
> > +mdrestore g
> > +mdrestore ag
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 9d9458b8..b8bd1012 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -500,3 +500,4 @@
> >  500 auto quick mkfs prealloc mkfs
> >  501 auto quick unlink
> >  502 auto quick unlink
> > +740 auto copy metadump
> > 
