Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2537127990A;
	Mon, 24 Nov 2025 15:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998044; cv=none; b=KADqpUu6mVvWi7W6nRZ64hhizijMl4ztakVD//mfEwjNisJgG+kHExSxyFTAUxJFEREadiiMkp1ovN+XiC+pTdAWcotXj0hgtooTlEoVd2Nh7UzOPIE3rQu+RrhFqFH3m53LXxN2bWDzlgOkcZ0bSbyxrYXHnF0ebxnM+8dIVFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998044; c=relaxed/simple;
	bh=KBZLCgDQczk1qNfXgYUwHRe9gqN214in7GQPzckM670=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ed9YoXQVg2Oe3WTlrtfM9m2OVRcfLUh/dg5C7ElE1bYoeMuQ/q2YjyqO2E5M6vCMIKgVn6Qu+fK9sUUI3Ax7v0bpv3PjLlymtA3YqErgMeKSg6XmyZMNCnun7+omElUldYOgJw3fHCtxkRv+gNIAqy6rXWXbbBwt+0KZRh7caNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvnjU6Ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvnjU6Ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C111C4CEF1;
	Mon, 24 Nov 2025 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763998043;
	bh=KBZLCgDQczk1qNfXgYUwHRe9gqN214in7GQPzckM670=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fvnjU6EdLVX81N6UnSyZbNSaS4GDe2hs5MIkvFxl5JoNAmbpA6VrOo7j8yPqG4H1I
	 Q/yNke1cyTuh3z3QHCdtpttTw54EkgWB/zjevYCBj+Z97zdBm+c/jWdA02NoW4qqPa
	 LmB8ani4P1IYqAeWRSN5AReEtIw29MVzr3hdGHlKSFZWdjRzsyupPMGChpoKp7Tls/
	 lKgrhd08sEMiCB6WjtOdZ4JBCkCEN+uGhaQLYDCI0V1u+fFjZfCIJ1GU7MJcDyxMV8
	 eW55flIQho1ogzPX06MDKuyIIda23w57BrfokdTtVFlg2fN0T8v9GBEkfDOygXoxrT
	 Ofw9eAhSlrIlQ==
Date: Mon, 24 Nov 2025 16:27:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: "zlang@kernel.org" <zlang@kernel.org>, hch <hch@lst.de>, 
	Hans Holmberg <Hans.Holmberg@wdc.com>, "fstests@vger.kernel.org" <fstests@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: Add test for mkfs with smaller zone capacity
Message-ID: <ba3tbnjq2dernii2n6leyc6z76lcezsjemomtm54mrbm2xcnz5@kx3qp3qgrtqe>
References: <20251120160901.63810-1-cem@kernel.org>
 <20251120160901.63810-3-cem@kernel.org>
 <EffPQB_WQabsgl7V1GQULuAp9QQGB7KoH0wN5tHOvQUWRriHZorc1NPnsGnKEV1obcisN1kjuXM0KzubUhxk5Q==@protonmail.internalid>
 <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f6b4f20-9d71-49a5-a313-f860b3e8a4e3@wdc.com>

On Fri, Nov 21, 2025 at 06:51:31AM +0000, Johannes Thumshirn wrote:
> On 11/20/25 5:09 PM, cem@kernel.org wrote:
> > From: Carlos Maiolino <cem@kernel.org>
> >
> > Add a regression test for initializing zoned block devices with
> > sequential zones with a capacity smaller than the conventional
> > zones capacity.
> 
> 
> Hi Carlos,
> 
> Two quick questions:
> 
> 1) Is there a specific reason this is a xfs only test? I think checking
> this on btrfs and f2fs would make sense as well, like with generic/781.

I wrote this mostly as a regression test for xfs's mkfs, but yeah, I don't
think there is any reason for this to be xfs-specific.

> 
> 2)  I would also mount the FS and perform some IO on it.

I'm not sure about this. Do you have any purpose in mind? This is
specifically to test mkfs is able to properly format the filesystem, not
to try the kernel module per-se.
One could argue that something 'could' go wrong in the mkfs that might
be found out only via some IO, but that would require much more than
just 'some IO'.

I do think a mount/unmount might add some value to the test, but I fail
to see why issuing a random amount of I/O would prove the correctness of
mkfs properly dealing with small capacities.

Cheers.
Carlos

> 
> 
> 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >   tests/xfs/333     | 37 +++++++++++++++++++++++++++++++++++++
> >   tests/xfs/333.out |  2 ++
> >   2 files changed, 39 insertions(+)
> >   create mode 100755 tests/xfs/333
> >   create mode 100644 tests/xfs/333.out
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
> > +}
> > +
> > +_require_scratch
> > +_require_zloop
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount >> $seqres.full
> > +
> > +zloopdir="$SCRATCH_MNT/zloop"
> > +zone_size=64
> > +conv_zones=2
> > +zone_capacity=63
> > +
> > +zloop=$(_create_zloop $zloopdir $zone_size $conv_zones $zone_capacity)
> > +
> > +_try_mkfs_dev $zloop >> $seqres.full 2>&1 || \
> > +	_fail "Cannot mkfs zoned filesystem"
> > +
> > +echo Silence is golden
> > +# success, all done
> > +_exit 0
> > diff --git a/tests/xfs/333.out b/tests/xfs/333.out
> > new file mode 100644
> > index 000000000000..60a158987a22
> > --- /dev/null
> > +++ b/tests/xfs/333.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 333
> > +Silence is golden
> 
> 
