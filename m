Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 161007CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 07:17:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6CD6FAC003
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 05:17:37 -0700 (PDT)
Received: from relaycp04.dominioabsoluto.net (relaycp04.dominioabsoluto.net
	[217.116.26.100]) by cuda.sgi.com with ESMTP id
	bCxEuUBnGJejeviO for <xfs@oss.sgi.com>;
	Mon, 09 May 2016 05:17:34 -0700 (PDT)
Received: from smtp.movistar.es (smtp20.acens.net [86.109.99.144])
	by relaycp04.dominioabsoluto.net (Postfix) with ESMTP id 3EF18641F9
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 14:17:33 +0200 (CEST)
Received: from Telcontar.valinor (88.1.245.4) by smtp.movistar.es (8.6.122.03)
	(authenticated as robin.listas2)
	id 571F297700A36000 for xfs@oss.sgi.com; Mon, 9 May 2016 12:17:33 +0000
Received: from localhost (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id D133860D2A
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 14:17:32 +0200 (CEST)
Received: from Telcontar.valinor ([127.0.0.1])
	by localhost (Telcontar.valinor [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id DJmGSYck9d1i for <xfs@oss.sgi.com>;
	Mon,  9 May 2016 14:17:32 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by Telcontar.valinor (Postfix) with ESMTP id AE55060489
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 14:17:32 +0200 (CEST)
Subject: Re: Unable to mount a XFS filesystem
References: <690ueikfQ0112S06.1462789962@web06.cms.usa.net>
From: "Carlos E. R." <robin.listas@telefonica.net>
Message-ID: <57307FDC.4090608@telefonica.net>
Date: Mon, 9 May 2016 14:17:32 +0200
MIME-Version: 1.0
In-Reply-To: <690ueikfQ0112S06.1462789962@web06.cms.usa.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0837534302510073925=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mail list <xfs@oss.sgi.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============0837534302510073925==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="oA9QvRPIOTc1jEeJcBk7ON8DkuGg83TrU"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oA9QvRPIOTc1jEeJcBk7ON8DkuGg83TrU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2016-05-09 12:32, issa-gorissen@usa.net wrote:
> Received: 09:18 PM CEST, 05/08/2016
> From: "Carlos E. R." <>
>=20
>>
>> How did you do that upgrade? Zypper dup, or boot dvd, choose upgrade?
>>
> In fact it was not a "real" upgrade. I added a new boot disk on which I=

> installed Tumbleweed as a new OS. The MD RAID disks were kept in the co=
mputer.
> It seems the install did something to it I don't know about.

Ah, then it is a fresh install, inheriting data disks.

Then you probably keep the old boot disk. Perhaps you could try it and
find out if it still can mount the raid filesystem. If that is so,
perhaps data can be rescued. If you don't have a spare disk for a
backup, you might remove one side of the mirror and create it there,
then create again the raid in TW.

If you don't have the old boot disk, you can create a boot media on an
USB stick. You can use the 12.3 XFCE rescue image:

http://download.opensuse.org/distribution/13.2/iso/openSUSE-13.2-Rescue-C=
D-x86_64.iso

just cp it to the raw usb device, and boot it.


But leave that procedure as a last resource; wait for more comments or
ideas ;-)


>> Me, I would try to find out if the array is readable:
>>
>> dd if=3D/dev/md0 of=3D/dev/null
>>
>=20
> array is fine but somehow the md partitions have been shrunk with the
> superblock moved. Don't know know. Version of the superblock is 1.0; wh=
ich is
> stored at the end of the partition. So XFS filesystem starts at the sta=
rt of
> the partition. If after the new OS install I cannot mount XFS anymore, =
and as
> Dave said XFS mount will try to read end of filesystem; then the end of=
 the
> partition have changed.

Yes, I read his post. My idea was wrong, then.


--=20
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" at Telcontar)


--oA9QvRPIOTc1jEeJcBk7ON8DkuGg83TrU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlcwf9wACgkQtTMYHG2NR9VIJQCgh+gYkzfsf75G9nttiTF+dGDA
+fwAn3iUPf+2aqiMjSyWmjCXRpaoyKF5
=tHiU
-----END PGP SIGNATURE-----

--oA9QvRPIOTc1jEeJcBk7ON8DkuGg83TrU--


--===============0837534302510073925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0837534302510073925==--
