Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A2AC433ED
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FE8661406
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 16:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242474AbhDUQm2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 12:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236214AbhDUQm1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 12:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1279E6023B;
        Wed, 21 Apr 2021 16:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619023314;
        bh=UDdAzkekCLOAL1gA7NK4MwugnfvMypzEr7qJMGMkgvE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d5IdhrsmlqGJAgmb/5++MI+zyIafM9LOHgS+W5xNz+3fAYgrLHvCJdduLpiw3p4LP
         cqr3jEsdzDR9lv65aYA7UnmtVf566u0YNnzLRi3uhg8tfki7NaErG1F/PEkluz8Zou
         l8wCuTk56S4ZMPXBMR8VqTHu2QWeVmoXNnuqy7uqUoRFsIPA5oP0W4EbRXEECLxieB
         IJkZa5V94bOJvxWCYp0mBBExtyOr8Flt/0PsdsdHhJmKR9NSG7fGJfgHOpACsAH7FL
         PPOBL1xVuv1Mf2jS+xRhyWyUpGNz1E+wNuiyOHwnXnN/C6lW5fB/1Vjj4MRWNo0R+n
         yFOW0wXC9iJDA==
Date:   Wed, 21 Apr 2021 09:41:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
Message-ID: <20210421164153.GD3122235@magnolia>
References: <161896458140.776452.9583732658582318883.stgit@magnolia>
 <161896460627.776452.15178871770338402214.stgit@magnolia>
 <CAOQ4uxi8Bh8OYS-D6u=+U=uEdaO3EkoHce_rg6-0dyHQhG-sfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi8Bh8OYS-D6u=+U=uEdaO3EkoHce_rg6-0dyHQhG-sfw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 09:18:33AM +0300, Amir Goldstein wrote:
> On Wed, Apr 21, 2021 at 3:23 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Test that we can upgrade an existing filesystem to use bigtime.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/xfs        |   16 ++++++
> >  tests/xfs/908     |  117 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/908.out |   29 ++++++++++
> >  tests/xfs/909     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/909.out |    6 ++
> >  tests/xfs/group   |    2 +
> >  6 files changed, 319 insertions(+)
> >  create mode 100755 tests/xfs/908
> >  create mode 100644 tests/xfs/908.out
> >  create mode 100755 tests/xfs/909
> >  create mode 100644 tests/xfs/909.out
> >
> >
> > diff --git a/common/xfs b/common/xfs
> > index cb6a1978..253a31e5 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1184,3 +1184,19 @@ _xfs_timestamp_range()
> >                         awk '{printf("%s %s", $1, $2);}'
> >         fi
> >  }
> > +
> > +# Require that the scratch device exists, that mkfs can format with bigtime
> > +# enabled, that the kernel can mount such a filesystem, and that xfs_info
> > +# advertises the presence of that feature.
> > +_require_scratch_xfs_bigtime()
> > +{
> > +       _require_scratch
> > +
> > +       _scratch_mkfs -m bigtime=1 &>/dev/null || \
> > +               _notrun "mkfs.xfs doesn't support bigtime feature"
> > +       _try_scratch_mount || \
> > +               _notrun "kernel doesn't support xfs bigtime feature"
> > +       $XFS_INFO_PROG "$SCRATCH_MNT" | grep -q -w "bigtime=1" || \
> > +               _notrun "bigtime feature not advertised on mount?"
> > +       _scratch_unmount
> > +}
> > diff --git a/tests/xfs/908 b/tests/xfs/908
> > new file mode 100755
> > index 00000000..004a8563
> > --- /dev/null
> > +++ b/tests/xfs/908
> > @@ -0,0 +1,117 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 908
> > +#
> > +# Check that we can upgrade a filesystem to support bigtime and that inode
> > +# timestamps work properly after the upgrade.
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
> > +       cd /
> > +       rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_command "$XFS_ADMIN_PROG" "xfs_admin"
> > +_require_scratch_xfs_bigtime
> > +_require_xfs_repair_upgrade bigtime
> > +
> > +date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
> > +       _notrun "Userspace does not support dates past 2038."
> > +
> > +rm -f $seqres.full
> > +
> > +# Make sure we can't upgrade a V4 filesystem
> > +_scratch_mkfs -m crc=0 >> $seqres.full
> > +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> > +_check_scratch_xfs_features BIGTIME
> > +
> > +# Make sure we're required to specify a feature status
> > +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> > +_scratch_xfs_admin -O bigtime 2>> $seqres.full
> > +
> > +# Can we add bigtime and inobtcount at the same time?
> > +_scratch_mkfs -m crc=1,bigtime=0,inobtcount=0 >> $seqres.full
> > +_scratch_xfs_admin -O bigtime=1,inobtcount=1 2>> $seqres.full
> > +
> > +# Format V5 filesystem without bigtime support and populate it
> > +_scratch_mkfs -m crc=1,bigtime=0 >> $seqres.full
> > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/a
> > +touch -d 'Jan 9 19:19:19 UTC 1999' $SCRATCH_MNT/b
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +echo before upgrade:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +_scratch_unmount
> > +_check_scratch_fs
> > +
> > +# Now upgrade to bigtime support
> > +_scratch_xfs_admin -O bigtime=1 2>> $seqres.full
> > +_check_scratch_xfs_features BIGTIME
> > +_check_scratch_fs
> > +_scratch_xfs_db -c 'version' -c 'sb 0' -c 'p' >> $seqres.full
> > +
> > +# Mount again, look at our files
> > +_scratch_mount >> $seqres.full
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +echo after upgrade:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +# Bump one of the timestamps but stay under 2038
> > +touch -d 'Jan 10 19:19:19 UTC 1999' $SCRATCH_MNT/a
> > +
> > +echo after upgrade and bump:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +_scratch_cycle_mount
> > +
> > +# Did the bumped timestamp survive the remount?
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +echo after upgrade, bump, and remount:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +# Modify the other timestamp to stretch beyond 2038
> > +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> > +
> > +echo after upgrade and extension:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +_scratch_cycle_mount
> > +
> > +# Did the timestamp survive the remount?
> > +ls -la $SCRATCH_MNT/* >> $seqres.full
> > +
> > +echo after upgrade, extension, and remount:
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/a
> > +TZ=UTC stat -c '%Y' $SCRATCH_MNT/b
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/908.out b/tests/xfs/908.out
> > new file mode 100644
> > index 00000000..5e05854d
> > --- /dev/null
> > +++ b/tests/xfs/908.out
> > @@ -0,0 +1,29 @@
> > +QA output created by 908
> > +Running xfs_repair to upgrade filesystem.
> > +Large timestamp feature only supported on V5 filesystems.
> > +FEATURES: BIGTIME:NO
> > +Running xfs_repair to upgrade filesystem.
> > +Running xfs_repair to upgrade filesystem.
> > +Adding inode btree counts to filesystem.
> > +Adding large timestamp support to filesystem.
> > +before upgrade:
> > +915909559
> > +915909559
> > +Running xfs_repair to upgrade filesystem.
> > +Adding large timestamp support to filesystem.
> > +FEATURES: BIGTIME:YES
> > +after upgrade:
> > +915909559
> > +915909559
> > +after upgrade and bump:
> > +915995959
> > +915909559
> > +after upgrade, bump, and remount:
> > +915995959
> > +915909559
> 
> Did you design those following days timestamps to look so cool? ;-)

No, the repeated 5s and 9s weren't intended.

> > +after upgrade and extension:
> > +915995959
> > +7956915742
> > +after upgrade, extension, and remount:
> > +915995959
> > +7956915742
> 
> Consider this test reviewed-by-me
> I'd like more eyes on the quota grace period test, so not providing
> a reviewed-by tag for the entire patch.

Ok.

--D

> 
> Thanks,
> Amir.
