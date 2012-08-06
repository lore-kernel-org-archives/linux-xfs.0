Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q76AfnwS111978 for <xfs@oss.sgi.com>; Mon, 6 Aug 2012 05:41:49 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YLNIFVKu3Ev0Tg05 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Aug 2012 03:41:45 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS_WANT_CORRUPTED_GOTO error
Date: Mon, 06 Aug 2012 12:33:24 +0200
Message-ID: <1929929.ZGsW6LLNXR@saturn>
In-Reply-To: <CAP5prOivS=0PowpcEkmOWPRVo0V8HJQdDV+ZamM5bP5B_nZ5ew@mail.gmail.com>
References: <CAP5prOivS=0PowpcEkmOWPRVo0V8HJQdDV+ZamM5bP5B_nZ5ew@mail.gmail.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5357260626767499161=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Adam Huffman <adam.huffman@gmail.com>


--===============5357260626767499161==
Content-Type: multipart/signed; boundary="nextPart1946296.aonBfBRXqe"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart1946296.aonBfBRXqe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 6. August 2012, 10:50:43 schrieb Adam Huffman:
> Is there any way I can find out where this error is occurring i.e. on=

> which LVM logical volume?

By trying a manual mount on each fs this server has?

> Can it be fixed or is the filesystem irretrievably corrupted?

Try "xfs_repair -n" to see what it would fix. Try to get the newest=20
version of xfs_repair first.

If there was "only" a power outage chances are high you'll get it fixed=
,=20
but of course if your storage doesn't have BBWC or has disk write cache=
s=20
on or you mis-used the nobarrier option you might have lost a whole lot=
=20
of important in-flight data.
See http://xfs.org/index.php/XFS_FAQ

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart1946296.aonBfBRXqe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAfnXQACgkQzhSR9xwSCbTWuACffOfBJoYHOpPvNkJSvoG5zcg9
uXUAoIweyR+MYCH/2UpV7mnbKLlSpIfe
=JBu1
-----END PGP SIGNATURE-----

--nextPart1946296.aonBfBRXqe--


--===============5357260626767499161==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5357260626767499161==--
