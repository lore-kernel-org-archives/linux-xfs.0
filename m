Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6O0OmdD088877 for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 19:24:48 -0500
Received: from radon.netxsys.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56D4210B2B1E
	for <xfs@oss.sgi.com>; Thu, 23 Jul 2009 17:33:52 -0700 (PDT)
Received: from radon.netxsys.com (radon.netxsys.com [204.16.202.162]) by
	cuda.sgi.com with ESMTP id 9mxayb6N3xpM6Dpv for
	<xfs@oss.sgi.com>; Thu, 23 Jul 2009 17:33:52 -0700 (PDT)
Subject: Re: XFS: file system too large to be mounted on this system. 2.6.30.1
From: Krzysztof Adamski <k@adamski.org>
In-Reply-To: <4A67E4DE.1050904@sandeen.net>
References: <1248313295.4730.2.camel@oxygen.netxsys.com>
	<4A67E4DE.1050904@sandeen.net>
Date: Thu, 23 Jul 2009 20:25:30 -0400
Message-Id: <1248395130.4520.3.camel@oxygen.netxsys.com>
Mime-Version: 1.0
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
Cc: xfs@oss.sgi.com

On Wed, 2009-07-22 at 23:19 -0500, Eric Sandeen wrote:
> Krzysztof Adamski wrote:
> > I got "XFS: file system too large to be mounted on this system." when
> > mounting my not to large file system.
> > 
> > I'm running Debian lenny with a self compiled kernel, 32 bit userland
> > distribution.
> > 
> > I have both 32 and 64 bit kernels of the 2.6.30.1 installed. I was
> > running the 64bit kernel for a while, I needed to switch to the 32 bit
> > version to run VBox. After reboot to 32bit kernel, one filesystem would
> > not mount. The xfs_repair did not find any good superblocks.
> > Fortunately booting the 64bit kernel allowed mounting of this
> > filesystem.
> > This is a df while running 64bit kernel:
> > /dev/mapper/big--raid-file--store
> >                xfs   2558652416 2540114040  18538376 100% /file-store
> > /dev/sda1      xfs   195263012 194723636    539376 100% /disks/a1
> > 
> > The interesting part is that /disks/a1 did not have problem with
> > mounting on the 32bit kernel, just the /file-store.
> 
> 
> Do you have CONFIG_LBD (or maye now CONFIG_LBDAF) set on the newer
> 32-bit kernel?  You'll need that.

Yes, this was it, the CONFIG_LBD got unset when I used the .config file
to compile on a system that was running a 64 bit kernel. Now everything
is back to normal, thanks.

> 
> If you do ....
> 
> file-store is about 2T?  What is the filesystem block size?  (xfs_info
> on the mountpoint would tell you)

For reference:
# xfs_info /file-store
meta-data=/dev/mapper/big--raid-file--store isize=256    agcount=32,
agsize=19990496 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=639695872,
imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=65536  blocks=0, rtextents=0

> 
> The test is looking at whether the nr of filesystem blocks overflows
> based on CONFIG_LBD or not...
> 
> and the function hasn't changed since 2007.... hrm.
> 
> I'll put my money on CONFIG_LBDAF.
> 
> -Eric
> 
> > When running 2.6.28.4 32bit kernel I have no problem with mounting this
> > filesystem. So something broke between 2.6.28.4 and 2.6.30.1
> > 
> > I can provide any other info.
> > 
> > K
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
