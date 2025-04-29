Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D04F219307;
	Tue, 29 Apr 2025 14:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745938343; cv=none; b=G6Z0QJOH1DiwAnaPuVhX3PzRoX7YmTix4/gEotLpqOAQ8f2Iz/caP19wlTtv98I/mmTS7IFpELZaJYxnakZhoJHBaxsehZfHteFpAP1203nB8DLluRQW6MmIDfy0atb1FInzUA64XheWMMYFR2Ja7JGqnK/R6CWUnQNyg5Kf76k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745938343; c=relaxed/simple;
	bh=2KKHNkYhxe1N7/a2M1dbUCZhDAf2dqm9QoC+G9Jmil0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jfIV4iZpTLBL0qceAd/KFzUMKSHxo9N8f5tWjIMt3yXN/zRBmcO3RUnvZ8Acg7T/sGBR+WHeC01WYB6BGewpN9wyGJvoUSD3rcD+z0U9lN4hlwcn4XGW4jo0M4eEf4m69SEP+9NyJD35/Tq999+V+flmjg4vYk3QWweBSc3lRsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXULj9Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXULj9Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F45C4CEE3;
	Tue, 29 Apr 2025 14:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745938342;
	bh=2KKHNkYhxe1N7/a2M1dbUCZhDAf2dqm9QoC+G9Jmil0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXULj9NiNdluEGzQ7A+/5AbohWF+3XzABOK/9tFZRLm914XUI1zCR60KnqA2ci+AQ
	 8tcle+8Gfn97wv9EWys6NpbvUSZ5IM8NJ9auP4kqoGQj32fmGVxIa1sCnn4Y8bubNM
	 wRu9GhtBcgSvjBgnVK7q5HR+++6zWMalevFsjbzTwskzFJMoF4QOa1Xedc1SxZ4d/u
	 NDN9XDHjDjKttuKUC0cKk2aSOWf/6uTSfawgYfpVKS+2o5+GzySAcgc2ytu5AXl/cF
	 rU28TNI6E6lDJzBfTV+il1HU6QXE10IJz8KRp0CwqL2dhGWwdQOoW/i715sHAm4G/X
	 zLWLOM200BjZg==
Date: Tue, 29 Apr 2025 07:52:21 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
	"zlang@kernel.org" <zlang@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	"david@fromorbit.com" <david@fromorbit.com>, hch <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: add mount test for read only rt devices
Message-ID: <20250429145220.GU25675@frogsfrogsfrogs>
References: <20250425090259.10154-1-hans.holmberg@wdc.com>
 <20250425090259.10154-2-hans.holmberg@wdc.com>
 <20250425150331.GG25667@frogsfrogsfrogs>
 <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7079f6ce-e218-426a-9609-65428bbdfc99@wdc.com>

On Tue, Apr 29, 2025 at 12:03:20PM +0000, Hans Holmberg wrote:
> On 25/04/2025 17:04, Darrick J. Wong wrote:
> > On Fri, Apr 25, 2025 at 09:03:22AM +0000, Hans Holmberg wrote:
> >> Make sure that we can mount rt devices read-only if them themselves
> >> are marked as read-only.
> >>
> >> Also make sure that rw re-mounts are not allowed if the device is
> >> marked as read-only.
> >>
> >> Based on generic/050.
> >>
> >> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> >> ---
> >>  tests/xfs/837     | 55 +++++++++++++++++++++++++++++++++++++++++++++++
> >>  tests/xfs/837.out | 10 +++++++++
> >>  2 files changed, 65 insertions(+)
> >>  create mode 100755 tests/xfs/837
> >>  create mode 100644 tests/xfs/837.out
> >>
> >> diff --git a/tests/xfs/837 b/tests/xfs/837
> >> new file mode 100755
> >> index 000000000000..b20e9c5f33f2
> >> --- /dev/null
> >> +++ b/tests/xfs/837
> >> @@ -0,0 +1,55 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2009 Christoph Hellwig.
> >> +# Copyright (c) 2025 Western Digital Corporation
> >> +#
> >> +# FS QA Test No. 837
> >> +#
> >> +# Check out various mount/remount/unmount scenarious on a read-only rtdev
> >> +# Based on generic/050
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest mount auto quick
> >> +
> >> +_cleanup_setrw()
> >> +{
> >> +	cd /
> >> +	blockdev --setrw $SCRATCH_RTDEV
> >> +}
> >> +
> >> +# Import common functions.
> >> +. ./common/filter
> >> +
> >> +_require_realtime
> >> +_require_local_device $SCRATCH_RTDEV
> > 
> > I suspect this is copy-pasted from generic/050, but I wonder when
> > SCRATCH_RTDEV could be a character device, but maybe that's a relic of
> > Irix (and Solaris too, IIRC)?
> 
> Yeah, this was carried over from generic/050, and I can just drop it
> unless there is a good reason for keeping it?

I think you still need the _require_local_device call itself.

And come to think of it, weren't there supposed to be pmem filesystems
which would run entirely off a pmem character device and not have a
block interface available at all?

Though for an xfs-specific test we'll blow up pretty fast if
SCRATCH_RTDEV isn't a bdev so <shrug>.

> <pardon replying again Darrick, forgot to reply-all yesterday>

(I seriously didn't even notice.)

--D

> > 
> > The rest of the test looks fine to me though.
> > 
> > --D
> > 
> >> +_register_cleanup "_cleanup_setrw"
> >> +
> >> +_scratch_mkfs "-d rtinherit" > /dev/null 2>&1
> >> +
> >> +#
> >> +# Mark the rt device read-only.
> >> +#
> >> +echo "setting device read-only"
> >> +blockdev --setro $SCRATCH_RTDEV
> >> +
> >> +#
> >> +# Mount it and make sure it can't be written to.
> >> +#
> >> +echo "mounting read-only rt block device:"
> >> +_scratch_mount 2>&1 | _filter_ro_mount | _filter_scratch
> >> +if [ "${PIPESTATUS[0]}" -eq 0 ]; then
> >> +	echo "writing to file on read-only filesystem:"
> >> +	dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 oflag=direct 2>&1 | _filter_scratch
> >> +else
> >> +	_fail "failed to mount"
> >> +fi
> >> +
> >> +echo "remounting read-write:"
> >> +_scratch_remount rw 2>&1 | _filter_scratch | _filter_ro_mount
> >> +
> >> +echo "unmounting read-only filesystem"
> >> +_scratch_unmount 2>&1 | _filter_scratch | _filter_ending_dot
> >> +
> >> +# success, all done
> >> +echo "*** done"
> >> +status=0
> >> diff --git a/tests/xfs/837.out b/tests/xfs/837.out
> >> new file mode 100644
> >> index 000000000000..0a843a0ba398
> >> --- /dev/null
> >> +++ b/tests/xfs/837.out
> >> @@ -0,0 +1,10 @@
> >> +QA output created by 837
> >> +setting device read-only
> >> +mounting read-only rt block device:
> >> +mount: device write-protected, mounting read-only
> >> +writing to file on read-only filesystem:
> >> +dd: failed to open 'SCRATCH_MNT/foo': Read-only file system
> >> +remounting read-write:
> >> +mount: cannot remount device read-write, is write-protected
> >> +unmounting read-only filesystem
> >> +*** done
> >> -- 
> >> 2.34.1
> >>
> > 
> 
