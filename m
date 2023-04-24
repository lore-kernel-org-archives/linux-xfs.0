Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A08C77B61
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Apr 2023 17:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbjDXR5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Apr 2023 13:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDXR5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Apr 2023 13:57:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B25E49E1;
        Mon, 24 Apr 2023 10:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A34BC627C2;
        Mon, 24 Apr 2023 17:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06901C433EF;
        Mon, 24 Apr 2023 17:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682359033;
        bh=ArMgrNt/IxdyBDntvAMKYKrjg7FRfMYhWNWCcExsTr8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWILaKXkWPfW0XRc5bUDs4mgF1e/2EnCe8uA9EgCc9N/7EBBI6OPn3Wk5CXtY8uhu
         Ycxd7g2vRTDh1hIXNx3AGnbFAXgfPhtwTzleikRLfFZDWNi5DRzE9e7NDKjnEu+ETO
         12/cDJf7kemHE6NyS4YIriCe1zk3QpL2lY0szLbN7gG+Ub/mJ/cx6GGGjRmTDerm66
         ceU8ZAtM4LHTF6IoMuVm6SH9vwcds1h8jNAcsNyVHWwUU4iLjz+vPts0+WbQOBoYP1
         kico5607dAPFsoHmLPrSjiQ1f0qGSm0jXXXQnT2blPBPdefoL+k2qddfF0DE2EODAl
         8TC1WGKeQAr7A==
Date:   Mon, 24 Apr 2023 10:57:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 3/3] misc: add duration for recovery loop tests
Message-ID: <20230424175712.GF360885@frogsfrogsfrogs>
References: <168123682679.4086541.13812285218510940665.stgit@frogsfrogsfrogs>
 <168123684394.4086541.1780469729949319721.stgit@frogsfrogsfrogs>
 <20230423150959.agkw6tlnvjbiymbg@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230423150959.agkw6tlnvjbiymbg@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 23, 2023 at 11:09:59PM +0800, Zorro Lang wrote:
> On Tue, Apr 11, 2023 at 11:14:03AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make it so that we can run recovery loop tests for an exact number of
> > seconds.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/rc         |   34 ++++++++++++++++++++++++++++++++++
> >  tests/generic/019 |    1 +
> >  tests/generic/388 |    2 +-
> >  tests/generic/475 |    2 +-
> >  tests/generic/482 |    5 +++++
> >  tests/generic/648 |    8 ++++----
> >  6 files changed, 46 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index e89b0a3794..090f3d4938 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -5078,6 +5078,40 @@ _save_coredump()
> >  	$COREDUMP_COMPRESSOR -f "$out_file"
> >  }
> >  
> > +# Decide if a soak test should continue looping.  The sole parameter is the
> > +# number of soak loops that the test wants to run by default.  The actual
> > +# loop iteration number is stored in SOAK_LOOPIDX until the loop completes.
> > +#
> > +# If the test runner set a SOAK_DURATION value, this predicate will keep
> > +# looping until it has run for at least that long.
> > +_soak_loop_running() {
> > +	local max_soak_loops="$1"
> > +
> > +	test -z "$SOAK_LOOPIDX" && SOAK_LOOPIDX=1
> > +
> > +	if [ -n "$SOAK_DURATION" ]; then
> > +		if [ -z "$SOAK_DEADLINE" ]; then
> > +			SOAK_DEADLINE="$(( $(date +%s) + SOAK_DURATION))"
> > +		fi
> > +
> > +		local now="$(date +%s)"
> > +		if [ "$now" -gt "$SOAK_DEADLINE" ]; then
> > +			unset SOAK_DEADLINE
> > +			unset SOAK_LOOPIDX
> > +			return 1
> > +		fi
> > +		SOAK_LOOPIDX=$((SOAK_LOOPIDX + 1))
> > +		return 0
> > +	fi
> > +
> > +	if [ "$SOAK_LOOPIDX" -gt "$max_soak_loops" ]; then
> > +		unset SOAK_LOOPIDX
> > +		return 1
> > +	fi
> > +	SOAK_LOOPIDX=$((SOAK_LOOPIDX + 1))
> > +	return 0
> > +}
> > +
> >  init_rc
> >  
> >  ################################################################################
> > diff --git a/tests/generic/019 b/tests/generic/019
> > index b68dd90c0d..b81c1d17ba 100755
> > --- a/tests/generic/019
> > +++ b/tests/generic/019
> > @@ -30,6 +30,7 @@ _cleanup()
> >  }
> >  
> >  RUN_TIME=$((20+10*$TIME_FACTOR))
> > +test -n "$SOAK_DURATION" && RUN_TIME="$SOAK_DURATION"
> >  NUM_JOBS=$((4*LOAD_FACTOR))
> >  BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
> >  FILE_SIZE=$((BLK_DEV_SIZE * 512))
> > diff --git a/tests/generic/388 b/tests/generic/388
> > index 9cd737e8eb..4a5be6698c 100755
> > --- a/tests/generic/388
> > +++ b/tests/generic/388
> > @@ -42,7 +42,7 @@ _scratch_mkfs >> $seqres.full 2>&1
> >  _require_metadata_journaling $SCRATCH_DEV
> >  _scratch_mount
> >  
> > -for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
> > +while _soak_loop_running $((50 * TIME_FACTOR)); do
> >  	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p 4 >> $seqres.full &) \
> >  		> /dev/null 2>&1
> >  
> > diff --git a/tests/generic/475 b/tests/generic/475
> > index c426402ede..0cbf5131c2 100755
> > --- a/tests/generic/475
> > +++ b/tests/generic/475
> > @@ -41,7 +41,7 @@ _require_metadata_journaling $SCRATCH_DEV
> >  _dmerror_init
> >  _dmerror_mount
> >  
> > -for i in $(seq 1 $((50 * TIME_FACTOR)) ); do
> > +while _soak_loop_running $((50 * TIME_FACTOR)); do
> >  	($FSSTRESS_PROG $FSSTRESS_AVOID -d $SCRATCH_MNT -n 999999 -p $((LOAD_FACTOR * 4)) >> $seqres.full &) \
> >  		> /dev/null 2>&1
> >  
> > diff --git a/tests/generic/482 b/tests/generic/482
> > index 28c83a232e..b980826b14 100755
> > --- a/tests/generic/482
> > +++ b/tests/generic/482
> > @@ -62,8 +62,13 @@ nr_cpus=$("$here/src/feature" -o)
> >  if [ $nr_cpus -gt 8 ]; then
> >  	nr_cpus=8
> >  fi
> > +
> >  fsstress_args=$(_scale_fsstress_args -w -d $SCRATCH_MNT -n 512 -p $nr_cpus \
> >  		$FSSTRESS_AVOID)
> > +
> > +# XXX dm-logwrites pins kernel memory for every write!
> > +# test -n "$SOAK_DURATION" && fsstress_args="$fsstress_args --duration=$SOAK_DURATION"
> 
> Do you expect the second comment is a comment?

Actually... I'd like to withdraw this chunk so that people aren't
tempted to uncomment it.  I had previously wanted generic/482 to be a
SOAK_DURATION controllable test, but all that does is increase kernel
memory usage until the VM OOMs, and it OOMs pretty quickly if you don't
provision it with the same amount of RAM as the fs is writing to disk.

I'll repost this without the changes to g/482.

--D

> Others looks good to me. I'll test V2 and merge it if no regression from it.
> 
> Thanks,
> Zorro
> 
