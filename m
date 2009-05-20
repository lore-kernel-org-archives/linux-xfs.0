Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4K9uhO3099582 for <xfs@oss.sgi.com>; Wed, 20 May 2009 04:56:43 -0500
Received: from mail5.tpgi.com.au (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F00212FA055
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 03:02:07 -0700 (PDT)
Received: from mail5.tpgi.com.au (mail5.tpgi.com.au [203.12.160.101]) by
	cuda.sgi.com with ESMTP id 7H51EhSW9ADU1FcW for
	<xfs@oss.sgi.com>; Wed, 20 May 2009 03:02:07 -0700 (PDT)
Date: Wed, 20 May 2009 19:56:39 +1000
From: Alex Samad <alex@samad.com.au>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090520095639.GA27496@samad.com.au>
References: <20090520003745.GA27491@samad.com.au>
	<20090520090558.GQ16929@discord.disaster>
MIME-Version: 1.0
In-Reply-To: <20090520090558.GQ16929@discord.disaster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2218898026927556416=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--===============2218898026927556416==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2009 at 07:05:58PM +1000, Dave Chinner wrote:
> On Wed, May 20, 2009 at 10:37:45AM +1000, Alex Samad wrote:
> > Hi
> >=20
> > I have been quit a lot of crashes on my debian amd64 box in the 2.6.29
> > series of kernel. Seems for me to be when the system is under load and
> > there is network action -> nfsd -> xfs.
>=20
> Perhaps a use after free or a reference counting problem. Thanks for
> reporting it.
>=20
> > May  5 19:45:38 x kernel: ------------[ cut here ]------------

[snip]

> > I have logged a bug with debian
> > ( more info http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D526406),
> > there has been one other to report this problem.
> >=20
> > we believe somebody has already reported a similar problem here
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/dd00f5=
2e93397c9e/6b6814dab9b41a05?pli=3D1
>=20
> Which no-one noticed was related to XFS (not in the subject line)
> and so most people (like me) would have simply deleted it without
> reading it....
>=20
> > has any one else seen this problem, who do I need to raise this too ?
>=20

thanks

> I've cc'd the XFS list.
>=20
> > I am able to reproduce this problem on my machine (amd64 phenomem II 8G
> > ram), running virtualbox, I have a vm access the local filesystem via
> > nfs (udp) and when I do a rm -fr <some directory ~200M> I see the bug
>=20
> I run debian, XFS and 2.6.29 on all my machines but I haven't
> tripped over the problem - it all appears to be related to calling
> dispose_list() during/just after removing a lot of files. If you
> have a simple method of reproducing the problem (e.g. a simple shell
> script) it would help track down the problem much faster....

my source directory was an openwrt trunk (svn co
svn://svn.openwrt.org/openwrt/trunk/) which I had done a compile on, I
went to delete it (just about every time it would cause this problem.

on the original data set (I was in the process of moving from one
location to another so I still have the original data)

du -s --si=20
5.2G

find | wc -l
313320

if you have a look at the debian bug, another person (mike) has
experienced this on a machine that is basically a backup server so
heavily stressed out - using xfs partitions - he found going back to
2.6.28-7 seems to be stable.



>=20
> Cheers,
>=20
> Dave.


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoT09QACgkQkZz88chpJ2P+DwCeKmpLZGr3qPzsnpa1Lp3Pur/0
QNMAoNSQLT3yKRVDZ8bGScMnyjO+9ux9
=NCm2
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--


--===============2218898026927556416==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2218898026927556416==--
