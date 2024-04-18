Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C9016ABE2;
	Thu, 18 Apr 2024 15:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713452553; cv=none; b=QWwTkRSK464BJOYzlSgmHql04QPfWZsmP4yQy5vOeti8MM2/SJn2A7KuJjueb6MRFZeg/fhb5KmVdqWxOjFFO18rxtZsBeoZ/J8/jpfweLwfwXJ0r56hD30Ne3gpSvJMgVcjgRtt5X0tO5r496st4+E408118ZPvfAQtYVJqPUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713452553; c=relaxed/simple;
	bh=nH6sL8geJUd0RL6tpBKH82t1t3v+StyUkwZnGFo033Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DPMuuyBmPYQ6CgG5LdJW1zb6ZhNZbON1wOIvXpo4o5RJ/eeW4/ldQjiiyKKvRG82X0sdGBqIDeSdHjP6e6/plI1PRrehmD/w6Yu6hxMEWXXWBw3Hgle6WUdErfHaBlGZ/K3D6cZ47c3co0/3kUDwoSr/dt50ywuTE+zROQi5tRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIlC38yV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIlC38yV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD101C113CE;
	Thu, 18 Apr 2024 15:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713452552;
	bh=nH6sL8geJUd0RL6tpBKH82t1t3v+StyUkwZnGFo033Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIlC38yV58piWdGxGkbr/F2jYVA9HLqNDVDWmqKyCWwRkkM8/glXqWrKtBn2kzdNI
	 nKkHY2/+bGBlkK/oUbwHxQhFCBBE2IUg67drwx6Xv0zLOap44nDfgU8JyeieuVAD3L
	 WuN+l5rlGGxkry19iL1PbBEAv/riVQ9avxTj5M9LsOZay2Od3EpbhTynMJ2p6ZJc1B
	 j21/JxVMxmmRsXgOgkT0t91K4Mbb1vIT4CAveYcEcUKvDUvOhVIiDmbj0q8XjZR6po
	 geGdHfKyIPDsTeYc3d5GHQC3JBPufVUhwW5cQa0p7feyZ93WakNICKTv5qVH10nAGc
	 inqrz/ghwiwyg==
Date: Thu, 18 Apr 2024 08:02:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: don't run tests that require v4 file systems
 when not supported
Message-ID: <20240418150232.GJ11948@frogsfrogsfrogs>
References: <20240418074046.2326450-1-hch@lst.de>
 <20240418074046.2326450-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240418074046.2326450-6-hch@lst.de>

On Thu, Apr 18, 2024 at 09:40:46AM +0200, Christoph Hellwig wrote:
> Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
> a crc=0 file systems before running tests that rely on it to avoid failures
> on kernels with CONFIG_XFS_SUPPORT_V4 disabled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  common/xfs    | 10 ++++++++++
>  tests/xfs/002 |  1 +
>  tests/xfs/095 |  1 +
>  tests/xfs/096 |  1 +
>  tests/xfs/132 |  1 +
>  tests/xfs/148 |  6 ++++++
>  tests/xfs/194 | 10 ++++++++++
>  tests/xfs/199 |  1 +
>  tests/xfs/300 |  1 +
>  tests/xfs/526 |  3 +++
>  tests/xfs/612 |  1 +
>  tests/xfs/613 |  1 +
>  12 files changed, 37 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 49ca5a2d5..733c3a5be 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1852,3 +1852,13 @@ _xfs_discard_max_offset_kb()
>  	$XFS_IO_PROG -c 'statfs' "$1" | \
>  		awk '{g[$1] = $3} END {print (g["geom.bsize"] * g["geom.datablocks"] / 1024)}'
>  }
> +
> +# check if mkfs and the kernel support nocrc (v4) file systems
> +_require_xfs_nocrc()
> +{
> +	_scratch_mkfs_xfs -m crc=0 > /dev/null 2>&1 || \
> +		_notrun "v4 file systems not supported"
> +	_try_scratch_mount > /dev/null 2>&1 || \
> +		_notrun "v4 file systems not supported"
> +	_scratch_unmount
> +}
> diff --git a/tests/xfs/002 b/tests/xfs/002
> index 8dfd2693b..26d0cd6e4 100755
> --- a/tests/xfs/002
> +++ b/tests/xfs/002
> @@ -23,6 +23,7 @@ _begin_fstest auto quick growfs
>  _supported_fs xfs
>  _require_scratch_nocheck
>  _require_no_large_scratch_dev
> +_require_xfs_nocrc
>  
>  _scratch_mkfs_xfs -m crc=0 -d size=128m >> $seqres.full 2>&1 || _fail "mkfs failed"
>  
> diff --git a/tests/xfs/095 b/tests/xfs/095
> index a3891c85e..e7dc3e9f4 100755
> --- a/tests/xfs/095
> +++ b/tests/xfs/095
> @@ -19,6 +19,7 @@ _begin_fstest log v2log auto
>  _supported_fs xfs
>  _require_scratch
>  _require_v2log
> +_require_xfs_nocrc
>  
>  if [ "$(blockdev --getss $SCRATCH_DEV)" != "512" ]; then
>  	_notrun "need 512b sector size"
> diff --git a/tests/xfs/096 b/tests/xfs/096
> index 7eff6cb1d..0a1bfb3fa 100755
> --- a/tests/xfs/096
> +++ b/tests/xfs/096
> @@ -20,6 +20,7 @@ _supported_fs xfs
>  
>  _require_scratch
>  _require_xfs_quota
> +_require_xfs_nocrc
>  
>  function option_string()
>  {
> diff --git a/tests/xfs/132 b/tests/xfs/132
> index ee1c8c1ec..b46d3d28c 100755
> --- a/tests/xfs/132
> +++ b/tests/xfs/132
> @@ -19,6 +19,7 @@ _supported_fs xfs
>  
>  # we intentionally corrupt the filesystem, so don't check it after the test
>  _require_scratch_nocheck
> +_require_xfs_nocrc
>  
>  # on success, we'll get a shutdown filesystem with a really noisy log message
>  # due to transaction cancellation.  Hence we don't want to check dmesg here.
> diff --git a/tests/xfs/148 b/tests/xfs/148
> index c9f634cfd..fde3bf476 100755
> --- a/tests/xfs/148
> +++ b/tests/xfs/148
> @@ -27,6 +27,8 @@ _cleanup()
>  _supported_fs xfs
>  _require_test
>  _require_attrs
> +_require_xfs_nocrc
> +
>  _disable_dmesg_check
>  
>  imgfile=$TEST_DIR/img-$seq
> @@ -40,6 +42,10 @@ test_names=("something" "$nullstr" "$slashstr" "another")
>  rm -f $imgfile $imgfile.old
>  
>  # Format image file w/o crcs so we can sed the image file
> +#
> +# TODO: It might be possible to rewrite this using proper xfs_db
> +# fs manipulation commands that would work with CRCs.
> +#
>  # We need to use 512 byte inodes to ensure the attr forks remain in short form
>  # even when security xattrs are present so we are always doing name matches on
>  # lookup and not name hash compares as leaf/node forms will do.
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 5a1dff5d2..2fcc55b3e 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -30,6 +30,16 @@ _supported_fs xfs
>  # real QA test starts here
>  
>  _require_scratch
> +
> +#
> +# This currently forces nocrc because only that can support 512 byte block size
> +# and thus block size = 1/8 page size on 4k page size systems.
> +# In theory we could run it on systems with larger page size with CRCs, or hope
> +# that large folios would trigger the same issue.
> +# But for now that is left as an exercise for the reader.
> +#
> +_require_xfs_nocrc
> +
>  _scratch_mkfs_xfs >/dev/null 2>&1
>  
>  # For this test we use block size = 1/8 page size
> diff --git a/tests/xfs/199 b/tests/xfs/199
> index 4669f2c3e..f99b04db3 100755
> --- a/tests/xfs/199
> +++ b/tests/xfs/199
> @@ -26,6 +26,7 @@ _cleanup()
>  _supported_fs xfs
>  
>  _require_scratch
> +_require_xfs_nocrc
>  
>  # clear any mkfs options so that we can directly specify the options we need to
>  # be able to test the features bitmask behaviour correctly.
> diff --git a/tests/xfs/300 b/tests/xfs/300
> index 2ee5eee71..bc1f0efc6 100755
> --- a/tests/xfs/300
> +++ b/tests/xfs/300
> @@ -13,6 +13,7 @@ _begin_fstest auto fsr
>  . ./common/filter
>  
>  _require_scratch
> +_require_xfs_nocrc
>  
>  # real QA test starts here
>  
> diff --git a/tests/xfs/526 b/tests/xfs/526
> index 4261e8497..c5c5f9b1a 100755
> --- a/tests/xfs/526
> +++ b/tests/xfs/526
> @@ -27,6 +27,9 @@ _require_test
>  _require_scratch_nocheck
>  _require_xfs_mkfs_cfgfile
>  
> +# Currently the only conflicting options are v4 specific
> +_require_xfs_nocrc
> +
>  cfgfile=$TEST_DIR/a
>  rm -rf $cfgfile
>  
> diff --git a/tests/xfs/612 b/tests/xfs/612
> index 4ae4d3977..0f6df7deb 100755
> --- a/tests/xfs/612
> +++ b/tests/xfs/612
> @@ -17,6 +17,7 @@ _supported_fs xfs
>  _require_scratch_xfs_inobtcount
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  _require_xfs_repair_upgrade inobtcount
> +_require_xfs_nocrc
>  
>  # Make sure we can't upgrade to inobt on a V4 filesystem
>  _scratch_mkfs -m crc=0,inobtcount=0,finobt=0 >> $seqres.full
> diff --git a/tests/xfs/613 b/tests/xfs/613
> index 522358cb3..8bff21711 100755
> --- a/tests/xfs/613
> +++ b/tests/xfs/613
> @@ -34,6 +34,7 @@ _supported_fs xfs
>  _fixed_by_kernel_commit 237d7887ae72 \
>  	"xfs: show the proper user quota options"
>  
> +_require_xfs_nocrc
>  _require_test
>  _require_loop
>  _require_xfs_io_command "falloc"
> -- 
> 2.39.2
> 
> 
