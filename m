Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 679C07F4E
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 14:10:45 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 45B458F8033
	for <xfs@oss.sgi.com>; Mon, 15 Dec 2014 12:10:41 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GFLG4cxw17U0oxUO for <xfs@oss.sgi.com>;
	Mon, 15 Dec 2014 12:10:39 -0800 (PST)
Date: Tue, 16 Dec 2014 07:10:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20141215201036.GQ24183@dastard>
References: <20141211123936.1f3d713d@harpe.intellique.com>
	<20141215130715.4dfaaa8e@harpe.intellique.com>
	<20141215132500.13210fdb@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141215132500.13210fdb@harpe.intellique.com>
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

On Mon, Dec 15, 2014 at 01:25:00PM +0100, Emmanuel Florac wrote:
> Le Mon, 15 Dec 2014 13:07:15 +0100
> Emmanuel Florac <eflorac@intellique.com> =E9crivait:
> =

> > Dec 12 00:40:18 TEST-ADAPTEC kernel: XFS (dm-0):
> > xfs_do_force_shutdown(0x1) called from line 383 of file
> > fs/xfs/xfs_trans_buf.c.  Return address =3D 0xffffffff8125cc90
> > Dec 12 00:40:31 TEST-ADAPTEC kernel: XFS (dm-0): xfs_log_force: error
> > 5 returned.
> > Dec 12 00:41:02 TEST-ADAPTEC kernel: XFS (dm-0): xfs_log_force: error
> > 5 returned.
> > =

> =

> Reading the source I see that the error occured in xfs_buf_read_map, I
> suppose it's when xfsbufd tries to scan dirty metadata?

a) we don't have an xfsbufd anymore, and b) the xfsbufd never
"scanned" or read metadata - it only wrote dirty buffers back to
disk.

> This is a read
> error, so it could very well be a simple IO starvation at the controller
> level (as the controller probably gives priority to whatever writes are
> pending over reads).

The controller is broken if it's returning EIO to reads when it
is busy.

> Maybe setting xfsbufd_centisecs to the max could help here?

Deprecated Sysctls
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

  fs.xfs.xfsbufd_centisecs      (Min: 50  Default: 100  Max: 3000)
        Dirty metadata is now tracked by the log subsystem and
        flushing is driven by log space and idling demands. The
        xfsbufd no longer exists, so this syctl does nothing.

        Due for removal in 3.14.

Seems like the removal patch is overdue....

> Trying
> right away... Any advice welcome.

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_=
reporting_a_problem.3F

I'd start with upgrading the firmware on your RAID controller and
turning the XFS error level up to 11....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
