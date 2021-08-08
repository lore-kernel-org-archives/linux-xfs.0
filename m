Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97883C4320A
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Aug 2021 15:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A31D60720
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Aug 2021 15:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhHHP2B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Aug 2021 11:28:01 -0400
Received: from out20-86.mail.aliyun.com ([115.124.20.86]:35700 "EHLO
        out20-86.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhHHP2B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Aug 2021 11:28:01 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436392|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.00868954-0.000254152-0.991056;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.Kx2XgC8_1628436459;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.Kx2XgC8_1628436459)
          by smtp.aliyun-inc.com(10.147.40.26);
          Sun, 08 Aug 2021 23:27:40 +0800
Date:   Sun, 8 Aug 2021 23:27:39 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, tytso@mit.edu
Subject: Re: [PATCH 3/3] dmflakey: support external log and realtime devices
Message-ID: <YQ/365PeoTI87Tt4@desktop>
References: <162674334277.2651055.14927938006488444114.stgit@magnolia>
 <162674335915.2651055.17005305530614106697.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162674335915.2651055.17005305530614106697.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 19, 2021 at 06:09:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upgrade the dmerror code to coordinate making external scratch log and
> scratch realtime devices error out along with the scratch device.  Note
> that unlike SCRATCH_DEV, we save the old rt/log devices in a separate
> variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper
> functions continue to work properly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

This patch doesn't apply, seems like it's depending on context that
isn't upstreamed yet. I checked your branch and found that we're missing
patch "xfs: test xfs_scrub phase 6 media error reporting"

The patch in question has been posted for review in Mar., but it seems
it has some unresolved comments and has never been merged..

The first two patches look fine to me, and I'm taking them for this
update.

Thanks,
Eryu

>                                                                                                                                                                                                                    
> Upgrade the dmerror code to coordinate making external scratch log and                                                                                                                                             
> scratch realtime devices error out along with the scratch device.
> Note                                                                                                                                            
> that unlike SCRATCH_DEV, we save the old rt/log devices in a separate                                                                                                                                              
> variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper                                                                                                                                                  
> functions continue to work properly.                                                                                                                                                                               
>                                                          
> ---
>  common/dmerror    |  186 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  tests/generic/441 |    2 -
>  tests/generic/487 |    2 -
>  3 files changed, 178 insertions(+), 12 deletions(-)
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 7f6800c0..03f3fd97 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -4,30 +4,94 @@
>  #
>  # common functions for setting up and tearing down a dmerror device
>  
> +_dmerror_setup_vars()
> +{
> +	local backing_dev="$1"
> +	local tag="$2"
> +	local target="$3"
> +
> +	test -z "$target" && target=error
> +	local blk_dev_size=$(blockdev --getsz "$backing_dev")
> +
> +	eval export "DMLINEAR_${tag}TABLE=\"0 $blk_dev_size linear $backing_dev 0\""
> +	eval export "DMERROR_${tag}TABLE=\"0 $blk_dev_size $target $backing_dev 0\""
> +}
> +
>  _dmerror_setup()
>  {
> -	local dm_backing_dev=$SCRATCH_DEV
> +	local rt_target=
> +	local linear_target=
>  
> -	local blk_dev_size=`blockdev --getsz $dm_backing_dev`
> +	for arg in "$@"; do
> +		case "${arg}" in
> +		no_rt)		rt_target=linear;;
> +		no_log)		log_target=linear;;
> +		*)		echo "${arg}: Unknown _dmerror_setup arg.";;
> +		esac
> +	done
>  
> +	# Scratch device
>  	export DMERROR_DEV='/dev/mapper/error-test'
> +	_dmerror_setup_vars $SCRATCH_DEV
>  
> -	export DMLINEAR_TABLE="0 $blk_dev_size linear $dm_backing_dev 0"
> +	# Realtime device.  We reassign SCRATCH_RTDEV so that all the scratch
> +	# helpers continue to work unmodified.
> +	if [ -n "$SCRATCH_RTDEV" ]; then
> +		if [ -z "$NON_ERROR_RTDEV" ]; then
> +			# Set up the device switch
> +			local dm_backing_dev=$SCRATCH_RTDEV
> +			export NON_ERROR_RTDEV="$SCRATCH_RTDEV"
> +			SCRATCH_RTDEV='/dev/mapper/error-rttest'
> +		else
> +			# Already set up; recreate tables
> +			local dm_backing_dev="$NON_ERROR_RTDEV"
> +		fi
>  
> -	export DMERROR_TABLE="0 $blk_dev_size error $dm_backing_dev 0"
> +		_dmerror_setup_vars $dm_backing_dev RT $rt_target
> +	fi
> +
> +	# External log device.  We reassign SCRATCH_LOGDEV so that all the
> +	# scratch helpers continue to work unmodified.
> +	if [ -n "$SCRATCH_LOGDEV" ]; then
> +		if [ -z "$NON_ERROR_LOGDEV" ]; then
> +			# Set up the device switch
> +			local dm_backing_dev=$SCRATCH_LOGDEV
> +			export NON_ERROR_LOGDEV="$SCRATCH_LOGDEV"
> +			SCRATCH_LOGDEV='/dev/mapper/error-logtest'
> +		else
> +			# Already set up; recreate tables
> +			local dm_backing_dev="$NON_ERROR_LOGDEV"
> +		fi
> +
> +		_dmerror_setup_vars $dm_backing_dev LOG $log_target
> +	fi
>  }
>  
>  _dmerror_init()
>  {
> -	_dmerror_setup
> +	_dmerror_setup "$@"
> +
>  	_dmsetup_remove error-test
>  	_dmsetup_create error-test --table "$DMLINEAR_TABLE" || \
>  		_fatal "failed to create dm linear device"
> +
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		_dmsetup_remove error-rttest
> +		_dmsetup_create error-rttest --table "$DMLINEAR_RTTABLE" || \
> +			_fatal "failed to create dm linear rt device"
> +	fi
> +
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		_dmsetup_remove error-logtest
> +		_dmsetup_create error-logtest --table "$DMLINEAR_LOGTABLE" || \
> +			_fatal "failed to create dm linear log device"
> +	fi
>  }
>  
>  _dmerror_mount()
>  {
>  	_scratch_options mount
> +
>  	$MOUNT_PROG -t $FSTYP `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
>  		$DMERROR_DEV $SCRATCH_MNT
>  }
> @@ -39,11 +103,23 @@ _dmerror_unmount()
>  
>  _dmerror_cleanup()
>  {
> +	test -n "$NON_ERROR_LOGDEV" && $DMSETUP_PROG resume error-logtest &>/dev/null
> +	test -n "$NON_ERROR_RTDEV" && $DMSETUP_PROG resume error-rttest &>/dev/null
>  	$DMSETUP_PROG resume error-test > /dev/null 2>&1
> +
>  	$UMOUNT_PROG $SCRATCH_MNT > /dev/null 2>&1
> +
> +	test -n "$NON_ERROR_LOGDEV" && _dmsetup_remove error-logtest
> +	test -n "$NON_ERROR_RTDEV" && _dmsetup_remove error-rttest
>  	_dmsetup_remove error-test
>  
>  	unset DMERROR_DEV DMLINEAR_TABLE DMERROR_TABLE
> +
> +	SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
> +	unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
> +
> +	SCRATCH_RTDEV="$NON_ERROR_RTDEV"
> +	unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
>  }
>  
>  _dmerror_load_error_table()
> @@ -59,12 +135,47 @@ _dmerror_load_error_table()
>  		suspend_opt="$*"
>  	fi
>  
> +	# Suspend the scratch device before the log and realtime devices so
> +	# that the kernel can freeze and flush the filesystem if the caller
> +	# wanted a freeze.
>  	$DMSETUP_PROG suspend $suspend_opt error-test
>  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
>  
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> +	fi
> +
> +	# Load new table
>  	echo "$DMERROR_TABLE" | $DMSETUP_PROG load error-test
>  	load_res=$?
>  
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG load error-rttest --table "$DMERROR_RTTABLE"
> +		[ $? -ne 0 ] && _fail "failed to load error table into error-rttest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG load error-logtest --table "$DMERROR_LOGTABLE"
> +		[ $? -ne 0 ] && _fail "failed to load error table into error-logtest"
> +	fi
> +
> +	# Resume devices in the opposite order that we suspended them.
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG resume error-logtest
> +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG resume error-rttest
> +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> +	fi
> +
>  	$DMSETUP_PROG resume error-test
>  	resume_res=$?
>  
> @@ -85,12 +196,47 @@ _dmerror_load_working_table()
>  		suspend_opt="$*"
>  	fi
>  
> +	# Suspend the scratch device before the log and realtime devices so
> +	# that the kernel can freeze and flush the filesystem if the caller
> +	# wanted a freeze.
>  	$DMSETUP_PROG suspend $suspend_opt error-test
>  	[ $? -ne 0 ] && _fail  "dmsetup suspend failed"
>  
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG suspend $suspend_opt error-rttest
> +		[ $? -ne 0 ] && _fail "failed to suspend error-rttest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG suspend $suspend_opt error-logtest
> +		[ $? -ne 0 ] && _fail "failed to suspend error-logtest"
> +	fi
> +
> +	# Load new table
>  	$DMSETUP_PROG load error-test --table "$DMLINEAR_TABLE"
>  	load_res=$?
>  
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG load error-rttest --table "$DMLINEAR_RTTABLE"
> +		[ $? -ne 0 ] && _fail "failed to load working table into error-rttest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG load error-logtest --table "$DMLINEAR_LOGTABLE"
> +		[ $? -ne 0 ] && _fail "failed to load working table into error-logtest"
> +	fi
> +
> +	# Resume devices in the opposite order that we suspended them.
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		$DMSETUP_PROG resume error-logtest
> +		[ $? -ne 0 ] && _fail  "failed to resume error-logtest"
> +	fi
> +
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		$DMSETUP_PROG resume error-rttest
> +		[ $? -ne 0 ] && _fail  "failed to resume error-rttest"
> +	fi
> +
>  	$DMSETUP_PROG resume error-test
>  	resume_res=$?
>  
> @@ -157,20 +303,36 @@ __dmerror_recreate_map()
>  # Update the dm error table so that the range (start, len) maps to the
>  # preferred dm target, overriding anything that maps to the implied dm target.
>  # This assumes that the only desired targets for this dm device are the
> -# preferred and and implied targets.
> +# preferred and and implied targets.  The fifth argument is the scratch device
> +# that we want to change the table for.
>  __dmerror_change()
>  {
>  	local start="$1"
>  	local len="$2"
>  	local preferred_tgt="$3"
>  	local implied_tgt="$4"
> +	local whichdev="$5"
> +	test -z "$whichdev" && whichdev="$SCRATCH_DEV"
>  
> -	DMERROR_TABLE="$( (echo "$DMERROR_TABLE"; echo "$start $len $preferred_tgt") | \
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		old_table="$DMERROR_TABLE";;
> +	"$NON_ERROR_LOGDEV")	old_table="$DMERROR_LOGTABLE";;
> +	"$NON_ERROR_RTDEV")	old_table="$DMERROR_RTTABLE";;
> +	*)			echo "$whichdev: Unknown dmerror device."; return;;
> +	esac
> +
> +	new_table="$( (echo "$old_table"; echo "$start $len $preferred_tgt") | \
>  		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
>  		sort -g | \
>  		__dmerror_combine_extents | \
> -		__dmerror_recreate_map "$SCRATCH_DEV" "$preferred_tgt" \
> +		__dmerror_recreate_map "$whichdev" "$preferred_tgt" \
>  				"$implied_tgt" )"
> +
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		DMERROR_TABLE="$new_table";;
> +	"$NON_ERROR_LOGDEV")	DMERROR_LOGTABLE="$new_table";;
> +	"$NON_ERROR_RTDEV")	DMERROR_RTTABLE="$new_table";;
> +	esac
>  }
>  
>  # Reset the dm error table to everything ok.  The dm device itself must be
> @@ -178,6 +340,8 @@ __dmerror_change()
>  _dmerror_reset_table()
>  {
>  	DMERROR_TABLE="$DMLINEAR_TABLE"
> +	DMERROR_LOGTABLE="$DMLINEAR_LOGTABLE"
> +	DMERROR_RTTABLE="$DMLINEAR_RTTABLE"
>  }
>  
>  # Update the dm error table so that IOs to the given range will return EIO.
> @@ -186,8 +350,9 @@ _dmerror_mark_range_bad()
>  {
>  	local start="$1"
>  	local len="$2"
> +	local dev="$3"
>  
> -	__dmerror_change "$start" "$len" error linear
> +	__dmerror_change "$start" "$len" error linear "$dev"
>  }
>  
>  # Update the dm error table so that IOs to the given range will succeed.
> @@ -196,6 +361,7 @@ _dmerror_mark_range_good()
>  {
>  	local start="$1"
>  	local len="$2"
> +	local dev="$3"
>  
> -	__dmerror_change "$start" "$len" linear error
> +	__dmerror_change "$start" "$len" linear error "$dev"
>  }
> diff --git a/tests/generic/441 b/tests/generic/441
> index 0ec751da..85f29a3a 100755
> --- a/tests/generic/441
> +++ b/tests/generic/441
> @@ -52,7 +52,7 @@ unset SCRATCH_RTDEV
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> -_dmerror_init
> +_dmerror_init no_log
>  _dmerror_mount
>  
>  _require_fs_space $SCRATCH_MNT 65536
> diff --git a/tests/generic/487 b/tests/generic/487
> index fda8828d..3c9b2233 100755
> --- a/tests/generic/487
> +++ b/tests/generic/487
> @@ -45,7 +45,7 @@ unset SCRATCH_RTDEV
>  
>  echo "Format and mount"
>  _scratch_mkfs > $seqres.full 2>&1
> -_dmerror_init
> +_dmerror_init no_log
>  _dmerror_mount
>  
>  datalen=65536
