Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D0DC19F2B
	for <linux-xfs@archiver.kernel.org>; Sun, 31 Jul 2022 16:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiGaQsZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jul 2022 12:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiGaQsY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 Jul 2022 12:48:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B722E027;
        Sun, 31 Jul 2022 09:48:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84BA0B80DA8;
        Sun, 31 Jul 2022 16:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF82C433D6;
        Sun, 31 Jul 2022 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659286100;
        bh=b/g78xdkLUL23bRHqXSwOFKO11OWi7KU6mFpVZqVrUI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JtsciovRimx+k2eC8tKZCqqTj5kqmS1P+B6i4o0MjCCD/ZHxGoRBchn9qTaKeh3FB
         vUlnLr6lCUhXxJPsvXffhRrzf0DK23qN0iVzTAiJMngzSD7xkMWiLJHNE4TrX4dyve
         UyJAM8g9mqIfi5ri2pVHcjyBlL24aY5BUKrAJCn1DxUmnraySD4lMf1qypXIRN/xhg
         uxhGCP3EwHEmJpJzRJesyIK2WOls0z+4wXZv+susa7XYCeD2DHzG5ZpxD9tnwv+83V
         IVZJHu16z2obtTqMQcKZg1glHANbqGavzqWMQSWi3adMImKPtgE8nU9/iT8a8A+aTY
         qfWWrd8/HV01Q==
Date:   Sun, 31 Jul 2022 09:48:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 2/2] dmerror: support external log and realtime devices
Message-ID: <YuayU5+5XfgUTnIV@magnolia>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886492259.1585061.11384715139979799178.stgit@magnolia>
 <20220730101834.6nscxoc2u3wfy7nq@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220730101834.6nscxoc2u3wfy7nq@zlang-mailbox>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jul 30, 2022 at 06:18:34PM +0800, Zorro Lang wrote:
> On Tue, Jul 26, 2022 at 12:48:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Upgrade the dmerror code to coordinate making external scratch log and
> > scratch realtime devices error out along with the scratch device.  Note
> > that unlike SCRATCH_DEV, we save the old rt/log devices in a separate
> > variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper
> > functions continue to work properly.
> > 
> > This is very similar to what we did for dm-flakey a while back.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> 
> Hi Darrick,
> 
> I'll merge the patch 1/2 this week, but this 2/2 looks like bring in new
> failures on ext4 with local.config as [0], for example[1], which is passed[2]
> without this patch. It's fine on Btrfs and xfs for me.
> 
> Thanks,
> Zorro
> 
> [0]
> export TEST_DEV=/dev/sda5
> export TEST_DIR=/mnt/test
> export SCRATCH_DEV=/dev/sda3
> export SCRATCH_MNT=/mnt/scratch
> export USE_EXTERNAL=yes
> export SCRATCH_LOGDEV=/dev/loop0
> 
> [1]
> generic/338 4s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/338.out.bad)
>     --- tests/generic/338.out   2022-04-29 23:07:23.330499055 +0800
>     +++ /root/git/xfstests/results//logdev/generic/338.out.bad  2022-07-30 18:01:41.900765965 +0800
>     @@ -1,2 +1,4 @@
>      QA output created by 338   
>      Silence is golden
>     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
>     +       dmesg(1) may have more information after failed mount system call.

Hmm, any chance you could post the dmesg that goes with this?

--D

>     ...
>     (Run 'diff -u /root/git/xfstests/tests/generic/338.out /root/git/xfstests/results//logdev/generic/338.out.bad'  to see the entire diff)
> generic/441 5s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/441.out.bad)
>     --- tests/generic/441.out   2022-04-29 23:07:23.406499916 +0800
>     +++ /root/git/xfstests/results//logdev/generic/441.out.bad  2022-07-30 18:01:46.829822438 +0800
>     @@ -1,3 +1,6 @@
>      QA output created by 441   
>      Format and mount
>     -Test passed!
>     +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
>     +       dmesg(1) may have more information after failed mount system call.
>     +Success on second fsync on fd[0]!
>     +umount: /mnt/scratch: not mounted.
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/generic/441.out /root/git/xfstests/results//logdev/generic/441.out.bad'  to see the entire diff)
> 
> [2]
> generic/338 4s ...  5s
> generic/441 5s ...  5s
> generic/442 3s ...  3s
> 
> 
> >  common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  tests/generic/441 |    2 -
> >  tests/generic/487 |    2 -
> >  3 files changed, 156 insertions(+), 7 deletions(-)
> > 
> > 
> > diff --git a/common/dmerror b/common/dmerror
> > index 01a4c8b5..85ef9a16 100644
> > --- a/common/dmerror
> > +++ b/common/dmerror
> > @@ -4,25 +4,88 @@
> >  #
> >  # common functions for setting up and tearing down a dmerror device
> >  
> > +_dmerror_setup_vars()
> > +{
> > +	local backing_dev="$1"
> > +	local tag="$2"
> > +	local target="$3"
> > +
> > +	test -z "$target" && target=error
> > +	local blk_dev_size=$(blockdev --getsz "$backing_dev")
> > +
> > +	eval export "DMLINEAR_${tag}TABLE=\"0 $blk_dev_size linear $backing_dev 0\""
> > +	eval export "DMERROR_${tag}TABLE=\"0 $blk_dev_size $target $backing_dev 0\""
> > +}
> > +
> >  _dmerror_setup()
> >  {
> > -	local dm_backing_dev=$SCRATCH_DEV
> > +	local rt_target=
> > +	local linear_target=
> >  
> > -	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
> > +	for arg in "$@"; do
> > +		case "${arg}" in
> > +		no_rt)		rt_target=linear;;
> > +		no_log)		log_target=linear;;
> > +		*)		echo "${arg}: Unknown _dmerror_setup arg.";;
> > +		esac
> > +	done
> >  
> > +	# Scratch device
> >  	export DMERROR_DEV='/dev/mapper/error-test'
> > +	_dmerror_setup_vars $SCRATCH_DEV
> >  
> > -	export DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
> > +	# Realtime device.  We reassign SCRATCH_RTDEV so that all the scratch
> > +	# helpers continue to work unmodified.
> > +	if [ -n "$SCRATCH_RTDEV" ]; then
> > +		if [ -z "$NON_ERROR_RTDEV" ]; then
> > +			# Set up the device switch
> > +			local dm_backing_dev=$SCRATCH_RTDEV
> > +			export NON_ERROR_RTDEV="$SCRATCH_RTDEV"
> > +			SCRATCH_RTDEV='/dev/mapper/error-rttest'
> > +		else
> > +			# Already set up; recreate tables
> > +			local dm_backing_dev="$NON_ERROR_RTDEV"
> > +		fi
> >  
> > -	export DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
> > +		_dmerror_setup_vars $dm_backing_dev RT $rt_target
> > +	fi
> > +
> > +	# External log device.  We reassign SCRATCH_LOGDEV so that all the
> > +	# scratch helpers continue to work unmodified.
> > +	if [ -n "$SCRATCH_LOGDEV" ]; then
> > +		if [ -z "$NON_ERROR_LOGDEV" ]; then
> > +			# Set up the device switch
> > +			local dm_backing_dev=$SCRATCH_LOGDEV
> > +			export NON_ERROR_LOGDEV="$SCRATCH_LOGDEV"
> > +			SCRATCH_LOGDEV='/dev/mapper/error-logtest'
> > +		else
> > +			# Already set up; recreate tables
> > +			local dm_backing_dev="$NON_ERROR_LOGDEV"
> > +		fi
> > +
> > +		_dmerror_setup_vars $dm_backing_dev LOG $log_target
> > +	fi
> >  }
> >  
> >  _dmerror_init()
> >  {
> > -	_dmerror_setup
> > +	_dmerror_setup "$@"
> > +
> >  	_dmsetup_remove error-test
> >  	_dmsetup_create error-test --table "$DMLINEAR_TABLE" || \
> >  		_fatal "failed to create dm linear device"
> > +
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		_dmsetup_remove error-rttest
> > +		_dmsetup_create error-rttest --table "$DMLINEAR_RTTABLE" || \
> > +			_fatal "failed to create dm linear rt device"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		_dmsetup_remove error-logtest
> > +		_dmsetup_create error-logtest --table "$DMLINEAR_LOGTABLE" || \
> > +			_fatal "failed to create dm linear log device"
> > +	fi
> >  }
> >  
> >  _dmerror_mount()
> > @@ -39,11 +102,27 @@ _dmerror_unmount()
> >  
> >  _dmerror_cleanup()
> >  {
> > +	test -n "$NON_ERROR_LOGDEV" && $DMSETUP_PROG resume error-logtest &>/dev/null
> > +	test -n "$NON_ERROR_RTDEV" && $DMSETUP_PROG resume error-rttest &>/dev/null
> >  	$DMSETUP_PROG resume error-test > /dev/null 2>&1
> > +
> >  	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> > +
> > +	test -n "$NON_ERROR_LOGDEV" && _dmsetup_remove error-logtest
> > +	test -n "$NON_ERROR_RTDEV" && _dmsetup_remove error-rttest
> >  	_dmsetup_remove error-test
> >  
> >  	unset DMERROR_DEV DMLINEAR_TABLE DMERROR_TABLE
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
> > +		unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		SCRATCH_RTDEV="$NON_ERROR_RTDEV"
> > +		unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
> > +	fi
> >  }
> >  
> >  _dmerror_load_error_table()
> > @@ -59,12 +138,47 @@ _dmerror_load_error_table()
> >  		suspend_opt="$*"
> >  	fi
> >  
> > +	# Suspend the scratch device before the log and realtime devices so
> > +	# that the kernel can freeze and flush the filesystem if the caller
> > +	# wanted a freeze.
> >  	$DMSETUP_PROG suspend $suspend_opt error-test
> >  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
> >  
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> > +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> > +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> > +	fi
> > +
> > +	# Load new table
> >  	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
> >  	load_res=$?
> >  
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
> > +		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
> > +		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
> > +	fi
> > +
> > +	# Resume devices in the opposite order that we suspended them.
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG resume error-logtest
> > +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG resume error-rttest
> > +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> > +	fi
> > +
> >  	$DMSETUP_PROG resume error-test
> >  	resume_res=$?
> >  
> > @@ -85,12 +199,47 @@ _dmerror_load_working_table()
> >  		suspend_opt="$*"
> >  	fi
> >  
> > +	# Suspend the scratch device before the log and realtime devices so
> > +	# that the kernel can freeze and flush the filesystem if the caller
> > +	# wanted a freeze.
> >  	$DMSETUP_PROG suspend $suspend_opt error-test
> >  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
> >  
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> > +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> > +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> > +	fi
> > +
> > +	# Load new table
> >  	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
> >  	load_res=$?
> >  
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG load error-rttest --table "$DMLINEAR_RTTABLE"
> > +		[ $? -ne 0 ] && _fail "failed to load working table into error-rttest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG load error-logtest --table "$DMLINEAR_LOGTABLE"
> > +		[ $? -ne 0 ] && _fail "failed to load working table into error-logtest"
> > +	fi
> > +
> > +	# Resume devices in the opposite order that we suspended them.
> > +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> > +		$DMSETUP_PROG resume error-logtest
> > +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> > +	fi
> > +
> > +	if [ -n "$NON_ERROR_RTDEV" ]; then
> > +		$DMSETUP_PROG resume error-rttest
> > +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> > +	fi
> > +
> >  	$DMSETUP_PROG resume error-test
> >  	resume_res=$?
> >  
> > diff --git a/tests/generic/441 b/tests/generic/441
> > index 0ec751da..85f29a3a 100755
> > --- a/tests/generic/441
> > +++ b/tests/generic/441
> > @@ -52,7 +52,7 @@ unset SCRATCH_RTDEV
> >  
> >  echo "Format and mount"
> >  _scratch_mkfs > $seqres.full 2>&1
> > -_dmerror_init
> > +_dmerror_init no_log
> >  _dmerror_mount
> >  
> >  _require_fs_space $SCRATCH_MNT 65536
> > diff --git a/tests/generic/487 b/tests/generic/487
> > index fda8828d..3c9b2233 100755
> > --- a/tests/generic/487
> > +++ b/tests/generic/487
> > @@ -45,7 +45,7 @@ unset SCRATCH_RTDEV
> >  
> >  echo "Format and mount"
> >  _scratch_mkfs > $seqres.full 2>&1
> > -_dmerror_init
> > +_dmerror_init no_log
> >  _dmerror_mount
> >  
> >  datalen=65536
> > 
> 
