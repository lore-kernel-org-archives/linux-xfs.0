Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4139 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753528AbeAKDH5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Jan 2018 22:07:57 -0500
Date: Thu, 11 Jan 2018 14:07:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180111030723.GU16421@dastard>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia>
 <20180108220139.GB16421@dastard>
 <5A548D31.4000002@youngman.org.uk>
 <20180109222523.GJ16421@dastard>
 <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85f60b96-b2ca-be84-a7f6-380b545c3ac8@turmel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

on Wed, Jan 10, 2018 at 09:10:55AM -0500, Phil Turmel wrote:
> On 01/09/2018 05:25 PM, Dave Chinner wrote:
> 
> > It's nice to know that MD has redefined RAID-10 to be different to
> > the industry standard definition that has been used for 20 years and
> > optimised filesystem layouts for.  Rotoring data across odd numbers
> > of disks like this is going to really, really suck on filesystems
> > that are stripe layout aware..
> 
> You're a bit late to this party, Dave.  MD has implemented raid10 like
> this as far back as I can remember, and it is especially valuable when
> running more than two copies.  Running raid10,n3 across four or five
> devices is a nice capacity boost without giving up triple copies (when
> multiples of three aren't available) or giving up the performance of
> mirrored raid.

XFS comes from a different background - high performance, high
reliability and hardware RAID storage. Think hundreds of drives in a
filesystem, not a handful. i.e. The XFS world is largely enterprise
and HPC storage, not small DIY solutions for a home or back-room
office.  We live in a different world, and MD rarely enters mine.

> > For example, XFS has hot-spot prevention algorithms in it's
> > internal physical layout for striped devices. It aligns AGs across
> > different stripe units so that metadata and data doesn't all get
> > aligned to the one disk in a RAID0/5/6 stripe. If the stripes are
> > rotoring across disks themselves, then we're going to end up back in
> > the same position we started with - multiple AGs aligned to the
> > same disk.
> 
> All of MD's default raid5 and raid6 layouts rotate stripes, too, so that
> parity and syndrome are distributed uniformly.

Well, yes, but it appears you haven't thought through what that
typically means.  Take a 4+1, chunk size 128k, stripe width 512k

A	B	C	D	E
0	0	0	0	P
P	1	1	1	1
2	P	2	2	2
3	3	P	3	3
4	4	4	P	4

For every 5 stripe widths, each disk holds one stripe unit of
parity. Hence 80% of data accesses aligned to a specific data offset
hit that disk. i.e. disk A is hit by 0-128k, parity for 512-1024k,
1024-1152k, 1536-1664k and 2048-2176k. IOWs, if we align stuff to
512k, we're going to hit disk A 80% of the time and disk B 20% of
the time.

So, if mkfs.xfs ends up aligning all AGs to a multiple of 512k, then
all our static AG metadata is aligned to disk A. Further, all the
AGs will align their first stripe unit in a stripe width to Disk A,
too.  Hence this results in a major IO hotspot on disk A, and
smaller hotspot on disk B. Disks C, D, and E will have the least IO
load on them.

By telling XFS that the stripe unit is 128k and the stripe width is
512k, we can avoid this problem. mkfs.xfs will rotor it's AG
alignment by some number of stripe units at a time. i.e. AG 0 aligns
to disk A, AG 1 aligns to disk B, AG 2 aligns to disk 3, and so on.

The result is that base alignment used by the filesystem is now
distributed evenly across all disks in the RAID array and so all
disks get loaded evenly. The hot spots go away because the
filesystem has aligned it's layout appropriately for the underlying
storage geometry.  This applies to any RAID geometry that stripes
data across multiple disks in a regular/predictable pattern.

[ I'd cite an internal SGI paper written in 1999 that measured and
analysed all this on RAID0 in real world workloads and industry
standard benchmarks like AIM7 and SpecSFS and lead to the mkfs.xfs
changes I described above, but, well, I haven't had access to that
since I left SGI 10 years ago... ]

> > IMO, odd-numbered disks in RAID-10 should be considered harmful and
> > never used....
> 
> Users are perfectly able to layer raid1+0 or raid0+1 if they don't want
> the features of raid10.  Given the advantages of MD's raid10, a pedant
> could say XFS's lack of support for it should be considered harmful and
> XFS never used.  (-:

MD RAID is fine with XFS as long as you use a sane layout and avoid
doing stupid things that require reshaping and changing the geometry
of the underlying device. Reshaping is where the trouble all
starts...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
