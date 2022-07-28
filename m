Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7A8C19F29
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jul 2022 18:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiG1SQx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbiG1SQv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jul 2022 14:16:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1E2F52E61
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 11:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659032210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EPlsARbjYyAnVdHZvAkQPXdMP0CrLwS63z//t4b6wBU=;
        b=Gxt0o8Jq6pVoLkOTtw9OH31OSOXlfteAyU46GwT0oqFO396ov8uB7THVpuw1BR5rZrquh4
        Ydn6z64bdGNeJHI/oqEMr4rHL2YVnhepe12IZDLXqFyyvRXFRi4iqrwKoBmo6yjvmZt0Kk
        ZYqlLG7wf+A6Sea+L/hye2wxjcrtZuM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-eaOJLZ4dOaqv5MMZslqq5g-1; Thu, 28 Jul 2022 14:16:48 -0400
X-MC-Unique: eaOJLZ4dOaqv5MMZslqq5g-1
Received: by mail-qt1-f200.google.com with SMTP id bq10-20020a05622a1c0a00b0031ef98498a4so1502854qtb.19
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jul 2022 11:16:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EPlsARbjYyAnVdHZvAkQPXdMP0CrLwS63z//t4b6wBU=;
        b=o1eW+OT/Cwe4R9c6hBlvDg42JZNJo9vb5yRnfnA45nMKvp4xnftpTAhfpBrRWudPzO
         iS4xvntGfBadH5gvQsbUCylVUqhaISy4Wk61AIK8uqnc0w9fONK9XBDRv9wOh8lW1+gi
         S5dJYP2tX/vcP59CCa7TEERRzXTa5OsFwEA7ofhqoeNJD5+tom6Pt6tEYAMtluIkSsK+
         IMM8rc5BSVHOrkPppjgsSApViHaD3adOGtlFynKqOyq2/n/49Ia/Hnj8/PQEURLIi/Uf
         SVi9LXQGFoYZ9FFE8EdHZ/DIKpTk8XZH2Gldeyz2Ev5pVNlQ3EUyOW4kEIbxwoxdwz+Q
         Rfyg==
X-Gm-Message-State: AJIora/Gxey6jRAVz3wW3BS7YBoEjMvKcgF1CIzBDKpIF5PDbuTmcDsF
        RKrWpI2SPzS8puZuFVgmJC+uZR8kgaqId7vdkXA4RmhB1BTNqGSitPB0GZsIULlKGzsR9jJAuqP
        /rfs7JLHD5fycpeb7DsGv
X-Received: by 2002:a05:620a:454a:b0:6b6:dae:4d6e with SMTP id u10-20020a05620a454a00b006b60dae4d6emr80524qkp.281.1659032208392;
        Thu, 28 Jul 2022 11:16:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uf+7jLPoOmApLfrYg3jypg97ie/GpzT9dQTGpcLZscm8uoscKsVS/1Dh3QBZyJC+u4E59DJA==
X-Received: by 2002:a05:620a:454a:b0:6b6:dae:4d6e with SMTP id u10-20020a05620a454a00b006b60dae4d6emr80506qkp.281.1659032207958;
        Thu, 28 Jul 2022 11:16:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u186-20020a3792c3000000b006a67d257499sm1005695qkd.56.2022.07.28.11.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 11:16:47 -0700 (PDT)
Date:   Fri, 29 Jul 2022 02:16:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, tytso@mit.edu,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 2/2] dmerror: support external log and realtime devices
Message-ID: <20220728181641.3nzdhnh5bozxube3@zlang-mailbox>
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
              ^^
It should be log_target.

Others looks good to me, but as this patch affects many cases and other
filesystems, I'd like to give it more testing, and more review time for
others.

Thanks,
Zorro

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

