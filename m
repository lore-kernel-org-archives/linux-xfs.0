Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88E297CA0
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 20:50:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 598F8304132
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2016 18:50:21 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	kTZuJDN8Lr0IzpUS for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2016 18:50:18 -0700 (PDT)
Date: Wed, 17 Aug 2016 11:49:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfs: master branch updated to v4.8-rc2, for-next
	branch updated to d25ed4d
Message-ID: <20160817014931.GG19025@dastard>
References: <20160816233659.GE19025@dastard>
	<20160817003350.GA8268@birch.djwong.org>
	<20160817011053.GF19025@dastard>
MIME-Version: 1.0
In-Reply-To: <20160817011053.GF19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4638208802303808427=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com


--===============4638208802303808427==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABTtc+pdwF7KHXCz"
Content-Disposition: inline


--ABTtc+pdwF7KHXCz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 17, 2016 at 11:10:53AM +1000, Dave Chinner wrote:
> On Tue, Aug 16, 2016 at 05:33:50PM -0700, Darrick J. Wong wrote:
> > On Wed, Aug 17, 2016 at 09:36:59AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > >=20
> > > I've just updated the master branch of hte XFS kernel repository to
> > > v4.8-rc2. If you have outstanding patches, can you check they apply
> > > to this updated branch, and if not rebase your patches and resend
> > > them?
> >=20
> > I think this is missing "xfs: remove OWN_AG rmap when allocating a bloc=
k from
> > the AGFL", a.k.a. the fix for the generic/299 crash you were seeing.
>=20
> Oh, I might have merged one patch short. Thanks for the head's up.

Alright - I did merge one patch short. Fixed and force-pushed. Top
commit of the for-next branch should now be:

commit 32438cf9d54bd53b531f6d98814e84dd278360c1
Merge: a03f1a6 1d4795e
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Aug 17 11:13:37 2016 +1000

    Merge branch 'iomap-fixes-4.8-rc3' into for-next

-Dave.

--=20
Dave Chinner
david@fromorbit.com

--ABTtc+pdwF7KHXCz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs8KqAAoJEK3oKUf0dfodL6MQALRaY/hkoa4TLgmCMxiDOe/0
pWUZOSbg2s8VcVWda9FqYdSb953mizD2X+fTzk0UXV5+NWeK8S4crkjg6j6e3t5s
6aGd8EEk1Meqb7wUyExD5v9kgAbvp0ob0K2es7i1YaIekdlfD5kPO4Bwsdgoafd2
cWVFhRak/9R3A5At07mF7lY+F7l9L0OBowDHBRorUHX3XaRANQAeOVesbKsWOMC1
MkRaBlYJ+mwiqb/zgpXJG5ebOLc+qQ0Z2NeqZGckqOkGGPJjrEstFR9bhD3JGSW9
rGuYqE4DmZFPeMDqKJvADDyq8WpfQ0DtMUSgRnkLZyvHQ11j6ek3sBlFZtIi9Pm+
26qIOXWE//FGoLT8eGJPwqQY+RUYhqd8F73vr/qzv1KzNEFuHr1RfKhcHnwfZDaP
HG/+XJOoiiObR162x8Uts1jcAv61TqKdwOKeLiIRfoFzlveMQ7rQhO+xHCBkqOmm
6jpFpBretedqMXG2Uc738ihjMXyJcNpN882jLfk7SlHBm5nxCD8TRDwZWYtRbwc7
W9hFbOHvBNQBewdu71qmqWUdP0jMiBt/i0FpPMbkOwH/I11/gR3ki5bhxZVSQh+m
gAoY7fP3ljiEFhMGyEw0w+lk6FNTcAfvO7aYMintVjnXH1J6en31Zh3gKG7UVap6
7z3r0KbQ9rxwz9Ajd8DD
=oBFi
-----END PGP SIGNATURE-----

--ABTtc+pdwF7KHXCz--


--===============4638208802303808427==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4638208802303808427==--
