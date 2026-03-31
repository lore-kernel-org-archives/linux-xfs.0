Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E98D38A709
	for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 20:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774989769; cv=none; b=iKE95dqg0bxSng10tLO2HiuqdTtcUckGph8eJHC0uSom3BfTSOzhAoPW8I1Bh8leKrXTlKXDED52jzxzcNv8oK2U1Ok0bJXWrbXwB1PRCSO//RuhfqzEz7yYz+n9gZW9cZDdPQd9Lr77t3NuNlfbwWof43tn2RjYggXsnepGGxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774989769; c=relaxed/simple;
	bh=anr0ANBqfzzDIa9fn2x02DCPZMdl080Jx7sxNmoWRTo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1MW275nmMBO0+xNV8KeBUjny9XBuDdSEKn4qCLjQoZ+DHKP8zetPp3fGxoNTZv89MNtkgvbiTKcoEkxX9sgMkU3QAZagYy+Z2+Wr02auKyGG/C0xotY0tuifPSse8OfOZUx3IB8JvhgJV6WAJRdE8DOc4U0MBfxPGyRQ2kP2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ks205NKS; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMiCr5Be; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ks205NKS";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMiCr5Be"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774989767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YjgdNxtVaDM1OxGfeLykizdY8tjsUG0Q9V5uVd3qrNY=;
	b=Ks205NKSAiOfsaJxpyq2hYM+Xkb7YH9ear2WsvSDxeakzhGYjKssPtIzrB2dTEZ0SLRT4E
	shChTAx1rosunKF3/gxhoH/ssOG04/uDlZFqvblMUx5jzl+/HyL4EjC9w5Im9gr/9QZYDD
	7U0xCU3hV9ZfVrq0YROQorYnFt139sw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-k-PVlKuFNLSsNdHx9XD1lQ-1; Tue, 31 Mar 2026 16:42:46 -0400
X-MC-Unique: k-PVlKuFNLSsNdHx9XD1lQ-1
X-Mimecast-MFC-AGG-ID: k-PVlKuFNLSsNdHx9XD1lQ_1774989765
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35da8eb0553so256918a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 31 Mar 2026 13:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774989765; x=1775594565; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YjgdNxtVaDM1OxGfeLykizdY8tjsUG0Q9V5uVd3qrNY=;
        b=VMiCr5Bepi26v+41/xce4fMuAwFGswJ3qfF8KSzehxtnb05FzTrfWxHKqXXae8DU0C
         f6OL4SORlB767xEuvRxWJCgbxvZxlbihhyswBXT7zbAKYKsi9Q0mJMxlNjV85q34Ntxw
         o0VnbXjlOqN5fPGQGEoH7QSzJe9P6TYUPf0iH4XbSN6DvH0D+vi6OY8ugsGznZUUnxwt
         wvR07g11eSU4ouac55egZXqOoH09yy25DGWqa4jnVyeF3eW/Mw4Re9ubj/Ch8m9hI3HO
         1zLqXRlN0ureDr9TjjIuF+fmEpIZ+rwUfhXAbgL0fsFreiEAvyHW5UCLnELBbUNpJAVh
         xZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774989765; x=1775594565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YjgdNxtVaDM1OxGfeLykizdY8tjsUG0Q9V5uVd3qrNY=;
        b=kwObrv+ZXy+1INNyIk/CcpuDbutYaTn08fIGVy6Ut9xcPlXprtcmYyME6KVAAPZMt3
         Ee1O84GYyMCbhrRLuhXc8iLMBBDZ0ZnFtLA5H29qD0qd1llYP3AiCpyfGxyC7xHB+haZ
         aUPYhyQuYpUTpfl9u8L+bI5hzgL/LVCgBKK18hFyZk50Dpt6cLyqQP04Abd/jL6G7FFx
         iQblfBUiVjDeaehfk6YjFXoLBAG9bnGAHs2mgQwUUqEN/h/aZjjjlnZY5FUhQWA/fNSe
         ZACdZsuxDkovcohYscENKr+OOZNaGsh+4V76MpNeVE6urRUt8NG2tMeM2pZzH8WsPkwi
         FJAg==
X-Forwarded-Encrypted: i=1; AJvYcCXIZjuYieIXs00SUDqY9SUg6+rTyvEjbYiDcstGhR9AL9s2OB2pNcgIZGNMbEgk3yHRMCjpESzS+lo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHF+7cfSD9+9nIbO7aSiWdgZ6bdNQjJbOXncQVX0qxKfX+LsUS
	fJeHhsIdQ/cQpye9QhMHXPPOiEeg/dztyU0tu1rsnUUHWFcbl8rbKuRtguiTmrExQY8XW5umLS1
	/FSCFmjWb+AcInQo33ukMqGtQTvDTde0Ij//LzBsxWdzDxKZHSfb331JIkUVFyA==
X-Gm-Gg: ATEYQzxs6yWnoUhq4PK0Yg4/IaD/GjayEsYbwIfEM4qMOP0CTrhZhnBKFfJFIQpOd0n
	h93eam8U77RKUoVkJ14CsC8Q0lcIpCeqV06w9N2RiC37pfBe7cBYcGokX8CReBu0mPHJeAsKQKz
	cZ5cWAcvLMuEXqgpT4OkuXEsjmuRWL1eUyHn4kmyQYUdn3yV5l0Vxx+xUmS/A5i7/31LOB5OurV
	j8aFfiy6fZdhwRgI6suDyYqnUKgP3Zb9V7XiAb+EY/XrqAQsZl7XM6EVN5PRWFHqxJH3oJ5i3X1
	4nu7yJJxg3VrqXm1gpwWahAJegFTI3XpjOCxFO6qmbzhhOtaG/QTmHekjRhwta9ua3rDGFZicL0
	5jG+2uq7D1A5V9nY3vA==
X-Received: by 2002:a17:90b:3f4c:b0:35d:9fe9:f830 with SMTP id 98e67ed59e1d1-35dc6f90b81mr575065a91.12.1774989764788;
        Tue, 31 Mar 2026 13:42:44 -0700 (PDT)
X-Received: by 2002:a17:90b:3f4c:b0:35d:9fe9:f830 with SMTP id 98e67ed59e1d1-35dc6f90b81mr575014a91.12.1774989764145;
        Tue, 31 Mar 2026 13:42:44 -0700 (PDT)
Received: from doltdoltdolt ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dba54797dsm1371640a91.1.2026.03.31.13.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 13:42:43 -0700 (PDT)
Date: Wed, 1 Apr 2026 04:42:38 +0800
From: Zorro Lang <zlang@redhat.com>
To: fstests@vger.kernel.org
Cc: Hans Holmberg <hans.holmberg@wdc.com>, zlang@kernel.org,
	Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH v2 2/2] xfs: test that zone_gc_low_space writes start gc
 for rw fses
Message-ID: <20260331204238.6jddcr6noqx77xrp@doltdoltdolt>
References: <20260327123429.39330-1-hans.holmberg@wdc.com>
 <20260327123429.39330-3-hans.holmberg@wdc.com>
 <20260327152218.GC6223@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327152218.GC6223@frogsfrogsfrogs>

On Fri, Mar 27, 2026 at 08:22:18AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 27, 2026 at 01:34:29PM +0100, Hans Holmberg wrote:
> > Test that writes to the sysfs attribute zone_gc_low_space triggers
> > garbage collection for rw (but not ro) file systems.
> > 
> > Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> 
> Looks good to me, given what I saw of the kernel patch.  It probably
> needs a _fixed_by_kernel_commit tag once the patch goes upstream.

Yes, please :) It's helpful for downstream kernel maintainers.

Thanks,
Zorro

> 
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> --D
> 
> > ---
> >  common/xfs        | 17 +++++++++++
> >  tests/xfs/999     | 72 +++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/xfs/999.out |  2 ++
> >  3 files changed, 91 insertions(+)
> >  create mode 100755 tests/xfs/999
> >  create mode 100644 tests/xfs/999.out
> > 
> > diff --git a/common/xfs b/common/xfs
> > index c81f939e68d2..45d7f75d2064 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -748,6 +748,23 @@ _xfs_get_scratch_rtdev_bdev()
> >  	fi
> >  }
> >  
> > +# Get a stat from /proc/self/mountstats for a specific mount point
> > +_xfs_get_mountstat() {
> > +	awk -v mount="$1" -v stat="$2" \
> > +		'$0~"mounted on "mount" with fstype xfs"{f=1} f&&index($0,stat){print $NF;exit}' \
> > +		/proc/self/mountstats
> > +}
> > +
> > +# Get the user available blocks for a rt mount
> > +_xfs_get_user_available_rt_blocks() {
> > +	_xfs_get_mountstat "$1" "user available RT blocks:"
> > +}
> > +
> > +# Check if gc is required for a rt mount
> > +_xfs_get_rt_gc_required () {
> > +	_xfs_get_mountstat "$1" "RT GC required:"
> > +}
> > +
> >  # Snapshot the metadata on the scratch device
> >  _scratch_xfs_metadump()
> >  {
> > diff --git a/tests/xfs/999 b/tests/xfs/999
> > new file mode 100755
> > index 000000000000..2c5b54368b6d
> > --- /dev/null
> > +++ b/tests/xfs/999
> > @@ -0,0 +1,72 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Western Digital Corporation
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# Tests that writes to zonegc_low_space will trigger start of garbage
> > +# collection for rw (but not ro) file systems
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto rw zone quick
> > +
> > +. ./common/zoned
> > +
> > +_require_scratch
> > +_require_odirect
> > +
> > +zdev="$(_xfs_get_scratch_rtdev_bdev)"
> > +_require_zoned_device "$zdev"
> > +capacity=$(_zone_capacity 0 $zdev)
> > +_scratch_mkfs_sized $(($capacity * 6)) > $seqres.full 2>&1
> > +
> > +# limit max open zones to avoid gc to trigger before we want it to
> > +export MOUNT_OPTIONS="$MOUNT_OPTIONS -o max_open_zones=2"
> > +_try_scratch_mount || _notrun "mount option not supported"
> > +_require_xfs_scratch_zoned
> > +
> > +# create three zone-sized files and invalidate 95% of the data
> > +for i in $(seq 1 3); do
> > +	filename=$SCRATCH_MNT/data_$i
> > +	dd if=/dev/zero of=$filename bs=1M oflag=direct\
> > +		count=$(($capacity / (1024 * 1024))) >> $seqres.full 2>&1
> > +	truncate -s $(($capacity / 20)) $filename
> > +done
> > +
> > +# remount read-only and set the gc limit to free up unused space
> > +_scratch_remount ro
> > +rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> > +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
> > +
> > +# reclaiming a zone with 5% used blocks should take way less than 1 second
> > +sleep 1
> > +
> > +# gc should not run for read only file systems
> > +rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> > +[ "$rt_available_post" -gt "$rt_available_pre" ] && \
> > +	_fail "gc should not run while read only"
> > +
> > +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 0
> > +
> > +# remount rw and check that gc starts, frees up blocks and stops after
> > +# the threshold is set to reclaim the unused blocks
> > +_scratch_remount rw
> > +
> > +rt_available_pre="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> > +_set_fs_sysfs_attr $SCRATCH_DEV "zoned/zonegc_low_space" 100
> > +
> > +i=0
> > +while [ $(_xfs_get_rt_gc_required "$SCRATCH_MNT") -eq "1" ]; do
> > +	sleep 1
> > +	let i=$i+1
> > +	[ $i -gt 3 ] && _fail "gc did not complete within a reasonable time"
> > +done
> > +
> > +rt_available_post="$(_xfs_get_user_available_rt_blocks "$SCRATCH_MNT")"
> > +[ "$rt_available_pre" -ge "$rt_available_post" ] && \
> > +	_fail "gc did not free up space"
> > +
> > +echo "Silence is golden"
> > +status=0
> > +
> > +exit
> > diff --git a/tests/xfs/999.out b/tests/xfs/999.out
> > new file mode 100644
> > index 000000000000..3b276ca804fc
> > --- /dev/null
> > +++ b/tests/xfs/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +Silence is golden
> > -- 
> > 2.34.1
> > 
> > 
> 

