Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778F5C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 20:37:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5178261403
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Apr 2021 20:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245580AbhDUUiZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhDUUiY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Apr 2021 16:38:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74EDF61403;
        Wed, 21 Apr 2021 20:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619037470;
        bh=IzEWw8Ar7nJUyItkVfP9SZd+RieHDCQZUgCRzqq2zZY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iPYn3jLP6OBib2JbYtnJy58hH8ujokoToTixR4oFa3zBiWNKxf+iHbWxamQ0kCJtU
         YNP5nkDI2a9SWbXNjwz6v9tYi9Zf43wg+mKlp2oDaoSYS3tyFK/lyRu8YtFnHU9aUN
         MDxByTnli5mS6zK6ASJED9EFxjCpP+fUEU9VVp6CILbEyvOfC+XUVR7M/jZ9tvnWdr
         HJ67531vWNvDFYkmuYhN/5qC0vg/7XZQhvootDVn58O30AaFZCwgV2xGKc2g0Bb6jv
         U6TKCsxmd0V6kAAI6tEnAYxZIf60AdEGowXCWgTRXgeDkg0YsuqF1dwVYP9y1I8jsp
         GtQC2DtA5gi/g==
Date:   Wed, 21 Apr 2021 13:37:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <20210421203746.GE3122235@magnolia>
References: <161896455503.776294.3492113564046201298.stgit@magnolia>
 <161896456107.776294.13840945585349427098.stgit@magnolia>
 <YIBhAPo25d9GTAC8@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIBhAPo25d9GTAC8@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 01:29:36PM -0400, Brian Foster wrote:
> On Tue, Apr 20, 2021 at 05:22:41PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that the needsrepair feature flag can be cleared only by
> > repair and that mounts are prohibited when the feature is set.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  common/xfs        |   28 ++++++++++++++++++
> >  tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/768.out |    4 +++
> >  tests/xfs/770     |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/770.out |    2 +
> >  tests/xfs/group   |    2 +
> >  6 files changed, 199 insertions(+)
> >  create mode 100755 tests/xfs/768
> >  create mode 100644 tests/xfs/768.out
> >  create mode 100755 tests/xfs/770
> >  create mode 100644 tests/xfs/770.out
> > 
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 887bd001..c2384146 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -312,6 +312,13 @@ _scratch_xfs_check()
> >  	_xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
> >  }
> >  
> > +_require_libxfs_debug_flag() {
> > +	local hook="$1"
> > +
> > +	grep -q LIBXFS_DEBUG_WRITE_CRASH "$(type -P xfs_repair)" || \
> 
> Did you mean to use $hook here?

Yes.

> > +		_notrun "libxfs debug hook $hook not detected?"
> > +}
> > +
> >  _scratch_xfs_repair()
> >  {
> >  	SCRATCH_OPTIONS=""
> > @@ -1114,3 +1121,24 @@ _xfs_get_cowgc_interval() {
> >  		_fail "Can't find cowgc interval procfs knob?"
> >  	fi
> >  }
> > +
> > +# Print the status of the given features on the scratch filesystem.
> > +# Returns 0 if all features are found, 1 otherwise.
> > +_check_scratch_xfs_features()
> > +{
> > +	local features="$(_scratch_xfs_db -c 'version')"
> > +	local output=("FEATURES:")
> > +	local found=0
> > +
> > +	for feature in "$@"; do
> > +		local status="NO"
> > +		if echo "${features}" | grep -q -w "${feature}"; then
> > +			status="YES"
> > +			found=$((found + 1))
> > +		fi
> > +		output+=("${feature}:${status}")
> > +	done
> > +
> > +	echo "${output[@]}"
> > +	test "${found}" -eq "$#"
> > +}
> > diff --git a/tests/xfs/768 b/tests/xfs/768
> > new file mode 100755
> > index 00000000..e6301829
> > --- /dev/null
> > +++ b/tests/xfs/768
> > @@ -0,0 +1,80 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 768
> > +#
> > +# Make sure that the kernel won't mount a filesystem if repair forcibly sets
> > +# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
> > +# to force repair to write an invalid dirent value as a sentinel to trigger a
> > +# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
> > +# the repair immediately after forcing the flag on.
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
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch_nocheck
> > +_require_scratch_xfs_crc		# needsrepair only exists for v5
> > +_require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
> > +
> > +rm -f $seqres.full
> > +
> > +# Set up a real filesystem for our actual test
> > +_scratch_mkfs -m crc=1 >> $seqres.full
> 
> I don't think there's a need to explicitly format with -mcrc=1 when the
> require above would filter out the test anyways (which I think is fine
> since v5 has been default for some time now). Otherwise this test LGTM.

<nod> Fixed.

> > +
> > +# Create a directory large enough to have a dir data block.  2k worth of
> > +# dirent names ought to do it.
> > +_scratch_mount
> > +mkdir -p $SCRATCH_MNT/fubar
> > +for i in $(seq 0 256 2048); do
> > +	fname=$(printf "%0255d" $i)
> > +	ln -s -f urk $SCRATCH_MNT/fubar/$fname
> > +done
> > +inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
> > +_scratch_unmount
> > +
> > +# Fuzz the directory
> > +_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
> > +	-c "fuzz -d bu[2].inumber add" >> $seqres.full
> > +
> > +# Try to repair the directory, force it to crash after setting needsrepair
> > +LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
> > +test $? -eq 137 || echo "repair should have been killed??"
> > +
> > +# We can't mount, right?
> > +_check_scratch_xfs_features NEEDSREPAIR
> > +_try_scratch_mount &> $tmp.mount
> > +res=$?
> > +_filter_scratch < $tmp.mount
> > +if [ $res -eq 0 ]; then
> > +	echo "Should not be able to mount after needsrepair crash"
> > +	_scratch_unmount
> > +fi
> > +
> > +# Repair properly this time and retry the mount
> > +_scratch_xfs_repair 2>> $seqres.full
> > +_check_scratch_xfs_features NEEDSREPAIR
> > +
> > +_scratch_mount
> > +
> > +# success, all done
> > +status=0
> > +exit
> ...
> > diff --git a/tests/xfs/770 b/tests/xfs/770
> > new file mode 100755
> > index 00000000..40e67ab5
> > --- /dev/null
> > +++ b/tests/xfs/770
> > @@ -0,0 +1,83 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 770
> > +#
> > +# Populate a filesystem with all types of metadata, then run repair with the
> > +# libxfs write failure trigger set to go after a single write.  Check that the
> > +# injected error trips, causing repair to abort, that needsrepair is set on the
> > +# fs, the kernel won't mount; and that a non-injecting repair run clears
> > +# needsrepair and makes the filesystem mountable again.
> > +#
> > +# Repeat with the trip point set to successively higher numbers of writes until
> > +# we hit ~200 writes or repair manages to run to completion without tripping.
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
> > +. ./common/populate
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs xfs
> > +_require_scratch_nocheck
> > +_require_scratch_xfs_crc		# needsrepair only exists for v5
> > +_require_populate_commands
> > +_require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
> > +
> > +rm -f $seqres.full
> > +
> > +# Populate the filesystem
> > +_scratch_populate_cached nofill >> $seqres.full 2>&1
> > +
> > +max_writes=200			# 200 loops should be enough for anyone
> > +nr_incr=$((13 / TIME_FACTOR))
> 
> Could we randomize this increment so we get varying behavior run to run?
> It might be nice to actually do that on a per-iteration basis as well
> rather than once at the start of the test.

Ok, I'll add a little bit of randomness to each run.

How about:

	local crash_after=$(( nr_writes + ((RANDOM % 7) - 3) ))
	LIBXFS_DEBUG_WRITE_CRASH=ddev=$crash_after _scratch_xfs_repair

?

> > +test $nr_incr -lt 1 && nr_incr=1
> > +for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
> > +	# Start a repair and force it to abort after some number of writes
> > +	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes \
> > +			_scratch_xfs_repair 2>> $seqres.full
> > +	res=$?
> > +	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
> > +		echo "repair failed with $res??"
> > +		break
> > +	elif [ $res -eq 0 ]; then
> > +		[ $nr_writes -eq 1 ] && \
> > +			echo "ran to completion on the first try?"
> > +		break
> > +	fi
> > +
> > +	# Check the state of NEEDSREPAIR after repair fails.  If it isn't set
> > +	# but if repair -n says the fs is clean, then it's possible that the
> > +	# injected error caused it to abort immediately after the write that
> > +	# cleared NEEDSREPAIR.
> > +	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
> > +	   ! _scratch_xfs_repair -n &>> $seqres.full; then
> > +		echo "NEEDSREPAIR should be set on corrupt fs"
> > +	fi
> > +
> > +	# Repair properly this time and retry the mount
> 
> We can probably drop the "retry the mount" bit since we no longer do
> that.

Oops, yes, good catch.

> > +	_scratch_xfs_repair 2>> $seqres.full
> > +	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> > +		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> 
> Maybe I'm mistaken, but I thought we were going to let repair run and
> fail repeatedly/incrementally and then leave the full repair for the
> end..?

Ah.  Last time you wrote:

"It probably makes sense to test that NEEDSREPAIR remains set throughout
the test sequence until repair completes cleanly..."

and I interpreted "throughout the test sequence" to mean "until the
end of the loop body", not the whole test.

But I guess it /would/ be more interesting to study the effects of
multiple successive write failures. ;)

--D

> 
> Brian
> 
> > +done
> > +
> > +# success, all done
> > +echo Silence is golden.
> > +status=0
> > +exit
> > diff --git a/tests/xfs/770.out b/tests/xfs/770.out
> > new file mode 100644
> > index 00000000..725d740b
> > --- /dev/null
> > +++ b/tests/xfs/770.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 770
> > +Silence is golden.
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index d1b1456b..461ae2b2 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -522,3 +522,5 @@
> >  537 auto quick
> >  538 auto stress
> >  539 auto quick mount
> > +768 auto quick repair
> > +770 auto repair
> > 
> 
