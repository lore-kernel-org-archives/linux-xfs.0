Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F311AD9ED;
	Thu, 10 Oct 2024 06:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728543442; cv=none; b=dw36PzBD4N8z3ryTEp8CMSgKYsh2gSFxI3cBMODrJ4LAgAJQ31F/Dw9cL0z+UfQco85SOGcGNBTPQ4VwAUm570vKFhO7qZRZ9KqVMuRM6rB0mN522PC0Pk60pPCZEZLZOHD4J45V229XFqkPjy46MDwVWKm6GcUqLPySDZZB3yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728543442; c=relaxed/simple;
	bh=xDWKmO3r3tbshvCsqR9vW7wKntkrZTILsKD/+n6LUMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VuPlLDI9te94KPMkUF3fFJlQ8g+/qvyykfIiMT/vReeHlgTuAjwnVtR6kWsLrVkR5xe8Al47sim0rr7EPSSrLRYT7SwDpoM2XxM1+PAVIuqLKuf2iPU7KxioFMRIeUMem065hRP3V/bFg3jfwg82zFFq+idbC89SIPlQYQ0UyyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ATtoGDZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATtoGDZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A5BC4CEC6;
	Thu, 10 Oct 2024 06:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728543441;
	bh=xDWKmO3r3tbshvCsqR9vW7wKntkrZTILsKD/+n6LUMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATtoGDZYDgaYuw/V9yZhZ0y3+M3K+PZlGIbsxYpr744q7XXKdZnWgPodEjdni2nsQ
	 Ef3H+CA3NZYrIR6q7Zku+94rbiS8+OhBA2iHuW4GVcD2GtLWsDFVKck/fd6ZHWL5Ri
	 ZLNkrSYQAslBnVXycMrGf5C7H/j+0QbYyXGK6pfCqL4ulkHRZUYViYxiDxNtm3jNO1
	 GDrn/c1HseJoVaO5SYLqLMKUQxe+fnD0OfFSNiQoOLGXy+Fme1ecBi4+Zr/ZD4VmrH
	 usjKiiXF8lio88XdfRR+qHcMMFYpZBvgNALpQBdK7OG+Z/On1VIhR50sg+NPcMEa1l
	 TEvqT4EiuCYAQ==
Date: Thu, 10 Oct 2024 14:57:17 +0800
From: Zorro Lang <zlang@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>,
	"djwong@kernel.org" <djwong@kernel.org>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Message-ID: <20241010065717.742mmidqllyhbkph@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241008105055.11928-1-hans.holmberg@wdc.com>
 <20241008105055.11928-3-hans.holmberg@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008105055.11928-3-hans.holmberg@wdc.com>

On Tue, Oct 08, 2024 at 10:52:04AM +0000, Hans Holmberg wrote:
> From: Hans Holmberg <Hans.Holmberg@wdc.com>
> 
> These test cases specify small -d sizes which combined with a rt dev of
> unrestricted size and the rtrmap feature can cause mkfs to fail with
> error:
> 
> mkfs.xfs: cannot handle expansion of realtime rmap btree; need <x> free
> blocks, have <y>
> 
> This is due to that the -d size is not big enough to support the
> metadata space allocation required for the rt groups.
> 
> Switch to use _scratch_mkfs_sized that sets up the -r size parameter
> to avoid this. If -r size=x and -d size=x we will not risk running
> out of space on the ddev as the metadata size is just a fraction of
> the rt data size.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/157 | 12 ++++++++----
>  tests/xfs/547 |  4 +++-
>  tests/xfs/548 |  2 +-
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/xfs/157 b/tests/xfs/157
> index 79d45ac2bb34..9b5badbaeb3c 100755
> --- a/tests/xfs/157
> +++ b/tests/xfs/157
> @@ -34,18 +34,21 @@ _require_test
>  _require_scratch_nocheck
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  
> +
>  # Create some fake sparse files for testing external devices and whatnot
> +fs_size=$((500 * 1024 * 1024))
> +
>  fake_datafile=$TEST_DIR/$seq.scratch.data
>  rm -f $fake_datafile
> -truncate -s 500m $fake_datafile
> +truncate -s $fs_size $fake_datafile
>  
>  fake_logfile=$TEST_DIR/$seq.scratch.log
>  rm -f $fake_logfile
> -truncate -s 500m $fake_logfile
> +truncate -s $fs_size $fake_logfile
>  
>  fake_rtfile=$TEST_DIR/$seq.scratch.rt
>  rm -f $fake_rtfile
> -truncate -s 500m $fake_rtfile
> +truncate -s $fs_size $fake_rtfile
>  
>  # Save the original variables
>  orig_ddev=$SCRATCH_DEV
> @@ -63,7 +66,8 @@ scenario() {
>  }
>  
>  check_label() {
> -	_scratch_mkfs -L oldlabel >> $seqres.full
> +	MKFS_OPTIONS="-L oldlabel $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
> +		>> $seqres.full

Currently _scratch_mkfs_sized will _notrun if fails, but _scratch_mkfs doesn't.
So _scratch_mkfs might be similar with _try_scratch_mkfs_sized (returns fail).
But for this patch, both make sense to me.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  	_scratch_xfs_db -c label
>  	_scratch_xfs_admin -L newlabel "$@" >> $seqres.full
>  	_scratch_xfs_db -c label
> diff --git a/tests/xfs/547 b/tests/xfs/547
> index eada4aadc27f..ffac546be4cd 100755
> --- a/tests/xfs/547
> +++ b/tests/xfs/547
> @@ -24,10 +24,12 @@ _require_xfs_db_command path
>  _require_test_program "punch-alternating"
>  _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>  
> +fs_size=$((512 * 1024 * 1024))
> +
>  for nrext64 in 0 1; do
>  	echo "* Verify extent counter fields with nrext64=${nrext64} option"
>  
> -	_scratch_mkfs -i nrext64=${nrext64} -d size=$((512 * 1024 * 1024)) \
> +	MKFS_OPTIONS="-i nrext64=${nrext64} $MKFS_OPTIONS" _scratch_mkfs_sized $fs_size \
>  		      >> $seqres.full
>  	_scratch_mount >> $seqres.full
>  
> diff --git a/tests/xfs/548 b/tests/xfs/548
> index f0b58563e64d..af72885a9c6e 100755
> --- a/tests/xfs/548
> +++ b/tests/xfs/548
> @@ -24,7 +24,7 @@ _require_xfs_db_command path
>  _require_test_program "punch-alternating"
>  _require_xfs_io_error_injection "bmap_alloc_minlen_extent"
>  
> -_scratch_mkfs -d size=$((512 * 1024 * 1024)) >> $seqres.full
> +_scratch_mkfs_sized $((512 * 1024 * 1024)) >> $seqres.full
>  _scratch_mount >> $seqres.full
>  
>  bsize=$(_get_file_block_size $SCRATCH_MNT)
> -- 
> 2.34.1
> 
