Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C524C37DE95;
	Fri, 13 Mar 2026 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773445266; cv=none; b=lKByf1sxEbZ5dTjoWe5U9K44i/LCx02kV6JVL4MDBoHnPkLsMvo1Mpy9GbfAAeu4TbZ6M7olxjNwSfBYb8GVxUn/BpF63/dokW2p2FmqhH9gP245Mt/RB00gEk2200gdEWPOk+9jhrcQjpxulPFr6DGLHDqqw6rPAZ786nhHud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773445266; c=relaxed/simple;
	bh=VtW4pkksUv6dfkxTaTy07edfanCdWpfeCuaSDM6cPg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=prPx/gwoX02+TOuFRuJAUKlGbqGTd+wqMoOrYntlWY+cKJ+IG/B7SeO0SJvgN5PGKsSprC78wAEJz4yIBiVW0QCQuKZK9nIaNXyXw7bpSeFxmhBSSgkdKkULuKXHCu5IohbKGmP9LAQSUJFTXMqnE6WMQGl4UQwF87O1LQQAyUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbZuH2Qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbZuH2Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97533C19421;
	Fri, 13 Mar 2026 23:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773445266;
	bh=VtW4pkksUv6dfkxTaTy07edfanCdWpfeCuaSDM6cPg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZbZuH2QmI8OjEkLm/ryX/kb/IcnTFzuTRHvWx/Qxdz2GxNWF3cKRRBweXAzmkah1D
	 wHzh8isy6J5uoz3g9SaGisZMVGY7/b3Orzg6KYsZ88lGb/8iEDDGo2Rl79UqA/w1ze
	 PjaRps/PxI9FOl6W8L1hYObu9r6J26bB5WfCWACcUjVBQYH5q+xpjzpeLmkCi8aqdn
	 6rCcDfO4AvE7PipmmnZ5ni2PHcUMSp/ra2kG7eRfWiewuirseJ3OO0H/oniq6t4SSh
	 XVMb+yJtylXoYO3MelWZHSZRVuCw73QZKIIDts7nNrloLEHx+Zz0rsNlAOMigOotCX
	 YUfqQGPRQdC8w==
Date: Fri, 13 Mar 2026 16:41:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/14] xfs: test xfs_healer can follow private mntns
 mount moves
Message-ID: <20260313234106.GF6023@frogsfrogsfrogs>
References: <20260310033846.GH1105363@frogsfrogsfrogs>
 <177311403712.1186408.7032564474004561606.stgit@frogsfrogsfrogs>
 <20260312142130.GG1770774@frogsfrogsfrogs>
 <20260313200553.xujzlttj66eg7mgm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313200553.xujzlttj66eg7mgm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 14, 2026 at 04:05:53AM +0800, Zorro Lang wrote:
> On Thu, Mar 12, 2026 at 07:21:30AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that when xfs_healer needs to reopen a filesystem to repair
> > it, it can still find the filesystem even if it has been mount --move'd.
> > This requires a bunch of private namespace magic.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tests/xfs/1904     |  129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/1904.out |    3 +
> >  2 files changed, 132 insertions(+)
> >  create mode 100755 tests/xfs/1904
> >  create mode 100755 tests/xfs/1904.out
> > 
> > diff --git a/tests/xfs/1904 b/tests/xfs/1904
> > new file mode 100755
> > index 00000000000000..78e8f5dcb0e834
> > --- /dev/null
> > +++ b/tests/xfs/1904
> > @@ -0,0 +1,129 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Oracle.  All Rights Reserved.
> > +#
> > +# FS QA Test 1904
> > +#
> > +# Ensure that autonomous self healing fixes the filesystem correctly even if
> > +# the original mount has moved somewhere else via --move.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto selfhealing
> > +
> > +. ./common/filter
> > +. ./common/fuzzy
> > +. ./common/systemd
> > +
> > +if [ -n "$IN_MOUNTNS" ]; then
> > +	_mount --make-rprivate /
> 
> I'd like to add this case and other cases related with mount propagation in this
> patchset to "mount" group. I'll do it when I merge this patchset. Others look and
> test good to me,

<nod> That sounds reasonable.  Thanks for all the other minor touch-ups
that you applied before merging into patches-in-queue!

--D

> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> > +	findmnt -o TARGET,PROPAGATION >> $seqres.full
> > +
> > +	_scratch_mount
> > +	_scratch_invoke_xfs_healer "$tmp.healer" --repair
> > +
> > +	# Move the scratch filesystem to a completely different mountpoint so that
> > +	# we can test if the healer can find it again.
> > +	new_dir=$TEST_DIR/moocow
> > +	mkdir -p $new_dir
> > +	_mount --move $SCRATCH_MNT $new_dir
> > +
> > +	df -t xfs >> $seqres.full
> > +
> > +	# Access the broken directory to trigger a repair, then poll the directory
> > +	# for 5 seconds to see if it gets fixed without us needing to intervene.
> > +	ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> > +	_filter_scratch < $tmp.err | _filter_test_dir
> > +	try=0
> > +	while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> > +		echo "try $try saw corruption" >> $seqres.full
> > +		sleep 0.1
> > +		ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> > +		try=$((try + 1))
> > +	done
> > +	echo "try $try no longer saw corruption or gave up" >> $seqres.full
> > +	_filter_scratch < $tmp.err | _filter_test_dir
> > +
> > +	# List the dirents of /victimdir to see if it stops reporting corruption
> > +	ls $new_dir/some/victimdir > /dev/null 2> $tmp.err
> > +	try=0
> > +	while [ $try -lt 50 ] && grep -q 'Structure needs cleaning' $tmp.err; do
> > +		echo "retry $try still saw corruption" >> $seqres.full
> > +		sleep 0.1
> > +		ls $SCRATCH_MNT/some/victimdir > /dev/null 2> $tmp.err
> > +		try=$((try + 1))
> > +	done
> > +	echo "retry $try no longer saw corruption or gave up" >> $seqres.full
> > +
> > +	new_dir_unmount() {
> > +		_unmount $new_dir
> > +	}
> > +
> > +	# Unmount to kill the healer
> > +	_scratch_kill_xfs_healer new_dir_unmount
> > +	cat $tmp.healer >> $seqres.full
> > +
> > +	# No need to clean up, the mount ns destructor will detach the
> > +	# filesystems for us.
> > +	exit
> > +fi
> > +
> > +_cleanup()
> > +{
> > +	command -v _kill_fsstress &>/dev/null && _kill_fsstress
> > +	cd /
> > +	rm -r -f $tmp.*
> > +	if [ -n "$new_dir" ]; then
> > +		_unmount "$new_dir" &>/dev/null
> > +		rm -rf "$new_dir"
> > +	fi
> > +}
> > +
> > +_require_unshare
> > +_require_test
> > +_require_scrub
> > +_require_xfs_io_command "repair"	# online repair support
> > +_require_xfs_db_command "blocktrash"
> > +_require_command "$XFS_HEALER_PROG" "xfs_healer"
> > +_require_command "$XFS_PROPERTY_PROG" "xfs_property"
> > +_require_scratch
> > +
> > +_scratch_mkfs >> $seqres.full
> > +_scratch_mount
> > +
> > +_xfs_has_feature $SCRATCH_MNT rmapbt || \
> > +	_notrun "reverse mapping required to test directory auto-repair"
> > +_xfs_has_feature $SCRATCH_MNT parent || \
> > +	_notrun "parent pointers required to test directory auto-repair"
> > +_require_xfs_healer $SCRATCH_MNT --repair
> > +
> > +# Configure the filesystem for automatic repair of the filesystem.
> > +$XFS_PROPERTY_PROG $SCRATCH_MNT set autofsck=repair >> $seqres.full
> > +
> > +# Create a largeish directory
> > +dblksz=$(_xfs_get_dir_blocksize "$SCRATCH_MNT")
> > +echo testdata > $SCRATCH_MNT/a
> > +mkdir -p "$SCRATCH_MNT/some/victimdir"
> > +for ((i = 0; i < (dblksz / 255); i++)); do
> > +	fname="$(printf "%0255d" "$i")"
> > +	ln $SCRATCH_MNT/a $SCRATCH_MNT/some/victimdir/$fname
> > +done
> > +
> > +# Did we get at least two dir blocks?
> > +dirsize=$(stat -c '%s' $SCRATCH_MNT/some/victimdir)
> > +test "$dirsize" -gt "$dblksz" || echo "failed to create two-block directory"
> > +
> > +# Break the directory, remount filesystem
> > +_scratch_unmount
> > +_scratch_xfs_db -x \
> > +	-c 'path /some/victimdir' \
> > +	-c 'bmap' \
> > +	-c 'dblock 1' \
> > +	-c 'blocktrash -z -0 -o 0 -x 2048 -y 2048 -n 2048' >> $seqres.full
> > +
> > +# mount --move only works if mount propagation is disabled, so we have to start
> > +# a subshell with a separate mount namespace, disable propagation for the
> > +# entire directory tree, and only then can we run our tests.
> > +IN_MOUNTNS=1 unshare -m bash "$0"
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/1904.out b/tests/xfs/1904.out
> > new file mode 100755
> > index 00000000000000..34a46298dd439a
> > --- /dev/null
> > +++ b/tests/xfs/1904.out
> > @@ -0,0 +1,3 @@
> > +QA output created by 1904
> > +QA output created by 1904
> > +ls: reading directory 'TEST_DIR/moocow/some/victimdir': Structure needs cleaning
> > 
> 
> 
