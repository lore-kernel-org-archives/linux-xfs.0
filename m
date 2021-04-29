Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CABC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE44A613F9
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Apr 2021 00:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239147AbhD2AcV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232095AbhD2AcV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Apr 2021 20:32:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B00613F1;
        Thu, 29 Apr 2021 00:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619656295;
        bh=bUZUk3/VXTuz79JMYVLsmHrNM1DhXmXyHyuHH0HAVow=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ntsVZcXb9YhGMXoRvS2+vVs+ec8KHIPGI+VJo1Tw6J48+PQYKYbkb332zPwRYJQlI
         NhqYvW2yxE3q2eG4rZhJJREKbRZTtR3eJLZGjQAX4hwcC9RLlBRHaL8ZjTN3ov2N9b
         D4nn5rTgjHsowoIp6ToFlpP2wNOA5Dvn+ZFdHLDoxJVe7eez9TNEsH7/t982UzlBX1
         E0B2pcN3PLK76YvokpZvDs5BB/iw78/6wechB+AJM36M34jsQOPERVJUTi4ShbjVHc
         Q7SaLzUKkHoTe7AdjXXVaIdHZm7KeB3qPfnHEKvIsDeW7LJYT5nDx4yH42AA5zTZCF
         iv1iqbVGdMBIg==
Date:   Wed, 28 Apr 2021 17:31:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: test what happens when we reset the root dir
 and it has xattrs
Message-ID: <20210429003135.GL3122264@magnolia>
References: <161958291787.3452247.15296911612919535588.stgit@magnolia>
 <161958292387.3452247.4459342156885074164.stgit@magnolia>
 <YImdkx6ofgQ1t8CD@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YImdkx6ofgQ1t8CD@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 28, 2021 at 01:38:27PM -0400, Brian Foster wrote:
> On Tue, Apr 27, 2021 at 09:08:43PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that we can reset the root directory and the xattrs are erased
> > properly.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/757     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/757.out |    7 ++++++
> >  tests/xfs/group   |    1 +
> >  3 files changed, 71 insertions(+)
> >  create mode 100755 tests/xfs/757
> >  create mode 100644 tests/xfs/757.out
> > 
> > 
> > diff --git a/tests/xfs/757 b/tests/xfs/757
> > new file mode 100755
> > index 00000000..0b9914f6
> > --- /dev/null
> > +++ b/tests/xfs/757
> > @@ -0,0 +1,63 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 757
> > +#
> > +# Make sure that attrs are handled properly when repair has to reset the root
> > +# directory.
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
> > +	rm -rf $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/populate
> > +. ./common/fuzzy
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch_nocheck
> > +
> > +rm -f $seqres.full
> > +
> > +echo "Format and populate btree attr root dir"
> > +_scratch_mkfs > "$seqres.full" 2>&1
> > +_scratch_mount
> > +
> > +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> > +__populate_create_attr "${SCRATCH_MNT}" "$((64 * blksz / 40))" true
> > +_scratch_unmount
> > +
> > +echo "Break the root directory"
> > +_scratch_xfs_fuzz_metadata_field core.mode zeroes 'sb 0' 'addr rootino' >> $seqres.full 2>&1
> > +
> > +echo "Detect bad root directory"
> > +_scratch_xfs_repair -n >> $seqres.full 2>&1 && \
> > +	echo "Should have detected bad root dir"
> > +
> > +echo "Fix bad root directory"
> > +_scratch_xfs_repair >> $seqres.full 2>&1
> > +
> > +echo "Detect fixed root directory"
> > +_scratch_xfs_repair -n >> $seqres.full 2>&1
> > +
> > +echo "Mount test"
> > +_scratch_mount
> > +
> 
> Is the regression test here that attrs are erased after this sequence
> (as suggested in the commit log), or that the fs mounts, or both? I'm
> basically just wondering if we should also dump the xattrs on the root
> dir as a last step (and expect NULL output)..? That aside:

I've been racking my brain trying to remember where this test came from.
IIRC it was some xfs_repair segfault bug that I came across last
September.  It would manifest if the root dir had xattrs attached and
repair decided to nuke the root directory, but there aren't any obvious
patches, and I've totally forgotten the original context.  It might have
related to Dave or someone noticing that things didn't quite work with a
filesystem that had selinux enabled and the root dir got corrupt...?

Either way, thanks for the reviews :)

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/xfs/757.out b/tests/xfs/757.out
> > new file mode 100644
> > index 00000000..9f3aed5a
> > --- /dev/null
> > +++ b/tests/xfs/757.out
> > @@ -0,0 +1,7 @@
> > +QA output created by 757
> > +Format and populate btree attr root dir
> > +Break the root directory
> > +Detect bad root directory
> > +Fix bad root directory
> > +Detect fixed root directory
> > +Mount test
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index 731f869c..76e31167 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -528,5 +528,6 @@
> >  537 auto quick
> >  538 auto stress
> >  539 auto quick mount
> > +757 auto quick attr repair
> >  908 auto quick bigtime
> >  909 auto quick bigtime quota
> > 
> 
