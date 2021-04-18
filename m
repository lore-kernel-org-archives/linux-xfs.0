Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2055C433B4
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 12:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF7F461359
	for <linux-xfs@archiver.kernel.org>; Sun, 18 Apr 2021 12:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhDRMP3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 18 Apr 2021 08:15:29 -0400
Received: from out20-111.mail.aliyun.com ([115.124.20.111]:37749 "EHLO
        out20-111.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhDRMP2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 08:15:28 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436294|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0351643-0.000727791-0.964108;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.K.pjIWp_1618748098;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.K.pjIWp_1618748098)
          by smtp.aliyun-inc.com(10.147.42.241);
          Sun, 18 Apr 2021 20:14:58 +0800
Date:   Sun, 18 Apr 2021 20:14:58 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test that the needsrepair feature works as
 advertised
Message-ID: <YHwiwogWS26/NR/K@desktop>
References: <161836233058.2755262.72157999681408577.stgit@magnolia>
 <161836233652.2755262.563331015931843615.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836233652.2755262.563331015931843615.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:05:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that the needsrepair feature flag can be cleared only by
> repair and that mounts are prohibited when the feature is set.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/xfs        |   21 ++++++++++++++
>  tests/xfs/768     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/768.out |    4 +++
>  tests/xfs/770     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/770.out |    2 +
>  tests/xfs/group   |    2 +
>  6 files changed, 191 insertions(+)
>  create mode 100755 tests/xfs/768
>  create mode 100644 tests/xfs/768.out
>  create mode 100755 tests/xfs/770
>  create mode 100644 tests/xfs/770.out
> 
> 
> diff --git a/common/xfs b/common/xfs
> index 887bd001..fa204663 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1114,3 +1114,24 @@ _xfs_get_cowgc_interval() {
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
> index 00000000..dd9c53be
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
> +_require_scratch
> +grep -q LIBXFS_DEBUG_WRITE_CRASH $XFS_REPAIR_PROG || \
> +		_notrun "libxfs write failure injection hook not detected?"

Sorry that I didn't notice it earlier, but this pattern repeats in both
tests, might be possible to turn it into a common helper?

And $XFS_REPAIR_PROG may contain some pre-defined options along with
xfs_repair in the future, like $DF_PROG is actually defined as
"df -T -P". Perhaps $(type -P xfs_repair) is better here.

> +
> +rm -f $seqres.full
> +
> +# Set up a real filesystem for our actual test
> +_scratch_mkfs -m crc=1 >> $seqres.full

Test relies on -m crc=1, so probably we need _require_xfs_crc as well to
make sure userspace and kernel supports crc.

Or just like xfs/770, use _require_scratch_xfs_crc instead of
_require_scratch?

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
> index 00000000..574047d5
> --- /dev/null
> +++ b/tests/xfs/770
> @@ -0,0 +1,82 @@
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
> +
> +_require_scratch_xfs_crc		# needsrepair only exists for v5
> +_require_populate_commands
> +
> +rm -f ${RESULT_DIR}/require_scratch	# we take care of checking the fs

Use _require_scratch_nocheck instead?

Thanks,
Eryu

> +rm -f $seqres.full
> +
> +# Populate the filesystem
> +_scratch_populate_cached nofill >> $seqres.full 2>&1
> +
> +max_writes=200			# 200 loops should be enough for anyone
> +nr_incr=$((13 / TIME_FACTOR))
> +test $nr_incr -lt 1 && nr_incr=1
> +for ((nr_writes = 1; nr_writes < max_writes; nr_writes += nr_incr)); do
> +	# Start a repair and force it to abort after some number of writes
> +	LIBXFS_DEBUG_WRITE_CRASH=ddev=$nr_writes _scratch_xfs_repair 2>> $seqres.full
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
> +	# but if repair -n says the fs is clean, then it's possible that the
> +	# injected error caused it to abort immediately after the write that
> +	# cleared NEEDSREPAIR.
> +	if ! _check_scratch_xfs_features NEEDSREPAIR > /dev/null &&
> +	   ! _scratch_xfs_repair -n &>> $seqres.full; then
> +		echo "NEEDSREPAIR should be set on corrupt fs"
> +	fi
> +
> +	# Repair properly this time and retry the mount
> +	_scratch_xfs_repair 2>> $seqres.full
> +	_check_scratch_xfs_features NEEDSREPAIR > /dev/null && \
> +		echo "Repair failed to clear NEEDSREPAIR on the $nr_writes writes test"
> +done
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
> index fe83f82d..09fddb5a 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -520,3 +520,5 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +768 auto quick repair
> +770 auto repair
