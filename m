Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Sep 2007 13:21:38 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8PKLSQ3015189
	for <linux-xfs@OSS.SGI.com>; Tue, 25 Sep 2007 13:21:33 -0700
Received: from from [127.0.0.1] (helo=base.ty.sabi.co.UK)
	by ty.sabi.co.UK with esmtp(Exim 4.66 #1)
	id 1IZR19-0007Pt-SN
	for <linux-xfs@OSS.SGI.com>; Sun, 23 Sep 2007 13:56:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18166.25242.174049.175729@base.ty.sabi.co.UK>
Date: Sun, 23 Sep 2007 13:56:58 +0100
Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
In-Reply-To: <20070923093841.GH19983@p15145560.pureserver.info>
References: <20070923093841.GH19983@p15145560.pureserver.info>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <linux-xfs@oss.sgi.com>

>>> On Sun, 23 Sep 2007 11:38:41 +0200, Ralf Gross
>>> <Ralf-Lists@ralfgross.de> said:

Ralf> Hi, we have a new large raid array, the shelf has 48 disks,
Ralf> the max. amount of disks in a single raid 5 set is 16.

Too bad about that petty limitation ;-).

Ralf> There will be one global spare disk, thus we have two raid 5
Ralf> with 15 data disks and one with 14 data disk.

Ahhh a positive-thinking, can-do, brave design ;-).

[ ... ]

Ralf> Often the data will be transfernd from the windows clients
Ralf> to the server in some parallel copy jobs at night (eg. 5-10,
Ralf> for each new data directory). The clients will access the
Ralf> data later (mostly) read only, the data will not be changed
Ralf> after it was stored on the file server.

This is good, and perhaps in some cases one of the few cases in
which even RAID5 naysayers might now object too much.

Ralf> Each client then needs a data stream of about 17 MB/s
Ralf> (max. 5 clients are expected to acces the data in parallel).

Do the requirements include as features some (possibly several)
hours of ''challenging'' read performance if any disk fails or
total loss of data if another disks fails during that time? ;-)

IIRC Google have reported 5% per year disk failure rates across a
very wide mostly uncorrelated population, you have 48 disks,
perhaps 2-3 disks per year will fail. Perhaps more and more often,
because they will likely be all from the same manufacturer, model,
batch and spinning in the same environment.

Ralf> [ ... ] I expect the fs, each will have a size of 10-11 TB,
Ralf> to be filled > 90%. I know this is not ideal, but we need
Ralf> every GB we can get.

That "every GB we can get" is often the key in ''wide RAID5''
stories. Cheap as well as fast and safe, you can have it all with
wide RAID5 setups, so the salesmen would say ;-).

Ralf> [ ... ] Stripe Size : 960 KB (15 x 64 KM)
Ralf> [ ... ] Stripe Size : 896 KB (14 x 64 KB)

Pretty long stripes, I wonder what happens when a whole stripe
cannot be written at once or it can but is not naturally aligned
;-).

Ralf> [ ... ] about 150 MB/s in seq. writing

Surprise surprise ;-).

Ralf> (tiobench) and 160 MB/s in seq.  reading.

This is sort of low. If there something that RAID5 can do sort of
OK is reads (if there are no faults). I'd look at the underlying
storage system and the maximum performance that you can get out of
a single disk.

I have seen a 45-drive 500GB storage subsystem where each drive
can deliver at most 7-10MB/s (even if the same disk standalone in
an ordinary PC can do 60-70MB/s), and the supplier actually claims
so in their published literature (that RAID product is meant to
compete *only* with tape backup subsystems). Your later comment
that "The raid array is connect to the server by fibre channel"
makes me suspect that it may be the same brand.

Ralf> This is ok,

As the total aggregate requirement is 5x17MB/s this is probably
the case [as long as there are no drive failures ;-)].

Ralf> but I'm curious what I could get with tuned xfs parameters.

Looking at the archives of this mailing list the topic ''good mkfs
parameters'' reappears frequently, even if usually for smaller
arrays, as many have yet to discover the benefits of 15-wide RAID5
setups ;-). Threads like these may help:

  http://OSS.SGI.com/archives/xfs/2007-01/msg00079.html
  http://OSS.SGI.com/archives/xfs/2007-05/msg00051.html
