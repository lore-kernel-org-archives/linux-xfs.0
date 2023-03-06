Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2458C6FD1A
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Mar 2023 23:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjCFXPU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Mar 2023 18:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCFXPT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2023 18:15:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F886A57;
        Mon,  6 Mar 2023 15:15:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D43F60DB9;
        Mon,  6 Mar 2023 23:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCEAC433EF;
        Mon,  6 Mar 2023 23:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678144500;
        bh=/y/w1z9s3+FJptpWXQFvoWI0RuTgRPDLEqKwBheBAuQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RjCGOPXBOEZy1xmrEz4135et6wg1LaYxBOevNBMc5c8q9w+K7ySDetObjer98UPC4
         eF5ird82j+YorgLsCDY2qKvpmjtDonDcjhNqikohtWEnXjFRRyEXGFSXEO87i6fWCj
         +PTn3QblpzWjvOS8VYinckXMFmn/Vx8mZcIuiSfiFp7nX35aK9376M8z3e6U1FXwZ/
         4bw4fUus/uMopXd3NXuuqh4ibc4AhRNkd36juzvuC8CSyEc+cFeTgDhMOjyBLlxYaF
         ept68NWit7q4/LexpR0kDH3DvQKel/SX/IGmb7TzncWYMCFyq7iSbTnmhyc/bvgjTE
         Nid9du2utKSSA==
Date:   Mon, 6 Mar 2023 15:14:59 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test upgrading old features
Message-ID: <20230306231459.GB1637786@frogsfrogsfrogs>
References: <167243882949.736459.9627363155663418213.stgit@magnolia>
 <167243882961.736459.4302174338740527578.stgit@magnolia>
 <20230306155611.6w6mn3k7owsc2jz7@zlang-mailbox>
 <20230306164155.GA1637786@frogsfrogsfrogs>
 <20230306165402.nrkm5jkowiorucmn@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306165402.nrkm5jkowiorucmn@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 07, 2023 at 12:54:02AM +0800, Zorro Lang wrote:
> On Mon, Mar 06, 2023 at 08:41:55AM -0800, Darrick J. Wong wrote:
> > On Mon, Mar 06, 2023 at 11:56:11PM +0800, Zorro Lang wrote:
> > > On Fri, Dec 30, 2022 at 02:20:29PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Test the ability to add older v5 features.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  tests/xfs/769     |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/769.out |    2 
> > > >  2 files changed, 250 insertions(+)
> > > >  create mode 100755 tests/xfs/769
> > > >  create mode 100644 tests/xfs/769.out
> > > > 
> > > > 
> > > > diff --git a/tests/xfs/769 b/tests/xfs/769
> > > > new file mode 100755
> > > > index 0000000000..7613048f52
> > > > --- /dev/null
> > > > +++ b/tests/xfs/769
> > > > @@ -0,0 +1,248 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0-or-later
> > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 769
> > > > +#
> > > > +# Test upgrading filesystems with new features.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto mkfs repair
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
> > > > +. ./common/populate
> > > > +
> > > > +# real QA test starts here
> > > > +_supported_fs xfs
> > > > +
> > > > +test -w /dev/ttyprintk || _notrun "test requires writable /dev/ttyprintk"
> > > 
> > > Hi Darrick,
> > > 
> > > I'm not sure why /dev/ttyprintk is necessary. I think sometimes we might not
> > > have this driver, but has /dev/kmsg. Can /dev/kmsg be a replacement of
> > > ttyprintk ?
> > 
> > The kernel logging here is for debugging purposes -- if the upgrade
> > corrupts the fs and the kernel splats, whoever triages the failure can
> > have at least some clue as to where things went wrong.
> > 
> > I think the _notrun line should go away though.
> 
> If only for debugging, better to let this case keep running without ttyprintk.
> Or it'll _notrun on many systems without ttyprintk driver.
> 
> There's a log_dmesg() helper in common/rc, the /dev/kmsg might be more often.
> As you've called *_require_check_dmesg*, it helps to check kmsg file. So
> how about use it? Or making a helper to write messages to ttyprintk, then
> fallback to kmsg if ttyprintk is missing ?

Yeah, I can hoist the ttyprintk usage into a helper that emits to
ttyprintk or kmsg depending on what's available.

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > 
> > > > +_require_check_dmesg
> > > > +_require_scratch_nocheck
> > > > +_require_scratch_xfs_crc
> > > > +
> > > > +# Does repair know how to add a particular feature to a filesystem?
> > > > +check_repair_upgrade()
> > > > +{
> > > > +	$XFS_REPAIR_PROG -c "$1=narf" 2>&1 | \
> > > > +		grep -q 'unknown option' && return 1
> > > > +	return 0
> > > > +}
> > > > +
> > > > +# Are we configured for realtime?
> > > > +rt_configured()
> > > > +{
> > > > +	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
> > > > +}
> > > > +
> > > > +# Compute the MKFS_OPTIONS string for a particular feature upgrade test
> > > > +compute_mkfs_options()
> > > > +{
> > > > +	local m_opts=""
> > > > +	local caller_options="$MKFS_OPTIONS"
> > > > +
> > > > +	for feat in "${FEATURES[@]}"; do
> > > > +		local feat_state="${FEATURE_STATE["${feat}"]}"
> > > > +
> > > > +		if echo "$caller_options" | grep -E -w -q "${feat}=[0-9]*"; then
> > > > +			# Change the caller's options
> > > > +			caller_options="$(echo "$caller_options" | \
> > > > +				sed -e "s/\([^[:alnum:]]\)${feat}=[0-9]*/\1${feat}=${feat_state}/g")"
> > > > +		else
> > > > +			# Add it to our list of new mkfs flags
> > > > +			m_opts="${feat}=${feat_state},${m_opts}"
> > > > +		fi
> > > > +	done
> > > > +
> > > > +	test -n "$m_opts" && m_opts=" -m $m_opts"
> > > > +
> > > > +	echo "$caller_options$m_opts"
> > > > +}
> > > > +
> > > > +# Log the start of an upgrade.
> > > > +function upgrade_start_message()
> > > > +{
> > > > +	local feat="$1"
> > > > +
> > > > +	echo "Add $feat to filesystem"
> > > > +}
> > > > +
> > > > +# Find dmesg log messages since we started a particular upgrade test
> > > > +function dmesg_since_feature_upgrade_start()
> > > > +{
> > > > +	local feat_logmsg="$(upgrade_start_message "$1")"
> > > > +
> > > > +	# search the dmesg log of last run of $seqnum for possible failures
> > > > +	# use sed \cregexpc address type, since $seqnum contains "/"
> > > > +	dmesg | \
> > > > +		tac | \
> > > > +		sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> > > > +		sed -ne "0,\#${feat_logmsg}#p" | \
> > > > +		tac
> > > > +}
> > > > +
> > > > +# Did the mount fail because this feature is not supported?
> > > > +function feature_unsupported()
> > > > +{
> > > > +	local feat="$1"
> > > > +
> > > > +	dmesg_since_feature_upgrade_start "$feat" | \
> > > > +		grep -q 'has unknown.*features'
> > > > +}
> > > > +
> > > > +# Exercise the scratch fs
> > > > +function scratch_fsstress()
> > > > +{
> > > > +	echo moo > $SCRATCH_MNT/sample.txt
> > > > +	$FSSTRESS_PROG -n $((TIME_FACTOR * 1000)) -p $((LOAD_FACTOR * 4)) \
> > > > +		-d $SCRATCH_MNT/data >> $seqres.full
> > > > +}
> > > > +
> > > > +# Exercise the filesystem a little bit and emit a manifest.
> > > > +function pre_exercise()
> > > > +{
> > > > +	local feat="$1"
> > > > +
> > > > +	_try_scratch_mount &> $tmp.mount
> > > > +	res=$?
> > > > +	# If the kernel doesn't support the filesystem even after a
> > > > +	# fresh format, skip the rest of the upgrade test quietly.
> > > > +	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
> > > > +		echo "mount failed due to unsupported feature $feat" >> $seqres.full
> > > > +		return 1
> > > > +	fi
> > > > +	if [ $res -ne 0 ]; then
> > > > +		cat $tmp.mount
> > > > +		echo "mount failed with $res before upgrading to $feat" | \
> > > > +			tee -a $seqres.full
> > > > +		return 1
> > > > +	fi
> > > > +
> > > > +	scratch_fsstress
> > > > +	find $SCRATCH_MNT -type f -print0 | xargs -r -0 md5sum > $tmp.manifest
> > > > +	_scratch_unmount
> > > > +	return 0
> > > > +}
> > > > +
> > > > +# Check the manifest and exercise the filesystem more
> > > > +function post_exercise()
> > > > +{
> > > > +	local feat="$1"
> > > > +
> > > > +	_try_scratch_mount &> $tmp.mount
> > > > +	res=$?
> > > > +	# If the kernel doesn't support the filesystem even after a
> > > > +	# fresh format, skip the rest of the upgrade test quietly.
> > > > +	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
> > > > +		echo "mount failed due to unsupported feature $feat" >> $seqres.full
> > > > +		return 1
> > > > +	fi
> > > > +	if [ $res -ne 0 ]; then
> > > > +		cat $tmp.mount
> > > > +		echo "mount failed with $res after upgrading to $feat" | \
> > > > +			tee -a $seqres.full
> > > > +		return 1
> > > > +	fi
> > > > +
> > > > +	md5sum --quiet -c $tmp.manifest || \
> > > > +		echo "fs contents ^^^ changed after adding $feat"
> > > > +
> > > > +	iam="check" _check_scratch_fs || \
> > > > +		echo "scratch fs check failed after adding $feat"
> > > > +
> > > > +	# Try to mount the fs in case the check unmounted it
> > > > +	_try_scratch_mount &>> $seqres.full
> > > > +
> > > > +	scratch_fsstress
> > > > +
> > > > +	iam="check" _check_scratch_fs || \
> > > > +		echo "scratch fs check failed after exercising $feat"
> > > > +
> > > > +	# Try to unmount the fs in case the check didn't
> > > > +	_scratch_unmount &>> $seqres.full
> > > > +	return 0
> > > > +}
> > > > +
> > > > +# Create a list of fs features in the order that support for them was added
> > > > +# to the kernel driver.  For each feature upgrade test, we enable all the
> > > > +# features that came before it and none of the ones after, which means we're
> > > > +# testing incremental migrations.  We start each run with a clean fs so that
> > > > +# errors and unsatisfied requirements (log size, root ino position, etc) in one
> > > > +# upgrade don't spread failure to the rest of the tests.
> > > > +FEATURES=()
> > > > +if rt_configured; then
> > > > +	check_repair_upgrade finobt && FEATURES+=("finobt")
> > > > +	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
> > > > +	check_repair_upgrade bigtime && FEATURES+=("bigtime")
> > > > +else
> > > > +	check_repair_upgrade finobt && FEATURES+=("finobt")
> > > > +	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
> > > > +	check_repair_upgrade reflink && FEATURES+=("reflink")
> > > > +	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
> > > > +	check_repair_upgrade bigtime && FEATURES+=("bigtime")
> > > > +fi
> > > > +
> > > > +test "${#FEATURES[@]}" -eq 0 && \
> > > > +	_notrun "xfs_repair does not know how to add V5 features"
> > > > +
> > > > +declare -A FEATURE_STATE
> > > > +for f in "${FEATURES[@]}"; do
> > > > +	FEATURE_STATE["$f"]=0
> > > > +done
> > > > +
> > > > +for feat in "${FEATURES[@]}"; do
> > > > +	echo "-----------------------" >> $seqres.full
> > > > +
> > > > +	upgrade_start_message "$feat" | tee -a $seqres.full /dev/ttyprintk > /dev/null
> > > > +
> > > > +	opts="$(compute_mkfs_options)"
> > > > +	echo "mkfs.xfs $opts" >> $seqres.full
> > > > +
> > > > +	# Format filesystem
> > > > +	MKFS_OPTIONS="$opts" _scratch_mkfs &>> $seqres.full
> > > > +	res=$?
> > > > +	outcome="mkfs returns $res for $feat upgrade test"
> > > > +	echo "$outcome" >> $seqres.full
> > > > +	if [ $res -ne 0 ]; then
> > > > +		echo "$outcome"
> > > > +		continue
> > > > +	fi
> > > > +
> > > > +	# Create some files to make things interesting.
> > > > +	pre_exercise "$feat" || break
> > > > +
> > > > +	# Upgrade the fs
> > > > +	_scratch_xfs_repair -c "${feat}=1" &> $tmp.upgrade
> > > > +	res=$?
> > > > +	cat $tmp.upgrade >> $seqres.full
> > > > +	grep -q "^Adding" $tmp.upgrade || \
> > > > +		echo "xfs_repair ignored command to add $feat"
> > > > +
> > > > +	outcome="xfs_repair returns $res while adding $feat"
> > > > +	echo "$outcome" >> $seqres.full
> > > > +	if [ $res -ne 0 ]; then
> > > > +		# Couldn't upgrade filesystem, move on to the next feature.
> > > > +		FEATURE_STATE["$feat"]=1
> > > > +		continue
> > > > +	fi
> > > > +
> > > > +	# Make sure repair runs cleanly afterwards
> > > > +	_scratch_xfs_repair -n &>> $seqres.full
> > > > +	res=$?
> > > > +	outcome="xfs_repair -n returns $res after adding $feat"
> > > > +	echo "$outcome" >> $seqres.full
> > > > +	if [ $res -ne 0 ]; then
> > > > +		echo "$outcome"
> > > > +	fi
> > > > +
> > > > +	# Make sure we can still exercise the filesystem.
> > > > +	post_exercise "$feat" || break
> > > > +
> > > > +	# Update feature state for next run
> > > > +	FEATURE_STATE["$feat"]=1
> > > > +done
> > > > +
> > > > +# success, all done
> > > > +echo Silence is golden.
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/769.out b/tests/xfs/769.out
> > > > new file mode 100644
> > > > index 0000000000..332432db97
> > > > --- /dev/null
> > > > +++ b/tests/xfs/769.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 769
> > > > +Silence is golden.
> > > > 
> > > 
> > 
> 
