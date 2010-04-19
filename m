Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3J3ikkw184196 for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 22:44:46 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED28A2CB648
	for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 20:46:44 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id x0q7vCgEUqJxma3A for
	<xfs@oss.sgi.com>; Sun, 18 Apr 2010 20:46:44 -0700 (PDT)
Date: Mon, 19 Apr 2010 11:45:23 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: different log info for mkfs.xfs and xfs_growfs
Message-ID: <20100419034523.GA3659@laptop.oracle.com>
References: <20100417145947.GA2573@laptop.oracle.com>
	<4BCA78D2.2030400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BCA78D2.2030400@sandeen.net>
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
Cc: xfs@oss.sgi.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-17 22:13, Eric Sandeen wrote:
> Wengang Wang wrote:
> > Hi experts,
> > 
> > I just noticed that the log info is different for mkfs.xfs and
> > xfs_growfs.
> > 
> > [root@desk test-xfsprogs]# mkfs.xfs -llogdev=/dev/sda11,size=32768b
> > /dev/sda10 -f
> > meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
> > blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=5002231, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =/dev/sda11             bsize=4096   blocks=32768, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > [root@desk test-xfsprogs]# mount -ologdev=/dev/sda11 /dev/sda10 /xfs
> > [root@desk test-xfsprogs]# xfs_growfs -n /xfs 
> > meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
> > blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=5002231, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =external               bsize=4096   blocks=32768, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > So xfs_growfs is simply reporting external.
> 
> The devicename isn't stored in the superblock, so growfs can't get it via
> the XFS_IOC_FSGEOMETRY ioctl.
> 
> > Why there is such a difference? And how get to know the log device name after it
> > is mounted?
> 
> /etc/mtab? :)
> 
> The UUID of the filesystem can be found in the log device after mkfs, but
> xfs is also perfectly happy with a completely zeroed-out log device (after
> a clean unmount).
 
Ok. I got.
> > It's 3.0.0 of xfsprogs. I failed to test with upstream because of the
> > comlilation error:
> > [wwg@desk xfsprogs.git]$ make
> > Building include
> > Building libxfs
> >     [DEP]
> > /usr/bin/makedepend: warning:  ignoring option -Wall
> > /usr/bin/makedepend: error:  cannot open "no-strict-aliasing"
> >     [LD]     libxfs.la
> > libtool: link: only absolute run-paths are allowed
> > gmake[2]: *** [libxfs.la] Error 1
> > gmake[1]: *** [libxfs] Error 2
> > make: *** [default] Error 2
> 
> I think I saw this once but it went away; does a make realclean
> fix it up for you - or was this a pristine git tree?

Yes, realclean works. 

Thanks for the explanations!

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
