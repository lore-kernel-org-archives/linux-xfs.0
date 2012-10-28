Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9SLtSCZ066776 for <xfs@oss.sgi.com>; Sun, 28 Oct 2012 16:55:28 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DYLOUGo2Cym5QAA3 for <xfs@oss.sgi.com>;
	Sun, 28 Oct 2012 14:57:15 -0700 (PDT)
Date: Mon, 29 Oct 2012 08:57:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Enabling quota on XFS filesystem with many files hangs
Message-ID: <20121028215713.GM29378@dastard>
References: <20121026191540.ca9ee64db2a51e7166b7fadc@mjh.name>
	<508ADE1C.40208@sandeen.net>
	<20121028132050.c8d143729cd565307fcee279@mjh.name>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121028132050.c8d143729cd565307fcee279@mjh.name>
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
To: Milan =?iso-8859-1?Q?Holz=E4pfel?= <listen@mjh.name>
Cc: xfs@oss.sgi.com

On Sun, Oct 28, 2012 at 01:20:50PM +0100, Milan Holz=E4pfel wrote:
> On Fri, 26 Oct 2012 14:01:48 -0500
> Eric Sandeen <sandeen@sandeen.net> wrote:
> =

> > On 10/26/12 12:15 PM, Milan Holz=E4pfel wrote:
> > > Hello all, =

> > > =

> > > I have an XFS filesystem of size 1.2 TiB with 101 GiB free space and =
14
> > > million inodes in use. =

> =

> Meanwhile, I deleted 200 GiB of data on that filesystem, with 9.9
> million inodes still in use. Now, quotacheck just works. =


IOWs, the problem is load related.

>  XFS (dm-3): Mounting Filesystem
>  XFS (dm-3): Ending clean mount
>  XFS (dm-3): Quotacheck needed: Please wait.
>  INFO: task mount:8806 blocked for more than 120 seconds.
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  mount           D ffffffff8180cba0     0  8806   8703 0x00000000
>   ffff880036be38a8 0000000000000086 ffff880036be3878 ffffffffa042b4e9
>   ffff880036be3fd8 ffff880036be3fd8 ffff880036be3fd8 0000000000013980
>   ffffffff81c13440 ffff88007908dc00 ffff880036be3898 7fffffffffffffff
>  Call Trace:
>   [<ffffffffa042b4e9>] ? xfs_buf_iowait+0xa9/0x100 [xfs]
>   [<ffffffff81698f59>] schedule+0x29/0x70
>   [<ffffffff81697675>] schedule_timeout+0x2a5/0x320
>   [<ffffffffa0486c75>] ? xfs_trans_read_buf+0x265/0x480 [xfs]
>   [<ffffffffa0459ae7>] ? xfs_btree_check_sblock+0xc7/0x130 [xfs]
>   [<ffffffff81698daf>] wait_for_common+0xdf/0x180
>   [<ffffffff8108a280>] ? try_to_wake_up+0x200/0x200
>   [<ffffffff81698f2d>] wait_for_completion+0x1d/0x20
>   [<ffffffffa048c8a4>] xfs_qm_flush_one+0x74/0xb0 [xfs]

It's waiting for a write IO to complete - it seems unlikely that XFS
is the cause here because it's waiting on the storage to complete an
IO....

> Here is some more information on the system:
> =

> Linux bombax 3.5.7-030507-generic #201210130556 SMP Sat Oct 13 09:57:36 U=
TC 2012 x86_64 x86_64 x86_64 GNU/Linux
> xfs_repair version 3.1.7
> 2 CPUs
> =

> Storage layers are:
> mdadm RAID-5 256 KiB chunk size on sd[abcd]8
> Block-device encryption with cryptsetup-luks =

> XFS file system with the quotacheck problem

... and that is an unusual configuration and says to me that the
storage under XFS is the likely problem....

> disks: 4x SATA, 3.0 Gbps, NCQ enabled
> hdparm -W says: "write-caching =3D  1 (on)" on all drives
> no battery-backed write cache

And slow SATA drives will not improve the situation, either.  The
software RAID with small random writes that quotacheck does will
cause lots of RMW cycles and hence be very slow. This, alone, can
trigger hung task warnings. When you add encryption to the stack,
the storage stack will be even slower.

If you can reproduce it, I'd be really interested to know what the
sysrq-w output shows, as it will probably indicate a dm-crypt or md
thread hung waiting for something else to occur....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
