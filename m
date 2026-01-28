Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7724334F48C
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769624985; cv=none; b=Q3askr5DvhA1OryTIqXIVIOVjr0nPvuruGWN+BnuelRgVGC22ub9V7lEWG2TPv+EEiD3lfAHNoBz3GnlJ0WyvQtkCDurH/xK/85E9gwwUrKlq1T6e5TnASnN23GKI/aKR+L4EBnj9C4w4jtY0lS7Ek+YlKJJHndWoJReW4fwaR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769624985; c=relaxed/simple;
	bh=xqB/9GebvPckFq88xbQghy3d+9yS9tTYvxH4N7vktMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DINoMBnnyeM+87/vJuQWwg5fYy0jowMJrwwgN0ndHecPFZhhcmfQOTB1tWXmHiBENglXE/3gcAJhdwTG+1jJW7e/fuLy4l8Z9rVQLuzfjB6KE+2iF/mWDcxxnmnzKzNXMiemDbSmEJ+DS4qrrflGHHPsIuDEqiHVU8Hzh+ZKWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkEIlm9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkEIlm9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9A7C4CEF1;
	Wed, 28 Jan 2026 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769624985;
	bh=xqB/9GebvPckFq88xbQghy3d+9yS9tTYvxH4N7vktMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gkEIlm9dCzHSpb0/6ndU4gunvBenn2mpMK/iYiGC0GrsYOFMa+fNkCC1Tplvm8BCw
	 cu1PolhJxD0Yqp5RnViWaCh2fMhUZWK1B8KIaFmEUd/AlWhHuvtgbKxDp1mHEX/yBN
	 DzSTBpZv501hRG4F1mJxltNaSJs6pvrtGAgS9Z63w6jsAH96X4rRC8inpMwi+yF4NL
	 xKLbYexZIaHW48IkjoTdeXFwD5QuaIA7fxrAAp58tsdb+8AsQ734bjlQF6l5WYdxhB
	 KZfLB5GqA0dVg+cXSO/CEmodECO85vHJGT0RHA1/ec225izCg5qtEE9TYMaiCLXQ+3
	 3XRoJbs3t/HLw==
Date: Wed, 28 Jan 2026 10:29:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
	hch@infradead.org
Subject: Re: [PATCH v1 2/2] xfs: Fix in xfs_rtalloc_query_range()
Message-ID: <20260128182944.GZ5945@frogsfrogsfrogs>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <43e717d7864a2662c067d8013e462209c7b2952a.1769613182.git.nirjhar.roy.lists@gmail.com>
 <20260128171443.GL5966@frogsfrogsfrogs>
 <dad72f2b-1cd6-42de-98f1-8c9bbbb4c8ef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dad72f2b-1cd6-42de-98f1-8c9bbbb4c8ef@gmail.com>

On Wed, Jan 28, 2026 at 11:30:18PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 1/28/26 22:44, Darrick J. Wong wrote:
> > On Wed, Jan 28, 2026 at 08:44:35PM +0530, Nirjhar Roy (IBM) wrote:
> > > xfs_rtalloc_query_range() should not return 0 by doing a NOP when
> > > start == end i.e, when the rtgroup size is 1. This causes incorrect
> > > calculation of free rtextents i.e, the count is reduced by 1 since
> > > the last rtgroup's rtextent count is not taken and hence xfs_scrub
> > > throws false summary counter report (from xchk_fscounters()).
> > > 
> > > A simple way to reproduce the above bug:
> > > 
> > > $ mkfs.xfs -f -m metadir=1 \
> > > 	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
> > > 	-d size=1G /dev/loop1
> > > meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
> > >           =                       sectsz=512   attr=2, projid32bit=1
> > >           =                       crc=1        finobt=1, sparse=1, rmapbt=1
> > >           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
> > >           =                       exchange=1   metadir=1
> > > data     =                       bsize=4096   blocks=262144, imaxpct=25
> > >           =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> > > log      =internal log           bsize=4096   blocks=16384, version=2
> > >           =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
> > >           =                       rgcount=4    rgsize=65536 extents
> > >           =                       zoned=0      start=0 reserved=0
> > > Discarding blocks...Done.
> > > Discarding blocks...Done.
> > > $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
> > > $ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
> > > meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
> > >           =                       sectsz=512   attr=2, projid32bit=1
> > >           =                       crc=1        finobt=1, sparse=1, rmapbt=1
> > >           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
> > >           =                       exchange=1   metadir=1
> > > data     =                       bsize=4096   blocks=262144, imaxpct=25
> > >           =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> > > log      =internal log           bsize=4096   blocks=16384, version=2
> > >           =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
> > >           =                       rgcount=4    rgsize=65536 extents
> > >           =                       zoned=0      start=0 reserved=0
> > > calling xfsctl with in.newblocks = 262145
> > > realtime blocks changed from 262144 to 262145
> > > $ xfs_scrub -n   -v /mnt1/scratch
> > > Phase 1: Find filesystem geometry.
> > > /mnt1/scratch: using 2 threads to scrub.
> > > Phase 2: Check internal metadata.
> > > Corruption: rtgroup 4 realtime summary: Repairs are required.
> > > Phase 3: Scan all inodes.
> > > Phase 5: Check directory tree.
> > > Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
> > > Phase 7: Check summary counters.
> > > Corruption: filesystem summary counters: Repairs are required.
> > > 125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
> > > 64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
> > > 18 inodes counted; 18 inodes checked.
> > > Phase 8: Trim filesystem storage.
> > > /mnt1/scratch: corruptions found: 2
> > > /mnt1/scratch: Re-run xfs_scrub without -n.
> > > 
> > > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > Yeah, that looks right.  I can also reproduce it with:
> > 
> > # mkfs.xfs -m metadir=1 -r rtdev=/dev/sdb /dev/sda -r rgsize=65536b,size=131073b -f
> > # mount /dev/sda /mnt -o rtdev=/dev/sdb
> > # xfs_scrub -dTvn /mnt
> > 
> > Cc: <stable@vger.kernel.org> # v6.13
> > Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
> > 
> > Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Thank you. Will the "Cc" and "Fixes" tag be added from this automatically,
> or do I need to re-send it by updating the commit message?

cem might add it on his own, but you could also resubmit with all three
trailers added, to keep things simple for him.

--D

> --NR
> 
> > 
> > --D
> > > ---
> > >   fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
> > > index 618061d898d4..8f552129ffcc 100644
> > > --- a/fs/xfs/libxfs/xfs_rtbitmap.c
> > > +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
> > > @@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
> > >   	if (start > end)
> > >   		return -EINVAL;
> > > -	if (start == end || start >= rtg->rtg_extents)
> > > +	if (start >= rtg->rtg_extents)
> > >   		return 0;
> > >   	end = min(end, rtg->rtg_extents - 1);
> > > -- 
> > > 2.43.5
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
