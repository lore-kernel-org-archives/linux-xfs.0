Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1S1dTfa140988 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 19:39:30 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	m1HDj2ReDz8ffgIT for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 17:39:27 -0800 (PST)
Date: Tue, 28 Feb 2012 12:39:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS, empty files after a crash
Message-ID: <20120228013924.GT3592@dastard>
References: <4F4387A7.2070009@gmail.com> <20120227010402.GR3592@dastard>
	<4F4B423E.2000409@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F4B423E.2000409@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: kadafax@gmail.com
Cc: xfs@oss.sgi.com

On Mon, Feb 27, 2012 at 09:43:42AM +0100, kadafax@gmail.com wrote:
> Le 27/02/12 02:04, Dave Chinner a =E9crit :
> >On Tue, Feb 21, 2012 at 01:01:43PM +0100, kfx wrote:
> >># du  myfile
> >>27460    myfile
> >>
> >># du --apparent-size myfile
> >>0    myfile
> >>
> >># xfs_bmap myfile
> >>myfile: no extents
> >That doesn't seem right:
> >
> >$ ls -l foobar
> >-rw------- 1 root root 0 Feb 27 11:54 foobar
> >$ du foobar
> >1024    foobar
> >$ du --apparent-size foobar
> >0       foobar
> >$ xfs_bmap foobar
> >foobar:
> >	0: [0..2047]: 255169872..255171919
> >
> >So xfs_bmap can and does report extents beyond EOF.
> >
> >du uses the fstat(2) syscall to get the block count from the inode,
> >so it's seeing an inode with a block count but no extents. Can you
> >dump the inode via xfs_db like so:
.....
> [root@server 1_out]# xfs_db -r -c "inode 114748" -c p /dev/sdc1
> core.magic =3D 0x494e
> core.mode =3D 0100644
> core.version =3D 2
> core.format =3D 2 (extents)
.....
> core.size =3D 0
> core.nblocks =3D 6460
> core.extsize =3D 0
> core.nextents =3D 1
.....
> core.prealloc =3D 0
....
> core.extsz =3D 0
> core.extszinherit =3D 0
....
> u.bmx[0] =3D [startoff,startblock,blockcount,extentflag]
> 0:[0,1881705728,6460,0]

Ok, so there's an extent there, but xfs_bmap is not showing it
because it isn't a preallocation but rather a normal extent. What
this indicates is that the inode size was not updated on disk after
the data write had occurred.

Given you are running 2.6.38 (the unbuntu kernel), this is likely
caused by a known bug introduced in 2.6.37 by VFS changes outside
XFS to prevent sync livelocks. That has been fixed in current 3.0.x
stable kernels and more recent 3.2+ kernels.  I'd suggest upgrading
your kernel.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
