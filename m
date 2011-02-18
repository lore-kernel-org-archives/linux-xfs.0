Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1IJq4tZ234481 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 13:52:04 -0600
Received: from e9.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7553E4DA7EA
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:54:43 -0800 (PST)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id kPg9fXJmO9y39V2l for
	<xfs@oss.sgi.com>; Fri, 18 Feb 2011 11:54:43 -0800 (PST)
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1IJT8M0005934
	for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 14:29:08 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p1IJshWd222584 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 14:54:43 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p1IJsgTn008230 for <xfs@oss.sgi.com>; Fri, 18 Feb 2011 17:54:42 -0200
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110218033030.GL13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
	<1297899728.32230.225.camel@chandra-lucid.beaverton.ibm.com>
	<4D5C8F4D.1060804@sandeen.net>
	<1297968550.32230.307.camel@chandra-lucid.beaverton.ibm.com>
	<20110217225209.GI13052@dastard>
	<1297994980.32230.309.camel@chandra-lucid.beaverton.ibm.com>
	<20110218033030.GL13052@dastard>
Date: Fri, 18 Feb 2011 11:57:39 -0800
Message-ID: <1298059059.32230.318.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, 2011-02-18 at 14:30 +1100, Dave Chinner wrote:
> On Thu, Feb 17, 2011 at 06:09:40PM -0800, Chandra Seetharaman wrote:
> > On Fri, 2011-02-18 at 09:52 +1100, Dave Chinner wrote:
> > > On Thu, Feb 17, 2011 at 10:49:10AM -0800, Chandra Seetharaman wrote:
> > > > Thanks for that info, Eric.
> > > > 
> > > > Now I increased the filesystem size and I see the following failure
> > > > --------------------------------
> > > > QA output created by 180
> > > > file /mnt/xfsScratchMntPt/456 has incorrect size - sync failed
> > > > file /mnt/xfsScratchMntPt/525 has incorrect size - sync failed
> > > > file /mnt/xfsScratchMntPt/624 has incorrect size - sync failed
> > > > ---------------------------------
> > > > 
> > > > I guess that is not good :)
> > > 
> > > No, not good. It passes here on x86_64 and a couple of different
> > > configurations storage back ends (1/2p on h/w raid1 writing
> > > @~90MB/s, 8p + s/w RAID0 @ ~700MB/s), so it doesn't seem like there
> > > is a generic problem.
> > > 
> > > what is the hardware you are testing on? 
> > PPC64
> 
> Yes, I know you are running on PPC64, but that doesn't tell me

It is a 4 processor quad-core, which gets 16 procs. 32G RAM.

Storage is a ipr RAID0 of 2 500G sas disks.

Filesystem size is 20G.

> anything about the hardware you are running on.  How many CPUs, how
> much RAM, what storage you are using, how it is configured, etc, is
> the sort of infomration relevant to understanding the circumstances
> around the failures you are seeing...
> 
> > > Does it happen on every run?
> > 
> > No, it is not consistent. It happened as this
> > 
> > +file /mnt/xfsScratchMntPt/993 has incorrect size - sync failed
> > 
> > and ran 10+ times, didn't fail at all.
> 
> OK. So it's a relatively rare failure, then?

Very rare. I ran it more than 20 times yesterday night, and it didn't
fail.

chandra
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
