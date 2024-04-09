Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15A8136994;
	Tue,  9 Apr 2024 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712678174; cv=none; b=MieS88ZFetQqziXM0Fr8AgK1bSRKipuxpmnwRZ+yhX993AUgUriVKYbTk6rtdah7pB34K/G3af5JHK/1rHExZxex1V9iPF68H+EgkBwtyL1ctUGlDnexsWELvosMFTtEfs5Qh7eKDn8a/GaKyN3Ip6daaysomo1lOQgUUttgvxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712678174; c=relaxed/simple;
	bh=S5NewKZvJ70uVHNaeY325Nt7Xd7ybzkn/Ca8HbOZusU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SJne7m8FS6hyagfAJeazsy6mbOuWXTeuyK4xh/2uvO5US5267lGAWCTaWxX9VsRiHOQvul0xDA3+8FutqQQgE0fFX5Xbzzazb6w8tgx6t0gyf11kZkavqH0Jmdcy0GsKbI/XC/LTTP0m6Eq9EktSyjjoc9L/jTB5MgkYz8Owt2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/yArW4S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/yArW4S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF1C433F1;
	Tue,  9 Apr 2024 15:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712678173;
	bh=S5NewKZvJ70uVHNaeY325Nt7Xd7ybzkn/Ca8HbOZusU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B/yArW4SceZc5rt7Bd3WaMySKPltp+OYrA9fZjLWdeGM0WduVGK7P6oluT4o2bhjh
	 Fu0BjLCKsa3ph4dsJ8WuG/8bpQmwgWUJFPkCVb/OUVXXKZPBx63yivX/1IDNzCjlKw
	 oThC9j7ZMdF3pS2YkeVeAmwsXKDCPU3U4Fuo1OHXmhzDT1NUbxcT6jiC2srLj3Azji
	 SYrD4z93rwVCRuTTC1/zNv+5Ju911UI7/mhblqy3pRigNLrOSwxX/94P3JHJ824WfG
	 XO4BGunSM7JXFiTpL2V22gWMj01b14yQaJtVk+28n6FEn04+Y24HXFf0sevaCVCK9f
	 0HdQsMGUQq+rQ==
Date: Tue, 9 Apr 2024 08:56:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>, Eric Sandeen <sandeen@redhat.com>
Cc: Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: don't run tests that require v4 file systems
 when not supported
Message-ID: <20240409155612.GF634366@frogsfrogsfrogs>
References: <20240408133243.694134-1-hch@lst.de>
 <20240408133243.694134-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240408133243.694134-7-hch@lst.de>

On Mon, Apr 08, 2024 at 03:32:43PM +0200, Christoph Hellwig wrote:
> Add a _require_xfs_nocrc helper that checks that we can mkfs and mount
> a crc=0 file systems before running tests that rely on it to avoid failures
> on kernels with CONFIG_XFS_SUPPORT_V4 disabled.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  common/xfs    | 10 ++++++++++
>  tests/xfs/002 |  1 +

Looks fine to me.

>  tests/xfs/045 |  1 +

xfs_db can change uuids on v5 filesystems now, so we don't nee the
-mcrc=0 in this test.

>  tests/xfs/095 |  1 +
>  tests/xfs/132 |  1 +

Looks fine to me.

>  tests/xfs/148 |  2 ++

I wonder if we could rewrite this test to use either the xfs_db write -d
command on dirents or attrs directly; or the link/attrset commands,
since AFAICT the dir/attr code doesn't itself run namecheck when
creating entries/attrs.

>  tests/xfs/158 |  1 +
>  tests/xfs/160 |  1 +

inobtcount and bigtime are new features, maybe these two tests should
lose the clause that checks that we can't upgrade a V4 filesystem?

>  tests/xfs/194 |  2 ++

Not sure why this one is fixated on $pagesize/8.  Was that a requirement
to induce an error?  Or would this work just as well on a 1k fsblock fs?

(Eric?)

>  tests/xfs/199 |  1 +
>  tests/xfs/300 |  1 +

Looks fine to me.

>  tests/xfs/513 |  1 +

I think we should split this into separate tests for V4/V5 options and
only _require_xfs_nocrc the one with V4 options, because I wouldn't want
to stop testing V5 codepaths simply because someone turned off V4
support in the kernle.

>  tests/xfs/526 |  1 +

I'm at a loss on this one -- what it does is useful, but there aren't
any V5 mkfs options that conflict as nicely as crc=0 does.

>  13 files changed, 24 insertions(+)
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
> diff --git a/tests/xfs/045 b/tests/xfs/045
> index d8cc9ac29..69531ba71 100755
> --- a/tests/xfs/045
> +++ b/tests/xfs/045
> @@ -22,6 +22,7 @@ _supported_fs xfs
>  
>  _require_test
>  _require_scratch_nocheck
> +_require_xfs_nocrc
>  
>  echo "*** get uuid"
>  uuid=`_get_existing_uuid`
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
> index c9f634cfd..72d05f12f 100755
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
> diff --git a/tests/xfs/158 b/tests/xfs/158
> index 4440adf6e..0107fa3d6 100755
> --- a/tests/xfs/158
> +++ b/tests/xfs/158
> @@ -18,6 +18,7 @@ _supported_fs xfs
>  _require_scratch_xfs_inobtcount
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  _require_xfs_repair_upgrade inobtcount
> +_require_xfs_nocrc
>  
>  # Make sure we can't format a filesystem with inobtcount and not finobt.
>  _scratch_mkfs -m crc=1,inobtcount=1,finobt=0 &> $seqres.full && \
> diff --git a/tests/xfs/160 b/tests/xfs/160
> index 399fe4bcf..134b38a18 100755
> --- a/tests/xfs/160
> +++ b/tests/xfs/160
> @@ -18,6 +18,7 @@ _supported_fs xfs
>  _require_command "$XFS_ADMIN_PROG" "xfs_admin"
>  _require_scratch_xfs_bigtime
>  _require_xfs_repair_upgrade bigtime
> +_require_xfs_nocrc
>  
>  date --date='Jan 1 00:00:00 UTC 2040' > /dev/null 2>&1 || \
>  	_notrun "Userspace does not support dates past 2038."
> diff --git a/tests/xfs/194 b/tests/xfs/194
> index 5a1dff5d2..2ef9403bb 100755
> --- a/tests/xfs/194
> +++ b/tests/xfs/194
> @@ -30,6 +30,8 @@ _supported_fs xfs
>  # real QA test starts here
>  
>  _require_scratch
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
> diff --git a/tests/xfs/513 b/tests/xfs/513
> index ce2bb3491..42eceeb90 100755
> --- a/tests/xfs/513
> +++ b/tests/xfs/513
> @@ -37,6 +37,7 @@ _fixed_by_kernel_commit 237d7887ae72 \
>  _require_test
>  _require_loop
>  _require_xfs_io_command "falloc"
> +_require_xfs_nocrc
>  
>  LOOP_IMG=$TEST_DIR/$seq.dev
>  LOOP_SPARE_IMG=$TEST_DIR/$seq.logdev
> diff --git a/tests/xfs/526 b/tests/xfs/526
> index 4261e8497..188d0d514 100755
> --- a/tests/xfs/526
> +++ b/tests/xfs/526
> @@ -26,6 +26,7 @@ _supported_fs xfs
>  _require_test
>  _require_scratch_nocheck
>  _require_xfs_mkfs_cfgfile
> +_require_xfs_nocrc
>  
>  cfgfile=$TEST_DIR/a
>  rm -rf $cfgfile
> -- 
> 2.39.2
> 
> 
