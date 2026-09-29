Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B50C3E5EEA
	for <linux-xfs@vger.kernel.org>; Tue, 29 Sep 2026 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790700012; cv=none; b=Gh8gQ+hGsnEayYOa1V8Q75ACZc+d6i0I2jyq4+j5KMcGNV6ZxYd0X4a/3Otmiz67M2fpv5b0v5/vFQyJMPEXreQa85uiwq8XQHSebS7lg2cjhqcXF8II6hSuCILPG9YDUOn9N8W8QI9VQwawo3T+ODig4a7mpLiOXEYADV2fa/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790700012; c=relaxed/simple;
	bh=zk2Ou+Fld/FkdKT7DsTBPEE11pj7H1hIHzxAqW433LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tbOgJZRisUKwnSDVewXv8XFMbjIun7Zus1wHl1rbwHfpTiYuiYs6esXGR2OqTwwQFODFu/LVFXgXY4wkFiaPI7WZElxDiUAC+Svw6GyUWW7Evvmedc/4En+EYlJBgOhLoxsFNIFQ1TT6PWH+PWrvIK2GJoPmVYZm+Lv80eCR/ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6bB9tcZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6bB9tcZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D3DC1F000FF;
	Tue, 29 Sep 2026 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790700010;
	bh=T2oBDRTQBfGA5356jUq9UXdHKSh/sNjatQZOtRUCKH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O6bB9tcZtZM03teQ6VCUjDMpXn7x1Q0Kt+yqA/NS31/LaWMigbqvtpG2rNVmF0W8j
	 GQ39q92ypMPaekcvsQp9+1xdhf8YVl1HVSO5WXMk4vwtb0MxFU82pVG07XtiKiB6s9
	 1HatHRG0O3Wha5f+Jpsqor+0tYg++y8CAMTqc3Xq5f3e1Lhboi68Z7iGFdBn13Swd8
	 XcJUxb4VtsNyTRMiXJ7Yd9W7nzCb6ZhUStQy4UEpwRmOtgWXzLt9GtcyUmyaW/RrSc
	 wPFun9M9PwQETP4V361zPSvGdt3LS2KZtEgOhCcbmmAOlGd61rCWkncruJmKprQe7d
	 EWYhNtqZng61Q==
Date: Tue, 29 Sep 2026 09:40:10 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: John Garry <john.garry@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>,
	cem@kernel.org, linux-xfs@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>, gost.dev@samsung.com
Subject: Re: [PATCH] xfs: don't limit software atomic writes by the group
 alignment
Message-ID: <20260929164010.GS2705364@frogsfrogsfrogs>
References: <20260925103640.932735-1-p.raghav@samsung.com>
 <41749fa7-dcfa-46f0-af0f-ed3fa5f39f15@linux.dev>
 <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffd48d49-c4f6-4fc3-88a5-0adb11d0d6b9@linux.dev>

On Tue, Sep 29, 2026 at 09:17:32AM +0200, Pankaj Raghav wrote:
> 
> 
> On 9/25/2026 1:44 PM, John Garry wrote:
> > On 9/25/26 11:36, Pankaj Raghav wrote:
> >  > xfs_calc_group_awu_max() clamps the atomic write unit maximum to the
> >  > greatest power-of-two factor of the group size when the device advertises
> >  > atomic writes, so that allocations can be made naturally aligned for
> >  > REQ_ATOMIC. But that value is the software limit: it is only used when
> >  > reflink is enabled, and out of place writes through the COW fork have no
> >  > alignment requirement.
> > 
> > We have mkfs atomic write options for selecting atomic write limits -
> > you have tried that, right?
> > 
> 
> Hmm, I did not try that but I restricted the agsize to a power of 2 value to
> workaround the limitation.
> 
> Are you talking about this option: max_atomic_write?
> 
> In any case, with default options the atomic values we are exposing is not
> correct at the moment.
> 
> > > 
> > > A filesystem on a > 4TB device that advertises 16k atomic writes then reports
> > > an atomic write unit maximum of a single fsblock and an optimal maximum of 0,
> > > and rejects any larger RWF_ATOMIC write. That is worse than the same filesystem
> > > on a device with no atomic write support at all.
> > > 
> > > Compute the software limit from the group size alone, and apply the
> > > alignment constraint in xfs_get_atomic_write_max_opt() instead, which is
> > > what reports the size that can be offloaded to the hardware.
> > > 
> > > Results on a 8TB device with 16k hardware atomic support with 4k
> > > blocksize:
> > > 
> > > Before patches:
> > > /media/test/hello.txt:
> > >    stx_atomic_write_unit_min:            4096
> > >    stx_atomic_write_unit_max:            4096
> > >    stx_atomic_write_unit_max_opt:        0
> > >    stx_atomic_write_segments_max:        1
> > > 
> > > After patches:
> > > /media/test/hello.txt:
> > >    stx_atomic_write_unit_min:            4096
> > >    stx_atomic_write_unit_max:            2097152
> > 
> > Here the AG size may not be a multiple of 2097152B, right? If so, when
> > we try to naturally align the allocation for a CoW write, even if the AG
> > blocks are naturally aligned (per AG), the disk blocks may not be
> > naturnally aligned - is this correct? For HW-based atomic writes, we
> > want naturally aligned disk blocks.
> > 
> 
> Correct.
> 
> Just to give more context:
> 
> Trace of calc_atomic_write_unit_max:
> 
>  mount-696   [010]   449.230543: xfs_calc_atomic_write_unit_max: dev 259:0
> ag max_write 262144 max_ioend 512 max_gsize 134217728 awu_max 512
> 
> 2097152 comes from awumax being 512 fsblocks.
> 
> root@debian:~# xfs_info /dev/nvme0n1
> meta-data=/dev/nvme0n1           isize=512    agcount=8, agsize=268435455 blks

268435455?  That's not aligned to the atomic write size, but that is the
max AG size.  I thought mkfs would round it down for us automatically:

        /*
         * We've already validated (or discarded) the hardware atomic write
         * geometry.  Try to align the agsize to the maximum atomic write unit
         * to give users maximum flexibility in choosing atomic write sizes.
         */
        if (ft->data.awu_max > 0)
                dsunit = max(DTOBT(ft->data.awu_max, cfg->blocklog),
                                dsunit);

But I guess I'll play around with it for a while and see if I get
anywhere.  Assuming you're running a recent mkfs that knows about
the atomic write options and whatnot?

--D

>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=2147483640, imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=521728, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> > >    stx_atomic_write_unit_max_opt:        4096
> > >    stx_atomic_write_segments_max:        1
> > > 
> > > Results on a 8TB device with 16k hardware atomic support with 16k
> > > blocksize:
> > > 
> > > Before patches:
> > > /media/test/hello.txt:
> > >    stx_atomic_write_unit_min:            16384
> > >    stx_atomic_write_unit_max:            16384
> > >    stx_atomic_write_unit_max_opt:        0
> > >    stx_atomic_write_segments_max:        1
> > > 
> > > After patches:
> > > /media/test/hello.txt:
> > >    stx_atomic_write_unit_min:            16384
> > >    stx_atomic_write_unit_max:            33554432
> > >    stx_atomic_write_unit_max_opt:        16384
> > >    stx_atomic_write_segments_max:        1
> > > 
> --
> Pankaj
> 
