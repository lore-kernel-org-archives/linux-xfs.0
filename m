Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001AA8C0B
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730403807; cv=none; b=QIR4qDh/30u3+/nYUMEATBZ6StOLtVAs00oPDUrEX1KjYqU1V2VoKiGIvvxVujO8Z5VQ8qucqrv+yU3OUNMi8+zS98OAusysFh4Vd2QpHjzYTY0OdizkMR6e9UWQUKa8UEw7LvETaNU59CtwwOd6RMbhJTcVu37wCDkFKlJH+xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730403807; c=relaxed/simple;
	bh=fd4UVJ3GFSmn28l8wpj8xt+4oeeCti+eGwIH4w7jBbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VmcD3GVAlS5uN8oTjtmSus0Y6OevyzsyrteanDkgsmMvoCEVXuY9ESTejnj3wwOCoDSSk2wnWKxNkqYvzgtHTVPMpYI51bUlIqWzZoeEhCEOZkHh+bvC28+WQcGTDEwtRKjo859A47FKpZquuoJVTyEfhtz00yNe0YiQowATD+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BYUStvH6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BYUStvH6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730403804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFklJBEH98MJ10sOML5S+M+l/1wubPg5JPuWW9rrgzg=;
	b=BYUStvH6nnR/GK4HUV9VJlwrIMsvPQC1c81Ay0Hrs9WTf5Hlc6n9Ln2WIKBcyal3DEJXUi
	eLqhPMqzPSpamYADLaQTv9sVxoOeSJCbLe9DaNMToIUlO3g/aU/RGsdHR07PCKHt1r5eW9
	88UXHZmT0AWWduHW6SneSPutoSZneZ0=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-118-g3uMkx6dOUuCspQpYTrmgA-1; Thu, 31 Oct 2024 15:43:22 -0400
X-MC-Unique: g3uMkx6dOUuCspQpYTrmgA-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-71e479829c8so1904494b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 12:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730403801; x=1731008601;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UFklJBEH98MJ10sOML5S+M+l/1wubPg5JPuWW9rrgzg=;
        b=vJyTMOrfzvNepn8rctw3ukVnEr4GE0b9tHreP/WDdEG4n+vH5efZGRLbGWKns62zHj
         ZjZK+51huWXrZibBCwOR2ETkVo21c5IpJhxI2CW08jPs1pQt+YUeca14oRUiy2H4dEiD
         oStZO/hK+JCc0lyEuJL+7Q0udpDG7b1qJrL3/Ioes7RAhPOhPwi6ZzWPwY0fq7PSXuMf
         cEGgzJdezGnLlDzxqO7rjo6eXFUwfzhTH8ZIadxpRuXJB6x3do6Z5AOLRosZk0AF3Sip
         IqVYPQrMjGEPCOYwqJVmnpLIka3KeUHq3+nbdUxPmrQZWIvL0GntZUARh+AA0DT78MaA
         qxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV1AtCY/DDFy4iC8iwjZUsOk7DNF2A7wXXSs3VE43+lzz4SKOr3voHGJBWiOm7agNspMau/svY2Ks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6AxzqsochElXpzHfWppHQ53CIP2HwvVfar0ni14h16GI2WBFq
	H2SbkxDKnFciSELTUoXLE2Pb7Uj49tvM08KjjJRXE+S68RsgIQisGhwOJwN8ZMJwloaaoAdYtPi
	z7PLu0fSUNbAdMqoZ4pLBW/RQ6Oa36ybNby7+gFH3urmuuX809J53V6/8jmVAKosjW0RL
X-Received: by 2002:a05:6a00:1809:b0:71e:6bf1:158f with SMTP id d2e1a72fcca58-720ab492bf1mr11135061b3a.21.1730403801300;
        Thu, 31 Oct 2024 12:43:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFf2WT7ozOJEDTTDFT38iu+oKLwguzz4mrUMna4vdBe+HZDeyTsawxUD7K6Ua8pK85xogVrFQ==
X-Received: by 2002:a05:6a00:1809:b0:71e:6bf1:158f with SMTP id d2e1a72fcca58-720ab492bf1mr11135040b3a.21.1730403800852;
        Thu, 31 Oct 2024 12:43:20 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1b8936sm1505388b3a.5.2024.10.31.12.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2024 12:43:20 -0700 (PDT)
Date: Fri, 1 Nov 2024 03:43:17 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2 2/2] xfs: online grow vs. log recovery stress test
 (realtime version)
Message-ID: <20241031194317.zbfzgna644x4eqfj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20241029172135.329428-1-bfoster@redhat.com>
 <20241029172135.329428-3-bfoster@redhat.com>
 <20241030195456.3busw2tbqqzinkm4@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZyOEMYid4ybKu3_E@bfoster>
 <20241031163524.GY2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241031163524.GY2386201@frogsfrogsfrogs>

On Thu, Oct 31, 2024 at 09:35:24AM -0700, Darrick J. Wong wrote:
> On Thu, Oct 31, 2024 at 09:20:49AM -0400, Brian Foster wrote:
> > On Thu, Oct 31, 2024 at 03:54:56AM +0800, Zorro Lang wrote:
> > > On Tue, Oct 29, 2024 at 01:21:35PM -0400, Brian Foster wrote:
> > > > This is fundamentally the same as the previous growfs vs. log
> > > > recovery test, with tweaks to support growing the XFS realtime
> > > > volume on such configurations. Changes include using the appropriate
> > > > mkfs params, growfs params, and enabling realtime inheritance on the
> > > > scratch fs.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > 
> > > 
> > > 
> > > >  tests/xfs/610     | 83 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/xfs/610.out |  2 ++
> > > >  2 files changed, 85 insertions(+)
> > > >  create mode 100755 tests/xfs/610
> > > >  create mode 100644 tests/xfs/610.out
> > > > 
> > > > diff --git a/tests/xfs/610 b/tests/xfs/610
> > > > new file mode 100755
> > > > index 00000000..6d3a526f
> > > > --- /dev/null
> > > > +++ b/tests/xfs/610
> > > > @@ -0,0 +1,83 @@
> > > > +#! /bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0
> > > > +# Copyright (c) 2024 Red Hat, Inc.  All Rights Reserved.
> > > > +#
> > > > +# FS QA Test No. 610
> > > > +#
> > > > +# Test XFS online growfs log recovery.
> > > > +#
> > > > +. ./common/preamble
> > > > +_begin_fstest auto growfs stress shutdown log recoveryloop
> > > > +
> > > > +# Import common functions.
> > > > +. ./common/filter
> > > > +
> > > > +_stress_scratch()
> > > > +{
> > > > +	procs=4
> > > > +	nops=999999
> > > > +	# -w ensures that the only ops are ones which cause write I/O
> > > > +	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -w -p $procs \
> > > > +	    -n $nops $FSSTRESS_AVOID`
> > > > +	$FSSTRESS_PROG $FSSTRESS_ARGS >> $seqres.full 2>&1 &
> > > > +}
> > > > +
> > > > +_require_scratch
> > > > +_require_realtime
> > > > +_require_command "$XFS_GROWFS_PROG" xfs_growfs
> > > > +_require_command "$KILLALL_PROG" killall
> > > > +
> > > > +_cleanup()
> > > > +{
> > > > +	$KILLALL_ALL fsstress > /dev/null 2>&1
> > > > +	wait
> > > > +	cd /
> > > > +	rm -f $tmp.*
> > > > +}
> > > > +
> > > > +_scratch_mkfs_xfs | _filter_mkfs >$seqres.full 2>$tmp.mkfs
> > > > +. $tmp.mkfs	# extract blocksize and data size for scratch device
> > > > +
> > > > +endsize=`expr 550 \* 1048576`	# stop after growing this big
> > > > +[ `expr $endsize / $dbsize` -lt $dblocks ] || _notrun "Scratch device too small"
> > > > +
> > > > +nags=4
> > > > +size=`expr 125 \* 1048576`	# 120 megabytes initially
> > > > +sizeb=`expr $size / $dbsize`	# in data blocks
> > > > +logblks=$(_scratch_find_xfs_min_logblocks -rsize=${size} -dagcount=${nags})
> > > > +
> > > > +_scratch_mkfs_xfs -lsize=${logblks}b -rsize=${size} -dagcount=${nags} \
> > > > +	>> $seqres.full || _fail "mkfs failed"
> > > 
> > > Ahah, not sure why this case didn't hit the failure of xfs/609, do you think
> > > we should filter out the mkfs warning too?
> 
> It won't-- the warning you got with 609 was about ignoring stripe
> geometry on a small data volume.  This mkfs invocation creates a
> filesystem with a normal size data volume and a small rt volume, and
> mkfs doesn't complain about small rt volumes.

Oh, good to know that, thanks Darick :)

> 
> --D
> 
> > My experience with this test is that it didn't reproduce any problems on
> > current master, but Darrick had originally customized it from xfs/609
> > and found it useful to identify some issues in outstanding development
> > work around rt.
> > 
> > I've been trying to keep the two tests consistent outside of enabling
> > the appropriate rt bits, so I'd suggest we apply the same changes here
> > as for 609 around the mkfs thing (whichever way that goes).
> > 
> > > SECTION       -- default
> > > FSTYP         -- xfs (non-debug)
> > > PLATFORM      -- Linux/x86_64 dell-per750-41 6.12.0-0.rc5.44.fc42.x86_64 #1 SMP PREEMPT_DYNAMIC Mon Oct 28 14:12:55 UTC 2024
> > > MKFS_OPTIONS  -- -f -rrtdev=/dev/mapper/testvg-rtdev /dev/sda6
> > > MOUNT_OPTIONS -- -o context=system_u:object_r:root_t:s0 -ortdev=/dev/mapper/testvg-rtdev /dev/sda6 /mnt/scratch
> > > 
> > > xfs/610        39s
> > > Ran: xfs/610
> > > Passed all 1 tests
> > > 
> > > > +_scratch_mount
> > > > +_xfs_force_bdev realtime $SCRATCH_MNT &> /dev/null
> > > > +
> > > > +# Grow the filesystem in random sized chunks while stressing and performing
> > > > +# shutdown and recovery. The randomization is intended to create a mix of sub-ag
> > > > +# and multi-ag grows.
> > > > +while [ $size -le $endsize ]; do
> > > > +	echo "*** stressing a ${sizeb} block filesystem" >> $seqres.full
> > > > +	_stress_scratch
> > > > +	incsize=$((RANDOM % 40 * 1048576))
> > > > +	size=`expr $size + $incsize`
> > > > +	sizeb=`expr $size / $dbsize`	# in data blocks
> > > > +	echo "*** growing to a ${sizeb} block filesystem" >> $seqres.full
> > > > +	$XFS_GROWFS_PROG -R ${sizeb} $SCRATCH_MNT >> $seqres.full
> > > > +
> > > > +	sleep $((RANDOM % 3))
> > > > +	_scratch_shutdown
> > > > +	ps -e | grep fsstress > /dev/null 2>&1
> > > > +	while [ $? -eq 0 ]; do
> > > > +		$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> > > > +		wait > /dev/null 2>&1
> > > > +		ps -e | grep fsstress > /dev/null 2>&1
> > > > +	done
> > > > +	_scratch_cycle_mount || _fail "cycle mount failed"
> > > 
> > > _scratch_cycle_mount does _fail if it fails, I'll help to remove the "|| _fail ..."
> > > 
> > 
> > Ok.
> > 
> > > > +done > /dev/null 2>&1
> > > > +wait	# stop for any remaining stress processes
> > > > +
> > > > +_scratch_unmount
> > > 
> > > If this ^^ isn't a necessary step of bug reproduce, then we don't need to do this
> > > manually, each test case does that at the end. I can help to remove it when I
> > > merge this patch.
> > > 
> > 
> > Hm I don't think so. That might also just be copy/paste leftover. Feel
> > free to drop it.
> > 
> > > Others looks good to me,
> > > 
> > > Reviewed-by: Zorro Lang <zlang@redaht.com>
> > > 
> > 
> > Thanks!
> > 
> > Brian
> > 
> > > 
> > > > +
> > > > +echo Silence is golden.
> > > > +
> > > > +status=0
> > > > +exit
> > > > diff --git a/tests/xfs/610.out b/tests/xfs/610.out
> > > > new file mode 100644
> > > > index 00000000..c42a1cf8
> > > > --- /dev/null
> > > > +++ b/tests/xfs/610.out
> > > > @@ -0,0 +1,2 @@
> > > > +QA output created by 610
> > > > +Silence is golden.
> > > > -- 
> > > > 2.46.2
> > > > 
> > > > 
> > > 
> > 
> > 
> 

