Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2B52E426F;
	Mon, 16 Jun 2025 12:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076128; cv=none; b=UPVuIFI9CPdAHgl6wVv9IVkZGbzpTHHYsrWkdpmL4d22bBdA/QQ6IVGuYYdD3PcfiKxO6XtwyWJbC+j5HaiEtIqjYsrPrQcenLSGCO6ZDLsgweIZlzk5mqEDSjnGGuTgWbjntjxo6vGJNo59NhbFireKrRpcar2A9GtFzF2c2Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076128; c=relaxed/simple;
	bh=f2KGMeFwQsSAT8oxGQsWFauxCTtaTcqmi4sViT9XyLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nSFuGGNUy1iFcIKcV5oSCOmy1KXyRRXxc8NKmp5OciYZKiAxko74NWBBExZ5QPCopx2oJTSX/6teGWeAH1cX1E1jy6vdThx0yGNkiSykwAzMEGJfEqga1mQ92/1XU60UzxI29q+eEtuQFe0XVLBYGDVUqykxsExoYeKoWwwN8uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FmE5wL6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FmE5wL6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAA4C4CEEA;
	Mon, 16 Jun 2025 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750076128;
	bh=f2KGMeFwQsSAT8oxGQsWFauxCTtaTcqmi4sViT9XyLo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FmE5wL6igUSom2Gtojgifa76hjNOzCtcPsnUAe7W81afvCzwqSTZ6tdNCwt54ws2d
	 jqv58ruqtUagSgl7OGxoBj4KAiA/7QZtko8o+I5DS1Wu5Eo4emoezHI7C7741wA40l
	 JUNtUCI/H5fmG1iRC8Cah1rwXOHqz1LxnupneXPgPkXkpq1iffaZEzKfrmttf9Wn0m
	 BqGMTfRH+95qiEDT4/ISepUasmU8oi0MEx8MYCx4LQpV0mUXbHO+rGIb8oAC2xFeji
	 lgz/APvdm/lwLzcTupayaVRAXbjNUJQXPAGww3h7qAoRtY6CfMIra51aAuePlSyxIS
	 Liheb324QnxWw==
Date: Mon, 16 Jun 2025 14:15:23 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christian Theune <ct@flyingcircus.io>
Cc: stable@vger.kernel.org, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, regressions@lists.linux.dev
Subject: Re: temporary hung tasks on XFS since updating to 6.6.92
Message-ID: <hoszywa5az7z4yxubonbhs2p2ysnut3s7jjnkd7ckz4sgdyqw2@ifuor5qnl7yu>
References: <M1JxD6k5Sdxnq-pztTdv_FZwURA8AaT9qWNFUYGCmhiTRQFESfH7xqdOqQjz-oKQiin8pQckoNhfNyCHu-cxEQ==@protonmail.internalid>
 <14E1A49D-23BF-4929-A679-E6D5C8977D40@flyingcircus.io>
 <umhydsim2pkxhtux5hizyahwd6hy36yct5znt6u6ewo4fojvgy@zn4gkroozwes>
 <Z9Ih4yZoepxhmmH5Jrd1bCz35l6iPh5g2J61q2NR7loEdQb_aRquKdD1xLaE_5SPMlkBM8zLdVfdPvvKuNBrGQ==@protonmail.internalid>
 <3E218629-EA2C-4FD1-B2DB-AA6E40D422EE@flyingcircus.io>
 <g7wcgkxdlbshztwihayxma7xkxe23nic7zcreb3eyg3yeld5cu@yk7l2e4ibajk>
 <M0QJfqa7-6M2vnPhyeyy36xCOmCEL83O7lj-ky1DXTqQXa677-oE8C_nAsBCBglBp_6k7vLeN4a2nJ6R3JuQxw==@protonmail.internalid>
 <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <01751810-C689-4270-8797-FC0D632B6AB6@flyingcircus.io>

On Mon, Jun 16, 2025 at 12:09:21PM +0200, Christian Theune wrote:
> 
> > On 16. Jun 2025, at 11:47, Carlos Maiolino <cem@kernel.org> wrote:
> >
> > On Mon, Jun 16, 2025 at 10:59:34AM +0200, Christian Theune wrote:
> >>
> >>
> >>> On 16. Jun 2025, at 10:50, Carlos Maiolino <cem@kernel.org> wrote:
> >>>
> >>> On Thu, Jun 12, 2025 at 03:37:10PM +0200, Christian Theune wrote:
> >>>> Hi,
> >>>>
> >>>> in the last week, after updating to 6.6.92, we’ve encountered a number of VMs reporting temporarily hung tasks blocking the whole system for a few minutes. They unblock by themselves and have similar tracebacks.
> >>>>
> >>>> The IO PSIs show 100% pressure for that time, but the underlying devices are still processing read and write IO (well within their capacity). I’ve eliminated the underlying storage (Ceph) as the source of problems as I couldn’t find any latency outliers or significant queuing during that time.
> >>>>
> >>>> I’ve seen somewhat similar reports on 6.6.88 and 6.6.77, but those might have been different outliers.
> >>>>
> >>>> I’m attaching 3 logs - my intuition and the data so far leads me to consider this might be a kernel bug. I haven’t found a way to reproduce this, yet.
> >>>
> >>> From a first glance, these machines are struggling because IO contention as you
> >>> mentioned, more often than not they seem to be stalling waiting for log space to
> >>> be freed, so any operation in the FS gets throttled while the journal isn't
> >>> written back. If you have a small enough journal it will need to issue IO often
> >>> enough to cause IO contention. So, I'd point it to a slow storage or small
> >>> enough log area (or both).
> >>
> >> Yeah, my current analysis didn’t show any storage performance issues. I’ll revisit this once more to make sure I’m not missing anything. We’ve previously had issues in this area that turned out to be kernel bugs. We didn’t change anything regarding journal sizes and only a recent kernel upgrade seemed to be relevant.
> >
> > You mentioned you saw PSI showing a huge pressure ration, during the time, which
> > might be generated by the journal writeback and giving it's a SYNC write, IOs
> > will stall if your storage can't write it fast enough. IIRC, most of the threads
> > from the logs you shared were waiting for log space to be able to continue,
> > which causes the log to flush things to disk and of course increase IO usage.
> > If your storage can't handle these IO bursts, then you'll get the stalls you're
> > seeing.
> > I am not discarding a possibility you are hitting a bug here, but it so far
> > seems your storage is not being able to service IOs fast enough to avoid such IO
> > stalls, or something else throttling IOs, XFS seems just the victim.
> 
> Yeah, it’s annoying, I know. To paraphrase "any sufficiently advanced bug is indistinguishable from slow storage”. ;)
> 
> As promised, I’ll dive deeper into the storage performance analysis, all telemetry so far was completely innocuous, but it’s a complex layering of SSDs → Ceph → Qemu … Usually if we have performance issues then the metrics reflect this quite obviously and will affect many machines at the same time. As this has always just affected one single VM at a time but spread over time my gut feeling is a bit more on the side of “it might be maybe a bug”. As those things tend to be hard/nasty to diagnose I wanted to raise the flag early on to see whether other’s might be having an “aha” moment if they’re experiencing something similar.
> 
> I’ll get back to you in 2-3 days with results from the storage analysis.
> 
> > Can you share the xfs_info of one of these filesystems? I'm curious about the FS
> > geometry.
> 
> Sure:
> 
> # xfs_info /
> meta-data=/dev/disk/by-label/root isize=512    agcount=21, agsize=655040 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
>          =                       exchange=0
> data     =                       bsize=4096   blocks=13106171, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

This seems to have been extended a few times, but nothing out-of-reality. Looks
fine, but, is this one of the filesystems where you are facing the problem? I'm
surprised this is the root FS, do you have that much IO into the rootFS?

> 
> # xfs_info /tmp/
> meta-data=/dev/vdb1              isize=512    agcount=8, agsize=229376 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0    bigtime=0 inobtcount=0 nrext64=0
>          =                       exchange=0
> data     =                       bsize=4096   blocks=1833979, imaxpct=25
>          =                       sunit=1024   swidth=1024 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
> log      =internal log           bsize=4096   blocks=2560, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0

This is worrisome. Your journal size is 10MiB, this can easily keep stalling IO
waiting for log space to be freed, depending on the nature of the machine this
can be easily triggered. I'm curious though how you made this FS, because 2560
is below the minimal log size that xfsprogs allows since (/me goes look
into git log) 2022, xfsprogs 5.15.

FWIW, one of the reasons the minimum journal log size has been increased is the
latency/stalls that happens when waiting for free log space, which is exactly
the symptom you've been seeing.

I'd suggest you to check the xfsprogs commit below if you want more details,
but if this is one of the filesystems where you see the stalls, this might very
well be the cause:

commit cdfa467edd2d1863de067680b0a3ec4458e5ff4a
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Apr 6 16:50:31 2022 -0400

    mkfs: increase the minimum log size to 64MB when possible

> 
> 
> >
> >>
> >>> There has been a few improvements though during Linux 6.9 on the log performance,
> >>> but I can't tell if you have any of those improvements around.
> >>> I'd suggest you trying to run a newer upstream kernel, otherwise you'll get very
> >>> limited support from the upstream community. If you can't, I'd suggest you
> >>> reporting this issue to your vendor, so they can track what you are/are not
> >>> using in your current kernel.
> >>
> >> Yeah, we’ve started upgrading selected/affected projects to 6.12, to see whether this improves things.
> >
> > Good enough.
> >
> >>
> >>> FWIW, I'm not sure if NixOS uses linux-stable kernels or not. If that's the
> >>> case, running a newer kernel suggestion is still valid.
> >>
> >> We’re running the NixOS mainline versions which are very vanilla. There are very very 4 small patches that only fix up things around building and binary paths for helpers to call to adapt them to the nix environment.
> >
> > I see. There were some improvements in the newer versions, so if you can rule
> > out any possibly fixed bug is worth it.
> >
> >
> >>
> >> Christian
> >>
> >>
> >> --
> >> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> >> Flying Circus Internet Operations GmbH · https://flyingcircus.io
> >> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
> >> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · https://flyingcircus.io
> Leipziger Str. 70/71 · 06108 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 
> 
