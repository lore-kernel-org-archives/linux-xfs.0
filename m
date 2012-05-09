Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4974uoj076554 for <xfs@oss.sgi.com>; Wed, 9 May 2012 02:04:56 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	cAa3OqkNBdFoFe3e for <xfs@oss.sgi.com>;
	Wed, 09 May 2012 00:04:54 -0700 (PDT)
Date: Wed, 9 May 2012 17:04:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: suddenly slow writes on XFS Filesystem
Message-ID: <20120509070450.GP5091@dastard>
References: <4FA63DDA.9070707@profihost.ag> <20120507013456.GW5091@dastard>
	<4FA76E11.1070708@profihost.ag> <20120507071713.GZ5091@dastard>
	<4FA77842.5010703@profihost.ag>
	<4FA7FA14.6080700@hardwarefreak.com>
	<4FA82B07.1020102@profihost.ag>
	<4FAA153D.1030606@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FAA153D.1030606@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Stefan Priebe <s.priebe@profihost.ag>

On Wed, May 09, 2012 at 01:57:01AM -0500, Stan Hoeppner wrote:
> On 5/7/2012 3:05 PM, Stefan Priebe wrote:
> > Am 07.05.2012 18:36, schrieb Stan Hoeppner:
....
> >> What I would suggest is doing an xfsdump to a filesystem on another LUN
> >> or machine, expand the size of this LUN by 50% or more (I gather this is
> >> an external RAID), format it appropriately, then xfsrestore.  This will
> >> eliminate your current free space fragmentation, and the 50% size
> >> increase will delay the next occurrence of this problem.  If you can't
> >> expand the LUN, simply do the xfsdump/format/xfsrestore, which will give
> >> you contiguous free space.
> > But this will only help for a few month or perhaps a year.
> 
> So you are saying your backup solution will fill up an additional 2.3TB
> in less than a year?  In that case I'd say you have dramatically
> undersized your backup storage and/or are not using file compression to
> your advantage.  And you're obviously not using archiving to your
> advantage or you'd not have the free space fragmentation issue because
> you'd be dealing with much larger files.
> 
> So the best solution to your current problem, and one that will save you
> disk space and thus $$, is to use a backup solution that makes use of
> both tar and gzip/bzip2.

Why use the slow method? xfsdump will be much faster than tar. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
