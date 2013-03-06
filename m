Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6EEEF804D
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 18:57:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4BF03304067
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 16:57:49 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	utn6WS1WD2pHC0re for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 16:57:47 -0800 (PST)
Date: Wed, 6 Mar 2013 11:57:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: strange behavior of a larger xfs directory
Message-ID: <20130306005744.GA4549@dastard>
References: <4300208.uZ6HVTycB6@xrated> <8026381.3dEJ1E4pzL@xrated>
	<20130305222941.GP26081@dastard> <1517139.CltWl8VXzZ@xrated>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1517139.CltWl8VXzZ@xrated>
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

On Wed, Mar 06, 2013 at 12:48:25AM +0100, Hans-Peter Jansen wrote:
> Am Mittwoch, 6. M=E4rz 2013, 09:29:41 schrieb Dave Chinner:
> > On Tue, Mar 05, 2013 at 09:32:02PM +0100, Hans-Peter Jansen wrote:
> > attr_list and attr_multi are supplied by libattr, you should not
> > need the *by_handle variants at all - they are special sauce used by
> > xfsdump, not xfs_reno....
> =

> Ahh, I see. These interfaces cannot be exercised much, given that google =

> didn't relate them to libattr prominently..

Attributes are not widely used by applications for some reason...

> Hmm, any idea on how xfs can be tricked into generating 64 bit inodes wit=
hout =

> the need to create an excessive big test fs, or is this an accepted pract=
ice?

The usual trick is to use a sparse loopback device and create the
filesystem on that. see, for example, xfstests 078, where it is
testing growfs on filesystems up to 16TB in size on a loopback
device...

> Note to myself: xfs_reno could use some mount option check. Forgot to rem=
ount =

> one partition with inode32 and, consequently, moved the offending inodes =
to =

> another 64 bit value..

I'd just use a wrapper script that checked /proc/mounts for the
inode64 flag being set first....

....

> Index: b/configure.ac
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- a/configure.ac
> +++ b/configure.ac
....

The patch looks sane - can you add a commit description and s
Signed-off-by line to it, and then we can use it directly....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
