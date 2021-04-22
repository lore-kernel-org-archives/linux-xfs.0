Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE01DC433B4
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 11:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CBEE6144A
	for <linux-xfs@archiver.kernel.org>; Thu, 22 Apr 2021 11:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhDVL0p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Apr 2021 07:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50478 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236008AbhDVL0o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Apr 2021 07:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619090769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mURK1cc27W9ZfncCePodYY3X9TlkWe8zEFaCTyeyjds=;
        b=Li21gANL1scp6Ou18s0qUoP3aH5Y17FD+yx13M6gBagGicmmPMAfqk7WtCdEeXGn0f2a73
        oE+AEPWjBYqhCNh8oTUYg99f5kUwifA06kGEX+eLedQnCtPxx2OwE0LKrW13VRJy4R9nFU
        Co23R0AUS8XQ9cxTI1fiFGrZpCFogNI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-EVUUfF3cMhGo069QpvV8Ug-1; Thu, 22 Apr 2021 07:26:07 -0400
X-MC-Unique: EVUUfF3cMhGo069QpvV8Ug-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D12EF107ACC7;
        Thu, 22 Apr 2021 11:26:06 +0000 (UTC)
Received: from bfoster (ovpn-112-25.rdu2.redhat.com [10.10.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F208B627DC;
        Thu, 22 Apr 2021 11:26:05 +0000 (UTC)
Date:   Thu, 22 Apr 2021 07:26:04 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH v5.1 1/1] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <YIFdTLvp7x5xctbW@bfoster>
References: <161896455503.776294.3492113564046201298.stgit@magnolia>
 <161896456107.776294.13840945585349427098.stgit@magnolia>
 <20210422004913.GG3122235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422004913.GG3122235@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 21, 2021 at 05:49:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that the needsrepair feature flag can be cleared only by
> repair and that mounts are prohibited when the feature is set.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v5.1: add a little randomness to x/770, fix the hook check function
> ---

Looks good, thanks for the tweaks:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  common/xfs        |   29 +++++++++++++++++
>  tests/xfs/768     |   80 +++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/768.out |    4 ++
>  tests/xfs/770     |   91 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/770.out |    2 +
>  tests/xfs/group   |    2 +
>  6 files changed, 208 insertions(+)
>  create mode 100755 tests/xfs/768
>  create mode 100644 tests/xfs/768.out
>  create mode 100755 tests/xfs/770
>  create mode 100644 tests/xfs/770.out
> 
> diff --git a/common/xfs b/common/xfs
> index 2e78fd4f..ba6523ad 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -312,6 +312,14 @@ _scratch_xfs_check()
>  	_xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
>  }
>  
> +# Check for secret debugging hooks in xfs_repair
> +_require_libxfs_debug_flag() {
> +	local hook="$1"
> +
> +	grep -q "$hook" "$(type -P xfs_repair)" || \
> +		_notrun "libxfs debug hook $hook not detected?"
> +}
> +
>  _scratch_xfs_repair()
>  {
>  	SCRATCH_OPTIONS=""
> @@ -1099,3 +1107,24 @@ _xfs_get_cowgc_interval() {
>  		_fail "Can't find cowgc interval procfs knob?"
>  	fi
>  }
> +
> +# Print the status of the given features on the scratch filesystem.
> +# Returns 0 if all features are found, 1 otherwise.
> +_check_scratch_xfs_features()
> +{
> +	local features="$(_scratch_xfs_db -c 'version')"
> +	local output=("FEATURES:")
> +	local found=0
> +
> +	for feature in "$@"; do
> +		local status="NO"
> +		if echo "${features}" | grep -q -w "${feature}"; then
> +			status="YES"
> +			found=$((found + 1))
> +		fi
> +		output+=("${feature}:${status}")
> +	done
> +
> +	echo "${output[@]}"
> +	test "${found}" -eq "$#"
> +}
> diff --git a/tests/xfs/768 b/tests/xfs/768
> new file mode 100755
> index 00000000..84c54a6e
> --- /dev/null
> +++ b/tests/xfs/768
> @@ -0,0 +1,80 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 768
> +#
> +# Make sure that the kernel won't mount a filesystem if repair forcibly sets
> +# NEEDSREPAIR while fixing metadata.  Corrupt a directory in such a way as
> +# to force repair to write an invalid dirent value as a sentinel to trigger a
> +# repair activity in a later phase.  Use a debug knob in xfs_repair to abort
> +# the repair immediately after forcing the flag on.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_nocheck
> +_require_scratch_xfs_crc		# needsrepair only exists for v5
> +_require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
> +
> +rm -f $seqres.full
> +
> +# Set up a real filesystem for our actual test
> +_scratch_mkfs >> $seqres.full
> +
> +# Create a directory large enough to have a dir data block.  2k worth of
> +# dirent names ought to do it.
> +_scratch_mount
> +mkdir -p $SCRATCH_MNT/fubar
> +for i in $(seq 0 256 2048); do
> +	fname=$(printf "%0255d" $i)
> +	ln -s -f urk $SCRATCH_MNT/fubar/$fname
> +done
> +inum=$(stat -c '%i' $SCRATCH_MNT/fubar)
> +_scratch_unmount
> +
> +# Fuzz the directory
> +_scratch_xfs_db -x -c "inode $inum" -c "dblock 0" \
> +	-c "fuzz -d bu[2].inumber add" >> $seqres.full
> +
> +# Try to repair the directory, force it to crash after setting needsrepair
> +LIBXFS_DEBUG_WRITE_CRASH=ddev=2 _scratch_xfs_repair 2>> $seqres.full
> +test $? -eq 137 || echo "repair should have been killed??"
> +
> +# We can't mount, right?
> +_check_scratch_xfs_features NEEDSREPAIR
> +_try_scratch_mount &> $tmp.mount
> +res=$?
> +_filter_scratch < $tmp.mount
> +if [ $res -eq 0 ]; then
> +	echo "Should not be able to mount after needsrepair crash"
> +	_scratch_unmount
> +fi
> +
> +# Repair properly this time and retry the mount
> +_scratch_xfs_repair 2>> $seqres.full
> +_check_scratch_xfs_features NEEDSREPAIR
> +
> +_scratch_mount
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/768.out b/tests/xfs/768.out
> new file mode 100644
> index 00000000..1168ba25
> --- /dev/null
> +++ b/tests/xfs/768.out
> @@ -0,0 +1,4 @@
> +QA output created by 768
> +FEATURES: NEEDSREPAIR:YES
> +mount: SCRATCH_MNT: mount(2) system call failed: Structure needs cleaning.
> +FEATURES: NEEDSREPAIR:NO
> diff --git a/tests/xfs/770 b/tests/xfs/770
> new file mode 100755
> index 00000000..5265eaca
> --- /dev/null
> +++ b/tests/xfs/770
> @@ -0,0 +1,91 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 770
> +#
> +# Populate a filesystem with all types of metadata, then run repair with the
> +# libxfs write failure trigger set to go after a single write.  Check that the
> +# injected error trips, causing repair to abort, that needsrepair is set on the
> +# fs, the kernel won't mount; and that a non-injecting repair run clears
> +# needsrepair and makes the filesystem mountable again.
> +#
> +# Repeat with the trip point set to successively higher numbers of writes until
> +# we hit ~200 writes or repair manages to run to completion without tripping.
> +
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/populate
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_nocheck
> +_require_scratch_xfs_crc		# needsrepair only exists for v5
> +_require_populate_commands
> +_require_libxfs_debug_flag LIBXFS_DEBUG_WRITE_CRASH
> +
> +rm -f $seqres.full
> +
> +# Populate the filesystem
> +_scratch_populate_cached nofill >> $seqres.full 2>&1
> +
> +max_writes=200			# 200 loops should be enough for anyone
> +nr_incr=$((13 / TIME_FACTOR))
> +test $nr_incr -lt 1 && nr_incr=1
> +for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
> +	# Add a tiny bit of randomness into each run
> +	allowed_writes=$(( nr_writes + (RANDOM % 7) ))
> +	echo "Setting debug hook to crash after $allowed_writes writes." >> $seqres.full
> +
> +	# Start a repair and force it to abort after some number of writes
> +	LIBXFS_DEBUG_WRITE_CRASH=ddev=$allowed_writes \
> +			_scratch_xfs_repair 2>> $seqres.full
> +	res=$?
> +	if [ $res -ne 0 ] && [ $res -ne 137 ]; then
> +		echo "repair failed with $res??"
> +		break
> +	elif [ $res -eq 0 ]; then
> +		[ $nr_writes -eq 1 ] && \
> +			echo "ran to completion on the first try?"
> +		break
> +	fi
> +
> +	# Check the state of NEEDSREPAIR after repair fails.  If it isn't set
> +	# but repair -n says the fs is clean, then it's possible that the
> +	# injected error caused it to abort immediately after the write that
> +	# cleared NEEDSREPAIR.
> +	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
> +	   ! _scratch_xfs_repair -n &>> $seqres.full; then
> +		echo "NEEDSREPAIR should be set on corrupt fs"
> +	fi
> +done
> +
> +# If NEEDSREPAIR is still set on the filesystem, ensure that a full run
> +# cleans everything up.
> +if _check_scratch_xfs_features NEEDSREPAIR > /dev/null; then
> +	echo "Clearing NEEDSREPAIR" >> $seqres.full
> +	_scratch_xfs_repair 2>> $seqres.full
> +	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> +		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> +fi
> +
> +# success, all done
> +echo Silence is golden.
> +status=0
> +exit
> diff --git a/tests/xfs/770.out b/tests/xfs/770.out
> new file mode 100644
> index 00000000..725d740b
> --- /dev/null
> +++ b/tests/xfs/770.out
> @@ -0,0 +1,2 @@
> +QA output created by 770
> +Silence is golden.
> diff --git a/tests/xfs/group b/tests/xfs/group
> index d1b1456b..461ae2b2 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -522,3 +522,5 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +768 auto quick repair
> +770 auto repair
> 

