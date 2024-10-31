Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B7219C574
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 13:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380653; cv=none; b=t+8qN837Dge6HiFkGieNqUWWLeu3fH/LDOm/+9T97c4/7EWuzoyKDXhxWwqdZiim++DBqQlV+qRggNNB8BIBPvXzBIvWKRwd+2Zgv/HHK35Yqvsgw5Wuxu6iJV0tLIj0DdKrJSECo9VdPDSHiJXUAFebKiCIMPTqZutoc6xgAgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380653; c=relaxed/simple;
	bh=nomR4va9pEGP47j7Wrwnpg4L+IsWrzsWGgULbjPWq4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5SQkOnekA/RXRLTAnJBtv9KGZVLgfHpZcZFwm0qhT8m2aiBvqoghKTXRJO7MxAESUEB+AD1xyKdV4nxEe38ikHwmLrENJnd5l+gao3ABvXL6VT8BFcKcwYIeDv9WjbuT90HLtqyZqQ/Y/uCLINT/U9I8czvCg6MwvKYgowignU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vga7SVNq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vga7SVNq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730380649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gaD2Glx1o7hZMT28NWgxhDk50/4ZX6Ex68QpBafqvJE=;
	b=Vga7SVNql8mdFGHVjVZJCoeo2D2uKB7nrY6MBvAfExzX7YV0/1RoSI2q8egTVwjqZ6rMz0
	JznfjhM9qH/iR5JJOf6XZUBlTVcxsY54/Z2EZ6IunA+4ei1xznNHSEq7o3K9Q4eQ3JjYPX
	mKKPybVFRw1Cw0e8tG4eNxqgFoMvVEk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-H3MVXOBJNEmoXwW3gJQx-w-1; Thu,
 31 Oct 2024 09:17:26 -0400
X-MC-Unique: H3MVXOBJNEmoXwW3gJQx-w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 158091955DD1;
	Thu, 31 Oct 2024 13:17:25 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08D4A1956054;
	Thu, 31 Oct 2024 13:17:23 +0000 (UTC)
Date: Thu, 31 Oct 2024 09:18:50 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH v2 1/2] xfs: online grow vs. log recovery stress test
Message-ID: <ZyODupQLyRFlep0W@bfoster>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241029172135.329428-2-bfoster@redhat.com>
 <20241030194133.vrtci4c5ozex6thv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030194133.vrtci4c5ozex6thv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Oct 31, 2024 at 03:41:33AM +0800, Zorro Lang wrote:
> On Tue, Oct 29, 2024 at 01:21:34PM -0400, Brian Foster wrote:
> > fstests includes decent functional tests for online growfs and
> > shrink, and decent stress tests for crash and log recovery, but no
> > combination of the two. This test combines bits from a typical
> > growfs stress test like xfs/104 with crash recovery cycles from a
> > test like generic/388. As a result, this reproduces at least a
> > couple recently fixed issues related to log recovery of online
> > growfs operations.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  tests/xfs/609     | 81 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/609.out |  2 ++
> >  2 files changed, 83 insertions(+)
> >  create mode 100755 tests/xfs/609
> >  create mode 100644 tests/xfs/609.out
> > 
> > diff --git a/tests/xfs/609 b/tests/xfs/609
> > new file mode 100755
> > index 00000000..4df966f7
> > --- /dev/null
> > +++ b/tests/xfs/609
> > @@ -0,0 +1,81 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 609
> > +#
> > +# Test XFS online growfs log recovery.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto growfs stress shutdown log recoveryloop
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +
> > +_stress_scratch()
> > +{
> > +	procs=4
> > +	nops=999999
> > +	# -w ensures that the only ops are ones which cause write I/O
> > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > +	    -n $nops $FSSTRESS_AVOID`
> > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > +}
> > +
> > +_require_scratch
> > +_require_command "$XFS_GROWFS_PROG" xfs_growfs
> > +_require_command "$KILLALL_PROG" killall
> > +
> > +_cleanup()
> > +{
> > +	$KILLALL_ALL fsstress > /dev/null 2>&1
> > +	wait
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > +
> > +endsize=`expr 550 \* 1048576`	# stop after growing this big
> > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > +
> > +nags=4
> > +size=`expr 125 \* 1048576`	# 120 megabytes initially
> > +sizeb=`expr $size / $dbsize`	# in data blocks
> > +logblks=$(_scratch_find_xfs_min_logblocks -dsize=${size} -dagcount=${nags})
> > +
> > +_scratch_mkfs_xfs -lsize=${logblks}b -dsize=${size} -dagcount=${nags} \
> > +	>> $seqres.full || _fail "mkfs failed"
> 
> 
> This test fails on my testing machine, as [1], due to above mkfs.xfs print
> a warning:
> 
> "mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256"
> 
> My test device is scripted, if without the specific mkfs options, it got:
>   # mkfs.xfs -f $SCRATCH_DEV
>   meta-data=/dev/sda6              isize=512    agcount=25, agsize=1064176 blks
>            =                       sectsz=512   attr=2, projid32bit=1
>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>            =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>            =                       exchange=0  
>   data     =                       bsize=4096   blocks=26604400, imaxpct=25
>            =                       sunit=16     swidth=32 blks
>   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>   log      =internal log           bsize=4096   blocks=179552, version=2
>            =                       sectsz=512   sunit=16 blks, lazy-count=1
>   realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> But if with the specific mkfs options, it got:
> 
>   # /usr/sbin/mkfs.xfs  -f   -lsize=3075b -dsize=131072000 -dagcount=4 $SCRATCH_DEV
>   mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256
>   meta-data=/dev/sda6              isize=512    agcount=4, agsize=8000 blks
>            =                       sectsz=512   attr=2, projid32bit=1
>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>            =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
>            =                       exchange=0  
>   data     =                       bsize=4096   blocks=32000, imaxpct=25
>            =                       sunit=0      swidth=0 blks
>   naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>   log      =internal log           bsize=4096   blocks=3075, version=2
>            =                       sectsz=512   sunit=0 blks, lazy-count=1
>   realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Hi Brian, if you think "ignoreing volume stripe" doesn't affect the test, we can
> filter out the stderr with "2>&1". I can help to change that when I merge.
> 

Hmm.. I don't think it should affect things. We could probably make the
scratch fs a bit bigger, but the idea is to leave enough room so it can
be grown a number of times. Any idea if using a particular min size fs
makes that warning go away?

Either way I don't think the custom stripe unit/width should make much
of a difference for a grow vs. log recovery test, so I'm fine with
filtering that out if that's easiest.

Brian

> Others looks good to me, with above confirmation:
> 
> Reviewed-by: Zorro Lang <zlang@redhat.com>
> 
> Thanks,
> Zorro
> 
> [1]
> SECTION       -- default
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 dell-per750-41 6.11.0-0.rc6.49.fc42.x86_64+debug #1 SMP PREEMPT_DYNAMIC Mon Sep  2 02:18:15 UTC 2024
> MKFS_OPTIONS  -- -f /dev/sda6
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/scratch
> 
> xfs/609       [failed, exit status 1]_check_dmesg: something found in dmesg (see /root/git/xfstests/results//default/xfs/609.dmesg)
> - output mismatch (see /root/git/xfstests/results//default/xfs/609.out.bad)
>     --- tests/xfs/609.out       2024-10-30 16:29:52.250176790 +0800
>     +++ /root/git/xfstests/results//default/xfs/609.out.bad     2024-10-30 16:31:01.759590117 +0800
>     @@ -1,2 +1,2 @@
>      QA output created by 609
>     -Silence is golden.
>     +mkfs.xfs: small data volume, ignoring data volume stripe unit 128 and stripe width 256
>     ...
>     (Run 'diff -u /root/git/xfstests/tests/xfs/609.out /root/git/xfstests/results//default/xfs/609.out.bad'  to see the entire diff)
> xfs/610       [not run] External volumes not in use, skipped this test
> Ran: xfs/609 xfs/610
> Not run: xfs/610
> Failures: xfs/609
> Failed 1 of 2 tests
> 
> 
> > +_scratch_mount
> > +
> > +# Grow the filesystem in random sized chunks while stressing and performing
> > +# shutdown and recovery. The randomization is intended to create a mix of sub-ag
> > +# and multi-ag grows.
> > +while [ $size -le $endsize ]; do
> > +	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
> > +	_stress_scratch
> > +	incsize=$((RANDOM % 40 * 1048576))
> > +	size=`expr $size + $incsize`
> > +	sizeb=`expr $size / $dbsize`	# in data blocks
> > +	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
> > +	$XFS_GROWFS_PROG -D ${sizeb} $SCRATCH_MNT >> $seqres.full
> > +
> > +	sleep $((RANDOM % 3))
> > +	_scratch_shutdown
> > +	ps -e | grep fsstress > /dev/null 2>&1
> > +	while [ $? -eq 0 ]; do
> > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > +		wait > /dev/null 2>&1
> > +		ps -e | grep fsstress > /dev/null 2>&1
> > +	done
> > +	_scratch_cycle_mount || _fail "cycle mount failed"
> > +done > /dev/null 2>&1
> > +wait	# stop for any remaining stress processes
> > +
> > +_scratch_unmount
> > +
> > +echo Silence is golden.
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/609.out b/tests/xfs/609.out
> > new file mode 100644
> > index 00000000..8be27d3a
> > --- /dev/null
> > +++ b/tests/xfs/609.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 609
> > +Silence is golden.
> > -- 
> > 2.46.2
> > 
> > 
> 

