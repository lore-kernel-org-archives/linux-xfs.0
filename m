Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAKMYPOe185634 for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 16:34:25 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 327371629A42
	for <xfs@oss.sgi.com>; Sun, 20 Nov 2011 14:34:22 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	f10yAwvqCDjYbT1X for <xfs@oss.sgi.com>;
	Sun, 20 Nov 2011 14:34:22 -0800 (PST)
Date: Mon, 21 Nov 2011 09:34:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Introduce SEEK_DATA/SEEK_HOLE support to XFS V1
Message-ID: <20111120223418.GD2386@dastard>
References: <4E887D7F.2010306@oracle.com>
	<20111114102444.GA27791@infradead.org>
	<4EC10DE8.6030607@oracle.com> <20111114125044.GA9802@infradead.org>
	<4EC768F5.4050904@oracle.com> <4EC76AB9.9030604@oracle.com>
	<20111120003031.GM7046@dastard> <4EC907C3.7020901@oracle.com>
	<20111120153013.GA19199@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111120153013.GA19199@infradead.org>
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
Cc: Jeff Liu <jeff.liu@oracle.com>, xfs@oss.sgi.com, Chris Mason <chris.mason@oracle.com>, aelder@sgi.com

On Sun, Nov 20, 2011 at 10:30:13AM -0500, Christoph Hellwig wrote:
> On Sun, Nov 20, 2011 at 09:59:31PM +0800, Jeff Liu wrote:
> > > 		fsb = XFS_B_TO_FSBT(mp, start_offset);
> > > 		error = xfs_bmap_first_unused(NULL, ip, 1, &fsb,
> > > 						XFS_DATA_FORK);
> > > 		if (error)
> > > 			return -error;
> > > 
> > > 		if (fsb <= XFS_B_TO_FSBT(mp, start_offset))
> > > 			return start_offset;
> > > 		return XFS_FSB_TO_B(mp, fsb);
> > 
> > Thanks for pointing it out, I even don't know XFS has this convenient routine at that time. :(
> 
> I didn't remember it either, but Dave has been working the dir code
> which makes use of this funtion lately :)
> 
> Btw, the documentation for the function doesn't mention that it starts
> searching for the hole only after the passed in block number, which
> is something that could be improved.

Definitely. 

A bit of code archeology shows that the location of the hole was
originally the return value of the function, then it got moved to a
function parameter so that the return value could be used for error
status (1995). Then the parameter go changed to be used as the first
block to start searching from when the dir2 code was introduced in
1999. So it's been wrong for quite some time ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
