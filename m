Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FFA48038
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 16:30:10 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AE60304048
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:30:07 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	HzkZQrH1qx98KGPt for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 14:30:04 -0800 (PST)
Date: Wed, 6 Mar 2013 09:29:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: strange behavior of a larger xfs directory
Message-ID: <20130305222941.GP26081@dastard>
References: <4300208.uZ6HVTycB6@xrated> <20130304230527.GM26081@dastard>
	<8026381.3dEJ1E4pzL@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8026381.3dEJ1E4pzL@xrated>
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
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: xfs@oss.sgi.com

On Tue, Mar 05, 2013 at 09:32:02PM +0100, Hans-Peter Jansen wrote:
> Am Dienstag, 5. M=E4rz 2013, 10:05:27 schrieb Dave Chinner:
> > On Mon, Mar 04, 2013 at 05:40:13PM +0100, Hans-Peter Jansen wrote:
> > Second solution: Run 3.8.1, make sure you mount with inode32, and
> > then run the xfs_reno tool mentioned on this page:
> >
> > http://xfs.org/index.php/Unfinished_work
> > =

> > to find all the inodes with inode numbers larger than 32
> > bits and move them to locations with smaller inode numbers.
> =

> Okay, I would like to take that route.
> =

> I've updated the xfsprogs, xfsdump and xfstests packages in my openSUSE b=
uild =

> service repo home:frispete:tools to current versions today, and plan to s=
ubmit =

> them to Factory. openSUSE is always lagging in this area.
> =

> I've tried to include a build of the xfs_reno tool in xfsprogs, since, as=
 you =

> mentioned, others might have a similar need soon. Unfortunately I failed =
so =

> far, because it is using some attr_multi and attr_list interfaces, that a=
ren't =

> part of the xfsprogs visible API anymore. Only the handle(3) man page ref=
ers =

> to them.
> =

> Attached is my current state: I've relocated the patch to xfsprogs 3.1.9, =

> because it already carries all the necessary headers (apart from attr_mul=
ti =

> and attr_list). The attr interfaces seem to be collected in libhandle now=
, =

> hence I've added it to the build. =


attr_list and attr_multi are supplied by libattr, you should not
need the *by_handle variants at all - they are special sauce used by
xfsdump, not xfs_reno....

.....
> +TOPDIR =3D ..
> +include $(TOPDIR)/include/builddefs
> +
> +LTCOMMAND =3D xfs_reno
> +CFILES =3D xfs_reno.c
> +LLDLIBS =3D $(LIBATTR)

The patch assumes that libattr has been found by autoconf and set up
in $(LIBATTR), but xfsprogs does not currently use libattr and hence
that variable isn't set up. Therefore this line is a no-op:

+LLDLIBS =3D $(LIBATTR)

Change it to:

LLDLIBS =3D -lattr

And the xfs_reno should then link.

BTW, if you want extra points and add the autoconf magic to the
patch, copy it from the xfsdump tree. The places you need to copy
from are:

$ git grep -l LIBATTR |grep -v Makefile
configure.ac
include/builddefs.in
m4/package_attrdev.m4
$

And for even more bonus points, you could write a basic xfstest that
creates a bunch of 64 bit inodes and then runs xfs_reno on it and
checks that they get moved to 32 bit inodes. At that point, we could
probably pull the xfs_reno patch into xfsprogs and ship it....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
