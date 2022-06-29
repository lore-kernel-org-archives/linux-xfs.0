Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE9FC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 22:43:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiF2Wni (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 18:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiF2Wni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 18:43:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB121826;
        Wed, 29 Jun 2022 15:43:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F9A61B2F;
        Wed, 29 Jun 2022 22:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87678C34114;
        Wed, 29 Jun 2022 22:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656542616;
        bh=YSA3RQHtRA0nxdISV34hG5/6Z19FBzquWkzHwYzWLKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hhmvWqmT8/APb/SPOMCtFPyadWyZ47bAekIConWGsIxg1VgVB9+fEugDkxls9rbr/
         eP/gKQIcDpNHB3OYOEXe7Hu+WCc1HoM6khxDkZZp8rrTI2iPjQQY89HGOG5r5neZ29
         SV7ep/Fzy+G67LBcDoyRVVDzVHQ0r+4fk947Iax3wgMtEvpjl5DM3f9d44HClMbGUb
         NcWSZbLGNEfWEQC7NBm+4vfMX+YElAcpsNeuA3oH8iTV6mFAnH4zMdZKG9iJVHUuoy
         bNM+2uGF5xTLLIWBgmFTSMM95f+FvoZUJ+GDeG9LYSO5dp9PUgiR7K7aVQMLSHjRBd
         4wTphfKgePcGw==
Date:   Wed, 29 Jun 2022 15:43:36 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     guaneryu@gmail.com, zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 3/9] xfs: test mkfs.xfs sizing of internal logs that
Message-ID: <YrzVmF1ixmr/3QhY@magnolia>
References: <165644767753.1045534.18231838177395571946.stgit@magnolia>
 <165644769450.1045534.8663346508633304230.stgit@magnolia>
 <20220629041807.GP1098723@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629041807.GP1098723@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 29, 2022 at 02:18:07PM +1000, Dave Chinner wrote:
> On Tue, Jun 28, 2022 at 01:21:34PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > This is a regression test that exercises the mkfs.xfs code that creates
> > log sizes that are very close to the AG size when stripe units are in
> > play and/or when the log is forced to be in AG 0.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  tests/xfs/843     |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/843.out |    2 ++
> >  2 files changed, 53 insertions(+)
> >  create mode 100755 tests/xfs/843
> >  create mode 100644 tests/xfs/843.out
> > 
> > 
> > diff --git a/tests/xfs/843 b/tests/xfs/843
> > new file mode 100755
> > index 00000000..5bb4bfb4
> > --- /dev/null
> > +++ b/tests/xfs/843
> > @@ -0,0 +1,51 @@
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
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs xfs
> > +_require_test
> > +echo Silence is golden
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
> > +}
> > +
> > +# First we try various small filesystems and stripe sizes.
> > +for M in `seq 298 302` `seq 490 520`; do
> > +	for S in `seq 32 4 64`; do
> > +		test_format "M=$M S=$S" -dsu=${S}k,sw=1,size=${M}m -N
> > +	done
> > +done
> > +
> > +# Log so large it pushes the root dir into AG 1.  We can't use -N for the mkfs
> > +# because this check only occurs after the root directory has been allocated,
> > +# which mkfs -N doesn't do.
> > +test_format "log pushes rootdir into AG 1" -d agcount=3200,size=6366g -lagnum=0 -N
> 
> Why are you passing "-N" to the test if it can't be used to test
> this?

I guess I went a little overboard after you asked for more -N and less
test runtime last time.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
