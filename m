Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D2F47F4E
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 21:09:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2390B8F8037
	for <xfs@oss.sgi.com>; Sun, 30 Jun 2013 19:09:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hTziIOMFtg5V8Yht for <xfs@oss.sgi.com>;
	Sun, 30 Jun 2013 19:09:41 -0700 (PDT)
Date: Mon, 1 Jul 2013 12:09:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: swidth in RAID
Message-ID: <20130701020939.GF27780@dastard>
References: <557F888F-34EA-4669-B861-C0B684DAD13D@gmail.com>
	<51D0A62E.2020309@hardwarefreak.com>
	<20130701013851.GC27780@dastard>
	<0DD94D98-18AA-441B-8F41-AD3AC1BCEC60@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0DD94D98-18AA-441B-8F41-AD3AC1BCEC60@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: aurfalien <aurfalien@gmail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Sun, Jun 30, 2013 at 06:54:31PM -0700, aurfalien wrote:
> 
> On Jun 30, 2013, at 6:38 PM, Dave Chinner wrote:
> 
> > On Sun, Jun 30, 2013 at 04:42:06PM -0500, Stan Hoeppner wrote:
> >> On 6/30/2013 1:43 PM, aurfalien wrote:
> >> 
> >>> I understand swidth should = #data disks.
> >> 
> >> No.  "swidth" is a byte value specifying the number of 512 byte blocks
> >> in the data stripe.
> >> 
> >> "sw" is #data disks.
> >> 
> >>> And the docs say for RAID 6 of 8 disks, that means 6.
> >>> 
> >>> But parity is distributed and you actually have 8 disks/spindles working for you and a bit of parity on each.
> >>> 
> >>> So shouldn't swidth equal disks in raid when its concerning distributed parity raid?
> >> 
> >> No.  Lets try visual aids.
> >> 
> >> Set 8 coffee cups (disk drives) on a table.  Grab a bag of m&m's.
> >> Separate 24 blues (data) and 8 reds (parity).
> >> 
> >> Drop a blue m&m in cups 1-6 and a red into 7-8.  You just wrote one RAID
> >> stripe.  Now drop a blue into cups 3-8 and a red in 1-2.  Your second
> >> write, this time rotating two cups (drives) to the right.  Now drop
> >> blues into 5-2 and reds into 3-4.  You've written your third stripe,
> >> rotating by two cups (disks) again.
> >> 
> >> This is pretty much how RAID6 works.  Each time we wrote we dropped 8
> >> m&m's into 8 cups, 6 blue (data chunks) and 2 red (parity chunks).
> >> Every RAID stripe you write will be constructed of 6 blues and 2 reds.
> > 
> > Right, that's how they are constructed, but not all RAID distributes
> > parity across different disks in the array. Some are symmetric, some
> > are asymmetric, some rotate right, some rotate left, and some use
> > statistical algorithms to give an overall distribution without being
> > able to predict where a specific parity block might lie within a
> > stripe...
> > 
> > And at the other end of the scale, isochronous RAID arrays tend to
> > have dedicated parity disks so that data read and write behaviour is
> > deterministic and therefore predictable from a high level....
> > 
> > So, assuming that a RAID5/6 device has a specific data layout (be it
> > distributed or fixed) at the filesystem level is just a bad idea. We
> > simply don't know. Even if we did, the only thing we can optimise is
> > the thing that is common between all RAID5/6 devices - writing full
> > stripe widths is the most optimal method of writing to them....
> 
> Am I interpreting this to say;
> 
> 16 disks is sw=16 regardless of parity?

No. I'm just saying that parity layout is irrelevant to the
filesystem and that all we care about is sw does not include parity
disks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
