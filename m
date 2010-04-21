Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3L34D40083803 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 22:04:14 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271ED10472DF
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 20:06:12 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id wyR7SjaFZWC7xVwp for
	<xfs@oss.sgi.com>; Tue, 20 Apr 2010 20:06:12 -0700 (PDT)
Date: Wed, 21 Apr 2010 11:03:14 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: Re: do we support using a file as logdev?
Message-ID: <20100421030314.GB2252@laptop.oracle.com>
References: <20100420143656.GA3634@laptop.oracle.com>
	<4BCDDDD0.9000808@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BCDDDD0.9000808@sandeen.net>
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
Cc: xfs@oss.sgi.com, joe.jin@oracle.com, greg.marsden@oracle.com, Wengang Wang <wen.gang.wang@oracle.com>

On 10-04-20 12:01, Eric Sandeen wrote:
> On 04/20/2010 09:36 AM, Wengang Wang wrote:
> > Hi experts,
> > 
> > Do we support using a file as log device?
> > If no, it's strange that we support running xfs on a file but don't support log
> > file.
> > If yes, it fails at mount.
> > 
> > [root@desk test-xfsprogs]# mkfs.xfs
> > -llogdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile,size=32768b
> > /dev/sda10 -f
> > meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
> > blks
> >          =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=5002231, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =/root/test-xfsprogs/test-xfsprogs-tmp/imagefile bsize=4096
> > blocks=32768, version=2
> >          =                       sectsz=512   sunit=0 blks, lazy-count=0
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > [root@desk test-xfsprogs]# mount
> > -ologdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile /dev/sda10 /xfs
> > mount: the kernel does not recognize /dev/sda10 as a block device
> >        (maybe `insmod driver'?)
> 
> Well, -o logdev=$BLAH sets up m_logname with that value in the mount
> point, and xfs_open_devices() then tries:
> 
>         if (mp->m_logname) {
>                 error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
> 
> which eventually does
> 
> 	open_bdev_exclusive(name, FMODE_READ|FMODE_WRITE, mp);
> /**
>  * open_bdev_exclusive  -  open a block device by name and set it up for use
>  *
>  * @path:       special file representing the block device
>  * @mode:       FMODE_... combination to pass be used
>  * @holder:     owner for exclusion
>  *
>  * Open the blockdevice described by the special file at @path, claim it
>  * for the @holder.
>  */
> 
> ... this is all in kernelspace, which has no notion of what
> /root/test-xfsprogs/test-xfsprogs-tmp/imagefile might be.  You'll need
> to use a devicename that open_bdev_exclusive() can understand (like
> /dev/loop0, as suggested)

I see.
Thanks Eric for your detailed explanation!

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
