Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3C9nFTY143607 for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 04:49:15 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59EE93C61A0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2011 02:52:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	7eCAPMoMjnIwzXVa for <xfs@oss.sgi.com>;
	Tue, 12 Apr 2011 02:52:35 -0700 (PDT)
Date: Tue, 12 Apr 2011 19:52:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: HUGE XFS regression in 2.6.32 upto 2.6.38
Message-ID: <20110412095233.GZ31057@dastard>
References: <BANLkTinyBD7Zm3DvoYCVfYJkF36yXz6hOA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BANLkTinyBD7Zm3DvoYCVfYJkF36yXz6hOA@mail.gmail.com>
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
To: Raz <raziebe@gmail.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Apr 12, 2011 at 10:58:53AM +0300, Raz wrote:
> Christoph Hello
> I am testing 2.6.38 with AIM benchmark.
> I compared 2.6.38 to 2.6.27 and I noticed that 2.6.27 is much better
> than 2.6.38 when
> doing sync random writes test over an xfs regular file over native
> Linux partition on top common sata disk.
> I git bisected the problem and I reached this SHA1:
> commit 13e6d5cdde0e785aa943810f08b801cadd0935df
> Author: Christoph Hellwig <hch@lst.de>
> Date: =A0 Mon Aug 31 21:00:31 2009 -0300
> =

> =A0 =A0xfs: merge fsync and O_SYNC handling
> =

> =A0 =A0The guarantees for O_SYNC are exactly the same as the ones we need=
 to
> =A0 =A0make for an fsync call (and given that Linux O_SYNC is O_DSYNC the
> =A0 =A0equivalent is fdadatasync, but we treat both the same in XFS), exc=
ept
> =A0 =A0with a range data writeout. =A0Jan Kara has started unifying these=
 two
> =A0 =A0path for filesystems using the generic helpers, and I've started to
> =A0 =A0look at XFS.
> ...
> =

> =

> The bellow two tests presents the how different performance is before and=
 patch:
> #test 16) bisect 11
> -------------------------------------------------------------------------=
-----------------------------------
> =A0Test =A0 =A0 =A0 =A0Test =A0 =A0 =A0 =A0Elapsed =A0Iteration =A0 =A0It=
eration =A0 =A0 =A0 =A0 =A0Operation
> Number =A0 =A0 =A0 Name =A0 =A0 =A0Time (sec) =A0 Count =A0 Rate (loops/s=
ec) =A0 =A0Rate (ops/sec)
> -------------------------------------------------------------------------=
-----------------------------------
> =A0 =A0 1 sync_disk_rw =A0 =A0 =A0 =A030.71 =A0 =A0 =A0 =A0 19 =A0 =A00.6=
1869 =A0 =A0 =A0 =A0 1583.85
> Sync Random Disk Writes (K)/second
> -------------------------------------------------------------------------=
-----------------------------------

That's clearly showing that your sync writes are not hitting the
disk. IOWs, the sync writes are not synchronous at all. There is
no way a single SATA drive can do >1500 writes to stable storage
per second.

IOWs, before this fix, sync writes were broken on your hardware.

> #test 17 ) bisect 12
> -------------------------------------------------------------------------=
-----------------------------------
> =A0 =A0 1 sync_disk_rw =A0 =A0 =A0 =A069.05 =A0 =A0 =A0 =A0 =A01 =A0 =A00=
.01448 =A0 =A0 =A0 =A0 =A0 37.07
> Sync Random Disk Writes (K)/second
> -------------------------------------------------------------------------=
-----------------------------------

And that's pretty tpyical for a SATA drive where sync writes are
actually hitting the platter correctly.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
