Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346742DBF5F;
	Tue, 17 Jun 2025 12:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164304; cv=none; b=r1pTI0hbo0NZm0446ZtUOJTxzTsxEgooho0wZ9OLRZlJqYKYAs/Ef4a46ajG6i/qanbnpjzlp8OXuBdpV9FkuYrK/EjEBwMvA0xBhiKLr/UkpLftEPjM20M/Af+NbwcZA3uFTa/4T5WNW37WVHV0t5N0aWsBOEJW/C+p0p7K5v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164304; c=relaxed/simple;
	bh=btFjE1s0qcxUFPoD5rLuwu/zQ5ZzD83LlZlyxmN4oG0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bqgB6XsiGHPMCop3LUlbznYdBR5E8p95rAMPweav9tm0V+r8SLjVlJorBOZmpMxIhwedIHObSbZSzOr8eUhNyr6qofa3FwVbiKMDGIkHqq6HpmWIPaLMippMvpq92HnmSmt76zuEVKmyuGL2yD0yFgH1GrMnxluOfxIK7GBrzP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNSpwbPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNSpwbPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E7C4CEE3;
	Tue, 17 Jun 2025 12:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750164303;
	bh=btFjE1s0qcxUFPoD5rLuwu/zQ5ZzD83LlZlyxmN4oG0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BNSpwbPhri4YxN5J3FDj+6H0B4A13+TI+yZ1JEmru9MdBdEc7BZdoc5ZLcKarj3e0
	 Rw3uPM+jlov1+2pGkcwnx3FQ/04rp3Bpfb1TIps9X/xDaF2U9hiOdND/K0U1iGKZ3p
	 EgZHjNB7KDm/+AH8w36UHFS+A14cUhjzUThT0Hf2tEBpIVXWEsrlIVaJzwg8YgzBNo
	 /lJoer/yPDddPuOLE1Gnbx7TB19f3pGRRkTcRnD6AK7Absy8hzdckZgxPzDj+Igy1D
	 RugplDnA2VJzYn9zCNf3/YTTYISi40nsGptSaLvoFAYqzjmHgUxPGowjAz8IryjpVy
	 AEM9pLbZ/Xpyg==
Date: Tue, 17 Jun 2025 14:44:59 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: stable@vger.kernel.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, regressions@lists.linux.dev
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
Message-ID: <gsuqdu3l3tdw5pbhfnkigs2mplpzgdhu7d6zok33f4e66ct6yh@gebktvf36kwn>
References: <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <M0QJfqa7-6M2vnPhyeyy36xCOmCEL83O7lj-ky1DXTqQXa677-oE8C_nAsBCBglBp_6k7vLeN4a2nJ6R3JuQxw==@protonmail.internalid>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
 <hoszywa5az7z4yxubonbhs2p2ysnut3s7jjnkd7ckz4sgdyqw2@ifuor5qnl7yu>
 <B380AC75-6B14-4EC9-A398-61A2D33033A7@flyingcircus.io>
 <SUCM2QMQ3TSn-abqhAXLpdEfSqdyFNhrwY0lcyPJNfPdl-2TGGBPkiBEueiV75Jl2UfC30lfhLMCSq7ND7st6Q==@protonmail.internalid>
 <0FAE679D-6EE7-4F71-9451-94D0825D1BF8@flyingcircus.io>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0FAE679D-6EE7-4F71-9451-94D0825D1BF8@flyingcircus.io>

On Tue, Jun 17, 2025 at 01:54:43PM +0200, Christian Theune wrote:
> 
> 
> > On 17. Jun 2025, at 07:44, Christian Theune <ct@flyingcircus.io> wrote:
> >
> >
> >
> >> On 16. Jun 2025, at 14:15, Carlos Maiolino <cem@kernel.org> wrote:
> >>
> >> On Mon, Jun 16, 2025 at 12:09:21PM +0200, Christian Theune wrote:
> >>
> >>>
> >>> # xfs_info /tmp/
> >>> meta-data=/dev/vdb1              isize=512    agcount=8, agsize=229376 blks
> >>>        =                       sectsz=512   attr=2, projid32bit=1
> >>>        =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >>>        =                       reflink=0    bigtime=0 inobtcount=0 nrext64=0
> >>>        =                       exchange=0
> >>> data     =                       bsize=4096   blocks=1833979, imaxpct=25
> >>>        =                       sunit=1024   swidth=1024 blks
> >>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> >>> log      =internal log           bsize=4096   blocks=2560, version=2
> >>>        =                       sectsz=512   sunit=8 blks, lazy-count=1
> >>> realtime =none                   extsz=4096   blocks=0, rtextents=0
> >>
> >> This is worrisome. Your journal size is 10MiB, this can easily keep stalling IO
> >> waiting for log space to be freed, depending on the nature of the machine this
> >> can be easily triggered. I'm curious though how you made this FS, because 2560
> >> is below the minimal log size that xfsprogs allows since (/me goes look
> >> into git log) 2022, xfsprogs 5.15.
> >>
> >> FWIW, one of the reasons the minimum journal log size has been increased is the
> >> latency/stalls that happens when waiting for free log space, which is exactly
> >> the symptom you've been seeing.
> >>
> >> I'd suggest you to check the xfsprogs commit below if you want more details,
> >> but if this is one of the filesystems where you see the stalls, this might very
> >> well be the cause:
> >
> > Interesting catch! I’ll double check this against our fleet and the affected machines and will dive into the traffic patterns of the specific underlying devices.
> >
> > This filesystem is used for /tmp and is getting created fresh after a “cold boot” from our hypervisor. It could be that a number of VMs have only seen warm reboots for a couple of years but get kernel upgrades with warm reboots quite regularly. We’re in the process of changing the /tmp filesystem creation to happen fresh during initrd so that the VM internal xfsprogs will more closely match the guest kernel.
> 
> I’ve checked the log size. A number of machines with very long uptimes have this outdated 10 MiB size. Many machines with less uptime have larger sizes (multiple hundred megabytes). Checking our codebase we let xfsprogs do their thing and don’t fiddle with the defaults.
> 
> The log sizes of the affected machines weren’t all set to 10 MiB - even machines with larger sizes were affected.

Bear in mind that this was the worst one you sent me, just because the other FS
had a larger log, it doesn't mean it's enough or it won't face the same problems
too, IIRC, the other configuration FS you sent, had a 64MiB log. xfsprogs has a
default log size based on the FS size, so it won't take too much disk space for
just the log, but the default may not be enough.
This of course is speculation from my part giving the logs you provided, but
might be worth to test your VMs with larger log sizes.

> 
> I’ll follow up - as promised - with further analysis whether IO starvation from the underlying storage may have occured.
> 
> Christian
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · https://flyingcircus.io
> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 
> 
