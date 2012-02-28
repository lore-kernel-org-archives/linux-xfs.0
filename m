Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S1mYM8141674 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 19:48:34 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	y5ub9xn5ZoDPhZeb for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 17:48:15 -0800 (PST)
Date: Tue, 28 Feb 2012 12:48:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mount: Structure needs cleaning
Message-ID: <20120228014813.GU3592@dastard>
References: <33393100.post@talk.nabble.com>
	<4F49B693.4080309@hardwarefreak.com>
	<33393429.post@talk.nabble.com> <20120227004902.GQ3592@dastard>
	<33397518.post@talk.nabble.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <33397518.post@talk.nabble.com>
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
To: MikeJeezy <forums@mgaccess.net>
Cc: xfs@oss.sgi.com

On Sun, Feb 26, 2012 at 07:11:58PM -0800, MikeJeezy wrote:
> 
> 
> 
> >The only reason for running xfs-repair -L is if you cannot mount the
> >filesystem to replay the log. i.e. on a shutdown like this, the
> >usual process is:
> 
> Right, when I tried to mount the volume it said "Structure needs cleaning"

OK, so you've done the right thing. I always like to check first ;)

> >You can only find out by looking at what the output of xfs_repair
> >told you about trashing inodes/directories.
> 
> Is this only output to the screen or to a log somewhere?

Only to stdout.

> > On 02/26/2012 11:07am, Stan Hoeppner wrote: 
> >Are those other VMs using XFS filesystems? 
> 
> What kernel version are you running?  
> 
> 2.6.18-274.18.1.el5

If you are running RHEL, you should really report problems through
the support channel.

> >Does your SAN array have battery backed write cache?  
> 
> This one does not currently, but I have ordered BBWC for it.
> 
> >Are the individual drive caches in the underlying array disabled? 
> 
> Write cache: enabled

There's your problem. You should read all the relevant sections on
write caches in the XFS FAQ. e.g:

http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
