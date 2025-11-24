Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D548315783;
	Mon, 24 Nov 2025 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764000298; cv=none; b=dUg411cCvFfoPalEKcJg3SgBzkwdp9aaVWCjsygI/4il9a5EvyYncmMWxvRXoZxsPNuv1DB6A+5UQ9oxewUuLBvAKTa4QsG344VvSgbbk8GBZUKc07YMwY9LVwSON9pnNy9uzUtu2OqrlJTncrPEtkeQ8+yG9agOe8biAiCsH7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764000298; c=relaxed/simple;
	bh=5Oizxdcv2uWs5bYpc6drHEZNwgpR6Ou5Isxn6pRxBvA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uzIjjzpV670l2/QLXuNzhN//2cZsPn+12ghAbBnnEUyobKbsFAU1wEriXT36LG2EBqAiBQTkkEy2EiaRykETiCyHaIZi4KIj8VFdW2T3CAz6Rfp6vZGXpPzju7Ju/2wPmS1RC3RQrNQrpFLJfHU27wjfyKDoP/nvCRyZAlS5Ot8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qHwvtgcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qHwvtgcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B39C116C6;
	Mon, 24 Nov 2025 16:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764000297;
	bh=5Oizxdcv2uWs5bYpc6drHEZNwgpR6Ou5Isxn6pRxBvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHwvtgcTVNm0FMjjiimrjXIHg+T5ec3o5McEyWB/aHg6UDEW5iJhlv9VnN4DbU1Lm
	 5KZGliFcf08VTb/raQAyv8SQQCvbFuMCIcrk4ILBGlBhsM4swfUABaDpKw443hhwdl
	 V+mXPz7/n6O8UJRSmkxlR1Wo16dd9S9+aeCDNzrJpJPcllT33kk4rgK+/g3FVF8FuE
	 asAIKCpFeb0HVehXIGkvDX5R6NUV94KcooD5fyiI7DTInHdGAmk6MqbxTLV3o65dr2
	 /DcfPR9SDapF1JBtPlZ3J47WQ8mYtOmFTLwz/qygFQaLcxSgpW9s7kDuXuLZO3KxXR
	 5cZYQyXTDf9Pw==
Date: Mon, 24 Nov 2025 17:04:53 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: zlang@kernel.org, hch@lst.de, hans.holmberg@wdc.com, 
	johannes.thumshirn@wdc.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <rzrip62rmjpbsbl3bjqw2cwyx4dbpsduf4xfyirt6de3c4lgix@k5xkqctglsdh>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <1Er6m8v66cLRPPkVkwXoCR8wXEU5y1Khjii-1riIP34bdvPREzfHMCdLNsNhqFxfguCVPo0UuX53-Itbm7RbuQ==@protonmail.internalid>
 <20251122083646.ihtwb3k4eocnb7fe@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122083646.ihtwb3k4eocnb7fe@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Nov 22, 2025 at 04:36:46PM +0800, Zorro Lang wrote:
> On Thu, Nov 20, 2025 at 05:08:30PM +0100, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Add a regression test for initializing zoned block devices with
> > sequential zones with a capacity smaller than the conventional
> > zones capacity.
> >
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  tests/xfs/333     | 37 +++++++++++++++++++++++++++++++++++++
> >  tests/xfs/333.out |  2 ++
> >  2 files changed, 39 insertions(+)
> >  create mode 100755 tests/xfs/333
> >  create mode 100644 tests/xfs/333.out
> >
> > diff --git a/tests/xfs/333 b/tests/xfs/333
> > new file mode 100755
> > index 000000000000..f045b13c73ee
> > --- /dev/null
> > +++ b/tests/xfs/333
> > @@ -0,0 +1,37 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2025 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 333
> > +#
> > +# Test that mkfs can properly initialize zoned devices
> > +# with a sequential zone capacity smaller than the conventional zone.
> > +#
> > +. ./common/preamble
> > +. ./common/zoned
> > +
> > +_begin_fstest auto zone mkfs quick
> > +_cleanup()
> > +{
> > +	_destroy_zloop $zloop
> 
>         cd /
>         rm -r -f $tmp.*
> 
> > +}
> > +
> > +_require_scratch
> 
> _require_block_device $SCRATCH_DEV

I'll add to the V2.

> 
> > +_require_zloop
> 
> g/781 checks if current $FSTYP supports zoned filesystem, and _notrun if it's
> not supported:
> 
>         _try_mkfs_dev $zloop >> $seqres.full 2>&1 ||\
>                 _notrun "cannot mkfs zoned filesystem"
> 
> I'm wondering if we could have a common helper for that, then this case can be
> a generic test case too.
> 
> For example:
> 
> _require_zloop_filesystem()
> {
>         _require_zloop
> 
>         local zloopdir="$TEST_DIR/zloop_test"
>         local zloop=$(_create_zloop $zloopdir 64 2)
> 
> 	_try_mkfs_dev $zloop >/dev/null 2>&1 || \
> 		_notrun "cannot make $FSTYP on zloop"
> 	_destroy_zloop $zloop
> }
> 
> But this method takes too much time to run, does anyone have a better idea to help it
> to be finished in several seconds?
> 
> 
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount >> $seqres.full
> > +
> > +zloopdir="$SCRATCH_MNT/zloop"
> > +zone_size=64
> > +conv_zones=2
> > +zone_capacity=63
> 
> Better to add a comment to explain what are these numbers for.

Hmm, why? The variable names are very self-descriptive. I could add a
comment, but it's just redundant IMHO, ex:

zone_size=64		# Set zloop zone size to 64MiB

I added the variables instead of passing the numbers directly to
_create_zloop to avoid needing to go back and forth to _create_zloop
definition and make the meaning clear.
I'm fine adding the comments, I just don't see the point.


> 
> > +
> > +zloop=$(_create_zloop $zloopdir $zone_size $conv_zones $zone_capacity)
> > +
> > +_try_mkfs_dev $zloop >> $seqres.full 2>&1 || \
> > +	_fail "Cannot mkfs zoned filesystem"
> > +
> > +echo Silence is golden
> 
> Is this done? If such zloop device can be created, should we expect it works as usual?

Yes, the whole point is to ensure mkfs can initialize the filesystem on
top of the zoned block device.

Cheers,
Carlos
