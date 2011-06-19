Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JMIwPR076798 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:18:58 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CA7A171E051
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 15:18:55 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IEkPxWUsGmKqZR2T for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2011 15:18:55 -0700 (PDT)
Date: Mon, 20 Jun 2011 08:18:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENOSPC but df and df -i show free space
Message-ID: <20110619221852.GH561@dastard>
References: <20110619215039.GA17820@hexapodia.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110619215039.GA17820@hexapodia.org>
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
To: Andy Isaacson <adi@hexapodia.org>
Cc: xfs@oss.sgi.com

On Sun, Jun 19, 2011 at 02:50:39PM -0700, Andy Isaacson wrote:
> % touch /d1/tmp/foo
> touch: cannot touch `/d1/tmp/foo': No space left on device
> % df /d1
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/mapper/vg0-d1   943616000 904690332  38925668  96% /d1

Problems like this will occur if you run your filesystem at > 85-90%
full for extented periods....

> % df -i /d1
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/mapper/vg0-d1   167509008 11806336 155702672    8% /d1
> % sudo xfs_growfs -n /d1
> meta-data=/dev/mapper/vg0-d1     isize=256    agcount=18, agsize=13107200 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=235929600, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=25600, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> % grep d1 /proc/mounts
> /dev/mapper/vg0-d1 /d1 xfs rw,relatime,attr2,noquota 0 0
> 
> Obviously I'm missing something, but what?

Most likely is that you have no contiguous free space large enough
to create a new inode chunk.  using xfs_db to dump the freespace
size histogram will tell you if this is the case or not.

> Nothing relevant in dmesg that I can see.  The filesystem started out at
> 200 GB and has been xfs_growfs'd in 100GB increments up to its current
> size of 900 GB.

Ugh. Sounds like you've been running the filesystem near full for
it's entire life....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
