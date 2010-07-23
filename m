Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6N66X4S185494 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 01:06:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A072C18E81
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 23:16:27 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id P1l6cJnLjArNj3ia for
	<xfs@oss.sgi.com>; Thu, 22 Jul 2010 23:16:27 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3783470B
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:09:29 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 7DE1383C803
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 08:08:38 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k sector drives
Date: Fri, 23 Jul 2010 08:09:27 +0200
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
In-Reply-To: <201007211333.48363.eye.of.the.8eholder@gmail.com>
MIME-Version: 1.0
Message-Id: <201007230809.28111@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0541825803154161955=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0541825803154161955==
Content-Type: multipart/signed;
  boundary="nextPart1840397.kTGzNSS1lg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1840397.kTGzNSS1lg
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 21. Juli 2010 Khelben Blackstaff wrote:
> Nevertheless, you don't have to get them to report 4k to linux. As
>  long as you align the partitions its fine. As i said in the other
>  post, newer fdisk doesn't use "DOS compatibility mode" and uses
>  sectors by default (instead of stupid CHS) with a 1MB alignment, so
>  every partition will be properly aligned. If you don't dual boot
>  Windows, you can also use GPT partitioning scheme. Also, from what i
>  have seen, xfsprogs are quite clever and find most stuff on their
>  own. I usually mkfs with "-s size=3D4096" just to be sure.

I always do -b size=3D4096 anyway, so I'm fine here. And I created the=20
partitions starting sector 512, so that should be good also.

> Slightly offtopic, there is another "problem" with these drives. They
>  park the heads every 8 seconds, so they might wear prematurely. You
>  can change the 8sec timer or disable it with the wdidle3 utility
>  from this url
> http://support.wdc.com/product/download.asp?groupid=3D609&amp;sid=3D113&a
> mp;lang=3Den
>=20
> If you want to know more about the problem, there are many forums
>  where you can read about wdidle3 and i also posted about it on my
>  blog.
>  http://lordkhelben.wordpress.com/2010/05/15/wd-caviar-green-hard-dis
> ks-idle-settings/
=20
Thanks, I did this, and it even worked for my other WDC=20
WD2002FYPS-01U1B0, which was on 12 seconds (the EARS were on 8s as you=20
said), and now all three drives have a 120s delay before parking. That=20
should be sufficient. It didn't work for the VelociRaptor in my PC, just=20
to mention.

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

--nextPart1840397.kTGzNSS1lg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxJMhgACgkQzhSR9xwSCbRZfQCfbaP3XU6dugT9imC1UZ5Nv0bj
Kn4AoKsBl0xIcLgG/NPiH4RA82sF+MOL
=lum4
-----END PGP SIGNATURE-----

--nextPart1840397.kTGzNSS1lg--


--===============0541825803154161955==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0541825803154161955==--
