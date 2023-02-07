Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6742CC636D4
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Feb 2023 18:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjBGStL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Feb 2023 13:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBGStK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Feb 2023 13:49:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F7F44BD
        for <linux-xfs@vger.kernel.org>; Tue,  7 Feb 2023 10:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HwxaycivPtx8dV47PWRIaUwEgwp1m9I9BIsrXJes8IU=;
        b=Ul1e6lnsfOLch9U+bqKLwf4BAL5yeN9Gn5ongderzPpk/p0KSx32GhDak2V8K0v44KQcIH
        xA149SZoH2d85W4rVSfIc7cEl4IUSra95SH5Mg21Io+WJYsfVlnO0LYe4QFbz3PLctx9Iw
        G/O8TOh0aRXZmHOWXbLQFmr3MVAPQ+0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-381-Bro0p8CyN5e4az22zytHYA-1; Tue, 07 Feb 2023 13:48:17 -0500
X-MC-Unique: Bro0p8CyN5e4az22zytHYA-1
Received: by mail-pl1-f198.google.com with SMTP id ik17-20020a170902ab1100b00198d8abcbcdso7097193plb.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Feb 2023 10:48:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HwxaycivPtx8dV47PWRIaUwEgwp1m9I9BIsrXJes8IU=;
        b=zPEL53LKDUoyzZO314HUWb7Ct7ukr2+4pkIb8dZFlaU4TMs6RLepF4yA5VlNN6ydko
         sgAAL5KTDi8tvFVREMZU+QT8clRV/hNizzC3T7o8d4l36gNBSNJvRJxDrXV3jSfQo/4i
         aWPkNKDyafoLHdc51dMj69AqjJNiquiR7eTKt8tEdJVGvGOf8cVSOmABAYJdUCxFXZca
         bpPiROVvwhzBdJe367KAkWUDR79/f05vmapUBi54at8WaCAa7TBK29IJYe/EhF8pMzHv
         lKdBgGK9D1g4FoC123ptYc1v9RGt9PlcwmolDMuz6+7rjquyX1Bsq1i5GwMeN8uqlk1K
         qCZg==
X-Gm-Message-State: AO0yUKVxMMX/aTu7pgYzextjO25IgMXXcBViReGgilNm/AzoZhfQtXxt
        EnHGBi38ETd59g6vKutYr3iwNEFUToi3UBkMMaaf7UqTYoFXEtLFFlbU0VwpayyMXviFBjWZVaH
        q0fCCEbO0lriUk/glb7W0N0H/WjJsBi0=
X-Received: by 2002:a05:6a20:8e0f:b0:be:c7a3:2b91 with SMTP id y15-20020a056a208e0f00b000bec7a32b91mr5628046pzj.0.1675795695947;
        Tue, 07 Feb 2023 10:48:15 -0800 (PST)
X-Google-Smtp-Source: AK7set/MqWPzFsfpzOGhusYJGE6dkdRssCq4RLcwqA6nuZBFU8L4KoD9CqwpTRyPKRrtFr8t8cuxYw==
X-Received: by 2002:a05:6a20:8e0f:b0:be:c7a3:2b91 with SMTP id y15-20020a056a208e0f00b000bec7a32b91mr5628025pzj.0.1675795695665;
        Tue, 07 Feb 2023 10:48:15 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id a22-20020a637056000000b004fb179066e1sm1484177pgn.65.2023.02.07.10.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 10:48:15 -0800 (PST)
Date:   Wed, 8 Feb 2023 02:48:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 4/5] fuzzy: allow xfs scrub stress tests to pick
 preconfigured fsstress configs
Message-ID: <20230207184811.5q3or7b267343l25@zlang-mailbox>
References: <167243874614.722028.11987534226186856347.stgit@magnolia>
 <167243874662.722028.15090629914232187990.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243874662.722028.15090629914232187990.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make it so that xfs_scrub stress tests can select what kind of fsstress
> operations they want to run.  This will make it easier for, say,
> directory scrubbers to configure fsstress to exercise directory tree
> changes while skipping file data updates, because those are irrelevant.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/fuzzy |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/common/fuzzy b/common/fuzzy
> index e39f787e78..c4a5bc9261 100644
> --- a/common/fuzzy
> +++ b/common/fuzzy
> @@ -466,6 +466,7 @@ __stress_scrub_fsx_loop() {
>  	local end="$1"
>  	local runningfile="$2"
>  	local remount_period="$3"
> +	local stress_tgt="$4"	# ignored
>  	local focus=(-q -X)	# quiet, validate file contents
>  
>  	# As of November 2022, 2 million fsx ops should be enough to keep
> @@ -528,10 +529,70 @@ __stress_scrub_fsstress_loop() {
>  	local end="$1"
>  	local runningfile="$2"
>  	local remount_period="$3"
> +	local stress_tgt="$4"
> +	local focus=()
> +
> +	case "$stress_tgt" in
> +	"dir")
> +		focus+=('-z')
> +
> +		# Create a directory tree rapidly
> +		for op in creat link mkdir mknod symlink; do
> +			focus+=('-f' "${op}=8")
> +		done
> +		focus+=('-f' 'rmdir=2' '-f' 'unlink=8')
> +
> +		# Rename half as often
> +		for op in rename rnoreplace rexchange; do
> +			focus+=('-f' "${op}=4")
> +		done
> +
> +		# Read and sync occasionally
> +		for op in getdents stat fsync; do
> +			focus+=('-f' "${op}=1")
> +		done
> +		;;
> +	"xattr")
> +		focus+=('-z')
> +
> +		# Create a directory tree slowly
> +		for op in creat ; do
> +			focus+=('-f' "${op}=2")
> +		done
> +		for op in unlink rmdir; do
> +			focus+=('-f' "${op}=1")
> +		done
> +
> +		# Create xattrs rapidly
> +		for op in attr_set setfattr; do
> +			focus+=('-f' "${op}=80")
> +		done
> +
> +		# Remove xattrs 1/4 as quickly
> +		for op in attr_remove removefattr; do
> +			focus+=('-f' "${op}=20")
> +		done
> +
> +		# Read and sync occasionally
> +		for op in listfattr getfattr fsync; do
> +			focus+=('-f' "${op}=10")
> +		done
> +		;;
> +	"writeonly")
> +		# Only do things that cause filesystem writes
> +		focus+=('-w')
> +		;;
> +	"default")
> +		# No new arguments
> +		;;
> +	*)
> +		echo "$stress_tgt: Unrecognized stress target, using defaults."
> +		;;
> +	esac
>  
>  	# As of March 2022, 2 million fsstress ops should be enough to keep
>  	# any filesystem busy for a couple of hours.
> -	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 $FSSTRESS_AVOID)
> +	local args=$(_scale_fsstress_args -p 4 -d $SCRATCH_MNT -n 2000000 "${focus[@]}" $FSSTRESS_AVOID)
>  	echo "Running $FSSTRESS_PROG $args" >> $seqres.full
>  
>  	if [ -n "$remount_period" ]; then
> @@ -691,6 +752,14 @@ __stress_scrub_check_commands() {
>  # -w	Delay the start of the scrub/repair loop by this number of seconds.
>  #	Defaults to no delay unless XFS_SCRUB_STRESS_DELAY is set.  This value
>  #	will be clamped to ten seconds before the end time.
> +# -x	Focus on this type of fsstress operation.  Possible values:
> +#
> +#       'dir': Grow the directory trees as much as possible.
> +#       'xattr': Grow extended attributes in a small tree.
> +#       'default': Run fsstress with default arguments.
> +#       'writeonly': Only perform fs updates, no reads.
> +#
> +#       The default is 'default' unless XFS_SCRUB_STRESS_TARGET is set.
>  # -X	Run this program to exercise the filesystem.  Currently supported
>  #       options are 'fsx' and 'fsstress'.  The default is 'fsstress'.
>  _scratch_xfs_stress_scrub() {
> @@ -703,6 +772,7 @@ _scratch_xfs_stress_scrub() {
>  	local exerciser="fsstress"
>  	local io_args=()
>  	local remount_period="${XFS_SCRUB_STRESS_REMOUNT_PERIOD}"
> +	local stress_tgt="${XFS_SCRUB_STRESS_TARGET:-default}"
>  
>  	__SCRUB_STRESS_FREEZE_PID=""
>  	__SCRUB_STRESS_REMOUNT_LOOP=""
> @@ -710,7 +780,7 @@ _scratch_xfs_stress_scrub() {
>  	touch "$runningfile"
>  
>  	OPTIND=1
> -	while getopts "fi:r:s:S:t:w:X:" c; do
> +	while getopts "fi:r:s:S:t:w:x:X:" c; do
>  		case "$c" in
>  			f) freeze=yes;;
>  			i) io_args+=("$OPTARG");;
> @@ -719,6 +789,7 @@ _scratch_xfs_stress_scrub() {
>  			S) xfs_scrub_args+=("$OPTARG");;
>  			t) scrub_tgt="$OPTARG";;
>  			w) scrub_delay="$OPTARG";;
> +			x) stress_tgt="$OPTARG";;
>  			X) exerciser="$OPTARG";;
>  			*) return 1; ;;
>  		esac
> @@ -757,7 +828,7 @@ _scratch_xfs_stress_scrub() {
>  	fi
>  
>  	"__stress_scrub_${exerciser}_loop" "$end" "$runningfile" \
> -			"$remount_period" &
> +			"$remount_period" "$stress_tgt" &
>  
>  	if [ -n "$freeze" ]; then
>  		__stress_scrub_freeze_loop "$end" "$runningfile" &
> 

