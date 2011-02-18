Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1I3RsY2190546 for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 21:27:54 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 898CF1497FEF
	for <xfs@oss.sgi.com>; Thu, 17 Feb 2011 19:30:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	VzsjNAPEEXjrJvXr for <xfs@oss.sgi.com>;
	Thu, 17 Feb 2011 19:30:33 -0800 (PST)
Date: Fri, 18 Feb 2011 14:30:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_force_shutdown() called when running xfstests on 2.6.38-rc4
Message-ID: <20110218033030.GL13052@dastard>
References: <1297798863.32230.222.camel@chandra-lucid.beaverton.ibm.com>
	<20110215223022.GE13052@dastard>
	<1297886433.32230.224.camel@chandra-lucid.beaverton.ibm.com>
	<20110216221433.GG13052@dastard>
	<1297899728.32230.225.camel@chandra-lucid.beaverton.ibm.com>
	<4D5C8F4D.1060804@sandeen.net>
	<1297968550.32230.307.camel@chandra-lucid.beaverton.ibm.com>
	<20110217225209.GI13052@dastard>
	<1297994980.32230.309.camel@chandra-lucid.beaverton.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1297994980.32230.309.camel@chandra-lucid.beaverton.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Feb 17, 2011 at 06:09:40PM -0800, Chandra Seetharaman wrote:
> On Fri, 2011-02-18 at 09:52 +1100, Dave Chinner wrote:
> > On Thu, Feb 17, 2011 at 10:49:10AM -0800, Chandra Seetharaman wrote:
> > > Thanks for that info, Eric.
> > > 
> > > Now I increased the filesystem size and I see the following failure
> > > --------------------------------
> > > QA output created by 180
> > > file /mnt/xfsScratchMntPt/456 has incorrect size - sync failed
> > > file /mnt/xfsScratchMntPt/525 has incorrect size - sync failed
> > > file /mnt/xfsScratchMntPt/624 has incorrect size - sync failed
> > > ---------------------------------
> > > 
> > > I guess that is not good :)
> > 
> > No, not good. It passes here on x86_64 and a couple of different
> > configurations storage back ends (1/2p on h/w raid1 writing
> > @~90MB/s, 8p + s/w RAID0 @ ~700MB/s), so it doesn't seem like there
> > is a generic problem.
> > 
> > what is the hardware you are testing on? 
> PPC64

Yes, I know you are running on PPC64, but that doesn't tell me
anything about the hardware you are running on.  How many CPUs, how
much RAM, what storage you are using, how it is configured, etc, is
the sort of infomration relevant to understanding the circumstances
around the failures you are seeing...

> > Does it happen on every run?
> 
> No, it is not consistent. It happened as this
> 
> +file /mnt/xfsScratchMntPt/993 has incorrect size - sync failed
> 
> and ran 10+ times, didn't fail at all.

OK. So it's a relatively rare failure, then?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
