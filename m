Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6E737CA4
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 14:20:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2EEECAC004
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 12:20:23 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id fWhtONQXJyxlG0UB for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2016 12:20:21 -0700 (PDT)
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
	<626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
	<74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <df36996c-65c5-1cf7-5700-5676b6ee48e0@sandeen.net>
Date: Tue, 2 Aug 2016 14:20:13 -0500
MIME-Version: 1.0
In-Reply-To: <74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3949999399624062518=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============3949999399624062518==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="70jVWDRsHHbjA2XOqvmCwImDRNuA924Vu"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--70jVWDRsHHbjA2XOqvmCwImDRNuA924Vu
Content-Type: multipart/mixed; boundary="0AcBdpWt23SSM1A25G9jUKuVtaDv10304"
From: Eric Sandeen <sandeen@sandeen.net>
To: Jeff Mahoney <jeffm@suse.com>, xfs@oss.sgi.com
Message-ID: <df36996c-65c5-1cf7-5700-5676b6ee48e0@sandeen.net>
Subject: Re: Old bugs in xfsprogs?
References: <7e185931-8830-5f31-7abb-5419bb255991@suse.com>
 <626eedea-2b9a-4ca3-cd3d-1e528f45526f@sandeen.net>
 <74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>
In-Reply-To: <74fde7f6-54a2-078f-6064-d9e32564f9a7@suse.com>

--0AcBdpWt23SSM1A25G9jUKuVtaDv10304
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/2/16 1:51 PM, Jeff Mahoney wrote:
> On 8/2/16 11:00 AM, Eric Sandeen wrote:

=2E..

>> I could imagine that maybe for each candidate super we find, we should=

>> look at its geometry, and spot-check the other locations that it indic=
ates
>> should contain a superblock.  If we get enough semi-valid but conflict=
ing
>> "sets," maybe we should bail out and ask.  It's quite a corner case, t=
ho.
>=20
> I'm not sure a geometry check would've helped here.  The superblock
> geometry still would've covered the whole, unpartitioned device.  Since=

> we're already linking with blkid, maybe a check to see if there's a
> partition table on the device and bail if it sees one, unless forced?
> The part that I'm still trying to explain is how it managed to get a
> good magic from the log and then got the wrong uuid.

Hm, yeah, maybe right off the bat, if the primary super looks bad do
a blkid check, and a (sigh) "are you sure?" just like we do for mkfs.

>> Any chance you have full xfs_repair output?
>=20
> Sure, below.  I heard back from the reporter and confirmed that my
> hypothesis of mkfs -> fdisk -> mkfs was what happened.  He's on SLE12
> SP1, so that means xfsprogs 3.2.1.
>=20
> -Jeff
>=20
> ---
>=20
> labadmin:/ssd # xfs_repair postgre.raw -L
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> sb root inode value 18446744073709551615 (NULLFSINO) inconsistent with
> calculated value 128
> resetting superblock root inode pointer to 128
> sb realtime bitmap inode 18446744073709551615 (NULLFSINO) inconsistent
> with calculated value 129
> resetting superblock realtime bitmap ino pointer to 129
> sb realtime summary inode 18446744073709551615 (NULLFSINO) inconsistent=

> with calculated value 130
> resetting superblock realtime summary ino pointer to 130

huh.  Ok, so I guess the primary in block zero was mostly-ok, and all
of the backup supers were still more or less intact, and it didn't have
to go searching...

-Eric


--0AcBdpWt23SSM1A25G9jUKuVtaDv10304--

--70jVWDRsHHbjA2XOqvmCwImDRNuA924Vu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJXoPJ0AAoJECCuFpLhPd7gMMwP/0j3lITM12XKrfXHdOAzGiIz
HjvNAwjvTtC1kx5mq8SnWFk/FPrhP8pDBzkF14aC3lyu4GB+Pp3SX+d7uGxpzQTK
jdplNO2sB8iaNdPolvgMSXQ5UdU3cs6hnxIwlXqRnA6N6/3gyF3ZL2qihYG4NyK7
cNMfcBQYLu21CDtNMExAxlBLIpiND0ckyBOimfdYiiHaLetqzIGYDGBof/KVTC+r
sEPSrLVXUMEU0XjIbJnfdIgB9wHmnNOqodjaJ6HYAT1FfLcwnngzYWRjW8JSE8wF
lN6tdLUBVkq+r+WJUegdK6ZAFVBuAPJF6c4Dj4Kl4qwce/ftcz1K5DFDLcm12Prm
bMKqrE6MDLOx3+12y0EI/hGkvKNtZjU5xmNL4eagz6WtjrzFYSggztDPJBTRMx9B
7nFofQGryW3aZ9fc9nQ79VGmP5zmue/DSeNk6ugFRSQhkhc/gdQuw1egubU309Fb
c/QlNa8puWLRbB2MYH8WuwNJuVebbzuaF7Ug2vRYiwK/JwI90gON39mjI2rux6Lb
trmayDjgjgh3sF9lSjLIgLQ/aUSSoQ+Sv2B/ksCjxOA7Zkd/pv1b/oOYBwth974u
QoOJ/13huyQGayfEjITBmyrwdEndDHxQotH/yG/QwnmqeOqL7BJi5zQojykUJdaU
0ipfbFCZhskeoBddy4/C
=QDdA
-----END PGP SIGNATURE-----

--70jVWDRsHHbjA2XOqvmCwImDRNuA924Vu--


--===============3949999399624062518==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3949999399624062518==--
