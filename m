Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2B17mbf131138 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 19:07:53 -0600
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5536433B0E4
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 17:10:27 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	9qB3OuCxJxXKWcF5 for <xfs@oss.sgi.com>;
	Thu, 10 Mar 2011 17:10:27 -0800 (PST)
Date: Fri, 11 Mar 2011 12:10:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Many-metadata performance still at a loss
Message-ID: <20110311011024.GB15097@dastard>
References: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1103101507120.5379@obet.zrqbmnf.qr>
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
To: Jan Engelhardt <jengelh@medozas.de>
Cc: xfs@oss.sgi.com

On Thu, Mar 10, 2011 at 03:14:34PM +0100, Jan Engelhardt wrote:
> Hi,
> 
> 
> Between 2.6.33 and 2.6.37 there was a lot of interesting announcements 
> with regards to XFS performance. However, now that I booted into 
> 2.6.37.2, I still see the metadata slowness from earlier.
> (Basically `time (tar -xf linux-2.6.37.tar.gz; sync)` - ext4 gets the 
> job done in like 15-20 seconds, xfs is still syncing after 11 minutes.)
> 
> Was there something I missed?
> 
> # xfs_info /
> meta-data=/dev/md3               isize=256    agcount=32, 
> agsize=11429117 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=365731739, 
> imaxpct=5
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
                                                              ^^^^^^^^^^^^
> realtime =none                   extsz=4096   blocks=0, rtextents=0

You're using an old mkfs? At minimum, this should have lazy-count=1.
I'm also wondering about the fact this is a MD device but there is
no sunit/swidth set, and the agcount of 32 is not a default value,
either. Seems like you handrolled your mkfs parameters - it is
better to just use the defaults a recent mkfs sets....

Further - what is your storage configuration (e.g. what type of MD
raid are you using) and is the filesystem correctly aligned to the
storage? If you get these wrong, then nothing else you do will
improve performance.

What are your mount options - perhaps you've missed the fact that
the new functionality requires the "delaylog" mount option to be
added.  Mind you, that is not a magic bullet - if the operation is
single threaded and CPU bound, delaylog makes  no difference to
performance, and with lazy-count=0 then the superblock will still be
a major contention point and probably nullify any improvement
delaylog could provide..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
