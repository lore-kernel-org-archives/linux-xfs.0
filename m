Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p567TDZj212734 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 02:29:13 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A12D16A3DF6
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 00:29:10 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id a6nmBnQSK8vvJfqB for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2011 00:29:10 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: I/O hang, possibly XFS, possibly general
Date: Mon, 6 Jun 2011 09:29:01 +0200
References: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
	<BANLkTim978GhfamN=TEFULP5GdfMu02-7w@mail.gmail.com>
	<19945.24042.711472.158523@tree.ty.sabi.co.UK>
In-Reply-To: <19945.24042.711472.158523@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201106060929.06814@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5015902640068812367=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5015902640068812367==
Content-Type: multipart/signed;
  boundary="nextPart3157995.l45fAgWuT4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3157995.l45fAgWuT4
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 4. Juni 2011 Peter Grandi wrote:
>   vm/dirty_ratio=3D2
>   vm/dirty_bytes=3D400000000
>=20
>   vm/dirty_background_ratio=3D60
>   vm/dirty_background_bytes=3D0
>=20
>   vm/dirty_expire_centisecs=3D200
>   vm/dirty_writeback_centisecs=3D400

Why dirty_background_ratio=3D60? This would mean you start to write dirty=20
pages only after it reaches 60% of total system memory... Setting it to=20
=3D1 would be the thing you want I guess.
Also, setting both dirty_background_(ratio|bytes) is not supported. The=20
latter wins, according to sysctl/vm.txt

Similarly, dirty_ratio and dirty_bytes belong together and exclude each=20
other. Maybe you specified both to fit older and newer kernels in one=20
example?

dirty_expire_centisecs to 200 means a sync every 2s, which might be good=20
in this specific setup mentioned here, but not for a generic server.=20
That would defeat XFS's in-memory grouping of blocks before writeout,=20
and in case of many parallel (slow|ftp) uploads could lead to much more=20
data fragmentation, or no?


=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3157995.l45fAgWuT4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3sgcIACgkQzhSR9xwSCbSFlgCdE7uBglNfxsBIxydx51KrPz7/
0+8AoLF1FS4tQ+Syo6fVB78x6DVmS1TF
=EbKb
-----END PGP SIGNATURE-----

--nextPart3157995.l45fAgWuT4--


--===============5015902640068812367==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5015902640068812367==--
