Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6NAuDBh196504 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 05:56:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63F4F46BA8A
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:59:13 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id gLpxQWioAMuRY2Ll for
	<xfs@oss.sgi.com>; Fri, 23 Jul 2010 03:59:13 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k sector drives
Date: Fri, 23 Jul 2010 12:59:07 +0200
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<201007230809.28111@zmi.at> <20100723095832.GA23174@infradead.org>
In-Reply-To: <20100723095832.GA23174@infradead.org>
MIME-Version: 1.0
Message-Id: <201007231259.11714@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8954844476942538501=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============8954844476942538501==
Content-Type: multipart/signed;
  boundary="nextPart1843060.9ylNIAyNWU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1843060.9ylNIAyNWU
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 23. Juli 2010 Christoph Hellwig wrote:
> -b size=3D4096 is the default anyway, for 4k sector drivers you also
>  want -s size=3D4096, which you do not want for 512 byte sector disks.

Thanks for clarification. Should I use "-s size=3D4096" despite the drive=20
saying 512b sectors? It's a "hidden" 4K sector drive, so maybe declaring=20
it extra for XFS helps performance? Or does it not matter at all?
=20
> What values do the files
>=20
>         /sys/block/<device>/queue/logical_block_size
>         /sys/block/<device>/queue/physical_block_size
>         /sys/block/<device>/alignment_offset
>=20
> say about your disk?

512, 512, 0 for a Western Digital D20EARS-00MVWB0 (2TB) which has 4K=20
sectors but obviously hides it.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1843060.9ylNIAyNWU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxJdf8ACgkQzhSR9xwSCbSMogCfbOYH1QeOqAh/v2qar1oalclD
x9sAn0dyzl6TjmSiy9UEDIu/tO1FAVAj
=K8YR
-----END PGP SIGNATURE-----

--nextPart1843060.9ylNIAyNWU--


--===============8954844476942538501==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8954844476942538501==--
