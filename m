Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9F7DnDE110918 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 02:13:49 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4EDAE191A10F
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 00:14:57 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id cP1iwtJu9wNR7Nqk for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 00:14:57 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [RFC,
	PATCH 0/2] xfs: dynamic speculative preallocation for delalloc
Date: Fri, 15 Oct 2010 09:14:54 +0200
References: <C8DCC927.48D3%ivan.novick@emc.com>
In-Reply-To: <C8DCC927.48D3%ivan.novick@emc.com>
MIME-Version: 1.0
Message-Id: <201010150914.55604@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5406079036293102373=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Ivan.Novick@emc.com, aelder@sgi.com

--===============5406079036293102373==
Content-Type: multipart/signed;
  boundary="nextPart1510069.6G2cAd0Cij";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1510069.6G2cAd0Cij
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 14. Oktober 2010 Ivan.Novick@emc.com wrote:
> I have seen ~50% performance improvement in read rate when changing
> from small extents to large extents with XFS. Essentially going from
> not using allocsize to setting 1gb allocsize.  Also GB/s class
> filesystem.

In case of a database, I'd say 1GB allocsize seems fine. But when you're=20
at /var/log/, it could be a penalty, as when you have 50 open log files=20
which get permanently appended, you have 50GB preallocated which almost=20
surely won't be needed before the log is rotated anyway.

The question is: what is a good value for preallocation?

I'd guess for a database 1GB seems reasonable, for /var/log one full=20
stripe (nr-data-disks * stripe size), for webserver/ftp data too, as=20
well as a fileserver (storing office documents) and mailserver (storing=20
each mail as a separate file or into one flat file).
Or, when you have an app that writes files of specific size, use the=20
"normal maximum" file size. We have a special server storing files of=20
normally 50M-1G size, there I set allocsize=3D1024k, so that files will be=
=20
in one junk on disk. When sometimes a file is bigger, then it will be=20
fragmented but at reasonable sizes so it won't matter too much.

Is that reasonable?

Are there guides to help with that? I'd like to write a FAQ entry if=20
there is (can ever be?) a consensus of what would be a good value.

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

--nextPart1510069.6G2cAd0Cij
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky3/28ACgkQzhSR9xwSCbRbGACfVGwo7MAUQ0BRY4K9hIkAyPsX
NVEAoMck/JZhCWVKa4KQZmy2LAoxOXv3
=MVwQ
-----END PGP SIGNATURE-----

--nextPart1510069.6G2cAd0Cij--


--===============5406079036293102373==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5406079036293102373==--
