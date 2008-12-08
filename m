Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB88f6YW016432 for <xfs@oss.sgi.com>; Mon, 8 Dec 2008 02:41:06 -0600
Received: from rproxy.teamix.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80888F08
	for <xfs@oss.sgi.com>; Mon,  8 Dec 2008 00:41:03 -0800 (PST)
Received: from rproxy.teamix.net (postman.teamix.net [194.150.191.120]) by
	cuda.sgi.com with ESMTP id M70R50XKvsiKj3sc for
	<xfs@oss.sgi.com>; Mon, 08 Dec 2008 00:41:03 -0800 (PST)
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: [TuxOnIce-devel] hangs with MTRR_SANITIZER? - solved
Date: Mon, 8 Dec 2008 09:40:28 +0100
References: <200811252244.14718.Martin@Lichtvoll.de>
	<200811290824.38750.Martin@lichtvoll.de>
	<200811300002.45669.Martin@lichtvoll.de>
	(sfid-20081130_000254_807842_E480F4DF)
In-Reply-To: <200811300002.45669.Martin@lichtvoll.de>
MIME-Version: 1.0
Message-Id: <200812080940.29371.ms@teamix.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5124756331574062810=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: tuxonice-devel@lists.tuxonice.net
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

--===============5124756331574062810==
Content-Type: multipart/signed;
  boundary="nextPart1299583.gNlHiHnN2i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1299583.gNlHiHnN2i
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag, 30. November 2008 schrieb Martin Steigerwald:
> Am Samstag 29 November 2008 schrieb Martin Steigerwald:
> > Hi!
> >
> > CC'd to linux-kernel mailinglist, as that might be something that goes
> > beyond any possible TuxOnIce or XFS issues. I know I am using TuxOnIce
> > which is not part of the mainline kernel. And I am even using an
> > inofficial patch - which I will use again unchanged for the non
> > MTRR_SANITIZER kernel, in order to know whether its the MTRR_SANITIZER
> > thing. And anyway before knowing whether it might be MTRR_SANITIZER
> > related I need to run the non MTRR_SANITIZER kernel for at least a week
> > and have quite some hibernate cycles. If someone else had issues with
> > MTRR_SANITIZER I would like to hear about it. Also if someone thinks I
> > am completely off track on trying to track this down I appreciate a
> > hint.
>
> Ok, its not MTRR_SANITIZER. It hung again on hibernate, again before any
> serious hibernating work has started. I will add debug output to my
> pre-hibernate script as it might hang already in there, maybe while
> disabling the network. I want to know whether it hangs before calling the
> hibernate script or after it. I think I will go for the latest official
> hibernate patch instead of using the inofficial one, although I am not
> convinced that it makes much of a difference. Lets see.
>
> The syncs I added to my pre-hibernate seemed to help. KDE configuration is
> intact. As a safeguard I rsync ~/.kde to a backup directory before
> hibernating anyway.

Okay... thats solved now.

Conclusions:

1) There was no XFS problem as the sync I added at the beginning of my pre=
=20
hibernate script did avoid the truncated files the one time I still had the=
=20
hang. Thus those appear to have been IO in flight.

2) Its not MTRR_SANITIZER as explained above nor any other mainline problem.

3) Instead problems gone, when I replaced the inofficial TuxOnIce rc7a for=
=20
2.6.26 to 2.6.27 forward port patch I used[1] with the official but still n=
ot=20
officially released current tuxonice for 2.6.27 patch[2].

So sorry for the noise. I just learned to prefer official upstream patches.=
=20
Whether they'd be officially released or not. Can ask whether they appear t=
o=20
be stable before trying one. ;)

[1]=20
http://lists.tuxonice.net/pipermail/tuxonice-devel/2008-November/000357.html

[2] http://www.tuxonice.net/downloads/all/current-tuxonice-2.6.27.patch.bz2

Ciao,
--=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1299583.gNlHiHnN2i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk83X0ACgkQHhDFkwOZrpDbHQCfYabC/cJcXse+xfB8z4nRz8KK
TRoAnAkyr7feChoLQ0cCLGibN2Bpaudn
=Z1Po
-----END PGP SIGNATURE-----

--nextPart1299583.gNlHiHnN2i--


--===============5124756331574062810==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5124756331574062810==--
