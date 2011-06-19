Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JMviZ5079196 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 17:57:44 -0500
Received: from straum.hexapodia.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 611BE51E974
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 15:57:43 -0700 (PDT)
Received: from straum.hexapodia.org (straum.hexapodia.org [207.7.131.186]) by
	cuda.sgi.com with ESMTP id NdTmq4w34CgxQrTL for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 15:57:43 -0700 (PDT)
Date: Sun, 19 Jun 2011 15:58:34 -0700
From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: ENOSPC but df and df -i show free space
Message-ID: <20110619225834.GY21778@hexapodia.org>
References: <20110619215039.GA17820@hexapodia.org>
	<20110619221852.GH561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110619221852.GH561@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, Jun 20, 2011 at 08:18:52AM +1000, Dave Chinner wrote:
> > % touch /d1/tmp/foo
> > touch: cannot touch `/d1/tmp/foo': No space left on device
> > % df /d1
> > Filesystem           1K-blocks      Used Available Use% Mounted on
> > /dev/mapper/vg0-d1   943616000 904690332  38925668  96% /d1
> 
> Problems like this will occur if you run your filesystem at > 85-90%
> full for extented periods....

Ah, yes, that's definitely been the case.  I grow the filesystem when it
hits 95% utilization or thereabouts.  Hadn't realized that's such an
awful use case for xfs.

> > % df -i /d1
> > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > /dev/mapper/vg0-d1   167509008 11806336 155702672    8% /d1
> > % sudo xfs_growfs -n /d1
> > meta-data=/dev/mapper/vg0-d1     isize=256    agcount=18, agsize=13107200 blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=235929600, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=25600, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > % grep d1 /proc/mounts
> > /dev/mapper/vg0-d1 /d1 xfs rw,relatime,attr2,noquota 0 0
> > 
> > Obviously I'm missing something, but what?
> 
> Most likely is that you have no contiguous free space large enough
> to create a new inode chunk.  using xfs_db to dump the freespace
> size histogram will tell you if this is the case or not.

% sudo xfs_db -c freesp /dev/vg0/d1
   from      to extents  blocks    pct
      1       1  168504  168504   1.71
      2       3     446    1135   0.01
      4       7    5550   37145   0.38
      8      15   49159  524342   5.33
     16      31    1383   29223   0.30
2097152 4194303       1 2931455  29.78
4194304 8388607       1 6150953  62.49

I don't really grok that output.

-andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
