Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4B1727F3F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 16:59:03 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0CEBA30407F
	for <xfs@oss.sgi.com>; Thu, 18 Dec 2014 14:59:02 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	K35AjfZKfxoEbYvf for <xfs@oss.sgi.com>;
	Thu, 18 Dec 2014 14:58:57 -0800 (PST)
Date: Fri, 19 Dec 2014 09:58:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141218225843.GB24183@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
	<20141215201036.GQ24183@dastard>
	<20141216123405.111c7ac0@harpe.intellique.com>
	<20141216195815.GB15665@dastard>
	<20141218164042.15220bf3@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141218164042.15220bf3@harpe.intellique.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 18, 2014 at 04:40:42PM +0100, Emmanuel Florac wrote:
> Le Wed, 17 Dec 2014 06:58:15 +1100
> Dave Chinner <david@fromorbit.com> =E9crivait:
> =

> > > =

> > > The firmware is the latest available. How do I turn logging to 11
> > > please ?  =

> > =

> > # echo 11 > /proc/sys/fs/xfs/error_level
> =

> OK, so now I've set the error level up, I've rerun my test without
> using LVM, and the FS crashed again, this time more seriously. Here's
> the significant exerpt from /var/log/messages:
> =

> Dec 18 03:56:05 TEST-ADAPTEC -- MARK --
> Dec 18 04:00:04 TEST-ADAPTEC kernel: CPU: 0 PID: 1738 Comm: kworker/0:1H =
Not tainted 3.16.7-storiq64-opteron #1
> Dec 18 04:00:04 TEST-ADAPTEC kernel: Hardware name: Supermicro H8SGL/H8SG=
L, BIOS 3.0a       05/07/2013
> Dec 18 04:00:04 TEST-ADAPTEC kernel: Workqueue: xfslogd xfs_buf_iodone_wo=
rk
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  0000000000000000 ffff88040e2d5080 f=
fffffff814ca287 ffff88040e2d5120
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  ffffffff811fbb0d ffff8800df925940 f=
fff88040e2d5120 ffff8800df925940
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  ffffffff810705a4 0000000000013f00 0=
00000000deed450 ffff88040deed450
> Dec 18 04:00:04 TEST-ADAPTEC kernel: Call Trace:
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  [<ffffffff814ca287>] ? dump_stack+0=
x41/0x51
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  [<ffffffff811fbb0d>] ? xfs_buf_iodo=
ne_work+0x8d/0xb0
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  [<ffffffff810705a4>] ? process_one_=
work+0x174/0x420
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  [<ffffffff81070c4b>] ? worker_threa=
d+0x10b/0x500
> Dec 18 04:00:04 TEST-ADAPTEC kernel:  [<ffffffff814cc290>] ? __schedule+0=
x2e0/0x750

Where's the XFS error output? This is just the output from the
dump_stack() call in the xfs error message code...

Still, that's implying a write IO error being reporte din IO
completion, not a read error, and that's different to the previous
issue you've reported. It's also indicative of an error coming from
the storage, not XFS...

Do these problems *only* happen during or after a RAID rebuild?

> Phase 7 - verify and correct link counts...
> resetting inode 4294866029 nlinks from 2 to 5
> resetting inode 150323855504 nlinks from 13 to 12
> Metadata corruption detected at block 0x10809dc640/0x1000
> libxfs_writebufr: write verifer failed on bno 0x10809dc640/0x1000
> Metadata corruption detected at block 0x10809dc640/0x1000
> libxfs_writebufr: write verifer failed on bno 0x10809dc640/0x1000
> done

I'd suggest you should be upgrading xfsprogs, because that's an
error that shouldn't happen at the end of a repair. If the latest
version (3.2.2) doesn't fix this problem, then please send me a
compressed metadump so I can work out what corruption xfs_repair
isn't fixing properly.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
