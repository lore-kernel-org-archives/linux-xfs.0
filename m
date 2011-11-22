Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAM5Rt3a119024 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 23:27:55 -0600
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AB2CB12792F2
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 21:27:54 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xMxIVhlpg6AFFVrl for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 21:27:54 -0800 (PST)
Date: Tue, 22 Nov 2011 16:27:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair is recommended over xfs_check.
Message-ID: <20111122052751.GM2386@dastard>
References: <4ECAC84C.1070000@sauce.co.nz> <20111122002306.GI2386@dastard>
	<4ECB25C7.8070801@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ECB25C7.8070801@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Richard Scobie <richard@sauce.co.nz>, xfs@oss.sgi.com

On Mon, Nov 21, 2011 at 10:32:07PM -0600, Eric Sandeen wrote:
> On 11/21/11 6:23 PM, Dave Chinner wrote:
> > On Tue, Nov 22, 2011 at 10:53:16AM +1300, Richard Scobie wrote:
> >> Is there currently now any situation where xfs_check would be used
> >> in preference to xfs_repair?
> >>
> >> If not, perhaps xfs_check could be deprecated.
> > 
> > xfs_check is one of the ways we test that xfs_repair is doing the
> > right thing. Having two implementation that you can use to compare
> > results is a good thing.....
> 
> What about for end users though?  I'm not sure there's much need
> for end users to be comparing xfs_check against xfs_repair in general,
> anyway ...

Right, but that doesn't mean it needs deprecating as that implies
complete removal at some point in the future. I'd prefer to keep it
around as we get most of what it does for free as it uses the xfs_db
infrastructure to do all it's work.

> Often enough I see users using xfs_check just because it's there,
> and running into trouble... it seems reasonable to warn the
> casual user against it, or at least recommend xfs_repair -n
> instead.  What do you think?

The patch to modify the man page to advise use of xfs_repair is
sufficient, I think. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
