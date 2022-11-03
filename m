Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB87C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 03:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbiKCDMc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 23:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKCDMa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 23:12:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716C1408D
        for <linux-xfs@vger.kernel.org>; Wed,  2 Nov 2022 20:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667445091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WpVBJdp3pASK/O5eT38PtXdBP2N6KMN2EpRk1i/V9bM=;
        b=C8u/2+YDHC4BamnkDs9arlcG1Fvd7oEsKfij/QiR8BVdixiephDjEyrV/jWJX0QTAqYI2N
        xQdKgq8bt/EGEmAAkUNtVeBVs1/ArhTAt/KgT8iss4tziEuwTDWlw9+EtavKv2Jr0XYZ2L
        Daf+sNgyamj5RX2TNsb3YECRivItOIg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-335-k2M0_z_YPuiamKT7pb13ew-1; Wed, 02 Nov 2022 23:11:30 -0400
X-MC-Unique: k2M0_z_YPuiamKT7pb13ew-1
Received: by mail-qk1-f197.google.com with SMTP id u7-20020a05620a0c4700b006ee526183fcso877736qki.8
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2022 20:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpVBJdp3pASK/O5eT38PtXdBP2N6KMN2EpRk1i/V9bM=;
        b=F5bTD20yHABidnQOD4esL6j5gLyoooov7WzeyAtyFuEVdqMKQsFXr9gP94PD+z1BtZ
         6co7k+GCcLkjgGrml+Y7MiBLPNUwcGdPPE46tGZIL5+XkiID/7bKi6+aF3avjpjIAsDU
         NwAeLgrF2VzjrDx/m97umqCxvJ/u+3ErU1DtB3MuKGruXa9zAi2AE7Em3iGIyGwNwM6x
         nc7jD3ajlO/8CPU8ODsHx4m8Usr+Bm+JeFWzSsZWaSpK0xoDUfrCRC0ic6jHQqpl1JRB
         mV1aiKzaflfxnQCkH9bfe6NgaoInr5IyMMttsqsELH7lWycjdRzB6LyVgnhjDKLLzAOW
         KdLA==
X-Gm-Message-State: ACrzQf0b/tKShEqDVSuFyCHeCF5vuthY+0z5E37S9ITSuRII2H3s9eCB
        mzrVBu2G8tmf1H1Manfqj2b5GptqoU9GRxQkpKzR+6erBKj+ZXouOVWbedEXu7tad7m3JFyT5b0
        U8N0ls7vntrdaSXD8h3pk
X-Received: by 2002:a0c:aa04:0:b0:4b4:525e:c98a with SMTP id d4-20020a0caa04000000b004b4525ec98amr24480467qvb.95.1667445088744;
        Wed, 02 Nov 2022 20:11:28 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM56D/fJrGUCCjgIE24kAkElwHxKwalpCpJkdatKD6ILicXdL/Lb0F/SjgMtKwIgJEjUBkaozw==
X-Received: by 2002:a0c:aa04:0:b0:4b4:525e:c98a with SMTP id d4-20020a0caa04000000b004b4525ec98amr24480446qvb.95.1667445088390;
        Wed, 02 Nov 2022 20:11:28 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bs11-20020ac86f0b000000b0039cc82a319asm7680302qtb.76.2022.11.02.20.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 20:11:27 -0700 (PDT)
Date:   Thu, 3 Nov 2022 11:11:23 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: test xfs_scrub phase 6 media error reporting
Message-ID: <20221103031123.dtipsyq46wzbmp27@zlang-mailbox>
References: <166742857552.1499365.12368724681885402947.stgit@magnolia>
 <166742858119.1499365.3871531327329245525.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166742858119.1499365.3871531327329245525.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 02, 2022 at 03:36:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add new helpers to dmerror to provide for marking selected ranges
> totally bad -- both reads and writes will fail.  Create a new test for
> xfs_scrub to check that it reports media errors in data files correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/dmerror    |  140 ++++++++++++++++++++++++++++++++++++++++++++++++
>  common/xfs        |    9 +++
>  tests/xfs/747     |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/747.out |   12 ++++
>  4 files changed, 316 insertions(+)
>  create mode 100755 tests/xfs/747
>  create mode 100644 tests/xfs/747.out
> 
> 
> diff --git a/common/dmerror b/common/dmerror
> index 54122b12ea..ca71fc11b4 100644
> --- a/common/dmerror
> +++ b/common/dmerror
> @@ -250,3 +250,143 @@ _dmerror_load_working_table()
>  	[ $load_res -ne 0 ] && _fail "dmsetup failed to load error table"
>  	[ $resume_res -ne 0 ] && _fail  "dmsetup resume failed"
>  }
> +
> +# Given a list of (start, length) tuples on stdin, combine adjacent tuples into
> +# larger ones and write the new list to stdout.
> +__dmerror_combine_extents()
> +{
> +	awk 'BEGIN{start = 0; len = 0;}{
> +if (start + len == $1) {
> +	len += $2;
> +} else {
> +	if (len > 0)
> +		printf("%d %d\n", start, len);
> +	start = $1;
> +	len = $2;
> +}
> +} END {
> +	if (len > 0)
> +		printf("%d %d\n", start, len);
> +}'
> +}
> +
> +# Given a block device, the name of a preferred dm target, the name of an
> +# implied dm target, and a list of (start, len) tuples on stdin, create a new
> +# dm table which maps each of the tuples to the preferred target and all other
> +# areas to the implied dm target.
> +__dmerror_recreate_map()
> +{
> +	local device="$1"
> +	local preferred_tgt="$2"
> +	local implied_tgt="$3"
> +	local size=$(blockdev --getsz "$device")
> +
> +	local awk_program='
> +	BEGIN {
> +		implied_start = 0;
> +	}
> +	{
> +		extent_start = $1;
> +		extent_len = $2;
> +
> +		if (extent_start > size) {
> +			extent_start = size;
> +			extent_len = 0;
> +		} else if (extent_start + extent_len > size) {
> +			extent_len = size - extent_start;
> +		}
> +
> +		if (implied_start < extent_start)
> +			printf("%d %d %s %s %d\n", implied_start,
> +					extent_start - implied_start,
> +					implied_tgt, device, implied_start);
> +		printf("%d %d %s %s %d\n", extent_start, extent_len,
> +				preferred_tgt, device, extent_start);
> +		implied_start = extent_start + extent_len;
> +	}
> +	END {
> +		if (implied_start < size)
> +			printf("%d %d %s %s %d\n", implied_start,
> +					size - implied_start, implied_tgt,
> +					device, implied_start);
> +	}'
> +
> +	awk -v device="$device" -v size=$size -v implied_tgt="$implied_tgt" \
> +		-v preferred_tgt="$preferred_tgt" "$awk_program"

Hi,

OK, if you prefer this way, should __dmerror_combine_extents follow this way too :)

> +}
> +
> +# Update the dm error table so that the range (start, len) maps to the
> +# preferred dm target, overriding anything that maps to the implied dm target.
> +# This assumes that the only desired targets for this dm device are the
> +# preferred and and implied targets.  The fifth argument is the scratch device
> +# that we want to change the table for.
> +__dmerror_change()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local preferred_tgt="$3"
> +	local implied_tgt="$4"
> +	local whichdev="$5"
> +	local old_table
> +	local new_table
> +
> +	case "$whichdev" in
> +	"SCRATCH_DEV"|"")	whichdev="$SCRATCH_DEV";;
> +	"SCRATCH_LOGDEV"|"LOG")	whichdev="$NON_ERROR_LOGDEV";;
> +	"SCRATCH_RTDEV"|"RT")	whichdev="$NON_ERROR_RTDEV";;
> +	esac
> +
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		old_table="$DMERROR_TABLE";;
> +	"$NON_ERROR_LOGDEV")	old_table="$DMERROR_LOGTABLE";;
> +	"$NON_ERROR_RTDEV")	old_table="$DMERROR_RTTABLE";;
> +	*)
> +		echo "$whichdev: Unknown dmerror device."
> +		return
> +		;;
> +	esac
> +
> +	new_table="$( (echo "$old_table"; echo "$start $len $preferred_tgt") | \
> +		awk -v type="$preferred_tgt" '{if ($3 == type) print $0;}' | \
> +		sort -g | \
> +		__dmerror_combine_extents | \
> +		__dmerror_recreate_map "$whichdev" "$preferred_tgt" \
> +				"$implied_tgt" )"
> +
> +	case "$whichdev" in
> +	"$SCRATCH_DEV")		DMERROR_TABLE="$new_table";;
> +	"$NON_ERROR_LOGDEV")	DMERROR_LOGTABLE="$new_table";;
> +	"$NON_ERROR_RTDEV")	DMERROR_RTTABLE="$new_table";;
> +	esac
> +}
> +
> +# Reset the dm error table to everything ok.  The dm device itself must be
> +# remapped by calling _dmerror_load_error_table.
> +_dmerror_reset_table()
> +{
> +	DMERROR_TABLE="$DMLINEAR_TABLE"
> +	DMERROR_LOGTABLE="$DMLINEAR_LOGTABLE"
> +	DMERROR_RTTABLE="$DMLINEAR_RTTABLE"
> +}
> +
> +# Update the dm error table so that IOs to the given range will return EIO.
> +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> +_dmerror_mark_range_bad()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local dev="$3"
> +
> +	__dmerror_change "$start" "$len" error linear "$dev"
> +}
> +
> +# Update the dm error table so that IOs to the given range will succeed.
> +# The dm device itself must be remapped by calling _dmerror_load_error_table.
> +_dmerror_mark_range_good()
> +{
> +	local start="$1"
> +	local len="$2"
> +	local dev="$3"
> +
> +	__dmerror_change "$start" "$len" linear error "$dev"
> +}
> diff --git a/common/xfs b/common/xfs
> index 8ac1964e9c..f466d2c42f 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -218,6 +218,15 @@ _xfs_get_dir_blocksize()
>  	$XFS_INFO_PROG "$fs" | sed -n "s/^naming.*bsize=\([[:digit:]]*\).*/\1/p"
>  }
>  
> +# Decide if this path is a file on the realtime device
> +_xfs_is_realtime_file()
> +{
> +	if [ "$USE_EXTERNAL" != "yes" ] || [ -z "$SCRATCH_RTDEV" ]; then
> +		return 1
> +	fi
> +	$XFS_IO_PROG -c 'stat -v' "$1" | grep -q -w realtime
> +}
> +
>  # Set or clear the realtime status of every supplied path.  The first argument
>  # is either 'data' or 'realtime'.  All other arguments should be paths to
>  # existing directories or empty regular files.
> diff --git a/tests/xfs/747 b/tests/xfs/747
> new file mode 100755
> index 0000000000..8b828bc48d
> --- /dev/null
> +++ b/tests/xfs/747
> @@ -0,0 +1,155 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 747
> +#
> +# Check xfs_scrub's media scan can actually return diagnostic information for
> +# media errors in file data extents.
> +
> +. ./common/preamble
> +_begin_fstest auto quick scrub

Do we need "eio" at here?

Others look good to me.

Thanks,
Zorro

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_cleanup
> +}
> +
> +# Import common functions.
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/dmerror
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_dm_target error
> +_require_scratch
> +_require_scratch_xfs_crc
> +_require_scrub
> +
> +filter_scrub_errors() {
> +	_filter_scratch | sed \
> +		-e "s/offset $((fs_blksz * 2)) /offset 2FSB /g" \
> +		-e "s/length $fs_blksz.*/length 1FSB./g"
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +_dmerror_init
> +_dmerror_mount >> $seqres.full 2>&1
> +
> +_supports_xfs_scrub $SCRATCH_MNT $SCRATCH_DEV || _notrun "Scrub not supported"
> +
> +# Write a file with 4 file blocks worth of data
> +victim=$SCRATCH_MNT/a
> +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> +unset errordev
> +_xfs_is_realtime_file $victim && errordev="RT"
> +bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
> +echo "$errordev:$bmap_str" >> $seqres.full
> +
> +phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> +if [ "$errordev" = "RT" ]; then
> +	len="$(echo "$bmap_str" | $AWK_PROG '{print $4}')"
> +else
> +	len="$(echo "$bmap_str" | $AWK_PROG '{print $6}')"
> +fi
> +fs_blksz=$(_get_block_size $SCRATCH_MNT)
> +echo "file_blksz:$file_blksz:fs_blksz:$fs_blksz" >> $seqres.full
> +kernel_sectors_per_fs_block=$((fs_blksz / 512))
> +
> +# Did we get at least 4 fs blocks worth of extent?
> +min_len_sectors=$(( 4 * kernel_sectors_per_fs_block ))
> +test "$len" -lt $min_len_sectors && \
> +	_fail "could not format a long enough extent on an empty fs??"
> +
> +phys_start=$(echo "$phys" | sed -e 's/\.\..*//g')
> +
> +echo "$errordev:$phys:$len:$fs_blksz:$phys_start" >> $seqres.full
> +echo "victim file:" >> $seqres.full
> +od -tx1 -Ad -c $victim >> $seqres.full
> +
> +# Set the dmerror table so that all IO will pass through.
> +_dmerror_reset_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror before:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +# All sector numbers that we feed to the kernel must be in units of 512b, but
> +# they also must be aligned to the device's logical block size.
> +logical_block_size=$(_min_dio_alignment $SCRATCH_DEV)
> +kernel_sectors_per_device_lba=$((logical_block_size / 512))
> +
> +# Mark as bad one of the device LBAs in the middle of the extent.  Target the
> +# second LBA of the third block of the four-block file extent that we allocated
> +# earlier, but without overflowing into the fourth file block.
> +bad_sector=$(( phys_start + (2 * kernel_sectors_per_fs_block) ))
> +bad_len=$kernel_sectors_per_device_lba
> +if (( kernel_sectors_per_device_lba < kernel_sectors_per_fs_block )); then
> +	bad_sector=$((bad_sector + kernel_sectors_per_device_lba))
> +fi
> +if (( (bad_sector % kernel_sectors_per_device_lba) != 0)); then
> +	echo "bad_sector $bad_sector not congruent with device logical block size $logical_block_size"
> +fi
> +_dmerror_mark_range_bad $bad_sector $bad_len $errordev
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking bad:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +_dmerror_load_error_table
> +
> +# See if the media scan picks it up.
> +echo "Scrub for injected media error (single threaded)"
> +
> +# Once in single-threaded mode
> +_scratch_scrub -b -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Once in parallel mode
> +echo "Scrub for injected media error (multi threaded)"
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Remount to flush the page cache and reread to see the IO error
> +_dmerror_unmount
> +_dmerror_mount
> +echo "victim file:" >> $seqres.full
> +od -tx1 -Ad -c $victim >> $seqres.full 2> $tmp.error
> +cat $tmp.error | sed -e 's/read error: //g' | _filter_scratch
> +
> +# Scrub again to re-confirm the media error across a remount
> +echo "Scrub for injected media error (after remount)"
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# Now mark the bad range good so that a retest shows no media failure.
> +_dmerror_mark_range_good $bad_sector $bad_len $errordev
> +_dmerror_load_error_table
> +
> +cat >> $seqres.full << ENDL
> +dmerror after marking good:
> +$DMERROR_TABLE
> +$DMERROR_RTTABLE
> +<end table>
> +ENDL
> +
> +echo "Scrub after removing injected media error"
> +
> +# Scrub one last time to make sure the error's gone.
> +_scratch_scrub -x >> $seqres.full 2> $tmp.error
> +cat $tmp.error | filter_scrub_errors
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/747.out b/tests/xfs/747.out
> new file mode 100644
> index 0000000000..714ceb2e56
> --- /dev/null
> +++ b/tests/xfs/747.out
> @@ -0,0 +1,12 @@
> +QA output created by 747
> +Scrub for injected media error (single threaded)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +Scrub for injected media error (multi threaded)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +od: SCRATCH_MNT/a: Input/output error
> +Scrub for injected media error (after remount)
> +Unfixable Error: SCRATCH_MNT/a: media error at data offset 2FSB length 1FSB.
> +SCRATCH_MNT: unfixable errors found: 1
> +Scrub after removing injected media error
> 

