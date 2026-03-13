Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39FC3E1217
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430584; cv=none; b=V6LrMmyMDDSMxJNRX+RV8mtMKYz0P94+9AFTzAfq/NAkqBfzxOP5ZfjBJdtqPc1/fUyfTfvG6Rd0j+e+buzWQDbcdQxKWPlmGMKt/HZ1a134hmqbRz49sOtPPV7CD/i5RlXz1/asP7GSOiNxq/XqULKJK7HYk5ZG6chp68vg5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430584; c=relaxed/simple;
	bh=s75qgKoKq+vNltbFCY5W99sUuXGovgNbY/Z7Z0RTqao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKNqpZ7XnOVQyKaBcvuQMMYJ2KdPPgi7/Md3s/SzjYqgcTRT7PFESB2Cg0NhDXRNELDF0zA7E+gaQS/ncRN7Aiq2Y/YAiTqrdYsKLh519rYZCL4RcxJBwMDh+0zjH3CWBbKxL6fYGLDigX92obUN8i8Fad4nUXM+rvns262lekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1QsNJ/d; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=G486Z505; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1QsNJ/d";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="G486Z505"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773430575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F6vLNkYI0Glv4imYlLdghWO+G939IWoHMCjoj79IDKc=;
	b=e1QsNJ/dsoFcE7oFZ/7dx/S4lMmSfARLQbMsxpmQrdEKiEmW5Pcmo1b0dvfw5e3vHaofxl
	Zavs8cecfLuLXRDoVwd6L+6l522Y8ndqhqwmBRMyBrp00PT/cTIZZ4eNT78UWAngG5Qbnk
	85TxuCjvIGcZvsZywrA/CdaSsZfDSA0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-YGriN93VPcqZMT3PWiNyMw-1; Fri, 13 Mar 2026 15:36:13 -0400
X-MC-Unique: YGriN93VPcqZMT3PWiNyMw-1
X-Mimecast-MFC-AGG-ID: YGriN93VPcqZMT3PWiNyMw_1773430573
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-829942cf9deso1986289b3a.0
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773430572; x=1774035372; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F6vLNkYI0Glv4imYlLdghWO+G939IWoHMCjoj79IDKc=;
        b=G486Z505tYGa41ooa0fJywkW5gA1GeHmiwPsNL5yM4Ud5dFyNV/rLoqi6RMhF7qY+3
         EFGaNvogrTxpR9tbdAuHlZGI/rOeWqrln2GNVP3jj508iwtFnIrmJbBxitmqDCQq3wOR
         3ND5U+pukU9VdenrTrm0d62HL/bvXnXxwDinfJohQZ+hbLKIOSdOhF88u6rdaDIHlrwv
         EHC6OvqFC6+hw+Txa3zLSDzOpGaALIthT3SzG2kpYYsxGC7oJYFCtkZoN5JmpQQYP+VQ
         1lZAv4zQFdjaJAmyy7XqcMfAL3gwCLvGhuhvGX0LuTWRGLd560+ANhQ43BqZ/EVuGLJZ
         S2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773430572; x=1774035372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F6vLNkYI0Glv4imYlLdghWO+G939IWoHMCjoj79IDKc=;
        b=Hs0XZQ6YRzKFwcx+wH5YlngG1h1f6tb1Nlxw2vckqRi/PFwt27T9SIL4FbToZ2qFVS
         XR+8nqugFdGO6FztSb/oskkg3KZxE6GmIjuS+MzYjJFEz49rAxn1o9yQwF25CkafCo7p
         MhlD6bcDP6BFN66jmRp/qmgEaRuo2EKd//mA6xMb/IY1W4Q6jSlhIwcttkf0sB4QZ4NU
         SdQgdDN2GPbUaRABTMoZOGSwUt/1uPvyV3MJC//E0cZHY5MsD+n5B7UE75bkIvdLpoqV
         27LdtS8g3jhum3Gn4d1CW7EIoh8vtTO/Dex5PCKQeO8vPraTNsSJXWUavmGOsOrJzki+
         mzqw==
X-Forwarded-Encrypted: i=1; AJvYcCUj4vtY8E7xnNA+b5x+3+Z3Pnd4BPKsF5b2xSze0gg9Ei3y3+Ok5JSYW95amZu+eKH3xHE/RznYVbw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNSosxVYoZs7lcmEFGuiYafV61PuESiBOruBL1AlCj6c2Keopk
	dts5FGNOY3xtEy16sHNbo+IdAEYmtiwY4/RVU9R1ALMZEyb52So7cuHiCUCM3loMA0qraOoqm9P
	bErLDYtQCggOAat+oVUS0Kpn5SgmdsiyBJprL3rxj3+pjQFgZPWwHS3EAyVqzfbiUEJuMfA==
X-Gm-Gg: ATEYQzwUK5oKjIb7ny0eBApdlg1iB84PpuvfO2K1bhKZfYlF+POTErJ3qYO22YCEuUs
	9HpWcDUTURNHajyj7KYIdaXpanCJ9rJlZ18ZM+n8uc+qXiEVPYzCp5FyQk+DkWRrTerI+872gbZ
	A2bqO+Esg5pCTP1+DhzulNSSVdDlyAYzkeqrDtTuHcMIzB8BHSEg7zu/lfjgbIYuWQLlEnu2kOT
	tBznCt5A49s7osb8ViTaWNrMkj7J1NYtXftzPcxawmEL/4ki8yRQyejPpn3cG5AlIGYAttY4d4R
	OrhtTSTQALlMyd6ZFquxQMq9pa/QL3xFAAG6oPjGETv9VA2ZHSPIYy1rv5gn2ZUBUi94zdQAIrP
	8i5u5xnRbcKxBjxOsKgVed6slyklaQcgUdo0o+EotkTIZQExV+FWNJ0IxmvAD8g==
X-Received: by 2002:a05:6a00:414e:b0:80a:fc3c:f839 with SMTP id d2e1a72fcca58-82a198b2533mr3706321b3a.49.1773430572104;
        Fri, 13 Mar 2026 12:36:12 -0700 (PDT)
X-Received: by 2002:a05:6a00:414e:b0:80a:fc3c:f839 with SMTP id d2e1a72fcca58-82a198b2533mr3706294b3a.49.1773430571528;
        Fri, 13 Mar 2026 12:36:11 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a07366974sm6736893b3a.48.2026.03.13.12.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:36:11 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:36:07 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/14] xfs: test xfs_healer can report file media errors
Message-ID: <20260313193607.2ds5gxfogf4sdfzs@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403923.1186408.14451135693864403499.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403923.1186408.14451135693864403499.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:52:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that xfs_healer can actually report media errors as found by the
> kernel.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1897     |  172 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1897.out |    7 ++
>  2 files changed, 179 insertions(+)
>  create mode 100755 tests/xfs/1897
>  create mode 100755 tests/xfs/1897.out
> 
> 
> diff --git a/tests/xfs/1897 b/tests/xfs/1897
> new file mode 100755
> index 00000000000000..4670c333a2d82c
> --- /dev/null
> +++ b/tests/xfs/1897
> @@ -0,0 +1,172 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1897
> +#
> +# Check that xfs_healer can report media errors.
> +
> +. ./common/preamble
> +_begin_fstest auto quick scrub eio selfhealing
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	_dmerror_cleanup
> +}
> +
> +. ./common/fuzzy
> +. ./common/filter
> +. ./common/dmerror
> +. ./common/systemd
> +
> +_require_scratch
> +_require_scrub
> +_require_dm_target error
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_xfs_io_command verifymedia
> +
> +filter_healer() {
> +	_filter_scratch | \
> +		grep -E '(media failed|media error)' | \
> +		sed \
> +		    -e 's/datadev/DEVICE/g' \
> +		    -e 's/rtdev/DEVICE/g' \
> +		    -e 's/ino [0-9]*/ino NUM/g' \
> +		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
> +		    -e 's/pos [0-9]*/pos NUM/g' \
> +		    -e 's/len [0-9]*/len NUM/g' \
> +		    -e 's/0x[0-9a-f]*/NUM/g' \
> +		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
> +		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g'
> +}
> +
> +filter_verify() {
> +	sed -e 's/\([a-z]*dev\): verify error at offset \([0-9]*\) length \([0-9]*\)/DEVICE: verify error at offset XXX length XXX/g'
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +
> +# The dm-error map added by this test doesn't work on zoned devices because
> +# table sizes need to be aligned to the zone size, and even for zoned on
> +# conventional this test will get confused because of the internal RT device.
> +#
> +# That check requires a mounted file system, so do a dummy mount before setting
> +# up DM.
> +_scratch_mount
> +_require_xfs_scratch_non_zoned
> +_require_xfs_healer $SCRATCH_MNT
> +_scratch_unmount
> +
> +_dmerror_init
> +_dmerror_mount
> +
> +# Write a file with 4 file blocks worth of data, figure out the LBA to target
> +victim=$SCRATCH_MNT/a
> +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> +unset errordev
> +verifymediadev="-d"
> +
> +awk_len_prog='{print $6}'
> +if _xfs_is_realtime_file $victim; then
> +	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
> +		awk_len_prog='{print $4}'
> +	fi
> +	errordev="RT"
> +	verifymediadev="-r"
> +fi
> +bmap_str="$($XFS_IO_PROG -c "bmap -elpv" $victim | grep "^[[:space:]]*0:")"
> +echo "$errordev:$bmap_str" >> $seqres.full
> +
> +phys="$(echo "$bmap_str" | $AWK_PROG '{print $3}')"
> +len="$(echo "$bmap_str" | $AWK_PROG "$awk_len_prog")"
> +
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
> +logical_block_size=`$here/src/min_dio_alignment $SCRATCH_MNT $SCRATCH_DEV`
> +kernel_sectors_per_device_lba=$((logical_block_size / 512))
> +
> +# Pretend as bad one of the device LBAs in the middle of the extent.  Target
> +# the second LBA of the third block of the four-block file extent that we
> +# allocated earlier, but without overflowing into the fourth file block.
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
> +echo "Simulate media error"
> +_scratch_invoke_xfs_healer "$tmp.healer"
> +echo "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" >> $seqres.full
> +$XFS_IO_PROG -x -c "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" $SCRATCH_MNT 2>&1 | filter_verify
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
> +echo "No more media error"
> +echo "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" >> $seqres.full
> +$XFS_IO_PROG -x -c "verifymedia $verifymediadev -R $((bad_sector * 512)) $(((bad_sector + bad_len) * 512))" $SCRATCH_MNT >> $seqres.full
> +
> +# Unmount filesystem to start fresh
> +echo "Kill healer"
> +_scratch_kill_xfs_healer _dmerror_unmount
> +
> +# filesystems without rmap do not translate media errors to lost file ranges
> +# so fake the output
> +_xfs_has_feature "$SCRATCH_DEV" rmapbt || \
> +	echo "VICTIM pos 0 len 0: media failed" >> $tmp.healer
> +
> +cat $tmp.healer >> $seqres.full
> +cat $tmp.healer | filter_healer
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1897.out b/tests/xfs/1897.out
> new file mode 100755
> index 00000000000000..1bb615c3119dce
> --- /dev/null
> +++ b/tests/xfs/1897.out
> @@ -0,0 +1,7 @@
> +QA output created by 1897
> +Simulate media error
> +DEVICE: verify error at offset XXX length XXX: Input/output error
> +No more media error
> +Kill healer
> +SCRATCH_MNT DEVICE daddr NUM bbcount NUM: media error
> +VICTIM pos NUM len NUM: media failed
> 

