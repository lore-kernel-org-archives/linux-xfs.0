Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25D7C433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:54:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CF0864F6C
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 20:54:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhBCUxp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 15:53:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:58650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232701AbhBCUwp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 15:52:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21F0364F5C;
        Wed,  3 Feb 2021 20:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612385524;
        bh=Cmx6O0A+0fS53bYklYizQ5Fl//NjYi2+nmePBWdk3tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uuHvX5z95G3A9TrH2xPGq6UEgrzITBZxw9CnauvXxTWdx9ak8pNS5X44dfoLUU+ej
         eOllMic2FSjQXK/vcM28Qv7U9pBtf9t+rnc4t/xm+Pmg56zvJ2XyUQFSYZl/VuG/Xd
         wpHi6ayXXD/Db1K6MavzR3oTMhLuuxi/Xm9Ah0vvNTvgpm0tToROpQwBmHuDlJFwcz
         hU5kcgqRKLoaAhG29XFsj/NrYbTXizhk3R+tHX7YRPVQYxCTXevKZALwbj45YRmBj1
         w2IaO8g2of627k33K+vPYl9caB1a0+bSNX2JyIKctdk2FA8v7pIgHu8b2zCPq2l49d
         rQoA+KRvi8e6A==
Date:   Wed, 3 Feb 2021 12:52:03 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: test delalloc quota leak when chprojid fails
Message-ID: <20210203205203.GF7193@magnolia>
References: <20210202194101.GQ7193@magnolia>
 <20210203161155.GF3647012@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203161155.GF3647012@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 03, 2021 at 11:11:55AM -0500, Brian Foster wrote:
> On Tue, Feb 02, 2021 at 11:41:01AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test for a bug in the XFS implementation of
> > FSSETXATTR.  When we try to change a file's project id, the quota
> > reservation code will update the incore quota reservations for delayed
> > allocation blocks.  Unfortunately, it does this before we finish
> > validating all the FSSETXATTR parameters, which means that if we decide
> > to bail out, we also fail to undo the incore changes.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  .gitignore          |    1 +
> >  src/Makefile        |    3 +-
> >  src/chprojid_fail.c |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/765       |   63 +++++++++++++++++++++++++++++++++++++
> >  tests/xfs/765.out   |    3 ++
> >  tests/xfs/group     |    1 +
> >  6 files changed, 156 insertions(+), 1 deletion(-)
> >  create mode 100644 src/chprojid_fail.c
> >  create mode 100755 tests/xfs/765
> >  create mode 100644 tests/xfs/765.out
> > 
> ...
> > diff --git a/src/chprojid_fail.c b/src/chprojid_fail.c
> > new file mode 100644
> > index 00000000..e7467372
> > --- /dev/null
> > +++ b/src/chprojid_fail.c
> > @@ -0,0 +1,86 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +/*
> > + * Copyright (c) 2021 Oracle.  All Rights Reserved.
> > + * Author: Darrick J. Wong <djwong@kernel.org>
> > + *
> > + * Regression test for failing to undo delalloc quota reservations when
> > + * changing project id and we fail some other FSSETXATTR validation.
> > + */
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <fcntl.h>
> > +#include <unistd.h>
> > +#include <sys/ioctl.h>
> > +#include <stdio.h>
> > +#include <string.h>
> > +#include <errno.h>
> > +#include <linux/fs.h>
> > +
> > +static char zerobuf[65536];
> > +
> > +int
> > +main(
> > +	int		argc,
> > +	char		*argv[])
> > +{
> > +	struct fsxattr	fa;
> > +	ssize_t		sz;
> > +	int		fd, ret;
> > +
> > +	if (argc < 2) {
> > +		printf("Usage: %s filename\n", argv[0]);
> > +		return 1;
> > +	}
> > +
> > +	fd = open(argv[1], O_CREAT | O_TRUNC | O_RDWR, 0600);
> > +	if (fd < 0) {
> > +		perror(argv[1]);
> > +		return 2;
> > +	}
> > +
> > +	/* Zero the project id and the extent size hint. */
> > +	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fa);
> > +	if (ret) {
> > +		perror("FSGETXATTR check file");
> > +		return 2;
> > +	}
> > +
> > +	if (fa.fsx_projid != 0 || fa.fsx_extsize != 0) {
> > +		fa.fsx_projid = 0;
> > +		fa.fsx_extsize = 0;
> > +		ret = ioctl(fd, FS_IOC_FSSETXATTR, &fa);
> > +		if (ret) {
> > +			perror("FSSETXATTR zeroing");
> > +			return 2;
> > +		}
> > +	}
> > +
> > +	/* Dirty a few kb of a file to create delalloc extents. */
> > +	sz = write(fd, zerobuf, sizeof(zerobuf));
> > +	if (sz != sizeof(zerobuf)) {
> > +		perror("delalloc write");
> > +		return 2;
> > +	}
> > +
> > +	/*
> > +	 * Fail to chprojid and set an extent size hint after we wrote the file.
> > +	 */
> 
> Might be helpful to document exactly why this command should fail.

Fixed.

> > +	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fa);
> > +	if (ret) {
> > +		perror("FSGETXATTR");
> > +		return 2;
> > +	}
> > +
> > +	fa.fsx_projid = 23652;
> > +	fa.fsx_extsize = 2;
> > +	fa.fsx_xflags |= FS_XFLAG_EXTSIZE;
> > +
> > +	ret = ioctl(fd, FS_IOC_FSSETXATTR, &fa);
> > +	if (ret) {
> > +		printf("FSSETXATTRR should fail: %s\n", strerror(errno));
> > +		return 0;
> > +	}
> > +
> > +	/* Uhoh, that FSSETXATTR call should have failed! */
> > +	return 3;
> > +}
> > diff --git a/tests/xfs/765 b/tests/xfs/765
> > new file mode 100755
> > index 00000000..769b545b
> > --- /dev/null
> > +++ b/tests/xfs/765
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 765
> > +#
> > +# Regression test for failing to undo delalloc quota reservations when changing
> > +# project id but we fail some other part of FSSETXATTR validation.  If we fail
> > +# the test, we trip debugging assertions in dmesg.
> > +#
> > +# The appropriate XFS patch is:
> > +# xfs: fix chown leaking delalloc quota blocks when fssetxattr fails
> > +
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1    # failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_debug
> 
> I agree with Zorro that we might as well just let this run with or
> without debug mode..

<nod> Fixed.

> > +_require_command "$FILEFRAG_PROG" filefrag
> > +_require_test_program "chprojid_fail"
> > +_require_quota
> > +_require_scratch
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format filesystem" | tee -a $seqres.full
> > +_scratch_mkfs > $seqres.full
> > +_qmount_option 'prjquota'
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +
> > +echo "Run test program"
> > +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> > +$here/src/chprojid_fail $SCRATCH_MNT/blah >> $seqres.full
> > +res=$?
> > +if [ $res -ne 0 ]; then
> > +	echo "chprojid_fail returned $res, expected 0"
> > +fi
> 
> Can we just use the output from the test program as the golden test
> output?

Hm, I guess so?  Not sure I want to encode the exact failure in the
test, but I don't see why not.

Admittedly it's done that way because originally I was going to wire
this up as a generic test, but then noticed that not all the other
fssetxattr implementations actually error out on nonzero extent size and
decided to pull this back into tests/xfs/.

> > +$XFS_QUOTA_PROG -f -x -c 'report -ap' $SCRATCH_MNT >> $seqres.full
> > +$FILEFRAG_PROG -v $SCRATCH_MNT/blah >> $seqres.full
> > +$FILEFRAG_PROG -v $SCRATCH_MNT/blah 2>&1 | grep -q delalloc || \
> > +	echo "file didn't get delalloc extents?"
> 
> This could technically cause a failure even if the test did the right
> thing if writeback happens to occur, right? I suppose that's exceedingly
> unlikely, but might at least be worth documenting in the event that
> somebody has to deal with that scenario sometime in the future.

Yeah.  I'll add a comment explaining that the delalloc grep is to check
that we even set up the test correctly.

--D

> 
> Brian
> 
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/765.out b/tests/xfs/765.out
> > new file mode 100644
> > index 00000000..f44ba43e
> > --- /dev/null
> > +++ b/tests/xfs/765.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 765
> > +Format filesystem
> > +Run test program
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index f406a9b9..fb78b0d7 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -544,6 +544,7 @@
> >  762 auto quick rw scrub realtime
> >  763 auto quick rw realtime
> >  764 auto quick repair
> > +765 auto quick quota
> >  908 auto quick bigtime
> >  909 auto quick bigtime quota
> >  910 auto quick inobtcount
> > 
> 
