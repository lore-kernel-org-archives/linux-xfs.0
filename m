Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C816D8009
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 08:55:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C8CCAC002
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 06:55:05 -0800 (PST)
Received: from frost.carfax.org.uk (frost.carfax.org.uk [85.119.82.111]) by
	cuda.sgi.com with ESMTP id ZUqNq29IyEboOEu6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 06:55:04 -0800 (PST)
Date: Thu, 14 Feb 2013 14:54:51 +0000
From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device
Message-ID: <20130214145450.GE28997@carfax.org.uk>
References: <1360667215-14701-1-git-send-email-lczerner@redhat.com>
	<20130212202753.GC26694@dastard>
	<20130213080154.GC18597@x2.net.home>
	<alpine.LFD.2.00.1302131127070.2315@(none)>
	<20130213121655.GA7799@x2.net.home>
	<20130213221720.GH26694@dastard>
	<982B8DBB-3FBA-4213-BC92-848A64C60110@colorremedies.com>
	<alpine.LFD.2.00.1302140929570.2315@(none)>
	<20130214110423.GN26694@dastard>
MIME-Version: 1.0
In-Reply-To: <20130214110423.GN26694@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9103897896664826237=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Karel Zak <kzak@redhat.com>, Zach Brown <zabrown@redhat.com>, =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>, Chris Murphy <lists@colorremedies.com>, linux-btrfs@vger.kernel.org


--===============9103897896664826237==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IU5/I01NYhRvwH70"
Content-Disposition: inline


--IU5/I01NYhRvwH70
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 14, 2013 at 10:04:23PM +1100, Dave Chinner wrote:
> On Thu, Feb 14, 2013 at 09:36:38AM +0100, Luk=C3=A1=C5=A1 Czerner wrote:
> > On Thu, 14 Feb 2013, Chris Murphy wrote:
> >=20
> > > Date: Thu, 14 Feb 2013 00:29:59 -0700
> > > From: Chris Murphy <lists@colorremedies.com>
> > > To: Dave Chinner <david@fromorbit.com>
> > > Cc: Karel Zak <kzak@redhat.com>, Luk=C3=A1=C5=A1 Czerner <lczerner@re=
dhat.com>,
> > >     xfs@oss.sgi.com, sandeen@redhat.com, Zach Brown <zabrown@redhat.c=
om>,
> > >     linux-btrfs@vger.kernel.org
> > > Subject: Re: [PATCH] xfs_mkfs: wipe old signatures from the device

> > So I
> > think that it got to the point where users will usually use mkfs.xfs
> > -f all the time. And even if they did not and they would use a wrong
> > device they would probably get the same warning even for the device
> > they wanted to use in the first place.
>=20
> I get a couple of queries a year from people saying they
> accidentally ran mkfs.ext4 on the wrong device and want to know if
> they can recover their XFS filesystem. The next question is usually
> "why didn't mkfs.ext4 warn me there was an existing filesystem on
> the device like mkfs.xfs does?".
>=20
> That is why the "don't overwrite an existing filesystem by default"
> behaviour is important. Users like to be protected from mistakes
> they weren't aware they made, and far too few of our filesystem
> utilities provide that safety net.
>=20
> A couple of users a year losing data like this is a couple of users
> too many. Especially when it would only take a couple of hours of
> your time to implement....
>=20
> > So even thoug it might help in some cases I do not think that we
> > should go and change all file systems to do that as well, it would
> > not be very useful anyway.
>=20
> Tell that to the next user that trashes their data because a
> filesystem tool simply assumed in correctly that it owned the block
> device.

   We had someone on IRC a day or two ago who had done exactly this.
They're not the only one -- I can recall seeing at least one other
person who managed to mkfs.btrfs on an existing filesystem.

   Hugo.

--=20
=3D=3D=3D Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk=
 =3D=3D=3D
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I --- =20
                       know a hawk from a handsaw.                      =20

--IU5/I01NYhRvwH70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBURz6ur9z9OVl50rAAQJB1A//fVP9a7JLmieKnwTPau+dKkvyOx2uS8wC
uVpd3OQ8HL7axQcqH30SVgmCnTt1hGFfzuHRXlwZQYdi5CWKI1umlnQZRskS5+Du
ye/yeJImpaK+aBw2ElsSSTw9q8gk7FHL1deDTJXb69sA9GecsaV0UM88Z+WdjI+D
wzdDke3QOH6VYq0jYuw3IJcPeTpvBOWTB5LLaxhJzEwkcPG+BKcjH+PqvbsGC6A2
GeR5mqPQAvl0ZK4C762LD5C1a5aycUPbX72C457Ok4YBQKA+pHr83tXmU4BVFJ3y
FqHfcRw9BkdWDmY0w/8wOpuN5Ao9HlkrhFfMLDWnk65qSVaG/dh8T0n9jwLc53wJ
j1Jd0QdaLuB3knSAridaNdKoG3+28RwxOypGWxQRvGhJYMv4f1f0ppPKeyX68f2C
gdaGYCSK/lVA51yYNTP9kfDloXGzOcSjMRRfCSGeOWz9KZqyeUC5Drz9Vy+Fk3Yf
kSGRlWrQCuxH57BZSshbTLMWhnvt3yK4V25Uw68izfTC+SnLxMZPnpq0IDY7opXm
JO2xuekYVbBl+y/Ai6ExGR57x8sSXV64fM4eeQ2ljSXW8iI2j60UDiHD51AC4f0X
HZuizFQ6IIOv3GvSzKolOQBD58DqaHBUKikE3RYgsoxf/7kiJM6Cq3T7838ZXUzr
k/cxaehRR4U=
=7fgO
-----END PGP SIGNATURE-----

--IU5/I01NYhRvwH70--


--===============9103897896664826237==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9103897896664826237==--
