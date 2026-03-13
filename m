Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC131B4244
	for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 19:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773430346; cv=none; b=HazvePEpmyhj41OwN7tgxdQ8+dNQteKXxX+R+3vyPI1zjR2qTWk2+rS592dohkVTMn0GbvrJroMH3azWhIk0BYQ+w9Lj6VUXFTobNWHzn2SzyKp9TqWudeEWGqNhTCQj07LGfu35QGse9rL7TRPsBcWOJgA8HtZS0ghv7Dn5mrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773430346; c=relaxed/simple;
	bh=93FqpVP7QYITBr1jhQR+adipzmbAcbSrUcxWlPGy4q0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bVXEOpRNe5qWrqaw8oVwjia555apkr8lw2Qpp9yEXbtp1J6KzFopFbb3jrPTx4EMdimh+KaW48dEvaf4XpOXMjLolySOEt72fqO62ojRyBdCxl9/Jc14zrgVjNntTunWN+ZC/YP5gadJqj9DwPOr0wmDtiStbEoQ2UMum2aAN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TnNsrJsn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VVIyWpnv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TnNsrJsn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VVIyWpnv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773430344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cID933nmxrU7CYOl4lGdzsQUC3e3+K8hwd9xh3fzkiQ=;
	b=TnNsrJsnUap/HEvL1eeBVeYc0IDldIMVvSFS9pkJ75ic05/byE4IafQRg8mG9DhpopQnzs
	tEergrEJHQ92C9aanFcKDP5EgyzykJVMd8s525F6BBEi1mRdmmGG4jWfsEJDoskTNBszxK
	UsbR5JwncUTlz9MwX/Mlzb4ovwupqTw=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-USOr9L4IP2iyjopRRjj7lg-1; Fri, 13 Mar 2026 15:32:22 -0400
X-MC-Unique: USOr9L4IP2iyjopRRjj7lg-1
X-Mimecast-MFC-AGG-ID: USOr9L4IP2iyjopRRjj7lg_1773430342
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2aec6c572fbso134879025ad.1
        for <linux-xfs@vger.kernel.org>; Fri, 13 Mar 2026 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773430341; x=1774035141; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cID933nmxrU7CYOl4lGdzsQUC3e3+K8hwd9xh3fzkiQ=;
        b=VVIyWpnvNFKwgYx/Us4HLXiqXZb7bZHINIHIeJb5qh1BhJzNuigfD49ufYXrCyeD65
         eVvlYBRLDb+33NBGsBVfKniKHygm0QemzkB9NAduhfgfV0hvQlfWjsrq8QDslnH//aoT
         9BtX/AASn2TaOi4UFPPhzMw/xXOQH6d0PaxcluVCZXpSsml2KrQy1xNUIa+r1+RIQKT2
         n+ReV3HuuqxXGtoIkgS/m6S9kbfibiyeoekYRwF86wJjDzmfUkebGVmv8szUxyDruRqi
         kG7MsMg1dokrl14AsK6TXf3PDl7TQH5/uEFEPqvO23tSPL4hWDwxbKOCBt8V37DpMzas
         E+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773430341; x=1774035141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cID933nmxrU7CYOl4lGdzsQUC3e3+K8hwd9xh3fzkiQ=;
        b=ksbc9HZIdKSuplhI7e1nqHmX4ZX+PbYe21G4dQsprwGZiqNEa9m+BH6/5V6i6zbGdP
         AXRNl3Y1CNFVl6UgOHZId5GeKmv8TmFzNexPxHOiQqSAm8jm+ULOYvujCRXUSV0PVznP
         Y/9dvlCOknx2wu673UvThwh6l+XOIpVEXXXy1NlIxG+cV+rtachZ1p66gyEUFgYAXH2x
         ZVBXea8POVHeOpVQKIcP5Ek1QA7HLUaWU6PZWJFHQ3sQolx+7nlfN5Az3pLERkv6zqnY
         dKcltbHPRGrgmzNOEYCVx6ZiRbjtP1NLYJzCs4ds405e8XHb95aeU1k/kNomu2Nt4S/p
         2RCA==
X-Forwarded-Encrypted: i=1; AJvYcCUPCHpuTpHnT+Sm31vouQ11yIlWzGiwC+Gp8fXmSGjQSttgfQl7B8cFcogQZQBvogwIcSrSJrBQqBs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHnXyPctOZjKq1uz+mME/LXARjRwWMCMJ9jfXMrk9n4TqcFtzH
	MR+OQh2ON3h+ZvwVml4x6CUIyya+SLSTHq93HuJhF5SjI0Ed299PrZz1B0drN7e9T6lYO6Ea+9l
	Fb9iqLreJlz4vALuEHXEtJRHS5sqa9tHms7yPmN8kJUWjzsxp/fNjt8hKqqVVGA==
X-Gm-Gg: ATEYQzyxqr2hRt+2a+7hZz1oGsv5uLTc/fDKoMznX5MFGVswoekDces10cBQf4KfBCb
	d3rjx5Lck/uBOnsKH6vU7rUZS/Ck7n33xCho6AEED8QNjYaslU3dp1gkNsk6Ke83qZh8PPUsMfD
	0yHYqvqmTEpUeOSC6w0IyPlZ1+egPyqs2h+BE/ixyFgYJZME+2dRvzEjy1h84bONwiHPfn5t4bB
	5vmF0i4sakEK3pcwlbtlMv40jj+ywEKJz237tyoFgB4ddWltiK2Nt94zCWhsau14HJi1IFbZlAt
	EC5mIYl4JBWipWrfx1aRnH3NYmUlRQfR7YRSV0p/rgcVRqCQuu4G0v0Jy3fNDwAAlmjmxD1Xn5a
	s+14FWA676lKEbq+ywiLj1gxlEM2lzS2VbHeeJsOZkivpSH4dODeTPhNDP/BO8Q==
X-Received: by 2002:a17:903:234e:b0:2b0:41eb:165e with SMTP id d9443c01a7336-2b041eb19b7mr5531035ad.38.1773430341315;
        Fri, 13 Mar 2026 12:32:21 -0700 (PDT)
X-Received: by 2002:a17:903:234e:b0:2b0:41eb:165e with SMTP id d9443c01a7336-2b041eb19b7mr5530825ad.38.1773430340882;
        Fri, 13 Mar 2026 12:32:20 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece7edc16sm29872965ad.58.2026.03.13.12.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 12:32:20 -0700 (PDT)
Date: Sat, 14 Mar 2026 03:32:16 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/14] xfs: test xfs_healer can report file I/O errors
Message-ID: <20260313193216.isih4krwrw352rfz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <177311403904.1186408.2255205098441030776.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177311403904.1186408.2255205098441030776.stgit@frogsfrogsfrogs>

On Mon, Mar 09, 2026 at 08:51:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that xfs_healer can actually report file I/O errors.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Tests and looks good to me,

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/1896     |  210 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/1896.out |   21 +++++
>  2 files changed, 231 insertions(+)
>  create mode 100755 tests/xfs/1896
>  create mode 100644 tests/xfs/1896.out
> 
> 
> diff --git a/tests/xfs/1896 b/tests/xfs/1896
> new file mode 100755
> index 00000000000000..911e1d5ee8a576
> --- /dev/null
> +++ b/tests/xfs/1896
> @@ -0,0 +1,210 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2024-2026 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 1896
> +#
> +# Check that xfs_healer can report file IO errors.
> +
> +. ./common/preamble
> +_begin_fstest auto quick scrub eio selfhealing
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
> +. ./common/systemd
> +
> +_require_scratch
> +_require_scrub
> +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> +_require_dm_target error
> +_require_no_xfs_always_cow	# no out of place writes
> +
> +# Ignore everything from the healer except for the four IO error log messages.
> +# Strip out file handle and range information because the blocksize can vary.
> +# Writeback and readahead can trigger multiple error messages due to retries,
> +# hence the uniq.
> +filter_healer_errors() {
> +	_filter_scratch | \
> +		grep -E '(buffered|directio)' | \
> +		sed \
> +		    -e 's/ino [0-9]*/ino NUM/g' \
> +		    -e 's/gen 0x[0-9a-f]*/gen NUM/g' \
> +		    -e 's/pos [0-9]*/pos NUM/g' \
> +		    -e 's/len [0-9]*/len NUM/g' \
> +		    -e 's|SCRATCH_MNT/a|VICTIM|g' \
> +		    -e 's|SCRATCH_MNT ino NUM gen NUM|VICTIM|g' | \
> +		sort | \
> +		uniq
> +}
> +
> +_scratch_mkfs >> $seqres.full
> +
> +#
> +# The dm-error map added by this test doesn't work on zoned devices because
> +# table sizes need to be aligned to the zone size, and even for zoned on
> +# conventional this test will get confused because of the internal RT device.
> +#
> +# That check requires a mounted file system, so do a dummy mount before setting
> +# up DM.
> +#
> +_scratch_mount
> +_require_xfs_scratch_non_zoned
> +_require_xfs_healer $SCRATCH_MNT
> +_scratch_unmount
> +
> +_dmerror_init
> +_dmerror_mount >> $seqres.full 2>&1
> +
> +# Write a file with 4 file blocks worth of data, figure out the LBA to target
> +victim=$SCRATCH_MNT/a
> +file_blksz=$(_get_file_block_size $SCRATCH_MNT)
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c "fsync" $victim >> $seqres.full
> +unset errordev
> +
> +awk_len_prog='{print $6}'
> +if _xfs_is_realtime_file $victim; then
> +	if ! _xfs_has_feature $SCRATCH_MNT rtgroups; then
> +		awk_len_prog='{print $4}'
> +	fi
> +	errordev="RT"
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
> +
> +# Remount to flush the page cache, start the healer, and make the LBA bad
> +_dmerror_unmount
> +_dmerror_mount
> +
> +_scratch_invoke_xfs_healer "$tmp.healer"
> +
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
> +# See if buffered reads pick it up
> +echo "Try buffered read"
> +$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio reads pick it up
> +echo "Try directio read"
> +$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio writes pick it up
> +echo "Try directio write"
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# Now mark the bad range good so that unmount won't fail due to IO errors.
> +echo "Fix device"
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
> +# Unmount filesystem to start fresh
> +echo "Kill healer"
> +_scratch_kill_xfs_healer _dmerror_unmount
> +cat $tmp.healer >> $seqres.full
> +cat $tmp.healer | filter_healer_errors
> +
> +# Start the healer again so that can verify that the errors don't persist after
> +# we flip back to the good dm table.
> +echo "Remount and restart healer"
> +_dmerror_mount
> +_scratch_invoke_xfs_healer "$tmp.healer"
> +
> +# See if buffered reads pick it up
> +echo "Try buffered read again"
> +$XFS_IO_PROG -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio reads pick it up
> +echo "Try directio read again"
> +$XFS_IO_PROG -d -c "pread 0 $((4 * file_blksz))" $victim >> $seqres.full
> +
> +# See if directio writes pick it up
> +echo "Try directio write again"
> +$XFS_IO_PROG -d -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# See if buffered writes pick it up
> +echo "Try buffered write again"
> +$XFS_IO_PROG -c "pwrite -S 0x58 0 $((4 * file_blksz))" -c fsync $victim >> $seqres.full
> +
> +# Unmount fs to kill healer, then wait for it to finish
> +echo "Kill healer again"
> +_scratch_kill_xfs_healer _dmerror_unmount
> +cat $tmp.healer >> $seqres.full
> +cat $tmp.healer | filter_healer_errors
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/1896.out b/tests/xfs/1896.out
> new file mode 100644
> index 00000000000000..1378d4fad44522
> --- /dev/null
> +++ b/tests/xfs/1896.out
> @@ -0,0 +1,21 @@
> +QA output created by 1896
> +Try buffered read
> +pread: Input/output error
> +Try directio read
> +pread: Input/output error
> +Try directio write
> +pwrite: Input/output error
> +Try buffered write
> +fsync: Input/output error
> +Fix device
> +Kill healer
> +VICTIM pos NUM len NUM: buffered_read: Input/output error
> +VICTIM pos NUM len NUM: buffered_write: Input/output error
> +VICTIM pos NUM len NUM: directio_read: Input/output error
> +VICTIM pos NUM len NUM: directio_write: Input/output error
> +Remount and restart healer
> +Try buffered read again
> +Try directio read again
> +Try directio write again
> +Try buffered write again
> +Kill healer again
> 

