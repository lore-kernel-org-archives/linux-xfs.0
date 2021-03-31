Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DA5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 15:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D08D61029
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Mar 2021 15:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhCaP47 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Mar 2021 11:56:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhCaP4j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 31 Mar 2021 11:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E411F61006;
        Wed, 31 Mar 2021 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617206199;
        bh=JQjTdpnaF7cwVBOo372oShy2warusYGn4AnPW0LdzOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PAmTTMPkd/sbO/eZ4WRot0al0TVyIHArbhjRevtgqyCbqU56IfHvcZhBXbC821IbG
         7miETBtUUS2UzZp3huck0bjhjutwK33HlJdAP9lH0nAAS+rk0KU8gtQ2ugohPqgabs
         UxK4G5dMMTTTdT4stlF+2xtMOaiHgEkmrL8Rnwk1wpFySGhTaWwM47Mkh/oVu+3vot
         c+xgosojF/TY7+MSRx4sRV2eDiEJ2MfYRxA/C3tEbTCNrlJEbO+JC6s9jNdotiuMH5
         ibQfNJrhK40Tb6uUatQpCb5TLQe8R2Q+Gl0qE60EjeQAEsRLrxsbZQT9KKGDwO+biE
         lrncH7X43ngfw==
Date:   Wed, 31 Mar 2021 08:56:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 4/4] xfs: test upgrading filesystem to bigtime
Message-ID: <20210331155638.GB4090233@magnolia>
References: <161715291588.2703979.11541640936666929011.stgit@magnolia>
 <161715293790.2703979.8248551223530213245.stgit@magnolia>
 <CAOQ4uxgCzwxv1xYYM-k-gsHnkyWxU_KzjTHRS3RyJf775R06SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgCzwxv1xYYM-k-gsHnkyWxU_KzjTHRS3RyJf775R06SQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 31, 2021 at 12:49:32PM +0300, Amir Goldstein wrote:
> On Wed, Mar 31, 2021 at 4:11 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Test that we can upgrade an existing filesystem to use bigtime.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/xfs        |   13 +++++
> >  tests/xfs/908     |   97 +++++++++++++++++++++++++++++++++++
> >  tests/xfs/908.out |   20 +++++++
> >  tests/xfs/909     |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/909.out |    6 ++
> >  tests/xfs/group   |    2 +
> >  6 files changed, 287 insertions(+)
> >  create mode 100755 tests/xfs/908
> >  create mode 100644 tests/xfs/908.out
> >  create mode 100755 tests/xfs/909
> >  create mode 100644 tests/xfs/909.out
> >
> >
> > diff --git a/common/xfs b/common/xfs
> > index 37658788..c430b3ac 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -1152,3 +1152,16 @@ _xfs_timestamp_range()
> >                         awk '{printf("%s %s", $1, $2);}'
> >         fi
> >  }
> > +
> > +_require_xfs_scratch_bigtime()
> > +{
> > +       _require_scratch
> > +
> > +       _scratch_mkfs -m bigtime=1 &>/dev/null || \
> > +               _notrun "mkfs.xfs doesn't have bigtime feature"
> > +       _try_scratch_mount || \
> > +               _notrun "bigtime not supported by scratch filesystem type: $FSTYP"
> > +       $XFS_INFO_PROG "$SCRATCH_MNT" | grep -q "bigtime=1" || \
> > +               _notrun "bigtime feature not advertised on mount?"
> > +       _scratch_unmount
> > +}
> > diff --git a/tests/xfs/908 b/tests/xfs/908
> > new file mode 100755
> > index 00000000..1ad3131a
> > --- /dev/null
> > +++ b/tests/xfs/908
> > @@ -0,0 +1,97 @@
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
> > +_require_xfs_scratch_bigtime
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
> > +# Modify one of the timestamps to stretch beyond 2038
> > +touch -d 'Feb 22 22:22:22 UTC 2222' $SCRATCH_MNT/b
> > +
> > +echo after upgrade:
> 
> There is an oddity in the output.
> The text says "after upgrade" but the timestampt of b has changed because
> it is really "after upgrade and stretch". Did you mean to print to output
> "after upgrade" and then again "after upgrade and stretch"?

Yes, this test should check that the timestamps are intact after the
upgrade.  Will repost.

--D

> Thanks,
> Amir.
