Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C228DCCA473
	for <linux-xfs@archiver.kernel.org>; Thu, 30 Jun 2022 19:32:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236491AbiF3TcR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236786AbiF3TcO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 15:32:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EEA43AD3;
        Thu, 30 Jun 2022 12:32:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A08BCB82CF7;
        Thu, 30 Jun 2022 19:32:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E11C34115;
        Thu, 30 Jun 2022 19:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656617530;
        bh=DMTA8Bz0BCQwoa9GNAKN/yJXk5fM9/qvJHnqz4K+fC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=glCF99gDE/IRpaBtJFspxhjReol3MNurcv08ua9JSmN+F1lt31sIOdgEOVe0iku8X
         pVhgNKwbG7lBg+389pmeBeFsmHt3QDv5tO4a2qqmq2osYMY/DHNAC4MzUJaPfJKVKN
         R9rDHTPHx/8FVBc1IpxEP43LaCC6F3ViTjuFM3GI4T+d+3OvsgxjwObMhnMcNaCtTz
         d5KwK/G5/+oRizjBB94+AGFj04yNB+ghIZuhWLWE8YZHQ5FFUWML2H8Of4rAaYFMWk
         Y9Fodb2Ab3mL+WB1ENiyyf9gbK/MBNTdudk0O3CJT9ryLBOE92ZbxCKI/J5rULDiyP
         k/vZgLkLDkqCg==
Date:   Thu, 30 Jun 2022 12:32:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <Yr36ObMe5agymA+F@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644769450.1045534.8663346508633304230.stgit@magnolia>
 <20220629041807.GP1098723@dread.disaster.area>
 <YrzVmF1ixmr/3QhY@magnolia>
 <20220630063714.vrvyip5b2fari3up@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630063714.vrvyip5b2fari3up@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 02:37:14PM +0800, Zorro Lang wrote:
> On Wed, Jun 29, 2022 at 03:43:36PM -0700, Darrick J. Wong wrote:
> > On Wed, Jun 29, 2022 at 02:18:07PM +1000, Dave Chinner wrote:
> > > On Tue, Jun 28, 2022 at 01:21:34PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > This is a regression test that exercises the mkfs.xfs code that creates
> > > > log sizes that are very close to the AG size when stripe units are in
> > > > play and/or when the log is forced to be in AG 0.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/843     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/843.out |    2 ++
> > > >  2 files changed, 53 insertions(+)
> > > >  create mode 100755 tests/xfs/843
> > > >  create mode 100644 tests/xfs/843.out
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/843 b/tests/xfs/843
> > > > new file mode 100755
> > > > index 00000000..5bb4bfb4
> > > > --- /dev/null
> > > > +++ b/tests/xfs/843
> > > > @@ -0,0 +1,51 @@
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
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs xfs
> > > > +_require_test
> > > > +echo Silence is golden
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
> > > > +}
> > > > +
> > > > +# First we try various small filesystems and stripe sizes.
> > > > +for M in `seq 298 302` `seq 490 520`; do
> > > > +	for S in `seq 32 4 64`; do
> > > > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> > > > +	done
> > > > +done
> > > > +
> > > > +# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > > > +# because this check only occurs after the root directory has been allocated,
> > > > +# which mkfs -N doesn't do.
> > > > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
> > > 
> > > Why are you passing "-N" to the test if it can't be used to test
> > > this?
> > 
> > I guess I went a little overboard after you asked for more -N and less
> > test runtime last time.
> 
> Is there anything different coverage if mkfs.xfs with or without "-N" (except
> really writing on disk) ? If no difference, I'm fine with that, or I think
> without "-N" might be good, especially this case only makes fs with small size,
> it's fast enough.

Yes -- with that one exception, the mkfs geometry validation examined by
this test are all performed before mkfs writes anything to disk.  The
root inode location check is performed /after/ allocating it, which
means that we actually have to let it write the new filesystem to disk.

That's why *most* of the tests can use -N to reduce runtime.

Come to think of it, this really ought to have a _require_fs_space call
to make sure that fallocating the log space succeeds.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Cheers,
> > > 
> > > Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > 
> 
