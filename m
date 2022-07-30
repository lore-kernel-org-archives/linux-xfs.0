Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 460B4C3F6B0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Jul 2022 10:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiG3KSr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Jul 2022 06:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiG3KSq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Jul 2022 06:18:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72AA429CAE
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 03:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659176323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EvLnNnP58OKkIgJ5D0YkweohrzJNaQlrCElpenwGRtU=;
        b=cwRhYVrh5c8yGM8IcrFXeFYiDod/N1VtUnkzBP4aBLORyXKxsnYWcfSUX8d/P3WH/AwCNd
        HSvVgjbzJEM/opOqzgaipCJIIPYZ1mbGOoiGAjvNzl0qH1LxbooC5kIhWR3CPED1sAerIq
        IEDUcjC1OCxY7/bZDOB/DIs5AvFGBok=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-gSGZQj72Omm0LfcXoMuAog-1; Sat, 30 Jul 2022 06:18:42 -0400
X-MC-Unique: gSGZQj72Omm0LfcXoMuAog-1
Received: by mail-ot1-f71.google.com with SMTP id f95-20020a9d03e8000000b0061c75d3deaaso2942571otf.12
        for <linux-xfs@vger.kernel.org>; Sat, 30 Jul 2022 03:18:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EvLnNnP58OKkIgJ5D0YkweohrzJNaQlrCElpenwGRtU=;
        b=t9iFB5qvR6VqsrFvoO30MsD0Q1hpr0OFUgbFlL1NPPh6It8gP6A1G+yq2UBDZ4scQF
         PdmUJClRthOZzylcgxc1Z93MYMRQDIr7yhGBb5aPBqYa9vfTcr2BEFe0GOtbs0Y81CFp
         FJ55FK3wwzErgbQl1FvegkAT46Z4JGX+kzoJukx8zDldeALSWUPSXjWBKQKm+ebev/9i
         38aGzsyTqVtHfuHW7LYitjl0JiaaZOs6tfmWtTlkWGSdyyvwWG4dJEnr9t4dZWifkjOT
         jwRJ0iq1NxhHL4S0qILIuiGh8V1iEraQRsggYZHerbtbMkgqHCmIWmKTlB1D2D6uBIfS
         QW8A==
X-Gm-Message-State: AJIora+lo1XaiKRLKIG3f94DGrRiKYy/11gxLWXc2ao9pQIYN3628Gx2
        ghi/X1Ux53Uv1wXxr3Tdgg6hzKgtfqnHLT12thVoeIloQnWPI3FJWToVPURvYlhP/ka/uiIVQRE
        ARKBBoTrRz7xCvUghlyNK
X-Received: by 2002:a05:6830:280e:b0:61d:401:afe1 with SMTP id w14-20020a056830280e00b0061d0401afe1mr2874283otu.358.1659176321111;
        Sat, 30 Jul 2022 03:18:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uxmzC8wNe+ieIfNWji3bCpaRyYXaRjM1cdXZ8erYeWmVG3ohg8JzbOKlZmBYpcQfECIgEnBw==
X-Received: by 2002:a05:6830:280e:b0:61d:401:afe1 with SMTP id w14-20020a056830280e00b0061d0401afe1mr2874268otu.358.1659176320743;
        Sat, 30 Jul 2022 03:18:40 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id er11-20020a056870c88b00b0010bf07976c9sm1800481oab.41.2022.07.30.03.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jul 2022 03:18:40 -0700 (PDT)
Date:   Sat, 30 Jul 2022 18:18:34 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 2/2] dmerror: support external log and realtime devices
Message-ID: <20220730101834.6nscxoc2u3wfy7nq@zlang-mailbox>
References: <165886491119.1585061.14285332087646848837.stgit@magnolia>
 <165886492259.1585061.11384715139979799178.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165886492259.1585061.11384715139979799178.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 26, 2022 at 12:48:42PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Upgrade the dmerror code to coordinate making external scratch log and
> scratch realtime devices error out along with the scratch device.  Note
> that unlike SCRATCH_DEV, we save the old rt/log devices in a separate
> variable and overwrite SCRATCH_{RT,LOG}DEV so that all the helper
> functions continue to work properly.
> 
> This is very similar to what we did for dm-flakey a while back.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Hi Darrick,

I'll merge the patch 1/2 this week, but this 2/2 looks like bring in new
failures on ext4 with local.config as [0], for example[1], which is passed[2]
without this patch. It's fine on Btrfs and xfs for me.

Thanks,
Zorro

[0]
export TEST_DEV=/dev/sda5
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/sda3
export SCRATCH_MNT=/mnt/scratch
export USE_EXTERNAL=yes
export SCRATCH_LOGDEV=/dev/loop0

[1]
generic/338 4s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/338.out.bad)
    --- tests/generic/338.out   2022-04-29 23:07:23.330499055 +0800
    +++ /root/git/xfstests/results//logdev/generic/338.out.bad  2022-07-30 18:01:41.900765965 +0800
    @@ -1,2 +1,4 @@
     QA output created by 338   
     Silence is golden
    +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
    +       dmesg(1) may have more information after failed mount system call.
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/338.out /root/git/xfstests/results//logdev/generic/338.out.bad'  to see the entire diff)
generic/441 5s ... - output mismatch (see /root/git/xfstests/results//logdev/generic/441.out.bad)
    --- tests/generic/441.out   2022-04-29 23:07:23.406499916 +0800
    +++ /root/git/xfstests/results//logdev/generic/441.out.bad  2022-07-30 18:01:46.829822438 +0800
    @@ -1,3 +1,6 @@
     QA output created by 441   
     Format and mount
    -Test passed!
    +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/error-test, missing codepage or helper program, or other error.
    +       dmesg(1) may have more information after failed mount system call.
    +Success on second fsync on fd[0]!
    +umount: /mnt/scratch: not mounted.
    ...
    (Run 'diff -u /root/git/xfstests/tests/generic/441.out /root/git/xfstests/results//logdev/generic/441.out.bad'  to see the entire diff)

[2]
generic/338 4s ...  5s
generic/441 5s ...  5s
generic/442 3s ...  3s


>  common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  tests/generic/441 |    2 -
>  tests/generic/487 |    2 -
>  3 files changed, 156 insertions(+), 7 deletions(-)
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 01a4c8b5..85ef9a16 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -4,25 +4,88 @@
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
> @@ -39,11 +102,27 @@ _dmerror_unmount()
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
> +	if [ -n "$NON_ERROR_LOGDEV" ]; then
> +		SCRATCH_LOGDEV="$NON_ERROR_LOGDEV"
> +		unset NON_ERROR_LOGDEV DMLINEAR_LOGTABLE DMERROR_LOGTABLE
> +	fi
> +
> +	if [ -n "$NON_ERROR_RTDEV" ]; then
> +		SCRATCH_RTDEV="$NON_ERROR_RTDEV"
> +		unset NON_ERROR_RTDEV DMLINEAR_RTTABLE DMERROR_RTTABLE
> +	fi
>  }
>  
>  _dmerror_load_error_table()
> @@ -59,12 +138,47 @@ _dmerror_load_error_table()
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
>  	$DMSETUP_PROG load error-test --table "$DMERROR_TABLE"
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
> @@ -85,12 +199,47 @@ _dmerror_load_working_table()
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
> 

