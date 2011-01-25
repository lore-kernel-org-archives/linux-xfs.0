Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P6Iwk9201315 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 00:18:58 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B4698AA2F5
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 22:21:18 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 31RFdW9nQDNOGvBv for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 22:21:18 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: extremely slow write performance plaintext
Date: Tue, 25 Jan 2011 07:21:09 +0100
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>
	<4D30C7F3.3040105@hardwarefreak.com>
	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
In-Reply-To: <1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
MIME-Version: 1.0
Message-Id: <201101250721.14716@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5875782278610784779=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Cory Coager <ccoager@davisvision.com>, Stan Hoeppner <stan@hardwarefreak.com>

--===============5875782278610784779==
Content-Type: multipart/signed;
  boundary="nextPart2800498.z8KdFmrLEf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2800498.z8KdFmrLEf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 18. Januar 2011 Cory Coager wrote:
> Also, I want to stress that I am only having performance issues with
> one logical volume, the others seem fine.

You're getting 40MB/s write speed and says that's fine? I get more=20
performance from a single SATA desktop drive. Your setup seems to suck=20
extremely somewhere.

It already starts with your dd speed. I started it on a virtualized VM=20
on an old, overloaded server and get:

# dd if=3D/dev/zero of=3Dtest.dd bs=3D1k count=3D1M
1048576+0 Datens=E4tze ein
1048576+0 Datens=E4tze aus
1073741824 Bytes (1,1 GB) kopiert, 10,9992 s, 97,6 MB/s

This is a hardware RAID 6 with just 8x 10krpm WD SATA drives. Try to=20
look into general I/O problems. Maybe you can try to boot from an actual=20
linux CD with kernel >2.6.30 to see if that helps performance.

Maybe one or more disks in your array are dead and the controller is=20
crying for replacement?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2800498.z8KdFmrLEf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0+a9oACgkQzhSR9xwSCbSMLwCgq2/V3O81NfYnOnUhlmdd9E/P
a4AAoKp/QzcB/KbtDN1VgHx0QPAffdX2
=aX+8
-----END PGP SIGNATURE-----

--nextPart2800498.z8KdFmrLEf--


--===============5875782278610784779==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5875782278610784779==--
