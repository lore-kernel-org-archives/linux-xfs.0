Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7BMV1rv165700 for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 17:31:02 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 266F5C9D9CA
	for <xfs@oss.sgi.com>; Wed, 11 Aug 2010 15:40:07 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id DOFcOyckcjhVQXg5 for
	<xfs@oss.sgi.com>; Wed, 11 Aug 2010 15:40:07 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 63C03703
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 00:31:22 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 2B2FE401C2E
	for <xfs@oss.sgi.com>; Thu, 12 Aug 2010 00:31:22 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: observed significant performance improvement using "delaylog" in
	a real-world application
Date: Thu, 12 Aug 2010 00:31:21 +0200
References: <i3rt4t$46c$1@dough.gmane.org> <201008111428.31196@zmi.at>
	<i3ul1b$d3b$1@dough.gmane.org>
In-Reply-To: <i3ul1b$d3b$1@dough.gmane.org>
MIME-Version: 1.0
Message-Id: <201008120031.21682@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4153623471444682869=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4153623471444682869==
Content-Type: multipart/signed;
  boundary="nextPart2733270.f5vIWqtFvQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2733270.f5vIWqtFvQ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 11. August 2010 Peter Niemayer wrote:
> I think after the "ext2"-age no serious file system ever had
> a real problem dealing with lots of files in one directory -
> or do you have contradicting information?
=20
IIRC 2010 there was someone on this list reporting problems when a=20
certain amount of files were created in a dir. He had to do with=20
audio/video recording, where delays are important (not to have). At one=20
point file creating time increased a lot, but I don't remember if it was=20
a filesystem problem or something else. But as it was the only report I=20
saw, I'd say you are right and a big number of files per dir doesn't=20
matter anymore.

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

--nextPart2733270.f5vIWqtFvQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxjJLkACgkQzhSR9xwSCbSYSwCgitiYdnwFqzjN3l/I/fYrqoTv
p/EAoPZMdS/4+Xdko9AsCQU9c8Uwrjoq
=VXNZ
-----END PGP SIGNATURE-----

--nextPart2733270.f5vIWqtFvQ--


--===============4153623471444682869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4153623471444682869==--
