Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0F0SxE7050441 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 18:29:00 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0A081C511FC
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 16:29:44 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	0apfBXg7jtJWIGUJ for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 16:29:44 -0800 (PST)
Date: Fri, 15 Jan 2010 11:29:38 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: usage of xfsctrl for embedded development / uuid question
Message-ID: <20100115002938.GC17483@discord.disaster>
References: <17182907.184441263481368019.JavaMail.www@wsfrf1112>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <17182907.184441263481368019.JavaMail.www@wsfrf1112>
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
To: paul.chavent@fnac.net
Cc: xfs@oss.sgi.com

[Please wrap you emails at 72 columns]

On Thu, Jan 14, 2010 at 04:02:48PM +0100, paul.chavent@fnac.net
wrote:
> Hi
> =

> I would like to use the xfsctl for trying directio and realtime
> feature on my gnu-linux embeded system (i have a "homemade" sdk).
> =

> It seems that the xfsctl function is defined inline, and that all i need =
is in =

> inlude/xfs/xfs.h
> inlude/xfs/xfs_fs.h
> inlude/xfs/platform_deps.h
> inlude/xfs/linux.h
> =

> So, for installing the dev files, it should be enought to do =

> tar -xvf xfsprogs-3.1.0.tar.gz
> cd xfsprogs-3.1.0.tar.gz
> ./configure --build=3D${HOST} --host=3D${TARGET}
> $MAKE -C include install-dev PKG_INC_DIR=3D${TOOLCHAIN_SYSROOT}/usr/inclu=
de/xfs

install-dev is dependent on a full build of xfsprogs.

Why not just include the xfsprogs-dev package (or equivalent)
from your base distro?

> So here are my remarks :
> =

> (1) uuid configuration problems :

> =A0=A0=A0 The package_uuiddev.m4 search for the function uuid_compare.
> This unction is present in the uuid included in e2fsprogs, but not
> in the OSSP uuid (http://www.ossp.org/pkg/lib/uuid/). So the
> configuration is ok but the compilation fails.

I doubt anyone has tried to build xfsprogs against that uuid
package before. Looks like it would need autoconf support to
detect, then a bunch of code changes to support the different
function prototype that the uuid_compare in the OSSP library
has. I'm not sure what best way to do this would be.

> =A0=A0=A0 The package_uuiddev.m4 search for uuid headers in multiple
> path but only one is included (in linux.h for example).

Sure - that's because we support multiple platforms and some
level of abstraction is required to do that cleanly.

> =A0=A0=A0 I think there is a bug with th definition of libuuid in
> package_uuiddev.m4 (not sure) =

> =

> (2) uuid requirement
> =

> =A0=A0=A0 As uuid seems to be not required for my application, i suggest
> a patch that allow to ignore the absence of this dependance.

It doesn't work like that - just about every xfs utility that
is build uses uuids in some form or another. IOWs, support needs to
be present for the correct working of the utilities. Hence we cannot
build xfsprogs without uuid support....

> (3) regeneration of configure
> =

> =A0=A0=A0 The regeneration of configure fails whith this message
> =

> =A0=A0=A0 # rm configure
> =A0=A0=A0 # make configure
> =A0=A0=A0 [...]
> =A0=A0=A0 autoconf
> =A0=A0=A0 configure.in:101: error: possibly undefined macro: AC_HAVE_BLKI=
D_TOPO
> =A0=A0=A0=A0=A0 If this token and others are legitimate, please use m4_pa=
ttern_allow.
> =A0=A0=A0=A0=A0 See the Autoconf documentation.

'make distclean' is the correct way to remove the configuration and
rebuild it. That should make the problem go away.

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
