Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CB619CC05
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 13:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730380770; cv=none; b=envFoW32LXpY3cRHF0DgxPA+ZKLQ6O0aB1Ri2fgUcMgDxZ6esc8D29pCLla/U0/fHF2LuZ2BDF1aP6HmYhbMUvBaikLOmE/UZRlejrpgv3fG564ZhEqKBGGdnk7tKLDAog8PLYQOYf8MRE3tD2chOFIdxna9iWdDvE/Vqn/5x0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730380770; c=relaxed/simple;
	bh=RkIREF0Z7jlaxVQmK25umKLkMs4ZC7hYy+GnFWoENnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyCUnOrDJiZcmHcg4Y/A1JFW5TA4PxASSVJa1yZH3nYudoCHuAUov+mmDec4ekinEQTuFmj8bKx+Nm1qZRSyQ2zRmv+ZHdnszq8hON4Z/rEmQZYIo69wDB2r+RcOZsk2kTO93CgiG5qPkv3SlI45soEuNGElnqta/BGx3xQmYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEFGxyNv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEFGxyNv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730380767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gtg3j9vmEULHzPGX/DvrIdWAuAhhZFV9YXn+TYLrbT0=;
	b=XEFGxyNvljyp/BXyqcD8tKdHq5TfPAv/N7LiIg06ttP35D8NTC40sJnpYV07T2IvnwzrQF
	hhPiYXnjhmDUeAovlqKqBsmEbhkcLmPT7q85XizZ9wjEflVJGcnmkdeQ3E0lAisQYefjDx
	oy0JPlW88HAbjf5Ku+yaoVnnUERhMOU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-499-bkGn7VUwNVKlAjcycESzOA-1; Thu,
 31 Oct 2024 09:19:24 -0400
X-MC-Unique: bkGn7VUwNVKlAjcycESzOA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B00C1955F3E;
	Thu, 31 Oct 2024 13:19:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.135])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08878300018D;
	Thu, 31 Oct 2024 13:19:21 +0000 (UTC)
Date: Thu, 31 Oct 2024 09:20:49 -0400
From: Brian Foster <bfoster@redhat.com>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, djwong@kernel.org,
	hch@lst.de
Subject: Re: [PATCH v2 2/2] xfs: online grow vs. log recovery stress test
 (realtime version)
Message-ID: <ZyOEMYid4ybKu3_E@bfoster>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241029172135.329428-3-bfoster@redhat.com>
 <20241030195456.3busw2tbqqzinkm4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241030195456.3busw2tbqqzinkm4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Oct 31, 2024 at 03:54:56AM +0800, Zorro Lang wrote:
> On Tue, Oct 29, 2024 at 01:21:35PM -0400, Brian Foster wrote:
> > This is fundamentally the same as the previous growfs vs. log
> > recovery test, with tweaks to support growing the XFS realtime
> > volume on such configurations. Changes include using the appropriate
> > mkfs params, growfs params, and enabling realtime inheritance on the
> > scratch fs.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> 
> 
> 
> >  tests/xfs/610     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/610.out |  2 ++
> >  2 files changed, 85 insertions(+)
> >  create mode 100755 tests/xfs/610
> >  create mode 100644 tests/xfs/610.out
> > 
> > diff --git a/tests/xfs/610 b/tests/xfs/610
> > new file mode 100755
> > index 00000000..6d3a526f
> > --- /dev/null
> > +++ b/tests/xfs/610
> > @@ -0,0 +1,83 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 610
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
> > +_require_realtime
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
> > +logblks=$(_scratch_find_xfs_min_logblocks -rsize=${size} -dagcount=${nags})
> > +
> > +_scratch_mkfs_xfs -lsize=${logblks}b -rsize=${size} -dagcount=${nags} \
> > +	>> $seqres.full || _fail "mkfs failed"
> 
> Ahah, not sure why this case didn't hit the failure of xfs/609, do you think
> we should filter out the mkfs warning too?
> 

My experience with this test is that it didn't reproduce any problems on
current master, but Darrick had originally customized it from xfs/609
and found it useful to identify some issues in outstanding development
work around rt.

I've been trying to keep the two tests consistent outside of enabling
the appropriate rt bits, so I'd suggest we apply the same changes here
as for 609 around the mkfs thing (whichever way that goes).

> SECTION       -- default
> FSTYP         -- xfs (non-debug)
> PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> MKFS_OPTIONS  -- -f -rrtdev=/dev/mapper/testvg-rtdev /dev/sda6
> MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 -ortdev=/dev/mapper/testvg-rtdev /dev/sda6 /mnt/scratch
> 
> xfs/610        39s
> Ran: xfs/610
> Passed all 1 tests
> 
> > +_scratch_mount
> > +_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
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
> > +	$XFS_GROWFS_PROG -R ${sizeb} $SCRATCH_MNT >> $seqres.full
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
> 
> _scratch_cycle_mount does _fail if it fails, I'll help to remove the "|| _fail ..."
> 

Ok.

> > +done > /dev/null 2>&1
> > +wait	# stop for any remaining stress processes
> > +
> > +_scratch_unmount
> 
> If this ^^ isn't a necessary step of bug reproduce, then we don't need to do this
> manually, each test case does that at the end. I can help to remove it when I
> merge this patch.
> 

Hm I don't think so. That might also just be copy/paste leftover. Feel
free to drop it.

> Others looks good to me,
> 
> Reviewed-by: Zorro Lang <zlang@redaht.com>
> 

Thanks!

Brian

> 
> > +
> > +echo Silence is golden.
> > +
> > +status=0
> > +exit
> > diff --git a/tests/xfs/610.out b/tests/xfs/610.out
> > new file mode 100644
> > index 00000000..c42a1cf8
> > --- /dev/null
> > +++ b/tests/xfs/610.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 610
> > +Silence is golden.
> > -- 
> > 2.46.2
> > 
> > 
> 

