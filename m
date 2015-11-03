Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A02A87FCB
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 13:11:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92215304039
	for <xfs@oss.sgi.com>; Tue,  3 Nov 2015 11:11:52 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2XU197AnpfKRWE9u for <xfs@oss.sgi.com>;
	Tue, 03 Nov 2015 11:11:46 -0800 (PST)
Date: Wed, 4 Nov 2015 06:11:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Is it possible to change sunit of log section post-mkfs
Message-ID: <20151103191132.GD19199@dastard>
References: <5638A62D.1020802@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5638A62D.1020802@dermichi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 03, 2015 at 01:18:53PM +0100, Michael Weissenbacher wrote:
> Hi!
> I have a XFS file system which lies on a 10-disk RAID-6 device that was
> created with Chunk Size = 1MiB.
> On mkfs.xfs time this was - as far as i know - specified with "-d
> su=1m,sw=8".
> 
> xfs_info shows the following:
> meta-data=/dev/sdb1              isize=256    agcount=15,
> agsize=268435200 blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=3905945088, imaxpct=5
>          =                       sunit=256    swidth=2048 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=521728, version=2
>          =                       sectsz=512   sunit=8 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> Interestingly, the sunit value of the log seems to be incorrect - as it
> should be 256 too, like the sunit value of the data. I am pretty sure
> the reason is that the log sunit cannot be 256 blks (=1024KiB) and
> because of this mkfs.xfs did fall back to the default of 8 blks
> (=32KiB). I found evidence of this in the following thread:
> http://oss.sgi.com/archives/xfs/2012-06/msg00431.html
> 
> What i want to achieve is to set the log sunit to the maximum possible
> of 64 blks (=256KiB).

Why? Is there a performance problem with the default setting?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
