Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF03C678D4
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Mar 2023 15:57:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCFP5M (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Mar 2023 10:57:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCFP5L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2023 10:57:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B540311E5
        for <linux-xfs@vger.kernel.org>; Mon,  6 Mar 2023 07:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678118183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kF3XHNJjKYRYb9noKmsEw3SpoWngoXqwCw8qYuawGy4=;
        b=VVNOUl+4R6/QrWhoTlPVRuh6NvKjazE2eM/FwPomUlAvN03rn+YA4+i3TNT/39RGUQBNdR
        XtZa+4fLPchLaRfLm1e64i/npUPYT7TSplBf4e2yAg1GFQcNQLw549JiZx2Q0M/pZUhpHS
        bRSRoObJvtXAtX9BIo3wdRmOcSSPUjE=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-AozjCDSIPCSx3A05q10CuA-1; Mon, 06 Mar 2023 10:56:18 -0500
X-MC-Unique: AozjCDSIPCSx3A05q10CuA-1
Received: by mail-pf1-f199.google.com with SMTP id p36-20020a056a000a2400b005f72df7d97bso5660562pfh.19
        for <linux-xfs@vger.kernel.org>; Mon, 06 Mar 2023 07:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678118177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kF3XHNJjKYRYb9noKmsEw3SpoWngoXqwCw8qYuawGy4=;
        b=Gz6RfSZ5/ANxhw/wzHdKR/rylbx684yKK5H8cSifOuFW56JXc4zErUzFB7PjKvVMgH
         BlZHYT0jnCJw/sqL2uBsXmYjqunlUPYWvEYlHDf0/RVY7RbMoDefg5WSz/tuEJAsFIOs
         Ha86xmOCyLR7HmVeaWuRAYSlEG65Fkmi0xNVr1aUQi4PxVQpd5t8GIbK8ASkP/O7KRAn
         N43JrI8T6pqZnya/ksLxDwTiec4SEg5iihAPSj3tWv6qkG8B/WAXio1rYBFWUUrUmk5Y
         x8AKQv+4uP069VXhEvbhMypRF7bK9PDN2jL6fGCChs/ielxcMobHiPO2vx9KwFniAeAu
         cyWQ==
X-Gm-Message-State: AO0yUKXGfLu8xqKj193f/pMEqnmQMJZ84d8g2eM1+1ihMGYgaecT/aOY
        rqR2U+mnW7bG7M2Urn0yvEMxRqFgsNW3ICpbpvM8EMttDu4S3s3T59S/LwJXzKmrcNAZMCfTkiY
        U6+8/TK7jmQIB7izDpyVo
X-Received: by 2002:aa7:9405:0:b0:5aa:4df7:7ef6 with SMTP id x5-20020aa79405000000b005aa4df77ef6mr11166306pfo.7.1678118176819;
        Mon, 06 Mar 2023 07:56:16 -0800 (PST)
X-Google-Smtp-Source: AK7set9BiIhuS0z2qb44wa6x9EaIShhYApDwKwUIIxyBXVaqU3nGnZFyJmZbNPVfOrc176HjIHN4kw==
X-Received: by 2002:aa7:9405:0:b0:5aa:4df7:7ef6 with SMTP id x5-20020aa79405000000b005aa4df77ef6mr11166293pfo.7.1678118176384;
        Mon, 06 Mar 2023 07:56:16 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79151000000b005cc52ea452csm6472876pfi.100.2023.03.06.07.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 07:56:16 -0800 (PST)
Date:   Mon, 6 Mar 2023 23:56:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test upgrading old features
Message-ID: <20230306155611.6w6mn3k7owsc2jz7@zlang-mailbox>
References: <167243882949.736459.9627363155663418213.stgit@magnolia>
 <167243882961.736459.4302174338740527578.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243882961.736459.4302174338740527578.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:20:29PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Test the ability to add older v5 features.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/769     |  248 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/769.out |    2 
>  2 files changed, 250 insertions(+)
>  create mode 100755 tests/xfs/769
>  create mode 100644 tests/xfs/769.out
> 
> 
> diff --git a/tests/xfs/769 b/tests/xfs/769
> new file mode 100755
> index 0000000000..7613048f52
> --- /dev/null
> +++ b/tests/xfs/769
> @@ -0,0 +1,248 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 769
> +#
> +# Test upgrading filesystems with new features.
> +#
> +. ./common/preamble
> +_begin_fstest auto mkfs repair
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/populate
> +
> +# real QA test starts here
> +_supported_fs xfs
> +
> +test -w /dev/ttyprintk || _notrun "test requires writable /dev/ttyprintk"

Hi Darrick,

I'm not sure why /dev/ttyprintk is necessary. I think sometimes we might not
have this driver, but has /dev/kmsg. Can /dev/kmsg be a replacement of
ttyprintk ?

Thanks,
Zorro


> +_require_check_dmesg
> +_require_scratch_nocheck
> +_require_scratch_xfs_crc
> +
> +# Does repair know how to add a particular feature to a filesystem?
> +check_repair_upgrade()
> +{
> +	$XFS_REPAIR_PROG -c "$1=narf" 2>&1 | \
> +		grep -q 'unknown option' && return 1
> +	return 0
> +}
> +
> +# Are we configured for realtime?
> +rt_configured()
> +{
> +	test "$USE_EXTERNAL" = "yes" && test -n "$SCRATCH_RTDEV"
> +}
> +
> +# Compute the MKFS_OPTIONS string for a particular feature upgrade test
> +compute_mkfs_options()
> +{
> +	local m_opts=""
> +	local caller_options="$MKFS_OPTIONS"
> +
> +	for feat in "${FEATURES[@]}"; do
> +		local feat_state="${FEATURE_STATE["${feat}"]}"
> +
> +		if echo "$caller_options" | grep -E -w -q "${feat}=[0-9]*"; then
> +			# Change the caller's options
> +			caller_options="$(echo "$caller_options" | \
> +				sed -e "s/\([^[:alnum:]]\)${feat}=[0-9]*/\1${feat}=${feat_state}/g")"
> +		else
> +			# Add it to our list of new mkfs flags
> +			m_opts="${feat}=${feat_state},${m_opts}"
> +		fi
> +	done
> +
> +	test -n "$m_opts" && m_opts=" -m $m_opts"
> +
> +	echo "$caller_options$m_opts"
> +}
> +
> +# Log the start of an upgrade.
> +function upgrade_start_message()
> +{
> +	local feat="$1"
> +
> +	echo "Add $feat to filesystem"
> +}
> +
> +# Find dmesg log messages since we started a particular upgrade test
> +function dmesg_since_feature_upgrade_start()
> +{
> +	local feat_logmsg="$(upgrade_start_message "$1")"
> +
> +	# search the dmesg log of last run of $seqnum for possible failures
> +	# use sed \cregexpc address type, since $seqnum contains "/"
> +	dmesg | \
> +		tac | \
> +		sed -ne "0,\#run fstests $seqnum at $date_time#p" | \
> +		sed -ne "0,\#${feat_logmsg}#p" | \
> +		tac
> +}
> +
> +# Did the mount fail because this feature is not supported?
> +function feature_unsupported()
> +{
> +	local feat="$1"
> +
> +	dmesg_since_feature_upgrade_start "$feat" | \
> +		grep -q 'has unknown.*features'
> +}
> +
> +# Exercise the scratch fs
> +function scratch_fsstress()
> +{
> +	echo moo > $SCRATCH_MNT/sample.txt
> +	$FSSTRESS_PROG -n $((TIME_FACTOR * 1000)) -p $((LOAD_FACTOR * 4)) \
> +		-d $SCRATCH_MNT/data >> $seqres.full
> +}
> +
> +# Exercise the filesystem a little bit and emit a manifest.
> +function pre_exercise()
> +{
> +	local feat="$1"
> +
> +	_try_scratch_mount &> $tmp.mount
> +	res=$?
> +	# If the kernel doesn't support the filesystem even after a
> +	# fresh format, skip the rest of the upgrade test quietly.
> +	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
> +		echo "mount failed due to unsupported feature $feat" >> $seqres.full
> +		return 1
> +	fi
> +	if [ $res -ne 0 ]; then
> +		cat $tmp.mount
> +		echo "mount failed with $res before upgrading to $feat" | \
> +			tee -a $seqres.full
> +		return 1
> +	fi
> +
> +	scratch_fsstress
> +	find $SCRATCH_MNT -type f -print0 | xargs -r -0 md5sum > $tmp.manifest
> +	_scratch_unmount
> +	return 0
> +}
> +
> +# Check the manifest and exercise the filesystem more
> +function post_exercise()
> +{
> +	local feat="$1"
> +
> +	_try_scratch_mount &> $tmp.mount
> +	res=$?
> +	# If the kernel doesn't support the filesystem even after a
> +	# fresh format, skip the rest of the upgrade test quietly.
> +	if [ $res -eq 32 ] && feature_unsupported "$feat"; then
> +		echo "mount failed due to unsupported feature $feat" >> $seqres.full
> +		return 1
> +	fi
> +	if [ $res -ne 0 ]; then
> +		cat $tmp.mount
> +		echo "mount failed with $res after upgrading to $feat" | \
> +			tee -a $seqres.full
> +		return 1
> +	fi
> +
> +	md5sum --quiet -c $tmp.manifest || \
> +		echo "fs contents ^^^ changed after adding $feat"
> +
> +	iam="check" _check_scratch_fs || \
> +		echo "scratch fs check failed after adding $feat"
> +
> +	# Try to mount the fs in case the check unmounted it
> +	_try_scratch_mount &>> $seqres.full
> +
> +	scratch_fsstress
> +
> +	iam="check" _check_scratch_fs || \
> +		echo "scratch fs check failed after exercising $feat"
> +
> +	# Try to unmount the fs in case the check didn't
> +	_scratch_unmount &>> $seqres.full
> +	return 0
> +}
> +
> +# Create a list of fs features in the order that support for them was added
> +# to the kernel driver.  For each feature upgrade test, we enable all the
> +# features that came before it and none of the ones after, which means we're
> +# testing incremental migrations.  We start each run with a clean fs so that
> +# errors and unsatisfied requirements (log size, root ino position, etc) in one
> +# upgrade don't spread failure to the rest of the tests.
> +FEATURES=()
> +if rt_configured; then
> +	check_repair_upgrade finobt && FEATURES+=("finobt")
> +	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
> +	check_repair_upgrade bigtime && FEATURES+=("bigtime")
> +else
> +	check_repair_upgrade finobt && FEATURES+=("finobt")
> +	check_repair_upgrade rmapbt && FEATURES+=("rmapbt")
> +	check_repair_upgrade reflink && FEATURES+=("reflink")
> +	check_repair_upgrade inobtcount && FEATURES+=("inobtcount")
> +	check_repair_upgrade bigtime && FEATURES+=("bigtime")
> +fi
> +
> +test "${#FEATURES[@]}" -eq 0 && \
> +	_notrun "xfs_repair does not know how to add V5 features"
> +
> +declare -A FEATURE_STATE
> +for f in "${FEATURES[@]}"; do
> +	FEATURE_STATE["$f"]=0
> +done
> +
> +for feat in "${FEATURES[@]}"; do
> +	echo "-----------------------" >> $seqres.full
> +
> +	upgrade_start_message "$feat" | tee -a $seqres.full /dev/ttyprintk > /dev/null
> +
> +	opts="$(compute_mkfs_options)"
> +	echo "mkfs.xfs $opts" >> $seqres.full
> +
> +	# Format filesystem
> +	MKFS_OPTIONS="$opts" _scratch_mkfs &>> $seqres.full
> +	res=$?
> +	outcome="mkfs returns $res for $feat upgrade test"
> +	echo "$outcome" >> $seqres.full
> +	if [ $res -ne 0 ]; then
> +		echo "$outcome"
> +		continue
> +	fi
> +
> +	# Create some files to make things interesting.
> +	pre_exercise "$feat" || break
> +
> +	# Upgrade the fs
> +	_scratch_xfs_repair -c "${feat}=1" &> $tmp.upgrade
> +	res=$?
> +	cat $tmp.upgrade >> $seqres.full
> +	grep -q "^Adding" $tmp.upgrade || \
> +		echo "xfs_repair ignored command to add $feat"
> +
> +	outcome="xfs_repair returns $res while adding $feat"
> +	echo "$outcome" >> $seqres.full
> +	if [ $res -ne 0 ]; then
> +		# Couldn't upgrade filesystem, move on to the next feature.
> +		FEATURE_STATE["$feat"]=1
> +		continue
> +	fi
> +
> +	# Make sure repair runs cleanly afterwards
> +	_scratch_xfs_repair -n &>> $seqres.full
> +	res=$?
> +	outcome="xfs_repair -n returns $res after adding $feat"
> +	echo "$outcome" >> $seqres.full
> +	if [ $res -ne 0 ]; then
> +		echo "$outcome"
> +	fi
> +
> +	# Make sure we can still exercise the filesystem.
> +	post_exercise "$feat" || break
> +
> +	# Update feature state for next run
> +	FEATURE_STATE["$feat"]=1
> +done
> +
> +# success, all done
> +echo Silence is golden.
> +status=0
> +exit
> diff --git a/tests/xfs/769.out b/tests/xfs/769.out
> new file mode 100644
> index 0000000000..332432db97
> --- /dev/null
> +++ b/tests/xfs/769.out
> @@ -0,0 +1,2 @@
> +QA output created by 769
> +Silence is golden.
> 

