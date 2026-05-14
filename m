Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF5D3DFC78;
	Thu, 14 May 2026 14:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778770019; cv=none; b=Wz1aHuIn9+esSsGXVbPpGDOpFLFsuqzcQ9PyoevlTwavWSTu4OU9CnvQUIGMbNiIiiiITNspEcYH750dih/2HGRbCJ2Hw6OAIOhJtqF9ikzpPHUm7HMOzfCLgjZ9xXxfdXZSgRXq7y1eZtFr5yJttFuGRhKMdOIoubEoQe+6Stc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778770019; c=relaxed/simple;
	bh=txaGIEzlBB5HwRgMpJj2HrPKqSeUNAc6D/N/rSmUXko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f+PvzSOhHVAMYehqsvJzNR3Dbs7LZmgeCMJ0ev3/8kMtL8fYAimn68ZA8mMduETEXhYHQ3+2+dxRGM3h9r6sLN5a4wUb/t7V7XJ1/NoTV73femTHHr7M6Iuna4FVx/58DTFgKJ4lDfMNmbkdffHbb/pZadgtaDF6uBU7yvI293o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVu6LaRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVu6LaRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AA4C2BCB3;
	Thu, 14 May 2026 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778770019;
	bh=txaGIEzlBB5HwRgMpJj2HrPKqSeUNAc6D/N/rSmUXko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aVu6LaRVC5kuE+soK4pTJnI0WmjwXVP+H7VeaqGOl5buvSRDreSZMlJ/LwdfDJjt6
	 fJJQOjwM8FSVHG07smF+5bNQECAhp9rHLRAUTieqL4DcwKh+PQia/VBGqDQzfC54iM
	 YHyrwsS8xIBlELOjeG0YRpNTXlTANLRrwAur95HIEPK6M6GIO2Xr7mypC5Y/FcC90b
	 fzgLefKB8k3pD+MW6ocjr8ltOKZU657s2ysoztcG6rHNBn9gc6+dSwi4kucUjh0Iv/
	 0kMP0CQfyDyaQMmsA/1KbK+87CLgSKEZgFIWP4h4NXgjrtvChYkenW6XqK+lV9D9Vz
	 xDN4yr5r379JA==
Date: Thu, 14 May 2026 07:46:58 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Lukas Herbolt <lukas@herbolt.com>
Cc: zlang@kernel.org, fstests@vger.kernel.org,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] generic/{102,172,347}: Adapt test for XFS on
 systems with 128+CPUs + SSDs
Message-ID: <20260514144658.GZ9544@frogsfrogsfrogs>
References: <20260514113910.866888-2-lukas@herbolt.com>
 <20260514113910.866888-8-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514113910.866888-8-lukas@herbolt.com>

On Thu, May 14, 2026 at 01:39:13PM +0200, Lukas Herbolt wrote:
> XFS will now scale by default its log size according the amount of CPUs. This
> can significantly increase the log area and using hard-coded size of file size
> will make the test file. Using the X percent of the free space to create the
> file will let the test proceed.
> 
> For generic/102 we also have to change the 102.out as we cannot know the
> amount written data and it has to be filtered out.
> 
> For generic/172 we just use the new function to calculate file big enough
> to consume most of the available space.
> 
> The generic/347 will use -l concurrency=0 in case it is being run on the
> XFS filesystem and mkfs.xfs already supports this option.
> 
> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
> ---
>  changes v2:
> 	test: generic/102 change the file size to 80% as it's closer to 
> 	      original size of 800MB

Cool, thanks.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  tests/generic/102     |  5 +++--
>  tests/generic/102.out | 20 ++++++++++----------
>  tests/generic/172     |  8 ++++----
>  tests/generic/347     |  9 ++++++++-
>  4 files changed, 25 insertions(+), 17 deletions(-)
> 
> diff --git a/tests/generic/102 b/tests/generic/102
> index daa5061bd3fe..be9ddda30a1d 100755
> --- a/tests/generic/102
> +++ b/tests/generic/102
> @@ -23,12 +23,13 @@ _require_scratch
>  dev_size=$((1024 * 1024 * 1024))     # 1GB filesystem
>  _scratch_mkfs_sized $dev_size >>$seqres.full 2>&1
>  _scratch_mount
> +file_size=`_mb_pct_of_available_space $SCRATCH_DEV 80`
>  
>  for ((i = 0; i < 10; i++)); do
>  	echo "loop $i" >>$seqres.full
>  
> -	$XFS_IO_PROG -f -c "pwrite -b 1m 0 800m" "$SCRATCH_MNT"/file | \
> -_filter_xfs_io | _filter_scratch
> +	$XFS_IO_PROG -f -c "pwrite -b 1m 0 ${file_size}m" "$SCRATCH_MNT"/file | \
> +_filter_xfs_io_numbers | _filter_scratch
>  
>  	rm -f "$SCRATCH_MNT"/file
>  done
> diff --git a/tests/generic/102.out b/tests/generic/102.out
> index b58aa5ccc68b..647bb23abec1 100644
> --- a/tests/generic/102.out
> +++ b/tests/generic/102.out
> @@ -1,21 +1,21 @@
>  QA output created by 102
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> -wrote 838860800/838860800 bytes at offset 0
> +wrote XXXX/XXXX bytes at offset XXXX
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> diff --git a/tests/generic/172 b/tests/generic/172
> index b67e817b667b..06f9370f065d 100755
> --- a/tests/generic/172
> +++ b/tests/generic/172
> @@ -37,15 +37,15 @@ echo "Reformat with appropriate size"
>  blksz="$(_get_block_size $testdir)"
>  _scratch_unmount
>  
> -file_size=$((768 * 1024 * 1024))
>  fs_size=$((1024 * 1024 * 1024))
>  _scratch_mkfs_sized $fs_size >> $seqres.full 2>&1
>  _scratch_mount >> $seqres.full 2>&1
>  rm -rf $testdir
>  mkdir $testdir
> +file_size=`_mb_pct_of_available_space $SCRATCH_DEV 70`
>  
>  echo "Create a big file and reflink it"
> -_pwrite_byte 0x61 0 $file_size $testdir/bigfile >> $seqres.full 2>&1
> +_pwrite_byte 0x61 0 ${file_size}m $testdir/bigfile >> $seqres.full 2>&1
>  _cp_reflink $testdir/bigfile $testdir/clonefile
>  _scratch_sync
>  
> @@ -54,7 +54,7 @@ _fill_fs $fs_size  $testdir/space $blksz 0 >> $seqres.full 2>&1
>  _scratch_sync
>  
>  echo "CoW the big file"
> -out="$(_pwrite_byte 0x62 0 $file_size $testdir/bigfile 2>&1 | \
> +out="$(_pwrite_byte 0x62 0 ${file_size}m $testdir/bigfile 2>&1 | \
>  	_filter_xfs_io_error)"
>  echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
>  echo ${out} >> $seqres.full 2>&1
> @@ -63,7 +63,7 @@ echo ${out}
>  echo "Remount and try CoW again"
>  _scratch_cycle_mount
>  
> -out="$(_pwrite_byte 0x62 0 $file_size $testdir/bigfile 2>&1 | \
> +out="$(_pwrite_byte 0x62 0 ${file_size}m $testdir/bigfile 2>&1 | \
>  	_filter_xfs_io_error)"
>  echo ${out} | grep -q "No space left on device" || echo "CoW should have failed with ENOSPC"
>  echo ${out} >> $seqres.full 2>&1
> diff --git a/tests/generic/347 b/tests/generic/347
> index 5c0e3f949585..06df0cf9eddc 100755
> --- a/tests/generic/347
> +++ b/tests/generic/347
> @@ -14,6 +14,13 @@ BACKING_SIZE=$((500 * 1024 * 1024 / 512))	# 500M
>  VIRTUAL_SIZE=$((10 * $BACKING_SIZE))		# 5000M
>  GROW_SIZE=$((100 * 1024 * 1024 / 512))		# 100M
>  
> +dmthin_mkfs_opts=""
> +if [ $FSTYP == "xfs" ]; then
> +	if _scratch_mkfs_xfs_supports_concurrency -l >> $seqres.full 2>&1; then
> +		dmthin_mkfs_opts="-l concurrency=0"
> +	fi
> +fi
> +
>  # Override the default cleanup function.
>  _cleanup()
>  {
> @@ -25,7 +32,7 @@ _setup_thin()
>  {
>  	_dmthin_init $BACKING_SIZE $VIRTUAL_SIZE
>  	_dmthin_set_queue
> -	_dmthin_mkfs
> +	_dmthin_mkfs $dmthin_mkfs_opts
>  	_dmthin_mount
>  }
>  
> -- 
> 2.54.0
> 
> 
