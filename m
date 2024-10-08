Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD71D224CC;
	Tue,  8 Oct 2024 17:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407499; cv=none; b=T++O3aOmVHWRTUbAu4MmF2labbjriwGZtIk+CFLOTYwNsKL6OfeQeSWu+0/942cZ/Y5AtwbETjAS1jrOmP1wdZ0J64JRRvwjw0RVuiUTULC3tMRvxN8OCkFcPqjUxHPIBugR/NtrzM32dRxBuTLX5DyDB3I3L77Ug7Ty3pqLHAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407499; c=relaxed/simple;
	bh=w0OhujDS1ofUSBtaLUZCk5GBcD9xUsqUfuPAn+iQeNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1IlSB4RsXFx7/Azq/X0m0vvMXoNndC64wle8C7MD7WHwJRWKukrCAXocOnuhLYpOxWYVoJB1YZNVB6Jlp2wt2/hbrY0oRolBHjUdD2fdSb6RgPOtigziTLk0zJLX7A1b2/aviqRnRvMg3mBvm6NxvdsP/uzEEgawlRcXLWkO6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLEUi3k9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLEUi3k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3ECC4CEC7;
	Tue,  8 Oct 2024 17:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728407499;
	bh=w0OhujDS1ofUSBtaLUZCk5GBcD9xUsqUfuPAn+iQeNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MLEUi3k9xkVyiVmnDAo6lDkErGEAbToBQbWsnMV2S95tU0tr1y7Vt8bFSBQkDFMJ3
	 k23Yu5saWjrDFDkwAdCqH982YZ4ME+FJq46IlZ/eO6T0ez9e9ckrzbssOBb99I5nE8
	 uHfPMkYCihHyfhNlT8ckuroOahWCr0AoE3og8XGrUoHfQFp+/iXtTBhHVe3Jmtdjp4
	 zOHym4MzOmE6l5qs3U3E5Fwr318yusiG+aTvA1vSQp0OFmut4wQztSTRzYGwZd0qxN
	 LFK6qC28ooKhCkdwnDiIZaBsvdC/0LZ2XSWOC2CK5uGpyin5Q7Zc67sc34kckeq9d2
	 fiUYJUFbVLCtw==
Date: Tue, 8 Oct 2024 10:11:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "zlang@redhat.com" <zlang@redhat.com>, hch <hch@lst.de>,
	"fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs/157,xfs/547,xfs/548: switch to using
 _scratch_mkfs_sized
Message-ID: <20241008171138.GJ21840@frogsfrogsfrogs>
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

I was surprised that this was necessary until I remembered that this
test checks various *combinations* of block devices and 500M files.
The block device can be quite large, so that's why you want
_scratch_mkfs_sized to force the size of both sections to 500M.
Heh, oops.  My bad, I should have caught that. :(

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

These other two are pretty self evident so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  _scratch_mount >> $seqres.full
>  
>  bsize=$(_get_file_block_size $SCRATCH_MNT)
> -- 
> 2.34.1
> 
