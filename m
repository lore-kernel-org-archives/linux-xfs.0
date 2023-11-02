Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB1DFC4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 20:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjKBUNc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKBUNc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 16:13:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493C2138
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 13:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698955958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gtkje9I4Wqu8jQGkwRn3O1YpAz7mpk29St4OfqXomMA=;
        b=Rr4cPv8aUgOkF3N4lTriysyxCma9waDk0MH6ZZ4UYgfTL3mUQpJlsSpyJIFKHv1Sq3gsUu
        DwPnehO1v//QsaDXEvyLffYEaKAHZ6xwFeoRtJr8lUYojESBlvGOh+8MdktyZtdWzQqZZK
        zK7doM9q8u4XUOmt0tWPCcHoJBW/nSo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-hiGG7Rf8N4a2geSbZvYcrQ-1; Thu, 02 Nov 2023 16:12:36 -0400
X-MC-Unique: hiGG7Rf8N4a2geSbZvYcrQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-6bce5140a2bso1185204b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2023 13:12:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698955955; x=1699560755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gtkje9I4Wqu8jQGkwRn3O1YpAz7mpk29St4OfqXomMA=;
        b=DfS8IRwJgp9FArzojs4vMBhA3rSsPR0pnGPMMe07Sx7dC7OMNC8ti1sf/PdmgzSSnZ
         0gcBW2SlJDIiQysPyoyaiJg53qHkRCjhNRHjXMFe1xdLXRf/rfO4MgJUFyOMhW2Di8um
         tA4PWBrpbX009rvhjp48s6xbhJeNcj2WSCFBsijm11WCroRR8u8P9tn9RpUw+AhUL1Qi
         rNipplX5LNU0cZhU1aDWQfn3G3C58Od+RGUnm6InGHrL93vZtppEQTDi6yd8KLlZbaOr
         1ol8QePrzzyTWn3agNSojzec7EUDM8QI7hDMkDz4J3EiaRGAQm44uFy7S58OYtjE6hx/
         VICw==
X-Gm-Message-State: AOJu0Yxqfryh6ijYwAUsYZOU7aoq+SckPd/7CYWuDC8GzFW7T73LXNyu
        saeusBCFv45fX3vMmoZJHlu2EsOxp5Iw21iKstw7UtohI0x4HF2UsZ6Omr1nICU1LYuYyxXhQJs
        kVDtYt9UVEf/3037sG+/m
X-Received: by 2002:a05:6a20:3d8b:b0:137:514a:984f with SMTP id s11-20020a056a203d8b00b00137514a984fmr20975717pzi.35.1698955955408;
        Thu, 02 Nov 2023 13:12:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuSQg+OemLc9IKCl4PrQmeWdLvyXStCrwfQUdTvYorn92K68UcxzUJzjNMDzNCxRdOclYhqA==
X-Received: by 2002:a05:6a20:3d8b:b0:137:514a:984f with SMTP id s11-20020a056a203d8b00b00137514a984fmr20975681pzi.35.1698955954928;
        Thu, 02 Nov 2023 13:12:34 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id k10-20020a634b4a000000b00577d53c50f7sm127190pgl.75.2023.11.02.13.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 13:12:34 -0700 (PDT)
Date:   Fri, 3 Nov 2023 04:12:31 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test unlinked inode list repair on demand
Message-ID: <20231102201231.xhjhzeah7lb7vm45@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <169687552892.3949084.287369396167434290.stgit@frogsfrogsfrogs>
 <169687553453.3949084.14532709239423528329.stgit@frogsfrogsfrogs>
 <20231101172054.GD1205143@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231101172054.GD1205143@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2023 at 10:20:54AM -0700, Darrick J. Wong wrote:
> On Mon, Oct 09, 2023 at 11:18:54AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a test to exercise recovery of unlinked inodes on a clean
> > filesystem.  This was definitely possible on old kernels that on an ro
> > mount would clean the log without processing the iunlink list.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Ping?  The kernel fixes and the xfs_db commands have both been merged
> upstream, could we please merge this functional test of the new unlinked
> inode cleanup code in the kernel XFS driver?

Sure Darrick. I'll try to merge it in next fstests release.

The x/1872 missed the _kernlog(), I think it's a Darrick specific common
helper :)

The x/1873 need the xfs_io repair -R, I'm using the lastest xfsprogs
for-next branch. Where can I get the -R support ?

Thanks,
Zorro

> 
> --D
> 
> > ---
> >  common/rc          |    4 +
> >  tests/xfs/1872     |  113 +++++++++++++++++++++++++++
> >  tests/xfs/1872.out |    5 +
> >  tests/xfs/1873     |  217 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1873.out |    6 +
> >  5 files changed, 344 insertions(+), 1 deletion(-)
> >  create mode 100755 tests/xfs/1872
> >  create mode 100644 tests/xfs/1872.out
> >  create mode 100755 tests/xfs/1873
> >  create mode 100644 tests/xfs/1873.out
> > 
> > 
> > diff --git a/common/rc b/common/rc
> > index 259a1ffb09..20d3e61c4e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2668,9 +2668,11 @@ _require_xfs_io_command()
> >  		param_checked="$pwrite_opts $param"
> >  		;;
> >  	"scrub"|"repair")
> > -		testio=`$XFS_IO_PROG -x -c "$command probe" $TEST_DIR 2>&1`
> > +		test -z "$param" && param="probe"
> > +		testio=`$XFS_IO_PROG -x -c "$command $param" $TEST_DIR 2>&1`
> >  		echo $testio | grep -q "Inappropriate ioctl" && \
> >  			_notrun "xfs_io $command support is missing"
> > +		param_checked="$param"
> >  		;;
> >  	"startupdate"|"commitupdate"|"cancelupdate")
> >  		$XFS_IO_PROG -f -c 'pwrite -S 0x58 0 128k -b 128k' $testfile > /dev/null
> > diff --git a/tests/xfs/1872 b/tests/xfs/1872
> > new file mode 100755
> > index 0000000000..3720a3d184
> > --- /dev/null
> > +++ b/tests/xfs/1872
> > @@ -0,0 +1,113 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1872
> > +#
> > +# Test using runtime code to fix unlinked inodes on a clean filesystem that
> > +# never got cleaned up.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick unlink
> > +
> > +# Import common functions.
> > +source ./common/filter
> > +source ./common/fuzzy
> > +source ./common/quota
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_xfs_db_command iunlink
> > +_require_scratch_nocheck	# we'll run repair ourselves
> > +
> > +# From the AGI definition
> > +XFS_AGI_UNLINKED_BUCKETS=64
> > +
> > +# Try to make each iunlink bucket have this many inodes in it.
> > +IUNLINK_BUCKETLEN=5
> > +
> > +# XXX Forcibly disable quota since quotacheck will break this test
> > +orig_mount_options="$MOUNT_OPTIONS"
> > +_qmount_option 'noquota'
> > +
> > +format_scratch() {
> > +	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
> > +	source "${tmp}.mkfs"
> > +	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
> > +
> > +	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
> > +	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
> > +}
> > +
> > +__repair_check_scratch() {
> > +	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
> > +		tee -a $seqres.full | \
> > +		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
> > +	return "${PIPESTATUS[0]}"
> > +}
> > +
> > +exercise_scratch() {
> > +	# Create a bunch of files...
> > +	declare -A inums
> > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > +		touch "${SCRATCH_MNT}/${i}" || break
> > +		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
> > +	done
> > +
> > +	# ...then delete them to exercise the unlinked buckets
> > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > +		if ! rm -f "${SCRATCH_MNT}/${i}"; then
> > +			echo "rm failed on inum ${inums[$i]}"
> > +			break
> > +		fi
> > +	done
> > +}
> > +
> > +# Offline repair should not find anything
> > +final_check_scratch() {
> > +	__repair_check_scratch
> > +	res=$?
> > +	if [ $res -eq 2 ]; then
> > +		echo "scratch fs went offline?"
> > +		_scratch_mount
> > +		_scratch_unmount
> > +		__repair_check_scratch
> > +	fi
> > +	test "$res" -ne 0 && echo "repair returned $res?"
> > +}
> > +
> > +echo "+ Part 0: See if runtime can recover the unlinked list" | tee -a $seqres.full
> > +format_scratch
> > +_kernlog "part 0"
> > +_scratch_mount
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +echo "+ Part 1: See if bulkstat can recover the unlinked list" | tee -a $seqres.full
> > +format_scratch
> > +_kernlog "part 1"
> > +_scratch_mount
> > +$XFS_IO_PROG -c 'bulkstat' $SCRATCH_MNT > /dev/null
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +echo "+ Part 2: See if quotacheck can recover the unlinked list" | tee -a $seqres.full
> > +if [ -f /proc/fs/xfs/xqmstat ]; then
> > +	MOUNT_OPTIONS="$orig_mount_options"
> > +	_qmount_option 'quota'
> > +	format_scratch
> > +	_kernlog "part 2"
> > +	_scratch_mount
> > +	exercise_scratch
> > +	_scratch_unmount
> > +	final_check_scratch
> > +fi
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1872.out b/tests/xfs/1872.out
> > new file mode 100644
> > index 0000000000..248f0e2416
> > --- /dev/null
> > +++ b/tests/xfs/1872.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 1872
> > ++ Part 0: See if runtime can recover the unlinked list
> > ++ Part 1: See if bulkstat can recover the unlinked list
> > ++ Part 2: See if quotacheck can recover the unlinked list
> > +Silence is golden
> > diff --git a/tests/xfs/1873 b/tests/xfs/1873
> > new file mode 100755
> > index 0000000000..4712dee7ab
> > --- /dev/null
> > +++ b/tests/xfs/1873
> > @@ -0,0 +1,217 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2023 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 1873
> > +#
> > +# Functional test of using online repair to fix unlinked inodes on a clean
> > +# filesystem that never got cleaned up.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto online_repair
> > +
> > +# Import common functions.
> > +source ./common/filter
> > +source ./common/fuzzy
> > +source ./common/quota
> > +
> > +# real QA test starts here
> > +
> > +# Modify as appropriate.
> > +_supported_fs generic
> > +_require_xfs_db_command iunlink
> > +# The iunlink bucket repair code wasn't added to the AGI repair code
> > +# until after the directory repair code was merged
> > +_require_xfs_io_command repair -R directory
> > +_require_scratch_nocheck	# repair doesn't like single-AG fs
> > +
> > +# From the AGI definition
> > +XFS_AGI_UNLINKED_BUCKETS=64
> > +
> > +# Try to make each iunlink bucket have this many inodes in it.
> > +IUNLINK_BUCKETLEN=5
> > +
> > +# XXX Forcibly disable quota since quotacheck will break this test
> > +_qmount_option 'noquota'
> > +
> > +format_scratch() {
> > +	_scratch_mkfs -d agcount=1 | _filter_mkfs 2> "${tmp}.mkfs" >> $seqres.full
> > +	source "${tmp}.mkfs"
> > +	test "${agcount}" -eq 1 || _notrun "test requires 1 AG for error injection"
> > +
> > +	local nr_iunlinks="$((IUNLINK_BUCKETLEN * XFS_AGI_UNLINKED_BUCKETS))"
> > +	readarray -t BADINODES < <(_scratch_xfs_db -x -c "iunlink -n $nr_iunlinks" | awk '{print $4}')
> > +}
> > +
> > +__repair_check_scratch() {
> > +	_scratch_xfs_repair -o force_geometry -n 2>&1 | \
> > +		tee -a $seqres.full | \
> > +		grep -E '(disconnected inode.*would move|next_unlinked in inode|unlinked bucket.*is.*in ag)'
> > +	return "${PIPESTATUS[0]}"
> > +}
> > +
> > +corrupt_scratch() {
> > +	# How far into the iunlink bucket chain do we target inodes for corruption?
> > +	# 1 = target the inode pointed to by the AGI
> > +	# 3 = middle of bucket list
> > +	# 5 = last element in bucket
> > +	local corruption_bucket_depth="$1"
> > +	if ((corruption_bucket_depth < 1 || corruption_bucket_depth > IUNLINK_BUCKETLEN)); then
> > +		echo "${corruption_bucket_depth}: Value must be between 1 and ${IUNLINK_BUCKETLEN}."
> > +		return 1
> > +	fi
> > +
> > +	# Index of the inode numbers within BADINODES
> > +	local bad_ino1_idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth) * XFS_AGI_UNLINKED_BUCKETS))
> > +	local bad_ino2_idx=$((bad_ino1_idx + 1))
> > +
> > +	# Inode numbers to target
> > +	local bad_ino1="${BADINODES[bad_ino1_idx]}"
> > +	local bad_ino2="${BADINODES[bad_ino2_idx]}"
> > +	printf "bad: 0x%x 0x%x\n" "${bad_ino1}" "${bad_ino2}" | _tee_kernlog >> $seqres.full
> > +
> > +	# Bucket within AGI 0's iunlinked array.
> > +	local ino1_bucket="$((bad_ino1 % XFS_AGI_UNLINKED_BUCKETS))"
> > +	local ino2_bucket="$((bad_ino2 % XFS_AGI_UNLINKED_BUCKETS))"
> > +
> > +	# The first bad inode stays on the unlinked list but gets a nonzero
> > +	# nlink; the second bad inode is removed from the unlinked list but
> > +	# keeps its zero nlink
> > +	_scratch_xfs_db -x \
> > +		-c "inode ${bad_ino1}" -c "write -d core.nlinkv2 5555" \
> > +		-c "agi 0" -c "fuzz -d unlinked[${ino2_bucket}] ones" -c "print unlinked" >> $seqres.full
> > +
> > +	local iwatch=()
> > +	local idx
> > +
> > +	# Make a list of the adjacent iunlink bucket inodes for the first inode
> > +	# that we targeted.
> > +	if [ "${corruption_bucket_depth}" -gt 1 ]; then
> > +		# Previous ino in bucket
> > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
> > +		iwatch+=("${BADINODES[idx]}")
> > +	fi
> > +	iwatch+=("${bad_ino1}")
> > +	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
> > +		# Next ino in bucket
> > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
> > +		iwatch+=("${BADINODES[idx]}")
> > +	fi
> > +
> > +	# Make a list of the adjacent iunlink bucket inodes for the second
> > +	# inode that we targeted.
> > +	if [ "${corruption_bucket_depth}" -gt 1 ]; then
> > +		# Previous ino in bucket
> > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth + 1) * XFS_AGI_UNLINKED_BUCKETS))
> > +		iwatch+=("${BADINODES[idx + 1]}")
> > +	fi
> > +	iwatch+=("${bad_ino2}")
> > +	if [ "$((corruption_bucket_depth + 1))" -lt "${IUNLINK_BUCKETLEN}" ]; then
> > +		# Next ino in bucket
> > +		idx=$(( (IUNLINK_BUCKETLEN - corruption_bucket_depth - 1) * XFS_AGI_UNLINKED_BUCKETS))
> > +		iwatch+=("${BADINODES[idx + 1]}")
> > +	fi
> > +
> > +	# Construct a grep string for tracepoints.
> > +	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} |bucket ${fuzz_bucket} "
> > +	GREP_STR="(xrep_attempt|xrep_done|bucket ${ino1_bucket} |bucket ${ino2_bucket} "
> > +	for ino in "${iwatch[@]}"; do
> > +		f="$(printf "|ino 0x%x" "${ino}")"
> > +		GREP_STR="${GREP_STR}${f}"
> > +	done
> > +	GREP_STR="${GREP_STR})"
> > +	echo "grep -E \"${GREP_STR}\"" >> $seqres.full
> > +
> > +	# Dump everything we did to to the full file.
> > +	local db_dump=(-c 'agi 0' -c 'print unlinked')
> > +	db_dump+=(-c 'addr root' -c 'print')
> > +	test "${ino1_bucket}" -gt 0 && \
> > +		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino1_bucket - 1))")
> > +	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino1_bucket}")
> > +	db_dump+=(-c "dump_iunlinked -a 0 -b ${ino2_bucket}")
> > +	test "${ino2_bucket}" -lt 63 && \
> > +		db_dump+=(-c "dump_iunlinked -a 0 -b $((ino2_bucket + 1))")
> > +	db_dump+=(-c "inode $bad_ino1" -c 'print core.nlinkv2 v3.inumber next_unlinked')
> > +	db_dump+=(-c "inode $bad_ino2" -c 'print core.nlinkv2 v3.inumber next_unlinked')
> > +	_scratch_xfs_db "${db_dump[@]}" >> $seqres.full
> > +
> > +	# Test run of repair to make sure we find disconnected inodes
> > +	__repair_check_scratch | \
> > +		sed -e 's/disconnected inode \([0-9]*\)/disconnected inode XXXXXX/g' \
> > +		    -e 's/next_unlinked in inode \([0-9]*\)/next_unlinked in inode XXXXXX/g' \
> > +		    -e 's/unlinked bucket \([0-9]*\) is \([0-9]*\) in ag \([0-9]*\) .inode=\([0-9]*\)/unlinked bucket YY is XXXXXX in ag Z (inode=AAAAAA/g' | \
> > +		uniq -c >> $seqres.full
> > +	res=${PIPESTATUS[0]}
> > +	test "$res" -ne 0 || echo "repair returned $res after corruption?"
> > +}
> > +
> > +exercise_scratch() {
> > +	# Create a bunch of files...
> > +	declare -A inums
> > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > +		touch "${SCRATCH_MNT}/${i}" || break
> > +		inums["${i}"]="$(stat -c %i "${SCRATCH_MNT}/${i}")"
> > +	done
> > +
> > +	# ...then delete them to exercise the unlinked buckets
> > +	for ((i = 0; i < (XFS_AGI_UNLINKED_BUCKETS * 2); i++)); do
> > +		if ! rm -f "${SCRATCH_MNT}/${i}"; then
> > +			echo "rm failed on inum ${inums[$i]}"
> > +			break
> > +		fi
> > +	done
> > +}
> > +
> > +# Offline repair should not find anything
> > +final_check_scratch() {
> > +	__repair_check_scratch
> > +	res=$?
> > +	if [ $res -eq 2 ]; then
> > +		echo "scratch fs went offline?"
> > +		_scratch_mount
> > +		_scratch_unmount
> > +		__repair_check_scratch
> > +	fi
> > +	test "$res" -ne 0 && echo "repair returned $res?"
> > +}
> > +
> > +echo "+ Part 1: See if scrub can recover the unlinked list" | tee -a $seqres.full
> > +format_scratch
> > +_kernlog "no bad inodes"
> > +_scratch_mount
> > +_scratch_scrub >> $seqres.full
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +echo "+ Part 2: Corrupt the first inode in the bucket" | tee -a $seqres.full
> > +format_scratch
> > +corrupt_scratch 1
> > +_scratch_mount
> > +_scratch_scrub >> $seqres.full
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +echo "+ Part 3: Corrupt the middle inode in the bucket" | tee -a $seqres.full
> > +format_scratch
> > +corrupt_scratch 3
> > +_scratch_mount
> > +_scratch_scrub >> $seqres.full
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +echo "+ Part 4: Corrupt the last inode in the bucket" | tee -a $seqres.full
> > +format_scratch
> > +corrupt_scratch 5
> > +_scratch_mount
> > +_scratch_scrub >> $seqres.full
> > +exercise_scratch
> > +_scratch_unmount
> > +final_check_scratch
> > +
> > +# success, all done
> > +echo Silence is golden
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1873.out b/tests/xfs/1873.out
> > new file mode 100644
> > index 0000000000..0e36bd2304
> > --- /dev/null
> > +++ b/tests/xfs/1873.out
> > @@ -0,0 +1,6 @@
> > +QA output created by 1873
> > ++ Part 1: See if scrub can recover the unlinked list
> > ++ Part 2: Corrupt the first inode in the bucket
> > ++ Part 3: Corrupt the middle inode in the bucket
> > ++ Part 4: Corrupt the last inode in the bucket
> > +Silence is golden
> > 
> 

