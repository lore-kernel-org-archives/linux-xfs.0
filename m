Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3KGxERd051550 for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 11:59:15 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A56711DD832F
	for <xfs@oss.sgi.com>; Tue, 20 Apr 2010 10:01:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9QiRNaGDhNAn7LMo for
	<xfs@oss.sgi.com>; Tue, 20 Apr 2010 10:01:14 -0700 (PDT)
Message-ID: <4BCDDDD0.9000808@sandeen.net>
Date: Tue, 20 Apr 2010 12:01:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: do we support using a file as logdev?
References: <20100420143656.GA3634@laptop.oracle.com>
In-Reply-To: <20100420143656.GA3634@laptop.oracle.com>
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
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: greg.marsden@oracle.com, joe.jin@oracle.com, xfs@oss.sgi.com

On 04/20/2010 09:36 AM, Wengang Wang wrote:
> Hi experts,
> 
> Do we support using a file as log device?
> If no, it's strange that we support running xfs on a file but don't support log
> file.
> If yes, it fails at mount.
> 
> [root@desk test-xfsprogs]# mkfs.xfs
> -llogdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile,size=32768b
> /dev/sda10 -f
> meta-data=/dev/sda10             isize=256    agcount=4, agsize=1250558
> blks
>          =                       sectsz=512   attr=2
> data     =                       bsize=4096   blocks=5002231, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =/root/test-xfsprogs/test-xfsprogs-tmp/imagefile bsize=4096
> blocks=32768, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> [root@desk test-xfsprogs]# mount
> -ologdev=/root/test-xfsprogs/test-xfsprogs-tmp/imagefile /dev/sda10 /xfs
> mount: the kernel does not recognize /dev/sda10 as a block device
>        (maybe `insmod driver'?)

Well, -o logdev=$BLAH sets up m_logname with that value in the mount
point, and xfs_open_devices() then tries:

        if (mp->m_logname) {
                error = xfs_blkdev_get(mp, mp->m_logname, &logdev);

which eventually does

	open_bdev_exclusive(name, FMODE_READ|FMODE_WRITE, mp);
/**
 * open_bdev_exclusive  -  open a block device by name and set it up for use
 *
 * @path:       special file representing the block device
 * @mode:       FMODE_... combination to pass be used
 * @holder:     owner for exclusion
 *
 * Open the blockdevice described by the special file at @path, claim it
 * for the @holder.
 */

... this is all in kernelspace, which has no notion of what
/root/test-xfsprogs/test-xfsprogs-tmp/imagefile might be.  You'll need
to use a devicename that open_bdev_exclusive() can understand (like
/dev/loop0, as suggested)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
