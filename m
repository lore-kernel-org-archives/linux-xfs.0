Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7BMvmgp030865 for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 17:57:49 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xlwVFF2f7eETb82A for <xfs@oss.sgi.com>;
	Sat, 11 Aug 2012 15:57:46 -0700 (PDT)
Date: Sun, 12 Aug 2012 08:57:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs warnings on kernel 3.2.15
Message-ID: <20120811225742.GH2877@dastard>
References: <1918987.4hlisJiio3@saturn> <20120809221518.GW2877@dastard>
	<6314061.2K1xYxIYlT@saturn>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <6314061.2K1xYxIYlT@saturn>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Sat, Aug 11, 2012 at 12:50:45PM +0200, Michael Monnerie wrote:
> Am Freitag, 10. August 2012, 08:15:18 schrieb Dave Chinner:
> > The freeze/thaw deadlock is not fixed in 3.5 and i think it missed
> > 3.6 as well so you're going to be waiting until 3.7 for this to be
> > fixed, I suspect....
> 
> OK, at least you guys have a plan for a fix. I'm happy to get that fixed 
> soon. Thank you.

It got included late in the 3.6-rc1 cycle, so it will be in 3.6.

> But when I think about it: Isn't that worth a backport fix? VMware isn't 
> a seldom used piece of software, and we use NetApp Storage with  
> snapshots, which is also used a lot worldwide. I can imagine others have 
> the same problem, or is it just me?

It's a problem that has been around for, well, since freeze was
first introduced many, many years ago. And the complexity of the fix
(20+ patch series, IIRC) makes it a difficult and time consuming fix
that requires a lot of testing - it touches the VFS and has changes
all through different filesystems, including XFS. I just can't see
anyone other than enterprise distro vendors spending that much
effort to back port such an intrusive fix....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
