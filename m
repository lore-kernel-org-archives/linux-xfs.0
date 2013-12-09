Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 306F27F81
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 16:21:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F7338F8033
	for <xfs@oss.sgi.com>; Mon,  9 Dec 2013 14:21:51 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	MnEAeBfxwkbTGQUS for <xfs@oss.sgi.com>;
	Mon, 09 Dec 2013 14:21:48 -0800 (PST)
Date: Tue, 10 Dec 2013 09:21:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131209222131.GX10988@dastard>
References: <CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>
	<52A191BA.20800@hardwarefreak.com>
	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>
	<52A302A9.9050509@hardwarefreak.com>
	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>
	<52A401FF.9050506@hardwarefreak.com>
	<20131208160339.5c45ab91@galadriel.home>
	<52A5159F.2060309@hardwarefreak.com>
	<20131209014002.GP31386@dastard>
	<52A61F3A.7040504@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A61F3A.7040504@hardwarefreak.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Mike Dacre <mike.dacre@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Dec 09, 2013 at 01:51:22PM -0600, Stan Hoeppner wrote:
> On 12/8/2013 7:40 PM, Dave Chinner wrote:
> > On Sun, Dec 08, 2013 at 06:58:07PM -0600, Stan Hoeppner wrote:
> >> On 12/8/2013 9:03 AM, Emmanuel Florac wrote:
> >>> Le Sat, 07 Dec 2013 23:22:07 -0600 vous =E9criviez:
> >> The Samsung 840 Pro I recommended is rated at 90K 4K write IOPS and
> >> actually hits that mark in IOmeter testing at a queue depth of 7 and
> >> greater:
> >> http://www.tomshardware.com/reviews/840-pro-ssd-toggle-mode-2,3302-3.h=
tml
> > =

> > Most RAID controllers can't saturate the IOPS capability of a single
> > modern SSD - the LSI 2208 in my largest test box can't sustain much
> > more than 30k write IOPS with the 1GB FBWC set to writeback mode,
> > even though the writes are spread across 4 SSDs that can do about
> > 200k IOPS between them.
> =

> 2208 card w/4 SSDs and only 30K IOPS?  And you've confirmed these SSDs
> do individually have 50K IOPS? =


Of course - OCZ Vertex4 drives connected to my workstation easily
sustain that. Behind a RAID controller, nothing near it. I can get
70kiops out of the 4 of them on read, but the RAID controller is the
bottleneck.

> Four such SSDs should be much higher
> than 30K with FastPath.  Do you have FastPath enabled?

It's supposed to be enabled by default in the vendor firmware and
cannot be disabled.  There's no obvious documentation on how to set
it up, so I figured it was simply enabled for my "virtual RAID0
driver per SSD" setup.

After googling around a bit, I found that this method of exporting
the drives isn't sufficient - you have to specifically configure the
caching correctly i.e. you have to turn off readahead and change it
to use writethrough caching. =


/me changes the settings and reboots everything.

Wow, I get 33,000 IOPS now. That was worth the change...

Hold on, let me run something I know is utterly write IO bound

/me runs mkfs.ext4 and...

Oh, great, *another* goddamn hang in the virtio blk_mq code.....

> If not it's now
> a freebie with firmware 5.7 or later.  Used to be a pay option.  If
> you're using an LSI RAID card w/SSDs you're spinning in the mud without
> FastPath.

Yeah, well, it's still 2.5x faster than the 1078 controller the
drives were previously behind, so...

> >> Its processor is a 3 core ARM Cortex R4 so it should excel in this RAID
> >> cache application, which will likely have gobs of concurrency, and thus
> >> a high queue depth.
> > =

> > That is probably 2x more powerful as the RAID controller's CPU...
> =

> 3x 300MHz ARM cores at 0.5W vs 1x 800MHz PPC core at ~10W?  The PPC core
> has significantly more transistors, larger caches, higher IPC.  I'd say
> this Sammy chip has a little less hardware performance than a singe LSI
> core, but not much less.  Two of them would definitely have higher
> throughput than one LSI core.

Keep in mind that there's more than just CPUs on those SoCs. Often
the CPUs are just marshalling agents for hardware offloads, and
those little ARM SoCs are full of hardware accelerators...

> >> Found a review of CacheCade 2.0.  Their testing shows near actual SSD
> >> throughput.  The Micron P300 has 44K/16K read/write IOPS and their
> >> testing hits 30K.  So you should be able to hit close to ~90K read/wri=
te
> >> IOPS with the Samsung 840s.
> >>
> >> http://www.storagereview.com/lsi_megaraid_cachecade_pro_20_review
> > =

> > Like all benchmarks, take them with a grain of salt. There's nothing
> > there about the machine that it was actually tested on, and the data
> > sets used for most of the tests were a small fraction of the size of
> > the SSD (i.e. all the storagemark tests used a dataset smaller than
> > 10GB, and the rest were sequential IO).
> =

> The value in these isn't in the absolute numbers, but the relative
> before/after difference with CacheCade enabled.
> =

> > IOW, it was testing SSD resident performance only, not the
> > performance you'd see when the cache is full and having to page
> > random data in and out of the SSD cache to/from spinning disks.
> =

> The CacheCade algorithm seems to be a bit smarter than that, and one has
> some configuration flexibility.  If one has a 128 GB SSD and splits it
> 50/50 between read/write cache, that leaves 64 GB write cache.  The
> algorithm isn't going to send large streaming writes to SSD when the
> rust array is capable of greater throughput.

Still, the benchmarks didn't stress any of this, and were completely
resident in the SSD. It's not indicative of the smarts that the
controller might have, nor of what happens in eal world workloads
which have to operate on 24x7 timescales, not a few minutes of
benchmarking...

So, while the tech might be great, the benchmarks sucked at
demonstrating that.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
