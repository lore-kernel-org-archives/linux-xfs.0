Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71565C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 23:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235809AbiEXXtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 19:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiEXXtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 19:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A6B62120;
        Tue, 24 May 2022 16:49:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 622FF61828;
        Tue, 24 May 2022 23:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEE7C34100;
        Tue, 24 May 2022 23:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653436170;
        bh=rmyeN3VbaMbqlR3n0NG/UqxcwU4ZhomXULU6tO8Rt3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVhqPXdr7uxkWMwKE12WfpjCcUpCBo7OO0iDrpdvHO1sRlQCSGthJv4uaZtXSek1g
         NE/TLCmRWeNx63SXETekIeyB75KlOSCUywl50CY9S3sM1WU1FHx7NBr3qxtnijXYfy
         bTwa2R+J1RmDKz/nS+3FBG3XnZsG0iCKM7BHBCrb71AXpdKMW4k2rQiRTnsY3jNNhE
         m2crVZSR7tvTZt3d0C71QmiqdjqsT6XBBegUcgo0sW5FxmL5Xe/so9KrqYdgMhOiEc
         Il+LyeqgD3+56VNmh5mx4Z2HOo7kejshnfRrlVm/74I1tyaX0oXY73zahNFkJls0/j
         b4jiLH8ON2dMA==
Date:   Tue, 24 May 2022 16:49:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, Eryu Guan <guaneryu@gmail.com>,
        fstests <fstests@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <Yo1vCizXEK7+AkZi@magnolia>
References: <Yo03mZ12X1nLGihK@magnolia>
 <20220524234426.GQ2306852@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220524234426.GQ2306852@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 25, 2022 at 09:44:26AM +1000, Dave Chinner wrote:
> On Tue, May 24, 2022 at 12:52:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test that exercises the mkfs.xfs code that creates
> > log sizes that are very close to the AG size when stripe units are in
> > play and/or when the log is forced to be in AG 0.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/843     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/843.out |    2 ++
> >  2 files changed, 58 insertions(+)
> >  create mode 100755 tests/xfs/843
> >  create mode 100644 tests/xfs/843.out
> > 
> > diff --git a/tests/xfs/843 b/tests/xfs/843
> > new file mode 100755
> > index 00000000..3384b1aa
> > --- /dev/null
> > +++ b/tests/xfs/843
> > @@ -0,0 +1,56 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 843
> > +#
> > +# Now that we've increased the default log size calculation, test mkfs with
> > +# various stripe units and filesystem sizes to see if we can provoke mkfs into
> > +# breaking.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto mkfs
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -r -f $tmp.* $testfile
> > +}
> 
> I'd omit this completely.
> 
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_test
> > +
> > +testfile=$TEST_DIR/a
> > +rm -f $testfile
> > +
> > +test_format() {
> > +	local tag="$1"
> > +	shift
> > +
> > +	echo "$tag" >> $seqres.full
> > +	$MKFS_XFS_PROG $@ -d file,name=$testfile &>> $seqres.full
> > +	local res=$?
> > +	test $res -eq 0 || echo "$tag FAIL $res" | tee -a $seqres.full
> 
> What breakage are you trying to provoke? Just the log size
> calculation? If so, why do we need to actually write the filesystem
> to disk? Won't "-N" still calculate everything and fail if it's
> broken or quit with success without needing to write anything to
> disk?

It will, but...

> > +}
> > +
> > +# First we try various small filesystems and stripe sizes.
> > +for M in `seq 298 302` `seq 490 520`; do
> > +	for S in `seq 32 4 64`; do
> > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m
> > +	done
> > +done
> > +
> > +# log so large it pushes the root dir into AG 1
> > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0

...this particular check in mkfs only happens after we allocate the root
directory, which an -N invocation doesn't do.

> > +
> > +# log end rounded beyond EOAG due to stripe unit
> > +test_format "log end beyond eoag" -d agcount=3200,size=6366g -d su=256k,sw=4
> > +
> > +echo Silence is golden
> 
> Put this at the top where the test is being set up (i.e. where you
> define testfile). That tells the reader straight away that no output
> is expected on a successful run before they start reading the test
> code....

Hmm, we probably ought to update the ./new template too.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
