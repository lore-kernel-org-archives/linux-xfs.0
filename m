Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q5o2mX101801 for <xfs@oss.sgi.com>; Mon, 26 Jul 2010 00:50:03 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7867E102D22
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 23:00:14 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id dxB00zPq8ufubzVY for
	<xfs@oss.sgi.com>; Sun, 25 Jul 2010 23:00:14 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: permanent kernel upgrading (was: bug and fun with XFS: unable to
	handle kernel NULL pointer dereference)
Date: Mon, 26 Jul 2010 07:52:54 +0200
References: <201007260019.51568@zmi.at> <20100726001859.GD655@dastard>
In-Reply-To: <20100726001859.GD655@dastard>
MIME-Version: 1.0
Message-Id: <201007260752.59573@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5130142153794461137=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>

--===============5130142153794461137==
Content-Type: multipart/signed;
  boundary="nextPart2557216.lLY253211c";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2557216.lLY253211c
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 26. Juli 2010 Dave Chinner wrote:
> > # mount /disks/work/
> > # umount /disks/work/
> > umount: /disks/work: device is busy.
> >         (In some cases useful info about processes that use
> >          the device is found by lsof(8) or fuser(1))
>=20
> Some other process has taken a reference to the fs, I'd say.
> And if that process triggered an oops, then you'd see this.

This is definitely improbable ;-). I stopped all processes, except sshd=20
and mingetty (for the console processes), and "lsof" reported no open=20
files. I'd swear it must be a bug, but as you said 2.6.27 (openSUSE=20
11.1) is just too old to take care.
=20
> Corrupt attribute fork - matches with the oops signatures.  I'd
> definitely consider upgrading your kernel as a first step...
=20
That's why I wrote "which I planned to migrate". I was just in the=20
process of doing so.

This brings me to another question: openSUSE 11.1 is, despite being old,=20
still maintained, so I was under the impression that I'd get updates for=20
problems. But I already received "upgrade your kernel" the last time for=20
my openSUSE 11.2 with it's kernel vmlinuz-2.6.31.12, which by the time=20
was the latest release (in the meantime openSUSE 11.3 got released).
So is this just a generic recommendation of developers who love the=20
bleeding-edge stuff and know how many problems they fixed since 2.6.27=20
("yak, that old stuff, how could it ever run?"), or is it known that not=20
enough fixes go into "maintained" kernels by distributions?

I have tons of servers to maintain, and can't compile kernels on my own=20
anymore (I did this when I was younger), so I used openSUSE and I am in=20
the process of replacing servers to SLES, which should receive much=20
better services but still kernel upgrading is not supported on such=20
platforms. So what is the best practice that one should choose when=20
running "long time services" where you can't upgrade all the time?

Just curious. :-)

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

--nextPart2557216.lLY253211c
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxNIrsACgkQzhSR9xwSCbQXagCdGHy1cYpR3vqVZ0eX1zOn/2I+
BlwAoNLxbAdWf07HK9xo3IAVqkGCipnb
=HKy5
-----END PGP SIGNATURE-----

--nextPart2557216.lLY253211c--


--===============5130142153794461137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5130142153794461137==--
