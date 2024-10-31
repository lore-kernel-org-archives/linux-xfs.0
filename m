Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0FB1953A2;
	Thu, 31 Oct 2024 16:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392525; cv=none; b=L+g3Bql1pZpYEIWyBqD0BLb2Kal3dmAuHw6+K7KA/pG3mpcvBHjt2TedLfXYqB5VEurQ4RRtVvO1z584gih8f+wHFl+p6v5hzvh7veyNXjJz41oWcGBIkj+ETqZjbC4WcPObzO6fEG0nMTBtZhto+vFVi0+jXvZkZrUQ9Bh0QEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392525; c=relaxed/simple;
	bh=9ICWSgF86KEzkURGgzatd13QF03GaXq/xs2m0N2bDGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSLpAHAaqDce020bQGxgIvBkKakL4xxWe9MQpBEIKfH3TK3aQQ5izhCo/WbyVfUBm7otc9ipHDw81UTeZJzjKnC+YVVOI66VsaTrY5eOLqzh8Y0dWh4HK30T05sK220bLMlh75Emv/GxHd/+4QQdFbO1wvvpMMYT6XY2swRp+UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r8N3j1/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r8N3j1/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8581C4E68E;
	Thu, 31 Oct 2024 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730392524;
	bh=9ICWSgF86KEzkURGgzatd13QF03GaXq/xs2m0N2bDGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r8N3j1/5LQ6ZqK/duru4TS1IC4/x4VecTKswTch+fRASN33/fO8vx4yduJUZYqiq1
	 ODAnBJyn/kZBLgePkfM57jl4pO6midcrVBhmW+ycvmFTVfw7xVtVJSlm6Gu55taoIr
	 Nf/QKnKXkyBdZfuVAoaFn8iesagJ8mf73uWRr76brmtTrAY5A56Zb0jw+6rVuZ0TML
	 Mdn2CG6oaA7IVfzk3TjBhGVZVihIOPUQ0aF+uVLHsA1cQTsKifiSeLfrtDGPUkCXnO
	 uCn4V9sDA6cQhB9G6HxVmJ1sZ5EcgmmyyU4gEBr8OCtCJo3aVnJ4YFUE/+GNVxkBfS
	 6UZfRg5mXmATQ==
Date: Thu, 31 Oct 2024 09:35:24 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 2/2] xfs: online grow vs. log recovery stress test
 (realtime version)
Message-ID: <20241031163524.GY2386201@frogsfrogsfrogs>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241029172135.329428-3-bfoster@redhat.com>
 <20241030195456.3busw2tbqqzinkm4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZyOEMYid4ybKu3_E@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyOEMYid4ybKu3_E@bfoster>

On Thu, Oct 31, 2024 at 09:20:49AM -0400, Brian Foster wrote:
> On Thu, Oct 31, 2024 at 03:54:56AM +0800, Zorro Lang wrote:
> > On Tue, Oct 29, 2024 at 01:21:35PM -0400, Brian Foster wrote:
> > > This is fundamentally the same as the previous growfs vs. log
> > > recovery test, with tweaks to support growing the XFS realtime
> > > volume on such configurations. Changes include using the appropriate
> > > mkfs params, growfs params, and enabling realtime inheritance on the
> > > scratch fs.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > 
> > 
> > 
> > >  tests/xfs/610     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/610.out |  2 ++
> > >  2 files changed, 85 insertions(+)
> > >  create mode 100755 tests/xfs/610
> > >  create mode 100644 tests/xfs/610.out
> > > 
> > > diff --git a/tests/xfs/610 b/tests/xfs/610
> > > new file mode 100755
> > > index 00000000..6d3a526f
> > > --- /dev/null
> > > +++ b/tests/xfs/610
> > > @@ -0,0 +1,83 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 610
> > > +#
> > > +# Test XFS online growfs log recovery.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto growfs stress shutdown log recoveryloop
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +
> > > +_stress_scratch()
> > > +{
> > > +	procs=4
> > > +	nops=999999
> > > +	# -w ensures that the only ops are ones which cause write I/O
> > > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > > +	    -n $nops $FSSTRESS_AVOID`
> > > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > > +}
> > > +
> > > +_require_scratch
> > > +_require_realtime
> > > +_require_command "$XFS_GROWFS_PROG" xfs_growfs
> > > +_require_command "$KILLALL_PROG" killall
> > > +
> > > +_cleanup()
> > > +{
> > > +	$KILLALL_ALL fsstress > /dev/null 2>&1
> > > +	wait
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > > +
> > > +endsize=`expr 550 \* 1048576`	# stop after growing this big
> > > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > > +
> > > +nags=4
> > > +size=`expr 125 \* 1048576`	# 120 megabytes initially
> > > +sizeb=`expr $size / $dbsize`	# in data blocks
> > > +logblks=$(_scratch_find_xfs_min_logblocks -rsize=${size} -dagcount=${nags})
> > > +
> > > +_scratch_mkfs_xfs -lsize=${logblks}b -rsize=${size} -dagcount=${nags} \
> > > +	>> $seqres.full || _fail "mkfs failed"
> > 
> > Ahah, not sure why this case didn't hit the failure of xfs/609, do you think
> > we should filter out the mkfs warning too?

It won't-- the warning you got with 609 was about ignoring stripe
geometry on a small data volume.  This mkfs invocation creates a
filesystem with a normal size data volume and a small rt volume, and
mkfs doesn't complain about small rt volumes.

--D

> My experience with this test is that it didn't reproduce any problems on
> current master, but Darrick had originally customized it from xfs/609
> and found it useful to identify some issues in outstanding development
> work around rt.
> 
> I've been trying to keep the two tests consistent outside of enabling
> the appropriate rt bits, so I'd suggest we apply the same changes here
> as for 609 around the mkfs thing (whichever way that goes).
> 
> > SECTION       -- default
> > FSTYP         -- xfs (non-debug)
> > PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> > MKFS_OPTIONS  -- -f -rrtdev=/dev/mapper/testvg-rtdev /dev/sda6
> > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 -ortdev=/dev/mapper/testvg-rtdev /dev/sda6 /mnt/scratch
> > 
> > xfs/610        39s
> > Ran: xfs/610
> > Passed all 1 tests
> > 
> > > +_scratch_mount
> > > +_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
> > > +
> > > +# Grow the filesystem in random sized chunks while stressing and performing
> > > +# shutdown and recovery. The randomization is intended to create a mix of sub-ag
> > > +# and multi-ag grows.
> > > +while [ $size -le $endsize ]; do
> > > +	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
> > > +	_stress_scratch
> > > +	incsize=$((RANDOM % 40 * 1048576))
> > > +	size=`expr $size + $incsize`
> > > +	sizeb=`expr $size / $dbsize`	# in data blocks
> > > +	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
> > > +	$XFS_GROWFS_PROG -R ${sizeb} $SCRATCH_MNT >> $seqres.full
> > > +
> > > +	sleep $((RANDOM % 3))
> > > +	_scratch_shutdown
> > > +	ps -e | grep fsstress > /dev/null 2>&1
> > > +	while [ $? -eq 0 ]; do
> > > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > > +		wait > /dev/null 2>&1
> > > +		ps -e | grep fsstress > /dev/null 2>&1
> > > +	done
> > > +	_scratch_cycle_mount || _fail "cycle mount failed"
> > 
> > _scratch_cycle_mount does _fail if it fails, I'll help to remove the "|| _fail ..."
> > 
> 
> Ok.
> 
> > > +done > /dev/null 2>&1
> > > +wait	# stop for any remaining stress processes
> > > +
> > > +_scratch_unmount
> > 
> > If this ^^ isn't a necessary step of bug reproduce, then we don't need to do this
> > manually, each test case does that at the end. I can help to remove it when I
> > merge this patch.
> > 
> 
> Hm I don't think so. That might also just be copy/paste leftover. Feel
> free to drop it.
> 
> > Others looks good to me,
> > 
> > Reviewed-by: Zorro Lang <zlang@redaht.com>
> > 
> 
> Thanks!
> 
> Brian
> 
> > 
> > > +
> > > +echo Silence is golden.
> > > +
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/610.out b/tests/xfs/610.out
> > > new file mode 100644
> > > index 00000000..c42a1cf8
> > > --- /dev/null
> > > +++ b/tests/xfs/610.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 610
> > > +Silence is golden.
> > > -- 
> > > 2.46.2
> > > 
> > > 
> > 
> 
> 
