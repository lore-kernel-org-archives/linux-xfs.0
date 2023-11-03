Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0029DC4167D
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Nov 2023 06:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjKCGeq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Nov 2023 02:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbjKCGeq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2023 02:34:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28D21B9
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 23:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698993231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IvU6OH/TQC7py4qvwbKli1VTxJe4KBNXBpUDVPev+kk=;
        b=b8K6rEa2++73At/8tnrZ7UFkyu0a5f83ekv+Zu+syNiB/SvvOk8gOL/aFIswkFAOlJbOdL
        qJl4b7lUZpJo3x9/iws0X6dw3Gkqf9mxJTXYap++fX1WROu1dwipFApTy32MLUzN9dRoQQ
        2JdJx4GM1xuDJWcuBvpWk+2V1Qe2+yU=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-277-gf2X0vTXP82wk6ntEjr6_Q-1; Fri, 03 Nov 2023 02:33:50 -0400
X-MC-Unique: gf2X0vTXP82wk6ntEjr6_Q-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3b5665e00b6so2535362b6e.2
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2023 23:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698993229; x=1699598029;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvU6OH/TQC7py4qvwbKli1VTxJe4KBNXBpUDVPev+kk=;
        b=A0G3CvjktuUUsO5kgfgCtf8KxM06LlOy29Bzrsl1+lhB0exE2lppHLcRxmFu6c9iT1
         4h1XJHLgHaGaG9rKrdDanSOdD9emOrb8I/X5zBll+TN2q+wvon8rpg4xe/WrJrdGTumn
         EHbhVw8NrxKnAihpBbpUZpJarriYxq501WnZxh6bl4QRtcRvkaNegn8Jxd3ecDu/zDOW
         nH9Z6hsfircS6GYH09bK/t+1EItDfVQ296NGXjB5K8RZNPMncWLMQpB2zV1uwarBuMZW
         56ZUx8uWoDXZCLqXEyt2CM6T2x21gdMdFvZxjynSF3Tc6ksW5qJSoz/kUNeQq1BLijLM
         IELQ==
X-Gm-Message-State: AOJu0Ywb+WUYfXvsGTl650ff9VX5HDQAu9YqlEit2yqoFIeFZGMH0t0u
        MKvFqTGuX3wolSlJGnXOwG4i3UMv7f/DkHY8ur2A2yMvizDGvuJu2yJ3PMULkf6hC6G5+hy4Fzo
        eZRPCDWJxhY2VMLyYNGjA
X-Received: by 2002:a05:6808:200f:b0:3b5:6a28:fcdd with SMTP id q15-20020a056808200f00b003b56a28fcddmr11049952oiw.18.1698993229643;
        Thu, 02 Nov 2023 23:33:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHP2kvzq0Qow6faNuTLYp9EE5n4/oVuZ41O/HZqL5GsbPyqCYdikp8XIv0N6QxgMXmmgdMEGQ==
X-Received: by 2002:a05:6808:200f:b0:3b5:6a28:fcdd with SMTP id q15-20020a056808200f00b003b56a28fcddmr11049939oiw.18.1698993229285;
        Thu, 02 Nov 2023 23:33:49 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d19-20020aa78693000000b006be2f4105d0sm742630pfo.175.2023.11.02.23.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 23:33:48 -0700 (PDT)
Date:   Fri, 3 Nov 2023 14:33:45 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test unlinked inode list repair on demand
Message-ID: <20231103063345.lofqi3ce4kdortgq@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169687552892.3949084.287369396167434290.stgit@frogsfrogsfrogs>
 <169687553453.3949084.14532709239423528329.stgit@frogsfrogsfrogs>
 <20231101172054.GD1205143@frogsfrogsfrogs>
 <20231102201231.xhjhzeah7lb7vm45@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20231102221818.GC1758611@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102221818.GC1758611@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 03:18:18PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 03, 2023 at 04:12:31AM +0800, Zorro Lang wrote:
> > On Wed, Nov 01, 2023 at 10:20:54AM -0700, Darrick J. Wong wrote:
> > > On Mon, Oct 09, 2023 at 11:18:54AM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Create a test to exercise recovery of unlinked inodes on a clean
> > > > filesystem.  This was definitely possible on old kernels that on an ro
> > > > mount would clean the log without processing the iunlink list.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Ping?  The kernel fixes and the xfs_db commands have both been merged
> > > upstream, could we please merge this functional test of the new unlinked
> > > inode cleanup code in the kernel XFS driver?
> > 
> > Sure Darrick. I'll try to merge it in next fstests release.
> > 
> > The x/1872 missed the _kernlog(), I think it's a Darrick specific common
> > helper :)
> 
> D'oh!  Yeah, that's part of ... oh, I guess I never sent /that/ series.
> The actual commit is here:
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/commit/?h=djwong-wtf&id=ca8940e822d83574772f6c953dcadb8c12b9b2b1
> 
> > The x/1873 need the xfs_io repair -R, I'm using the lastest xfsprogs
> > for-next branch. Where can I get the -R support ?
> 
> D'oh!  repair -R is in the series that Carlos said he'd pick up for
> xfsprogs 6.6:
> https://lore.kernel.org/linux-xfs/20231003113334.zi7p7c77pqvesmfb@andromeda/
> 
> Ok, I'll put this one back to sleep until xfsprogs catches up.  Or
> maybe next week.

I'm planning to have next fstests release next weekend. So if you hope, we can
catch that :)

> 
> (FWIW I pushed djwong-wtf of all three branches last night.)
> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > 
> > > --D
> > > 
> > > > ---
> > > >  common/rc          |    4 +
> > > >  tests/xfs/1872     |  113 +++++++++++++++++++++++++++
> > > >  tests/xfs/1872.out |    5 +
> > > >  tests/xfs/1873     |  217 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/1873.out |    6 +
> > > >  5 files changed, 344 insertions(+), 1 deletion(-)
> > > >  create mode 100755 tests/xfs/1872
> > > >  create mode 100644 tests/xfs/1872.out
> > > >  create mode 100755 tests/xfs/1873
> > > >  create mode 100644 tests/xfs/1873.out
> > > > 
> > > > 
> > > > diff --git a/common/rc b/common/rc
> > > > index 259a1ffb09..20d3e61c4e 100644
> > > > --- a/common/rc
> > > > +++ b/common/rc
> > > > @@ -2668,9 +2668,11 @@ _require_xfs_io_command()
> > > >  		param_checked="$pwrite_opts $param"
> > > >  		;;
> > > >  	"scrub"|"repair")
> > > > -		testio=`$XFS_IO_PROG -x -c "$command probe" $TEST_DIR 2>&1`
> > > > +		test -z "$param" && param="probe"
> > > > +		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`
> > > >  		echo $testio | grep -q "Inappropriate ioctl" && \
> > > >  			_notrun "xfs_io $command support is missing"
> > > > +		param_checked="$param"
> > > >  		;;
> > > >  	"startupdate"|"commitupdate"|"cancelupdate")
> > > >  		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
> > > > diff --git a/tests/xfs/1872 b/tests/xfs/1872
> > > > new file mode 100755
> > > > index 0000000000..3720a3d184
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1872
> > > > @@ -0,0 +1,113 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 1872
> > > > +#
> > > > +# Test using runtime code to fix unlinked inodes on a clean filesystem that
> > > > +# never got cleaned up.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto quick unlink
> > > > +
> > > > +# Import common functions.
> > > > +source ./common/filter
> > > > +source ./common/fuzzy
> > > > +source ./common/quota
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs generic
> > > > +_require_xfs_db_command iunlink
> > > > +_require_scratch_nocheck	# we'll run repair ourselves
> > > > +
> > > > +# From the AGI definition
> > > > +XFS_AGI_UNLINKED_BUCKETS=64
> > > > +
> > > > +# Try to make each iunlink bucket have this many inodes in it.
> > > > +IUNLINK_BUCKETLEN=5
> > > > +
> > > > +# XXX Forcibly disable quota since quotacheck will break this test
> > > > +orig_mount_options="$MOUNT_OPTIONS"
> > > > +_qmount_option 'noquota'
> > > > +
> > > > +format_scratch() {
> > > > +	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
> > > > +	source "${tmp}.mkfs"
> > > > +	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
> > > > +
> > > > +	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
> > > > +	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
> > > > +}
> > > > +
> > > > +__repair_check_scratch() {
> > > > +	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
> > > > +		tee -a $seqres.full | \
> > > > +		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
> > > > +	return "${PIPESTATUS[0]}"
> > > > +}
> > > > +
> > > > +exercise_scratch() {
> > > > +	# Create a bunch of files...
> > > > +	declare -A inums
> > > > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > > > +		touch "${SCRATCH_MNT}/${i}" || break
> > > > +		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
> > > > +	done
> > > > +
> > > > +	# ...then delete them to exercise the unlinked buckets
> > > > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > > > +		if ! rm -f "${SCRATCH_MNT}/${i}"; then
> > > > +			echo "rm failed on inum ${inums[$i]}"
> > > > +			break
> > > > +		fi
> > > > +	done
> > > > +}
> > > > +
> > > > +# Offline repair should not find anything
> > > > +final_check_scratch() {
> > > > +	__repair_check_scratch
> > > > +	res=$?
> > > > +	if [ $res -eq 2 ]; then
> > > > +		echo "scratch fs went offline?"
> > > > +		_scratch_mount
> > > > +		_scratch_unmount
> > > > +		__repair_check_scratch
> > > > +	fi
> > > > +	test "$res" -ne 0 && echo "repair returned $res?"
> > > > +}
> > > > +
> > > > +echo "+ Part 0: See if runtime can recover the unlinked list" | tee -a $seqres.full
> > > > +format_scratch
> > > > +_kernlog "part 0"
> > > > +_scratch_mount
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +echo "+ Part 1: See if bulkstat can recover the unlinked list" | tee -a $seqres.full
> > > > +format_scratch
> > > > +_kernlog "part 1"
> > > > +_scratch_mount
> > > > +$XFS_IO_PROG -c 'bulkstat' $SCRATCH_MNT > /dev/null
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +echo "+ Part 2: See if quotacheck can recover the unlinked list" | tee -a $seqres.full
> > > > +if [ -f /proc/fs/xfs/xqmstat ]; then
> > > > +	MOUNT_OPTIONS="$orig_mount_options"
> > > > +	_qmount_option 'quota'
> > > > +	format_scratch
> > > > +	_kernlog "part 2"
> > > > +	_scratch_mount
> > > > +	exercise_scratch
> > > > +	_scratch_unmount
> > > > +	final_check_scratch
> > > > +fi
> > > > +
> > > > +# success, all done
> > > > +echo Silence is golden
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1872.out b/tests/xfs/1872.out
> > > > new file mode 100644
> > > > index 0000000000..248f0e2416
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1872.out
> > > > @@ -0,0 +1,5 @@
> > > > +QA output created by 1872
> > > > ++ Part 0: See if runtime can recover the unlinked list
> > > > ++ Part 1: See if bulkstat can recover the unlinked list
> > > > ++ Part 2: See if quotacheck can recover the unlinked list
> > > > +Silence is golden
> > > > diff --git a/tests/xfs/1873 b/tests/xfs/1873
> > > > new file mode 100755
> > > > index 0000000000..4712dee7ab
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1873
> > > > @@ -0,0 +1,217 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 1873
> > > > +#
> > > > +# Functional test of using online repair to fix unlinked inodes on a clean
> > > > +# filesystem that never got cleaned up.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto online_repair
> > > > +
> > > > +# Import common functions.
> > > > +source ./common/filter
> > > > +source ./common/fuzzy
> > > > +source ./common/quota
> > > > +
> > > > +# real QA test starts here
> > > > +
> > > > +# Modify as appropriate.
> > > > +_supported_fs generic
> > > > +_require_xfs_db_command iunlink
> > > > +# The iunlink bucket repair code wasn't added to the AGI repair code
> > > > +# until after the directory repair code was merged
> > > > +_require_xfs_io_command repair -R directory
> > > > +_require_scratch_nocheck	# repair doesn't like single-AG fs
> > > > +
> > > > +# From the AGI definition
> > > > +XFS_AGI_UNLINKED_BUCKETS=64
> > > > +
> > > > +# Try to make each iunlink bucket have this many inodes in it.
> > > > +IUNLINK_BUCKETLEN=5
> > > > +
> > > > +# XXX Forcibly disable quota since quotacheck will break this test
> > > > +_qmount_option 'noquota'
> > > > +
> > > > +format_scratch() {
> > > > +	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
> > > > +	source "${tmp}.mkfs"
> > > > +	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
> > > > +
> > > > +	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
> > > > +	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
> > > > +}
> > > > +
> > > > +__repair_check_scratch() {
> > > > +	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
> > > > +		tee -a $seqres.full | \
> > > > +		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
> > > > +	return "${PIPESTATUS[0]}"
> > > > +}
> > > > +
> > > > +corrupt_scratch() {
> > > > +	# How far into the iunlink bucket chain do we target inodes for corruption?
> > > > +	# 1 = target the inode pointed to by the AGI
> > > > +	# 3 = middle of bucket list
> > > > +	# 5 = last element in bucket
> > > > +	local corruption_bucket_depth="$1"
> > > > +	if ((corruption_bucket_depth < 1 || corruption_bucket_depth > IUNLINK_BUCKETLEN)); then
> > > > +		echo "${corruption_bucket_depth}: Value must be between 1 and ${IUNLINK_BUCKETLEN}."
> > > > +		return 1
> > > > +	fi
> > > > +
> > > > +	# Index of the inode numbers within BADINODES
> > > > +	local bad_ino1_idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth) * XFS_AGI_UNLINKED_BUCKETS))
> > > > +	local bad_ino2_idx=$((bad_ino1_idx + 1))
> > > > +
> > > > +	# Inode numbers to target
> > > > +	local bad_ino1="${BADINODES[bad_ino1_idx]}"
> > > > +	local bad_ino2="${BADINODES[bad_ino2_idx]}"
> > > > +	printf "bad: 0x%x 0x%x\n" "${bad_ino1}" "${bad_ino2}" | _tee_kernlog >> $seqres.full
> > > > +
> > > > +	# Bucket within AGI 0's iunlinked array.
> > > > +	local ino1_bucket="$((bad_ino1 % XFS_AGI_UNLINKED_BUCKETS))"
> > > > +	local ino2_bucket="$((bad_ino2 % XFS_AGI_UNLINKED_BUCKETS))"
> > > > +
> > > > +	# The first bad inode stays on the unlinked list but gets a nonzero
> > > > +	# nlink; the second bad inode is removed from the unlinked list but
> > > > +	# keeps its zero nlink
> > > > +	_scratch_xfs_db -x \
> > > > +		-c "inode ${bad_ino1}" -c "write -d core.nlinkv2 5555" \
> > > > +		-c "agi 0" -c "fuzz -d unlinked[${ino2_bucket}] ones" -c "print unlinked" >> $seqres.full
> > > > +
> > > > +	local iwatch=()
> > > > +	local idx
> > > > +
> > > > +	# Make a list of the adjacent iunlink bucket inodes for the first inode
> > > > +	# that we targeted.
> > > > +	if [ "${corruption_bucket_depth}" -gt 1 ]; then
> > > > +		# Previous ino in bucket
> > > > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
> > > > +		iwatch+=("${BADINODES[idx]}")
> > > > +	fi
> > > > +	iwatch+=("${bad_ino1}")
> > > > +	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
> > > > +		# Next ino in bucket
> > > > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
> > > > +		iwatch+=("${BADINODES[idx]}")
> > > > +	fi
> > > > +
> > > > +	# Make a list of the adjacent iunlink bucket inodes for the second
> > > > +	# inode that we targeted.
> > > > +	if [ "${corruption_bucket_depth}" -gt 1 ]; then
> > > > +		# Previous ino in bucket
> > > > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
> > > > +		iwatch+=("${BADINODES[idx + 1]}")
> > > > +	fi
> > > > +	iwatch+=("${bad_ino2}")
> > > > +	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
> > > > +		# Next ino in bucket
> > > > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
> > > > +		iwatch+=("${BADINODES[idx + 1]}")
> > > > +	fi
> > > > +
> > > > +	# Construct a grep string for tracepoints.
> > > > +	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} |bucket ${fuzz_bucket} "
> > > > +	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} "
> > > > +	for ino in "${iwatch[@]}"; do
> > > > +		f="$(printf "|ino 0x%x" "${ino}")"
> > > > +		GREP_STR="${GREP_STR}${f}"
> > > > +	done
> > > > +	GREP_STR="${GREP_STR})"
> > > > +	echo "grep -E \"${GREP_STR}\"" >> $seqres.full
> > > > +
> > > > +	# Dump everything we did to to the full file.
> > > > +	local db_dump=(-c 'agi 0' -c 'print unlinked')
> > > > +	db_dump+=(-c 'addr root' -c 'print')
> > > > +	test "${ino1_bucket}" -gt 0 && \
> > > > +		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino1_bucket - 1))")
> > > > +	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino1_bucket}")
> > > > +	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino2_bucket}")
> > > > +	test "${ino2_bucket}" -lt 63 && \
> > > > +		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino2_bucket + 1))")
> > > > +	db_dump+=(-c "inode $bad_ino1" -c 'print core.nlinkv2 v3.inumber next_unlinked')
> > > > +	db_dump+=(-c "inode $bad_ino2" -c 'print core.nlinkv2 v3.inumber next_unlinked')
> > > > +	_scratch_xfs_db "${db_dump[@]}" >> $seqres.full
> > > > +
> > > > +	# Test run of repair to make sure we find disconnected inodes
> > > > +	__repair_check_scratch | \
> > > > +		sed -e 's/disconnected inode \([0-9]*\)/disconnected inode XXXXXX/g' \
> > > > +		    -e 's/next_unlinked in inode \([0-9]*\)/next_unlinked in inode XXXXXX/g' \
> > > > +		    -e 's/unlinked bucket \([0-9]*\) is \([0-9]*\) in ag \([0-9]*\) .inode=\([0-9]*\)/unlinked bucket YY is XXXXXX in ag Z (inode=AAAAAA/g' | \
> > > > +		uniq -c >> $seqres.full
> > > > +	res=${PIPESTATUS[0]}
> > > > +	test "$res" -ne 0 || echo "repair returned $res after corruption?"
> > > > +}
> > > > +
> > > > +exercise_scratch() {
> > > > +	# Create a bunch of files...
> > > > +	declare -A inums
> > > > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > > > +		touch "${SCRATCH_MNT}/${i}" || break
> > > > +		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
> > > > +	done
> > > > +
> > > > +	# ...then delete them to exercise the unlinked buckets
> > > > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > > > +		if ! rm -f "${SCRATCH_MNT}/${i}"; then
> > > > +			echo "rm failed on inum ${inums[$i]}"
> > > > +			break
> > > > +		fi
> > > > +	done
> > > > +}
> > > > +
> > > > +# Offline repair should not find anything
> > > > +final_check_scratch() {
> > > > +	__repair_check_scratch
> > > > +	res=$?
> > > > +	if [ $res -eq 2 ]; then
> > > > +		echo "scratch fs went offline?"
> > > > +		_scratch_mount
> > > > +		_scratch_unmount
> > > > +		__repair_check_scratch
> > > > +	fi
> > > > +	test "$res" -ne 0 && echo "repair returned $res?"
> > > > +}
> > > > +
> > > > +echo "+ Part 1: See if scrub can recover the unlinked list" | tee -a $seqres.full
> > > > +format_scratch
> > > > +_kernlog "no bad inodes"
> > > > +_scratch_mount
> > > > +_scratch_scrub >> $seqres.full
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +echo "+ Part 2: Corrupt the first inode in the bucket" | tee -a $seqres.full
> > > > +format_scratch
> > > > +corrupt_scratch 1
> > > > +_scratch_mount
> > > > +_scratch_scrub >> $seqres.full
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +echo "+ Part 3: Corrupt the middle inode in the bucket" | tee -a $seqres.full
> > > > +format_scratch
> > > > +corrupt_scratch 3
> > > > +_scratch_mount
> > > > +_scratch_scrub >> $seqres.full
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +echo "+ Part 4: Corrupt the last inode in the bucket" | tee -a $seqres.full
> > > > +format_scratch
> > > > +corrupt_scratch 5
> > > > +_scratch_mount
> > > > +_scratch_scrub >> $seqres.full
> > > > +exercise_scratch
> > > > +_scratch_unmount
> > > > +final_check_scratch
> > > > +
> > > > +# success, all done
> > > > +echo Silence is golden
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/1873.out b/tests/xfs/1873.out
> > > > new file mode 100644
> > > > index 0000000000..0e36bd2304
> > > > --- /dev/null
> > > > +++ b/tests/xfs/1873.out
> > > > @@ -0,0 +1,6 @@
> > > > +QA output created by 1873
> > > > ++ Part 1: See if scrub can recover the unlinked list
> > > > ++ Part 2: Corrupt the first inode in the bucket
> > > > ++ Part 3: Corrupt the middle inode in the bucket
> > > > ++ Part 4: Corrupt the last inode in the bucket
> > > > +Silence is golden
> > > > 
> > > 
> > 
> 

