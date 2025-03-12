Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224CE1EB9E1;
	Wed, 12 Mar 2025 20:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811409; cv=none; b=Fp5ztDxLKGvyr1vwY9En8fMTmvYUlfW8yzAKFEY+NGqPqs2+JbSlRPiFSuH2sJSrDkCN8oClHBjlBATWNvg4KRhxjiBG96pOl/88sW3Zc8xxrH2FCi2KCXDX1JcXPMj0sorDr4FtO4fHGqh0p3M3ofoomDNO2qi35jrapRQjOgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811409; c=relaxed/simple;
	bh=jsQ8INpJhUBPBOurC5b/debpTeqG3a/KEKZmqrk6jVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3uLsZEGjT9+zCyE+Gum69nE4RrjBVhXNcaDWjMzFjlHayVIjtgOX2qviKY8eCvLVSQsbRBtJHzjv4VboOjgg8/FY6kyUADo9TiG+THnmR55IATLLqGcDLqGEEPnuEDjCcNGRGAW81J50T7o53gxUxqoWkKrebFx1w6xPqGYar8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaCt+xMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaCt+xMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6C5C4CEDD;
	Wed, 12 Mar 2025 20:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741811408;
	bh=jsQ8INpJhUBPBOurC5b/debpTeqG3a/KEKZmqrk6jVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gaCt+xMhRsPXnKQIj0Ji2F3+Zr995no3uhlmQKFuLnrHUVwSoo/6Ozj6P602b2qtk
	 1kq/gKovn6/BybdFbksRzRpZZuFCTHK2YW3pFfHDcTJF/5VAP4uAmWXKKk2YWYeiye
	 OqRaqkFXC7M4Wq8/ja/DA4zcFRjizoZZLcycU+qHeerOIbF6hUMdDNAyOmydhx25nG
	 dcQLcOyQLaLZk6VHHyqvC8K4uWTh0v3EH2T2d62OXOQlFJKyM8dbUXS0HPcXvRy7av
	 SkZuDIq1+v5sr/8GW65mI5aOu+KtmikVXGIyrj3LgKAR+lq/bh3Ntie98xM8lSLGcn
	 kb0gRbRYWZUww==
Date: Wed, 12 Mar 2025 13:30:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/17] xfs: skip various tests when using the zoned
 allocator
Message-ID: <20250312203008.GQ2803749@frogsfrogsfrogs>
References: <20250312064541.664334-1-hch@lst.de>
 <20250312064541.664334-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250312064541.664334-17-hch@lst.de>

On Wed, Mar 12, 2025 at 07:45:08AM +0100, Christoph Hellwig wrote:
> Various file system features tested are incompatible with the zoned
> allocator.  Add a _require_xfs_scratch_non_zoned to guard them.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  tests/xfs/015 |  7 +++++++
>  tests/xfs/041 |  5 +++++
>  tests/xfs/272 |  5 +++++
>  tests/xfs/276 |  5 +++++
>  tests/xfs/306 |  4 ++++
>  tests/xfs/419 |  3 +++
>  tests/xfs/449 |  3 +++
>  tests/xfs/521 |  3 +++
>  tests/xfs/524 |  4 ++++
>  tests/xfs/540 |  3 +++
>  tests/xfs/541 |  3 +++
>  tests/xfs/556 | 13 +++++++++++++
>  tests/xfs/596 |  3 +++
>  13 files changed, 61 insertions(+)
> 
> diff --git a/tests/xfs/015 b/tests/xfs/015
> index acaace0ce103..ddb3e0911813 100755
> --- a/tests/xfs/015
> +++ b/tests/xfs/015
> @@ -38,6 +38,13 @@ _require_scratch
>  # need 128M space, don't make any assumption
>  _scratch_mkfs >/dev/null 2>&1
>  _scratch_mount
> +
> +# This test tries to grow the data device, which doesn't work for internal
> +# zoned RT devices
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	_require_xfs_scratch_non_zoned
> +fi

Does growfs work for external zoned rt devices?

> +
>  _require_fs_space $SCRATCH_MNT 196608
>  _scratch_unmount
>  
> diff --git a/tests/xfs/041 b/tests/xfs/041
> index 780078d44eeb..6cbcef6cfff0 100755
> --- a/tests/xfs/041
> +++ b/tests/xfs/041
> @@ -44,6 +44,11 @@ bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
>  onemeginblocks=`expr 1048576 / $bsize`
>  _scratch_mount
>  
> +# Growing the data device doesn't work with an internal RT volume directly
> +# following the data device.  But even without that this test forces data
> +# to the data device, which often is tiny on zoned file systems.
> +_require_xfs_scratch_non_zoned
> +
>  # We're growing the data device, so force new file creation there
>  _xfs_force_bdev data $SCRATCH_MNT
>  
> diff --git a/tests/xfs/272 b/tests/xfs/272
> index 0a7a7273ac92..aa5831dc0234 100755
> --- a/tests/xfs/272
> +++ b/tests/xfs/272
> @@ -29,6 +29,11 @@ echo "Format and mount"
>  _scratch_mkfs > "$seqres.full" 2>&1
>  _scratch_mount
>  
> +# The synthetic devices for internal zoned rt devices confuse the parser
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	_require_xfs_scratch_non_zoned
> +fi
> +
>  # Make sure everything is on the data device
>  _xfs_force_bdev data $SCRATCH_MNT
>  
> diff --git a/tests/xfs/276 b/tests/xfs/276
> index b675e79b249a..2802fc03c473 100755
> --- a/tests/xfs/276
> +++ b/tests/xfs/276
> @@ -32,6 +32,11 @@ _scratch_mkfs | _filter_mkfs 2> "$tmp.mkfs" >/dev/null
>  cat "$tmp.mkfs" > $seqres.full
>  _scratch_mount
>  
> +# The synthetic devices for internal zoned rt devices confuse the parser
> +if [ -z "$SCRATCH_RTDEV" ]; then
> +	_require_xfs_scratch_non_zoned
> +fi
> +
>  # Don't let the rt extent size perturb the fsmap output with unwritten
>  # extents in places we don't expect them
>  test $rtextsz -eq $dbsize || _notrun "Skipping test due to rtextsize > 1 fsb"
> diff --git a/tests/xfs/306 b/tests/xfs/306
> index 8981cbd72e1c..e78493784233 100755
> --- a/tests/xfs/306
> +++ b/tests/xfs/306
> @@ -33,6 +33,10 @@ unset SCRATCH_RTDEV
>  _scratch_mkfs_xfs -d size=100m -n size=64k >> $seqres.full 2>&1
>  _scratch_mount
>  
> +# When using the zone allotator, mkfs still creates an internal RT ѕection by

                         allocator

Now you have me craving tator tots.

--D

> +# default and the above unsetting SCRATCH_RTDEV of doesn't work.
> +_require_xfs_scratch_non_zoned
> +
>  # Fill a source directory with many largish-named files. 1k uuid-named entries
>  # sufficiently populates a 64k directory block.
>  mkdir $SCRATCH_MNT/src
> diff --git a/tests/xfs/419 b/tests/xfs/419
> index 5e122a0b8763..94ae18743da9 100755
> --- a/tests/xfs/419
> +++ b/tests/xfs/419
> @@ -44,6 +44,9 @@ cat $tmp.mkfs >> $seqres.full
>  . $tmp.mkfs
>  _scratch_mount
>  
> +# no support for rtextsize > 1 on zoned file systems
> +_require_xfs_scratch_non_zoned
> +
>  test $rtextsz -ne $dbsize || \
>  	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
>  
> diff --git a/tests/xfs/449 b/tests/xfs/449
> index a739df50e319..d93d84952c6a 100755
> --- a/tests/xfs/449
> +++ b/tests/xfs/449
> @@ -38,6 +38,9 @@ fi
>  
>  _scratch_mount
>  
> +# can't grow data volume on mixed configs
> +_require_xfs_scratch_non_zoned
> +
>  $XFS_SPACEMAN_PROG -c "info" $SCRATCH_MNT > $tmp.spaceman
>  echo SPACEMAN >> $seqres.full
>  cat $tmp.spaceman >> $seqres.full
> diff --git a/tests/xfs/521 b/tests/xfs/521
> index c92c621a2fd4..0da05a55a276 100755
> --- a/tests/xfs/521
> +++ b/tests/xfs/521
> @@ -43,6 +43,9 @@ export SCRATCH_RTDEV=$rtdev
>  _scratch_mkfs -r size=100m > $seqres.full
>  _try_scratch_mount || _notrun "Could not mount scratch with synthetic rt volume"
>  
> +# zoned file systems only support zoned size-rounded RT device sizes
> +_require_xfs_scratch_non_zoned
> +
>  testdir=$SCRATCH_MNT/test-$seq
>  mkdir $testdir
>  
> diff --git a/tests/xfs/524 b/tests/xfs/524
> index ef47a8461bf7..6251863476e5 100755
> --- a/tests/xfs/524
> +++ b/tests/xfs/524
> @@ -25,6 +25,10 @@ _require_test
>  _require_scratch_nocheck
>  _require_xfs_mkfs_cfgfile
>  
> +# reflink is currently not supported for zoned devices, and the normal support
> +# checks for it don't work at mkfs time.
> +_require_non_zoned_device $SCRATCH_DEV
> +
>  echo "Silence is golden"
>  
>  def_cfgfile=$TEST_DIR/a
> diff --git a/tests/xfs/540 b/tests/xfs/540
> index 9c0fa3c6bb10..5595eee85a9b 100755
> --- a/tests/xfs/540
> +++ b/tests/xfs/540
> @@ -34,6 +34,9 @@ test $rtextsz -ne $dbsize || \
>  	_notrun "cannot set rt extent size ($rtextsz) larger than fs block size ($dbsize)"
>  
>  _scratch_mount >> $seqres.full 2>&1
> +# no support for rtextsize > 1 on zoned file systems
> +_require_xfs_scratch_non_zoned
> +
>  rootino=$(stat -c '%i' $SCRATCH_MNT)
>  _scratch_unmount
>  
> diff --git a/tests/xfs/541 b/tests/xfs/541
> index b4856d496d5e..2b8c7ba17ff8 100755
> --- a/tests/xfs/541
> +++ b/tests/xfs/541
> @@ -30,6 +30,9 @@ _require_scratch
>  SCRATCH_RTDEV="" _scratch_mkfs | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
>  _try_scratch_mount || _notrun "Can't mount file system"
>  
> +# Zoned file systems don't support rtextsize > 1
> +_require_xfs_scratch_non_zoned
> +
>  # Check that there's no realtime section.
>  source $tmp.mkfs
>  test $rtblocks -eq 0 || echo "expected 0 rtblocks, got $rtblocks"
> diff --git a/tests/xfs/556 b/tests/xfs/556
> index 83d5022e700c..f5ad90c869ba 100755
> --- a/tests/xfs/556
> +++ b/tests/xfs/556
> @@ -35,6 +35,19 @@ filter_scrub_errors() {
>  }
>  
>  _scratch_mkfs >> $seqres.full
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
> +_scratch_unmount
> +
>  _dmerror_init
>  _dmerror_mount >> $seqres.full 2>&1
>  
> diff --git a/tests/xfs/596 b/tests/xfs/596
> index 12c38c2e9604..5827f045b4e6 100755
> --- a/tests/xfs/596
> +++ b/tests/xfs/596
> @@ -44,6 +44,9 @@ _scratch_mkfs_xfs -rsize=${rtsize}m | _filter_mkfs 2> "$tmp.mkfs" >> $seqres.ful
>  onemeginblocks=`expr 1048576 / $dbsize`
>  _scratch_mount
>  
> +# growfs on zoned file systems only works on zone boundaries
> +_require_xfs_scratch_non_zoned
> +
>  # We're growing the realtime device, so force new file creation there
>  _xfs_force_bdev realtime $SCRATCH_MNT
>  
> -- 
> 2.45.2
> 
> 
