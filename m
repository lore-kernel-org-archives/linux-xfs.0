Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1R1461w010332 for <xfs@oss.sgi.com>; Sun, 26 Feb 2012 19:04:06 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	aQtyCzkr2cJsQVvi for <xfs@oss.sgi.com>;
	Sun, 26 Feb 2012 17:04:04 -0800 (PST)
Date: Mon, 27 Feb 2012 12:04:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS, empty files after a crash
Message-ID: <20120227010402.GR3592@dastard>
References: <4F4387A7.2070009@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F4387A7.2070009@gmail.com>
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
To: kfx <kadafax@gmail.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 21, 2012 at 01:01:43PM +0100, kfx wrote:
> Hi,
> 
> After a crash, a lot of files on a xfs file system report an empty
> size with "ls -a" but not with "du".
> xfs_check and xfs_repair don't report any problem to repair
> (although an internal log is used) :(
> So if I understand correctly, those empty files actually use space
> on the disk but are incorrectly reported as empty by the system.
> Is there a way to copy back the used blocks to recover the files ?
> 
> Example for a previously not empty file:
> # ls -l myfile
> -rw-r--r-- 1 me me 0 2012-01-24 15:29 myfile
> 
> # du  myfile
> 27460    myfile
> 
> # du --apparent-size myfile
> 0    myfile
> 
> # xfs_bmap myfile
> myfile: no extents

That doesn't seem right:

$ ls -l foobar
-rw------- 1 root root 0 Feb 27 11:54 foobar
$ du foobar 
1024    foobar
$ du --apparent-size foobar 
0       foobar
$ xfs_bmap foobar
foobar:
	0: [0..2047]: 255169872..255171919

So xfs_bmap can and does report extents beyond EOF.

du uses the fstat(2) syscall to get the block count from the inode,
so it's seeing an inode with a block count but no extents. Can you
dump the inode via xfs_db like so:

$ ls -i foobar
604424233 foobar
$ sudo xfs_db -r -c "inode 604424233" -c p /dev/md0
core.magic = 0x494e
core.mode = 0100600
core.version = 2
.....

And post the output?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
