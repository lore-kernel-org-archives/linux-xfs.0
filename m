Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A3919F110
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728689347; cv=none; b=Oi39WA8lXP+cKY7hJ8vX6dqmjY5t2hOrPQAsSeHDoq0yq24X9fi9lvxR4sCq1S1H4u5UPsMj0kq/f57o6nhRL9SH78mZZunL+7cGmoYVZI9Z84ZVqImXSe9bO5HJmD1OK1go1OtTMu+pbpSdrQaPR9tva4ak2bzw3xwF7s8Ws3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728689347; c=relaxed/simple;
	bh=WjQC6nuHKvp58Va1iWwMejXipxUxQqTIf40/2lbPWdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oYRM3MlV1SSpr2+vxext7PJuaPA1GsIr/Z4vSnXeMjcoznvpl5Q1bHMKxx3BWPC4W3M7LPJ3bFqFkKy3FtdC6pJt6w3jZytOglOs3kx1Sk3H50YYPij2yRYQYalTBNczQvf9nXotklk3v63ImjDy0/2Lhozp6aRNjeMWd61CZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u3XujJet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u3XujJet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D569FC4CEC3;
	Fri, 11 Oct 2024 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728689346;
	bh=WjQC6nuHKvp58Va1iWwMejXipxUxQqTIf40/2lbPWdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u3XujJetnbMglaeub0U7EUGFfOuw28vhg5Z+/ilSO9fM1DA0+llCBHXyHaPbiL2Fn
	 bpl3ow6KPO3zwKwsgTnHcfXZ7J9nv3gjJF/BmCUp9vvtlnpGi/+u4+3W3TSRDZTz89
	 ze/dosv8m76EHK8iGAQYIr9qHp7p/zHrKWQ/NsQiDril9C3ua3pSeiDjyakMUQoN7R
	 N4/ikipVYU1k7nmZtr2l1igvh/ZbYylVuQJ+St1SohKlXUrBgh4IKwsjMdN06tUs23
	 Dr4Q8fURugXfH7j0jua8+RrFZa+r4hFrqgiNHW9g+giN2eG+WYr61eWzb+d/FyZGKv
	 uOym4zN53XAdA==
Date: Fri, 11 Oct 2024 16:29:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <20241011232906.GE21853@frogsfrogsfrogs>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
 <20241011231241.GD21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011231241.GD21853@frogsfrogsfrogs>

On Fri, Oct 11, 2024 at 04:12:41PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 02:41:17PM -0400, Brian Foster wrote:
> > On Fri, Oct 11, 2024 at 10:13:03AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 11, 2024 at 10:02:16AM -0400, Brian Foster wrote:
> > > > On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> > > > > On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > > > > > Ok, so we don't want geometry changes transactions in the same CIL
> > > > > > checkpoint as alloc related transactions that might depend on the
> > > > > > geometry changes. That seems reasonable and on a first pass I have an
> > > > > > idea of what this is doing, but the description is kind of vague.
> > > > > > Obviously this fixes an issue on the recovery side (since I've tested
> > > > > > it), but it's not quite clear to me from the description and/or logic
> > > > > > changes how that issue manifests.
> > > > > > 
> > > > > > Could you elaborate please? For example, is this some kind of race
> > > > > > situation between an allocation request and a growfs transaction, where
> > > > > > the former perhaps sees a newly added AG between the time the growfs
> > > > > > transaction commits (applying the sb deltas) and it actually commits to
> > > > > > the log due to being a sync transaction, thus allowing an alloc on a new
> > > > > > AG into the same checkpoint that adds the AG?
> > > > > 
> > > > > This is based on the feedback by Dave on the previous version:
> > > > > 
> > > > > https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> > > > > 
> > > > 
> > > > Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
> > > > not sure I'd go straight to this change given the situation...
> > > > 
> > > > > Just doing the perag/in-core sb updates earlier fixes all the issues
> > > > > with my test case, so I'm not actually sure how to get more updates
> > > > > into the check checkpoint.  I'll try your exercisers if it could hit
> > > > > that.
> > > > > 
> > > > 
> > > > Ok, that explains things a bit. My observation is that the first 5
> > > > patches or so address the mount failure problem, but from there I'm not
> > > > reproducing much difference with or without the final patch.
> > > 
> > > Does this change to flush the log after committing the new sb fix the
> > > recovery problems on older kernels?  I /think/ that's the point of this
> > > patch.
> > > 
> > 
> > I don't follow.. growfs always forced the log via the sync transaction,
> > right? Or do you mean something else by "change to flush the log?"
> 
> I guess I was typing a bit too fast this morning -- "change to flush the
> log to disk before anyone else can get their hands on the superblock".
> You're right that xfs_log_sb and data-device growfs already do that.
> 
> That said, growfsrt **doesn't** call xfs_trans_set_sync, so that's a bug
> that this patch fixes, right?
> 
> > I thought the main functional change of this patch was to hold the
> > superblock buffer locked across the force so nothing else can relog the
> > new geometry superblock buffer in the same cil checkpoint. Presumably,
> > the theory is that prevents recovery from seeing updates to different
> > buffers that depend on the geometry update before the actual sb geometry
> > update is recovered (because the latter might have been relogged).
> > 
> > Maybe we're saying the same thing..? Or maybe I just misunderstand.
> > Either way I think patch could use a more detailed commit log...
> 
> <nod> The commit message should point out that we're fixing a real bug
> here, which is that growfsrt doesn't force the log to disk when it
> commits the new rt geometry.
> 
> > > >                                                              Either way,
> > > > I see aborts and splats all over the place, which implies at minimum
> > > > this isn't the only issue here.
> > > 
> > > Ugh.  I've recently noticed the long soak logrecovery test vm have seen
> > > a slight tick up in failure rates -- random blocks that have clearly had
> > > garbage written to them such that recovery tries to read the block to
> > > recover a buffer log item and kaboom.  At this point it's unclear if
> > > that's a problem with xfs or somewhere else. :(
> > > 
> > > > So given that 1. growfs recovery seems pretty much broken, 2. this
> > > > particular patch has no straightforward way to test that it fixes
> > > > something and at the same time doesn't break anything else, and 3. we do
> > > 
> > > I'm curious, what might break?  Was that merely a general comment, or do
> > > you have something specific in mind?  (iows: do you see more string to
> > > pull? :))
> > > 
> > 
> > Just a general comment..
> > 
> > Something related that isn't totally clear to me is what about the
> > inverse shrink situation where dblocks is reduced. I.e., is there some
> > similar scenario where for example instead of the sb buffer being
> > relogged past some other buffer update that depends on it, some other
> > change is relogged past a sb update that invalidates/removes blocks
> > referenced by the relogged buffer..? If so, does that imply a shrink
> > should flush the log before the shrink transaction commits to ensure it
> > lands in a new checkpoint (as opposed to ensuring followon updates land
> > in a new checkpoint)..?
> 
> I think so.  Might we want to do that before and after to be careful?
> 
> > Anyways, my point is just that if it were me I wouldn't get too deep
> > into this until some of the reproducible growfs recovery issues are at
> > least characterized and testing is more sorted out.
> > 
> > The context for testing is here [1]. The TLDR is basically that
> > Christoph has a targeted test that reproduces the initial mount failure
> > and I hacked up a more general test that also reproduces it and
> > additional growfs recovery problems. This test does seem to confirm that
> > the previous patches address the mount failure issue, but this patch
> > doesn't seem to prevent any of the other problems produced by the
> > generic test. That might just mean the test doesn't reproduce what this
> > fixes, but it's kind of hard to at least regression test something like
> > this when basic growfs crash-recovery seems pretty much broken.
> 
> Hmm, if you make a variant of that test which formats with an rt device
> and -d rtinherit=1 and then runs xfs_growfs -R instead of -D, do you see
> similar blowups?  Let's see what happens if I do that...

Ahahaha awesome it corrupts the filesystem:

_check_xfs_filesystem: filesystem on /dev/sdf is inconsistent (r)
*** xfs_repair -n output ***
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - generate realtime summary info and bitmap...
sb_frextents 389, counted 10329
discrepancy in summary (0) at dblock 0x0 words 0x3f-0x3f/0x400
discrepancy in summary (0) at dblock 0x0 words 0x44-0x44/0x400
No modify flag set, skipping phase 5
Phase 6 - check inode connectivity...

--D

--- /dev/null
+++ b/tests/xfs/610
@@ -0,0 +1,102 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2000-2004 Silicon Graphics, Inc.  All Rights Reserved.
+#
+# FS QA Test No. 610
+#
+# XFS online growfs-while-allocating tests (rt subvol variant)
+#
+. ./common/preamble
+_begin_fstest growfs ioctl prealloc auto stress
+
+# Import common functions.
+. ./common/filter
+
+_create_scratch()
+{
+	_scratch_mkfs_xfs "$@" >> $seqres.full
+
+	if ! _try_scratch_mount 2>/dev/null
+	then
+		echo "failed to mount $SCRATCH_DEV"
+		exit 1
+	fi
+
+	_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
+
+	# fix the reserve block pool to a known size so that the enospc
+	# calculations work out correctly.
+	_scratch_resvblks 1024 >  /dev/null 2>&1
+}
+
+_fill_scratch()
+{
+	$XFS_IO_PROG -f -c "resvsp 0 ${1}" $SCRATCH_MNT/resvfile
+}
+
+_stress_scratch()
+{
+	procs=3
+	nops=1000
+	# -w ensures that the only ops are ones which cause write I/O
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
+	    -n $nops $FSSTRESS_AVOID`
+	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
+}
+
+_require_realtime
+_require_scratch
+_require_xfs_io_command "falloc"
+
+_scratch_mkfs_xfs | tee -a $seqres.full | _filter_mkfs 2>$tmp.mkfs
+. $tmp.mkfs	# extract blocksize and data size for scratch device
+
+endsize=`expr 550 \* 1048576`	# stop after growing this big
+incsize=`expr  42 \* 1048576`	# grow in chunks of this size
+modsize=`expr   4 \* $incsize`	# pause after this many increments
+
+[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
+
+size=`expr 125 \* 1048576`	# 120 megabytes initially
+sizeb=`expr $size / $dbsize`	# in data blocks
+logblks=$(_scratch_find_xfs_min_logblocks -rsize=${size})
+_create_scratch -lsize=${logblks}b -rsize=${size}
+
+for i in `seq 125 -1 90`; do
+	fillsize=`expr $i \* 1048576`
+	out="$(_fill_scratch $fillsize 2>&1)"
+	echo "$out" | grep -q 'No space left on device' && continue
+	test -n "${out}" && echo "$out"
+	break
+done
+
+#
+# Grow the filesystem while actively stressing it...
+# Kick off more stress threads on each iteration, grow; repeat.
+#
+while [ $size -le $endsize ]; do
+	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
+	_stress_scratch
+	size=`expr $size + $incsize`
+	sizeb=`expr $size / $dbsize`	# in data blocks
+	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
+	xfs_growfs -R ${sizeb} $SCRATCH_MNT >> $seqres.full
+	echo AGCOUNT=$agcount >> $seqres.full
+	echo >> $seqres.full
+
+	sleep $((RANDOM % 3))
+	_scratch_shutdown
+	ps -e | grep fsstress > /dev/null 2>&1
+	while [ $? -eq 0 ]; do
+		killall -9 fsstress > /dev/null 2>&1
+		wait > /dev/null 2>&1
+		ps -e | grep fsstress > /dev/null 2>&1
+	done
+	_scratch_cycle_mount || _fail "cycle mount failed"
+done > /dev/null 2>&1
+wait	# stop for any remaining stress processes
+
+_scratch_unmount
+
+status=0
+exit
--- /dev/null
+++ b/tests/xfs/610.out
@@ -0,0 +1,7 @@
+QA output created by 610
+meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
+data     = bsize=XXX blocks=XXX, imaxpct=PCT
+         = sunit=XXX swidth=XXX, unwritten=X
+naming   =VERN bsize=XXX
+log      =LDEV bsize=XXX blocks=XXX
+realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
