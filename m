Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1EF32C6C;
	Thu, 29 Feb 2024 01:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709170902; cv=none; b=OaAJe3Bb9k3r1XKQlQrRDJ1QL0ehbFT8ifFVDZfD/ZU7rmJMu2bUmUD3PF6x4pdAVfUfCs7sC+wveTn0ZAh+tsWi0u/VuaN0xlHgysPspFgqvkajXAKwZ/Y4B077F2R2B/XJW0WkUaD3pjt3IbWwNIg1is0weZ5c7gzGBe+7N9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709170902; c=relaxed/simple;
	bh=EbS7KTe9Idjh2tZmuWfIU803UZCyxj8oM773ssgElcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2wQhitYKUdNtFvzWtF2Hr8rbyQzmAL4Em7sGOdcIIQGqrDQBjuQT4RZSmEoeTELOOJ8sZHqWhG7Lm2Eo1X8ZrHZZqf7/emxE95E22fDkvfhOMkfweYopuxK1BdiM4ohJlb2q3EGZSv4gu4takRRZYhhBVhc4kKTOuEp8stcW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PadnlnQN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PadnlnQN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F4CC433F1;
	Thu, 29 Feb 2024 01:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709170901;
	bh=EbS7KTe9Idjh2tZmuWfIU803UZCyxj8oM773ssgElcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PadnlnQNA5LCuXFlDK5Sr6MxvFGgfek3vCYZ4+rxBWtENAALBX7Jn+IIBROIIfeT8
	 wCd2B6r+9lkWoGFdpxrtSL6U/J1z0Mivqt9a4zzyeIjw4PDA4YJ2dPvAz2tGzoo4fR
	 +SCkxdtIpivtszRL4e3ntiIlmE/60R16xnSulasLnELvAELVkiCgquApiTz0oshU+e
	 ytBPlhZvtDpNiT31NOOL5pnMXsYXmNLXmmRXrEUIefJLgdWj/lKSazj9gpWf2qCk8C
	 /jr3gMPLoXhESG0zjeWxHJF2MGAZyhFgYFLP2qpIux00IRhPoKF9ix3SR0zniINKWR
	 ebau0tqDfG5rw==
Date: Wed, 28 Feb 2024 17:41:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] generic: check logical-sector sized O_DIRECT
Message-ID: <20240229014140.GU6226@frogsfrogsfrogs>
References: <20221107045618.2772009-1-zlang@kernel.org>
 <20240228155929.GD1927156@frogsfrogsfrogs>
 <20240229005218.pwgakn5x3fwwcjnj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240229005218.pwgakn5x3fwwcjnj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Thu, Feb 29, 2024 at 08:52:18AM +0800, Zorro Lang wrote:
> On Wed, Feb 28, 2024 at 07:59:29AM -0800, Darrick J. Wong wrote:
> > On Mon, Nov 07, 2022 at 12:56:18PM +0800, Zorro Lang wrote:
> > > If the physical sector size is 4096, but the logical sector size
> > > is 512, the 512b dio write/read should be allowed.
> > 
> > Huh, did we all completely forget to review this patch?
> 
> Hmm?? This patch has been reviewed and merged in 2022, refer to g/704.
> Why did it appear (be refreshed) at here suddenly ?

Doh!

Sorry, I saw this patch sitting by itself with no replies or "Hey I
merged this" messages and thought we'd forgotten it.

And if it's running without problems (I haven't seen any in generic/704)
then I'll leave well enough alone.

--D

> > 
> > > Signed-off-by: Zorro Lang <zlang@kernel.org>
> > > ---
> > > 
> > > Hi,
> > > 
> > > This reproducer was written for xfs, I try to make it to be a generic
> > > test case for localfs. Current it test passed on xfs, extN and btrfs,
> > > the bug can be reproduced on old rhel-6.6 [1]. If it's not right for
> > > someone fs, please feel free to tell me.
> > > 
> > > Thanks,
> > > Zorro
> > > 
> > > [1]
> > > # ./check generic/888
> > > FSTYP         -- xfs (non-debug)
> > > PLATFORM      -- Linux/x86_64 xxx-xxxxx-xxxxxx 2.6.32-504.el6.x86_64
> > > MKFS_OPTIONS  -- -f -bsize=4096 /dev/loop1
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:nfs_t:s0 /dev/loop1 /mnt/scratch
> > > 
> > > generic/888      - output mismatch (see /root/xfstests-dev/results//generic/888.out.bad)
> > >     --- tests/generic/888.out   2022-11-06 23:42:44.683040977 -0500
> > >     +++ /root/xfstests-dev/results//generic/888.out.bad 2022-11-06 23:48:33.986481844 -0500
> > >     @@ -4,3 +4,4 @@
> > >      512
> > >      mkfs and mount
> > >      DIO read/write 512 bytes
> > >     +pwrite64: Invalid argument
> > >     ...
> > >     (Run 'diff -u tests/generic/888.out /root/xfstests-dev/results//generic/888.out.bad'  to see the entire diff)
> > > Ran: generic/888
> > > Failures: generic/888
> > > Failed 1 of 1 tests
> > > 
> > >  tests/generic/888     | 52 +++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/888.out |  6 +++++
> > >  2 files changed, 58 insertions(+)
> > >  create mode 100755 tests/generic/888
> > >  create mode 100644 tests/generic/888.out
> > > 
> > > diff --git a/tests/generic/888 b/tests/generic/888
> > > new file mode 100755
> > > index 00000000..b5075d1e
> > > --- /dev/null
> > > +++ b/tests/generic/888
> > > @@ -0,0 +1,52 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 888
> > > +#
> > > +# Make sure logical-sector sized O_DIRECT write is allowed
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick
> > > +
> > > +# Override the default cleanup function.
> > > +_cleanup()
> > > +{
> > > +	cd /
> > > +	rm -r -f $tmp.*
> > > +	[ -d "$SCSI_DEBUG_MNT" ] && $UMOUNT_PROG $SCSI_DEBUG_MNT 2>/dev/null
> > > +	_put_scsi_debug_dev
> > > +}
> > > +
> > > +# Import common functions.
> > > +. ./common/scsi_debug
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_fixed_by_kernel_commit 7c71ee78031c "xfs: allow logical-sector sized O_DIRECT"
> > > +_require_scsi_debug
> > > +# If TEST_DEV is block device, make sure current fs is a localfs which can be
> > > +# written on scsi_debug device
> > > +_require_test
> > > +_require_block_device $TEST_DEV
> > 
> > _require_odirect?
> > 
> > > +
> > > +echo "Get a device with 4096 physical sector size and 512 logical sector size"
> > > +SCSI_DEBUG_DEV=`_get_scsi_debug_dev 4096 512 0 256`
> > > +blockdev --getpbsz --getss $SCSI_DEBUG_DEV
> > > +
> > > +echo "mkfs and mount"
> > > +_mkfs_dev $SCSI_DEBUG_DEV || _fail "Can't make $FSTYP on scsi_debug device"
> > > +SCSI_DEBUG_MNT="$TEST_DIR/scsi_debug_$seq"
> > > +rm -rf $SCSI_DEBUG_MNT
> > > +mkdir $SCSI_DEBUG_MNT
> > > +run_check _mount $SCSI_DEBUG_DEV $SCSI_DEBUG_MNT
> > 
> > /me wonders, should we try to use $MKFS_OPTIONS and $MOUNT_OPTIONS
> > on the scsidebug device?  To catch cases where the config actually
> > matters for that kind of thing?
> 
> It's been merged, if we need to change something, better to send a new
> patch to change that :)
> 
> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > +
> > > +echo "DIO read/write 512 bytes"
> > > +# This dio write should succeed, even the physical sector size is 4096, but
> > > +# the logical sector size is 512
> > > +$XFS_IO_PROG -d -f -c "pwrite 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > +$XFS_IO_PROG -d -c "pread 0 512" $SCSI_DEBUG_MNT/testfile >> $seqres.full
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/888.out b/tests/generic/888.out
> > > new file mode 100644
> > > index 00000000..0f142ce9
> > > --- /dev/null
> > > +++ b/tests/generic/888.out
> > > @@ -0,0 +1,6 @@
> > > +QA output created by 888
> > > +Get a device with 4096 physical sector size and 512 logical sector size
> > > +4096
> > > +512
> > > +mkfs and mount
> > > +DIO read/write 512 bytes
> > > -- 
> > > 2.31.1
> > > 
> > 
> 
