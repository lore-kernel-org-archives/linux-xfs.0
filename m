Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D84723C516;
	Sun, 14 Jun 2026 17:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781457572; cv=none; b=koUpgIFRC7M2v3xzkdPRYKCbQ9aSp/ga/Y3kVqrn6FNw5cF2H7k0IEi2SghYHML9zP7nH/mpnpQHITcgfGGH1of+HQqHFFuuqbgePMo3YNSG28zhy/CmtnyeP7TiU466sdGDHSZBOA/+VY+fMzu0lALDnIawz7A+3R3CKQ9xm50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781457572; c=relaxed/simple;
	bh=LVJlTBz5w/gtyttfCltBOTNj+p9wfB0O0/SZWKBxB3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boVYbDTNDS1h4WsfH8I8i7qenle6oXcD/YEB+7H4fVDdTBbKsHmiCX+7/K1t1PSrenYAJSZPekmCYhnwElrN5eIaFlGgkUpbR2VRPl+GQ/ZJEHbn+mvTJh6InqaWeWX/sMlrCagUK8q/m5ddH/DF8R91oRAvOXd1m3MDIgvs9tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFWT95ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFWT95ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5559C1F000E9;
	Sun, 14 Jun 2026 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781457570;
	bh=+JpSYa8yNSTX4l4xtUJzcVpl27WjiwEe7nusY6pn80U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JFWT95ulVkoiwHOoaT9HYXoHTigqI8yvgjHzDETS7P8j9Pc9AnLterbq8y4FxJl+u
	 k5orsXV0HT2dIPIpG+iRmji3TmSmTKQ+Q0UVqUp0+4Ag88LwCytZwS7FsdP0AtFxj+
	 jQiIi6Y0DQ74HkcqSQ/XzR4CoNVsqI5OvDseFoJG6BeyaT8BLMM3GsCSmvSUi78XP/
	 +2tj8aavcGTVhXOgsMNd7yBFSNKEKPY4YrXqU8S9Y4B97yq4+5sv33/7p9B6HDklsB
	 OBI7mzf8JJyuoo/TWQNYQJb2RzxPqJ3zVBThWduGm9OlXJacRBsSRu6UF2g0aBTaBn
	 CD4N4BRgvhQkw==
Date: Mon, 15 Jun 2026 01:19:25 +0800
From: Zorro Lang <zlang@kernel.org>
To: Yao Sang <sangyao@kylinos.cn>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de, 
	djwong@kernel.org
Subject: Re: [PATCH] xfs/333: test zoned realtime writeback EIO shutdown
Message-ID: <ai7iISyutG9agTkU@zlang-mailbox>
Mail-Followup-To: Yao Sang <sangyao@kylinos.cn>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, hch@lst.de, djwong@kernel.org
References: <20260612074231.1109213-1-sangyao@kylinos.cn>
 <ai7LiV1TrX5D_E2J@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ai7LiV1TrX5D_E2J@zlang-mailbox>

On Mon, Jun 15, 2026 at 12:19:09AM +0800, Zorro Lang wrote:
> On Fri, Jun 12, 2026 at 03:42:31PM +0800, Yao Sang wrote:
> > Create a zoned realtime filesystem with a single user data open zone,
> > dirty one zone worth of data, and inject a writeback error on the
> > realtime device.
> > 
> > After disabling fault injection, fsync a second write.  The filesystem
> > must already be shut down so that the second fsync fails quickly instead
> > of waiting for zoned allocation progress.
> > 
> > Signed-off-by: Yao Sang <sangyao@kylinos.cn>
> > ---
> > This is a test for the XFS zoned writeback shutdown fix posted as:
> > https://lore.kernel.org/all/20260611015305.1583003-1-sangyao@kylinos.cn/
> > 
> > Tested on a ZNS realtime XFS setup with fail_make_request enabled.  The
> > test passes with the v2 XFS fix applied.  On a kernel without that fix,
> > the second fsync waits behind the consumed open zone and reproduces the
> > hung writer condition.
> > 
> >  tests/xfs/333     | 69 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/333.out |  1 +
> >  2 files changed, 70 insertions(+)
> >  create mode 100755 tests/xfs/333
> >  create mode 100644 tests/xfs/333.out
> > 
> > diff --git a/tests/xfs/333 b/tests/xfs/333
> > new file mode 100755
> > index 00000000..aafee4c3
> > --- /dev/null
> > +++ b/tests/xfs/333
> > @@ -0,0 +1,69 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Kylin Software.
> > +#
> > +# FS QA Test No. 333
> > +#
> > +# Check that an unrecoverable writeback error on a zoned realtime device shuts
> > +# down the filesystem.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick rw zone eio
> > +
> > +. ./common/filter
> > +. ./common/fail_make_request
> > +. ./common/zoned
> > +
> > +_require_debugfs
> > +_require_scratch_nocheck
> > +_require_realtime
> > +_require_block_device $SCRATCH_RTDEV
> > +_require_zoned_device $SCRATCH_RTDEV
> > +_require_command "$BLKZONE_PROG" blkzone
> > +_require_fail_make_request
> > +
> > +_cleanup()
> > +{
> > +	[ -n "$SCRATCH_RTDEV" ] && \
> > +		_bdev_fail_make_request $SCRATCH_RTDEV 0 > /dev/null 2>&1
> > +	_disallow_fail_make_request > /dev/null 2>&1
> > +	_scratch_unmount > /dev/null 2>&1
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +_register_cleanup _cleanup
>    ^^^^^^^^^^^^^^^^^
> This line isn't necessary. Since "_register_cleanup _cleanup" is called in
> _begin_fstest, it only registers the function name (not function instance).
> The latest definition will be called automatically, so there's no need to
> worry.
> 
> > +
> > +zone_capacity=$(_zone_capacity 0 $SCRATCH_RTDEV)
> > +echo "zone capacity: $zone_capacity" >> $seqres.full
> > +
> > +_scratch_mkfs_sized $((256 * 1024 * 1024)) >> $seqres.full 2>&1
> > +
> > +# Leave only one open zone for user data.  If writeback fails after consuming
> > +# it, further writers must either see shutdown or wait forever for zone space.
> > +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
> > +_try_scratch_mount || _notrun "mount option not supported"
> > +_require_xfs_scratch_zoned 1
> > +
> > +_prepare_for_eio_shutdown $SCRATCH_DEV
>    ^^^^^^^^^^^^^^^^^^^^^^^^^
> This line is already called in _try_scratch_mount, don't need to call it again,
> except you want to run it on another device.
> 
> > +
> > +testfile=$SCRATCH_MNT/writeback-error
> > +waitfile=$SCRATCH_MNT/wait-for-zone
> > +
> > +$XFS_IO_PROG -f -c "pwrite -S 0x58 0 $zone_capacity" $testfile \
> > +	>> $seqres.full 2>&1 || _fail "failed to dirty test file"
> > +
> > +_allow_fail_make_request 100 100000 0 > /dev/null
> > +_bdev_fail_make_request $SCRATCH_RTDEV 1 > /dev/null
> > +
> > +$XFS_IO_PROG -c "fsync" $testfile >> $seqres.full 2>&1 && \
> > +	_fail "fsync succeeded despite realtime device error"
> > +
> > +_bdev_fail_make_request $SCRATCH_RTDEV 0 > /dev/null
> > +_disallow_fail_make_request > /dev/null
> > +
> > +$XFS_IO_PROG -f -c "pwrite -S 0x59 0 4k" -c "fsync" $waitfile \
> > +	>> $seqres.full 2>&1 && \
> > +	_fail "filesystem did not shut down after zoned writeback error"
> 
> OK, others looks good to me.
> 
> Since above changes are straightforward, if you don't have any other updates
> that require a V2, I can just remove those two redundant lines for you when
> merging.
> 
> Reviewed-by: Zorro Lang <zlang@kernel.org>
> 
> Thanks,
> Zorro
> 
> > +
> > +status=0
> > +exit

And,

echo "Silence is golden"
_exit 0

> > diff --git a/tests/xfs/333.out b/tests/xfs/333.out
> > new file mode 100644
> > index 00000000..3e11d156
> > --- /dev/null
> > +++ b/tests/xfs/333.out
> > @@ -0,0 +1 @@
> > +QA output created by 333

Silence is golden

I'll help to make all these changes when I merge it.

Thanks,
Zorro

> > -- 
> > 2.25.1
> > 
> 
