Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p78Bwnfs033166 for <xfs@oss.sgi.com>; Mon, 8 Aug 2011 06:58:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26172536042
	for <xfs@oss.sgi.com>; Mon,  8 Aug 2011 04:58:46 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 7kKxOUiWcf7O7rOH for
	<xfs@oss.sgi.com>; Mon, 08 Aug 2011 04:58:46 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: "Corrupt dinode 6242615, (btree extents).  This is a bug."
Date: Mon, 8 Aug 2011 13:58:38 +0200
References: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
In-Reply-To: <alpine.OSX.1.00.1108081203550.26464@pegasus.binf.ku.dk>
MIME-Version: 1.0
Message-Id: <201108081358.43727@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6832527651301567733=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Hanne Munkholm <hanne@binf.ku.dk>

--===============6832527651301567733==
Content-Type: multipart/signed;
  boundary="nextPart3080799.1J2zpOdLuz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3080799.1J2zpOdLuz
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Montag, 8. August 2011 Hanne Munkholm wrote:
> a) Does it look like clearing the log with -L would be a good
> idea? To me it looks like a lot of errors that are not log
> errors is found?

Yes, mount -L/umount once to replay the log, when you are sure the block=20
device works correctly again.
=20
> b) What's with the segfault? What happens when the "real" repair
> with no -n gets to the segfault? Is it dangerous to try it if it
> segfaults somewhere halfway? (More dangerous than it would
> normally be).
>=20
> It is a 6TB file system and I am running a terribly old Xen
> kernel: 2.6.26-2-xen-amd64 #1 SMP Mon Jun 13 18:44:16 UTC 2011
> x86_64 GNU/Linux

Try to get the newest xfsprogs, maybe that's a bug in xfs_repair itself=20
that has been fixed. If that doesn't help, a newer kernel might solve=20
your problem.

Generally I've been able to fix all problems, and if not, xfsprogs has=20
received an update to fix a bug. But it's been a long time since the=20
latest bug, so an actual xfs_repair might help you.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3080799.1J2zpOdLuz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4/z3MACgkQzhSR9xwSCbSz7ACg7Vm6msT3XnxiE3u1cBJiYITQ
dsoAnjSoIf2mA09NS5vmf29Wk2emd8AW
=Ph9L
-----END PGP SIGNATURE-----

--nextPart3080799.1J2zpOdLuz--


--===============6832527651301567733==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6832527651301567733==--
