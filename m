Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0291C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A173461A2C
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Mar 2021 16:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhCYQdt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Mar 2021 12:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229839AbhCYQdW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 12:33:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5560561993;
        Thu, 25 Mar 2021 16:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616690002;
        bh=Yh8kP5w1znpIE83oLnJ0fkzeYCuENIM1UN1hlBjl5r4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NIZ+pW9zNiJA69qewT7N3kQNN497Q10jgm3r+lcvwXOtC5dqttjvDNmf+oMKGQwPf
         rSa664pEHHDlLY5hsYLSGf4XYiKNxZivK5j2zg427SNGyWk8/yl/630P7V/dder3v+
         Ag3wS6ToxIRrpiaZ4pm3o5gA3xPvBPQmYutEHQnN5A5BCOlZof3kAPi/Z/mUiWV3Oq
         TY4owITtHF7mbeyKBgOoAR+o6HuwPxgHX+kN31U/MCOmVdfGe8+5RTXkywbwPIrYGA
         KW20I70W2plnCCxIwHXCLlQgpdqmuIemVHpXGkimNcFTMJuXwjywHesCpabpmPVois
         Bz9sV+4HI3KaA==
Date:   Thu, 25 Mar 2021 09:33:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: test the xfs_db path command
Message-ID: <20210325163321.GG4090233@magnolia>
References: <161647321880.3430916.13415014495565709258.stgit@magnolia>
 <161647322430.3430916.12437291741320143904.stgit@magnolia>
 <87mturo9wl.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mturo9wl.fsf@garuda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 03:03:14PM +0530, Chandan Babu R wrote:
> On 23 Mar 2021 at 09:50, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > Add a new test to make sure the xfs_db path command works the way the
> > author thinks it should.
> >
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/917     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/917.out |   19 ++++++++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 118 insertions(+)
> >  create mode 100755 tests/xfs/917
> >  create mode 100644 tests/xfs/917.out
> >
> >
> > diff --git a/tests/xfs/917 b/tests/xfs/917
> > new file mode 100755
> > index 00000000..bf21b290
> > --- /dev/null
> > +++ b/tests/xfs/917
> > @@ -0,0 +1,98 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 917
> > +#
> > +# Make sure the xfs_db path command works the way the author thinks it does.
> > +# This means that it can navigate to random inodes, fails on paths that don't
> > +# resolve.
> > +#
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
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_xfs_db_command "path"
> > +_require_scratch
> > +
> > +echo "Format filesystem and populate"
> > +_scratch_mkfs > $seqres.full
> > +_scratch_mount >> $seqres.full
> > +
> > +mkdir $SCRATCH_MNT/a
> > +mkdir $SCRATCH_MNT/a/b
> > +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
> > +ln -s -f c $SCRATCH_MNT/a/d
> > +mknod $SCRATCH_MNT/a/e b 8 0
> > +ln -s -f b $SCRATCH_MNT/a/f
> 
> Later in the test script, there are two checks corresponding to accessibility
> of file symlink and dir symlink. However, $SCRATCH_MNT/a/d and
> $SCRATCH_MNT/a/f are actually referring to non-existant files since current
> working directory at the time of invocation of ln command is the xfstests
> directory.
> 
> i.e. 'c' and 'b' arguments to 'ln' command above must be qualified with
> $SCRATCH_MNT/a/.

Hm?  d and f look fine to me:

$ ./check xfs/917
$ mount /dev/sdf /opt
$ cd /opt/a
$ ls
total 4
drwxr-xr-x 2 root root    6 Mar 25 09:25 b/
-rw------- 1 root root   61 Mar 25 09:25 c
lrwxrwxrwx 1 root root    1 Mar 25 09:25 d -> c
brw-r--r-- 1 root root 8, 0 Mar 25 09:25 e
lrwxrwxrwx 1 root root    1 Mar 25 09:25 f -> b/

The link target is copied verbatim into the symlink, so I don't see why
they need to be qualified?

(FWIW the path command doesn't resolve symlinks, so it really only
checks that /a/d and /a/f exist and are of type symlink.)

--D

> 
> > +
> > +_scratch_unmount
> > +
> > +echo "Check xfs_db path on directories"
> > +_scratch_xfs_db -c 'path /a' -c print | grep -q 'sfdir.*count.* 5$' || \
> > +	echo "Did not find directory /a"
> > +
> > +_scratch_xfs_db -c 'path /a/b' -c print | grep -q sfdir || \
> > +	echo "Did not find empty sf directory /a/b"
> > +
> > +echo "Check xfs_db path on files"
> > +_scratch_xfs_db -c 'path /a/c' -c print | grep -q 'core.size.*61' || \
> > +	echo "Did not find 61-byte file /a/c"
> > +
> > +echo "Check xfs_db path on file symlinks"
> > +_scratch_xfs_db -c 'path /a/d' -c print | grep -q symlink || \
> > +	echo "Did not find symlink /a/d"
> > +
> > +echo "Check xfs_db path on bdevs"
> > +_scratch_xfs_db -c 'path /a/e' -c print | grep -q 'format.*dev' || \
> > +	echo "Did not find bdev /a/e"
> > +
> > +echo "Check xfs_db path on dir symlinks"
> > +_scratch_xfs_db -c 'path /a/f' -c print | grep -q symlink || \
> > +	echo "Did not find symlink /a/f"
> 
> --
> chandan
