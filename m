Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKMP1Da184775 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 16:25:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A32B1CE1F0F
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 14:26:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	BQ5LPm7KyRDnKj7j for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 14:26:56 -0800 (PST)
Date: Tue, 21 Dec 2010 09:26:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Question regarding xfs_repair / memory requirement.
Message-ID: <20101220222653.GL5193@dastard>
References: <alpine.DEB.2.00.1012200519230.26485@p34.internal.lan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012200519230.26485@p34.internal.lan>
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
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: xfs@oss.sgi.com

On Mon, Dec 20, 2010 at 05:20:18AM -0500, Justin Piszcz wrote:
> Hi,
> 
> I am looking at FS to use for a possible 43TB array.
> If there is a problem with a volume this large, how much ram will
> xfs_repair need to fsck the volume?

$ dd if=/dev/zero of=/mnt/scratch/test.img bs=1048576 count=1 seek=50000000
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.00463602 s, 226 MB/s
$ ls -lh /mnt/scratch/test.img 
-rw-r--r-- 1 dave dave 48T Dec 21 09:22 /mnt/scratch/test.img
$ sudo mkfs.xfs -d name=/mnt/scratch/test.img,file,size=43t
[sudo] password for dave: 
meta-data=/mnt/scratch/test.img  isize=256    agcount=43, agsize=268435455 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=11542724565, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=521728, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo xfs_repair -m 1 -vv /mnt/scratch/test.img 
Phase 1 - find and verify superblock...
        - max_mem = 1024, icount = 64, imem = 0, dblock = 11542724565, dmem = 5636095
Required memory for repair is greater that the maximum specified with the -m option. Please increase it to at least 5552
$

Not taking inodes into account, you'll need at least 5.5GB of RAM to run
xfs_repair on a 43TB filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
