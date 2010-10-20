Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9K8BUwY043015 for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 03:11:30 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 16AD21E7E207
	for <xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:12:41 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id aFVTcW4w4prGyzfD for
	<xfs@oss.sgi.com>; Wed, 20 Oct 2010 01:12:41 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Interesting possible XFS crash condition
Date: Wed, 20 Oct 2010 10:12:30 +0200
References: <4CBE887F.6020506@dolphinlogic.com>
In-Reply-To: <4CBE887F.6020506@dolphinlogic.com>
MIME-Version: 1.0
Message-Id: <201010201012.39778@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3762860691997427982=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Shawn Usry <shawn@dolphinlogic.com>

--===============3762860691997427982==
Content-Type: multipart/signed;
  boundary="nextPart1449362.HLG6LIrvcE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1449362.HLG6LIrvcE
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 20. Oktober 2010 Shawn Usry wrote:
> Limited information shown in what I've been able to capture in the=20
> kernel crash.  Nothing really specific or repeatable (different
> message  each time) - some instances to the term "atomic" and "xfs"
> - other times "irq" related

I'm not a dev, but I'd say a kernel crash dump would be very helpful.=20
Can't you at least take pictures of the messages?

I've never read about such XFS errors, maybe you should=20
1) xfs_metadump
2) xfs_mdrestore (into a file)
3) mount that file
and try to access files there. If this also crashes, it will really be=20
XFS related.

Also, can you try putting the hard disks onto another system, possibly=20
with changing the RAID controller? It might be a hardware error.

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

--nextPart1449362.HLG6LIrvcE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky+pHcACgkQzhSR9xwSCbTkjACgy6IKgUj021ICUI/grNC68xbk
XfsAoPHOz080a7P/2/t9MSdzSD37qGlG
=zPph
-----END PGP SIGNATURE-----

--nextPart1449362.HLG6LIrvcE--


--===============3762860691997427982==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3762860691997427982==--
