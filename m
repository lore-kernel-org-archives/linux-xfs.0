Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6L8BsiI149319 for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 03:11:55 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC1EDAB051B
	for <xfs@oss.sgi.com>; Tue, 21 Jul 2009 01:20:39 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id K5YpRZtNVZRwFDNu for
	<xfs@oss.sgi.com>; Tue, 21 Jul 2009 01:20:39 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Write barriers and hardware RAID
Date: Tue, 21 Jul 2009 10:12:26 +0200
References: <mailman.323.1248105112.225101.xfs@oss.sgi.com>
	<alpine.LRH.1.10.0907210918150.14559@pcuf.fi>
In-Reply-To: <alpine.LRH.1.10.0907210918150.14559@pcuf.fi>
MIME-Version: 1.0
Message-Id: <200907211012.31257@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3516882708778937735=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: J =?utf-8?q?P=C3=A4lve?= <xtc@pcuf.fi>, xfs@oss.sgi.com

--===============3516882708778937735==
Content-Type: multipart/signed;
  boundary="nextPart1759792.ujOdXkpOIO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1759792.ujOdXkpOIO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Please keep the discussion on the list also for others who search the=20
same info later.

On Dienstag 21 Juli 2009 J P=E4lve wrote:
> Thank you for your clarification. I'm still wondering about this
> mention in the FAQ:
>
> "With a RAID controller with battery backed controller cache and
> cache in write back mode, you should turn off barriers - they are
> unnecessary in this case, and if the controller honors the cache
> flushes, it will be harmful to performance."
>
> If you issue a cache flush request to one of these controllers that
> honor them, will it only flush its own cache or also issue a cache
> flush request to the disks? In the latter case, wouldn't write
> barriers work correctly even with both controller and disk cache
> enabled?

If you use a RAID controller but then it allows cache flushes from the=20
host to really flush it's cache, it's basically the same as setting the=20
whole controller to "write through" mode (where he doesn't buffer=20
anything). Your expensive RAID controller then acts like a dump switch=20
and your only advantage is that you can connect several disks with=20
parity. But your performance will be a mess. I can't believe anybody=20
wanting performance will do that.
( We have some "up to 4 people" companies with HP servers where the 3-
disk RAID-5 is setup this way. As long as they only store word documents=20
and such it's enough. We setup the whole controller write through then,=20
battery backup is of course not needed. But disk write cache is always=20
set to off, to prevent data loss on power fail.)

Back to your question: If there exists a hardware RAID controller=20
honoring flushes, it should also flush the disks (I'd expect that). But=20
I don't know any controller to really do that. If you do, please tell=20
me.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1759792.ujOdXkpOIO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkpleG8ACgkQzhSR9xwSCbRnegCfaLRFRyWT45dMRcD2G/HuR1uD
ZF8An0l/UTriGiHci9hlGCadHaZkfKuE
=SYXQ
-----END PGP SIGNATURE-----

--nextPart1759792.ujOdXkpOIO--


--===============3516882708778937735==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3516882708778937735==--
