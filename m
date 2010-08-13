Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DEDMk5064540 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 09:13:23 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D05A94B476F
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 07:13:47 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	rldXR4hfpoYT0V2k for <xfs@oss.sgi.com>;
	Fri, 13 Aug 2010 07:13:47 -0700 (PDT)
Date: Sat, 14 Aug 2010 00:13:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: observed significant performance improvement using "delaylog" in
Message-ID: <20100813141344.GE10429@dastard>
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<i41q43$6td$1@dough.gmane.org> <4C6516CA.2010602@hardwarefreak.com>
	<201008131235.45050@zmi.at> <20100813122907.GA14650@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100813122907.GA14650@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Michael Monnerie <michael.monnerie@is.it-management.at>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On Fri, Aug 13, 2010 at 08:29:07AM -0400, Christoph Hellwig wrote:
> On Fri, Aug 13, 2010 at 12:35:44PM +0200, Michael Monnerie wrote:
> > On Freitag, 13. August 2010 Stan Hoeppner wrote:
> > > Some benchmark results maybe worth a look:
> > > http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/
> >  
> > Thanks - it would have been great to see xfs with delaylog in that 
> > comparison, but the graphs are very very nice.
> > 
> > XFS seems performing better the more threads there are, just in "large 
> > file random reads" it's the slowest - why this?
> 
> Any idea who is doing these runs?

IIRC the tests are run by someone from IBM, but I cannot remember
who it is.

> Once we figure out what that large
> file random reads loads is I'm sure we could fix it soon.

>From http://btrfs.boxacle.net/:

Random Reads (raid, single-disk) 
	Start with 1024 files. 
		100 MB files on the raid system.
		35 MB files on the single-disk system.
	Each thread reads a fixed amount of data from a random location in one file using 4 kB reads. 
		5 MB reads on the raid system.
		1 MB reads on the single-disk system.

So it's not a small random read workload (100GB data set), so the
files on XFS are probably more spread out over multiple AGs
and hence further apart than other filesystems. Hence a greater
average seek distance, hence it slower throughput....

> And asking
> him/her to add -o delaylog would also be good.

Yes, that would be an interesting comparison...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
