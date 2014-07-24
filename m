Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 505BC7F53
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 17:34:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AF1230406B
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:34:42 -0700 (PDT)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id SztllSjl9cMtoAsj
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:34:40 -0700 (PDT)
Received: by mail-pa0-f49.google.com with SMTP id hz1so4763214pad.22
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2014 15:34:40 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20140724192245.GG1553@suse.cz>
Date: Thu, 24 Jul 2014 16:34:35 -0600
Message-Id: <5B4825C3-F47E-48B7-8DA4-6D79F53B73B1@dilger.ca>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
	<20131212232443.GL31386@dastard>
	<9520AB36-B728-423A-8EA1-FDD22B79AE90@dilger.ca>
	<B58DEEA8-561A-4173-B9F5-528B73E06C6D@dilger.ca>
	<20140724192245.GG1553@suse.cz>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5971906306549464896=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: dsterba@suse.cz
Cc: linux-nilfs@vger.kernel.org, xfs@oss.sgi.com, Btrfs Developer List <linux-btrfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com


--===============5971906306549464896==
Content-Type: multipart/signed; boundary="Apple-Mail=_EE49BFE3-FECB-40D9-B2D2-AD63AA8C9172"; protocol="application/pgp-signature"; micalg=pgp-sha1


--Apple-Mail=_EE49BFE3-FECB-40D9-B2D2-AD63AA8C9172
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jul 24, 2014, at 1:22 PM, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jul 17, 2014 at 12:07:57AM -0600, Andreas Dilger wrote:
>> any progress on this patch series?
>=20
> I'm sorry I got distracted at the end of year and did not finish the
> series.
>=20
>> I never saw an updated version of this patch series after the last =
round of
>> reviews, but it would be great to move it forward.  I have filefrag =
patches
>> in my e2fsprogs tree waiting for an updated version of your patch.
>>=20
>> I recall the main changes were:
>> - add FIEMAP_EXTENT_PHYS_LENGTH flag to indicate if fe_phys_length =
was valid
>=20
> fe_phys_length will be always valid, so other the flags are set only =
if it's
> not equal to the logical length.
>=20
>> - rename fe_length to fe_logi_length and #define fe_length =
fe_logi_length
>> - always fill in fe_phys_length (=3D fe_logi_length for uncompressed =
files)
>>  and set FIEMAP_EXTENT_PHYS_LENGTH whether the extent is compressed =
or not
>=20
> This is my understanding and contradicts the first point.

I think Dave Chinner's former point was that having fe_phys_length =
validity
depend on FIEMAP_EXTENT_DATA_COMPRESSED is a non-intuitive interface.  =
It is
not true that fe_phys_length would always be valid, since that is not =
the
case for older kernels that currently always set this field to 0, so =
they
need some flag to indicate if fe_phys_length is valid.  Alternately,
userspace could do:

	if (ext->fe_phys_length =3D=3D 0)
		ext->fe_phys_length =3D ext->fe_logi_length;

but that pre-supposes that fe_phys_length =3D=3D 0 is never a valid =
value when
fe_logi_length is non-zero, and this might introduce errors in some =
cases.
I could imagine that some compression methods might not allocate any =
space
at all if it was all zeroes, and just store a bit in the blockpointer or
extent, so having a separate FIEMAP_EXTENT_PHYS_LENGTH is probably safer
in the long run.  That opens up the question of whether a written zero
filled space that gets compressed away is different from a hole, but I'd
prefer to just return whatever the file mapping is than interpret it.

Cheers, Andreas

>> - add WARN_ONCE() in fiemap_fill_next_extent() as described below
>>=20
>> I don't know if there was any clear statement about whether there =
should be
>> separate FIEMAP_EXTENT_PHYS_LENGTH and FIEMAP_EXTENT_DATA_COMPRESSED =
flags,
>> or if the latter should be implicit?  Probably makes sense to have =
separate
>> flags.  It should be fine to use:
>>=20
>> #define FIEMAP_EXTENT_PHYS_LENGTH	0x00000010
>>=20
>> since this flag was never used.
>=20
> I've kept only FIEMAP_EXTENT_DATA_COMPRESSED, I don't see a need for
> FIEMAP_EXTENT_PHYS_LENGTH and this would be yet another flag because =
the
> FIEMAP_EXTENT_DATA_ENCODED is also implied.
>=20
> I'll send V4, we can discuss the PHYS_LENGTH flag then.


Cheers, Andreas






--Apple-Mail=_EE49BFE3-FECB-40D9-B2D2-AD63AA8C9172
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9GJ+3Kl2rkXzB/gAQL14w/9E/WENH/RddgvYvMI0mPiMkdxzFK++PEH
dsaix22ddMjmnP7cRHt/Ty5ZfcnydZqFG/FNta9ZOcfTDaUOXGw3C7U7X93MAorx
s+q6ISAO81cYTLKvxFJDXzYzo/QxB219+oByPSdutEOYvANM1x/2vY5QYPVwjg4g
dxTAmoChCCbGEn96VZOG0M93kugQn7n4EzMjjK/5niUOiQiT4GCsTCFGyXuieXf+
PifblnRrNgQVRCzOimY+lXbXgL0+huGFw0okgx1/QCz176s60yFweEktWPuHdrZ1
8cDp97T5EwLXe9NYH+tyR6aw6yURzx8BSLMMscQWXs12lceuV0c5tBQ9l8RKtlEo
cLJJwPXHt7BS/CWsLpjyEz3zNTkvX88rmV0kPZIdVeseI3yP7GLLTdJ5TWXeR3Jb
BS9RQlXXU+1dZET3Lab22uEkUted8qH0sKyACbcwGRitJNx6aDpu5ByV4MyCjKPm
HnJAmTbADVpJRVTaPmgQbs4MrEgZm9PxAG/JWm7Qi+KythnZVFG1DVocvmE9ZWSK
FCkyBKEwDR/7KiFy3EBm1v0nwVetoHVOykTLBu6jCW8BU70o5BwAp5gVfGYEj2x8
9lx6QZWKDSRH2YyVjh2q7s0DrNosPpejxwT5ZxdKNOAUTcw+m4HO5LzD6WYbkU5W
nvpdaVUDRbc=
=Z7dA
-----END PGP SIGNATURE-----

--Apple-Mail=_EE49BFE3-FECB-40D9-B2D2-AD63AA8C9172--


--===============5971906306549464896==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5971906306549464896==--
