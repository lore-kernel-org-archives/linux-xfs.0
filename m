Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9ML1Qre218173 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 16:01:26 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DE6F11DA53
	for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 14:02:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id zpQoUT8eT2d1JZsZ for
	<xfs@oss.sgi.com>; Fri, 22 Oct 2010 14:02:41 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: cannot defrag volume, fragmentation factor 21.73%
Date: Fri, 22 Oct 2010 23:02:38 +0200
References: <4CBC3910.70806@cape-horn-eng.com> <20101018231009.GL29677@dastard>
	<4CC1638B.4070807@cape-horn-eng.com>
In-Reply-To: <4CC1638B.4070807@cape-horn-eng.com>
MIME-Version: 1.0
Message-Id: <201010222302.39061@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3065479620385130285=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>

--===============3065479620385130285==
Content-Type: multipart/signed;
  boundary="nextPart3969359.xkFzNuiKzc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3969359.xkFzNuiKzc
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 22. Oktober 2010 Richard Ems wrote:
> But, at which numbers should I look at before starting a defrag then?

Watch the performance of your application. Record answer times with=20
munin or something, and if you ever "feel" it's too slow, look at the=20
recorded numbers again to see if your feelings fit the measurements.=20
Don't be paranoid about fragmentation. The more people access a server=20
at a time, the less important fragmentation is.=20

If you got 100 people streaming 100 perfect defragmented files, you=20
still got an access pattern that needs to move the disk head to 100=20
different positions all the time. If your single disk can't do that many=20
I/O's, build up a RAID, or get faster disks (10kprm, 15krpm, SSD).

Defrag is more for single threaded I/O workloads, where one stream at a=20
time has to be read/written. Therefore it helps on a Windows PC more=20
than on a server. Only use defrag if you really have lots of chunks per=20
file.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3969359.xkFzNuiKzc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzB++8ACgkQzhSR9xwSCbTMCgCgnTmI5N3GT7zTldXJz6SFhR86
1rIAoO+1ExBmSRy8dIRyKpPa9S9fd9NQ
=VzJT
-----END PGP SIGNATURE-----

--nextPart3969359.xkFzNuiKzc--


--===============3065479620385130285==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3065479620385130285==--
