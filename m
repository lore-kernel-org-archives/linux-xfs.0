Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACFGlsP134303 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 09:16:47 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C204173B10
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 07:18:11 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id StGwzERuzOMbQSVU for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 07:18:11 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: reducing imaxpct on linux
Date: Fri, 12 Nov 2010 16:18:08 +0100
References: <1289561141.20961.24.camel@sekli> <201011121401.52477@zmi.at>
	<1289571841.20961.44.camel@sekli>
In-Reply-To: <1289571841.20961.44.camel@sekli>
MIME-Version: 1.0
Message-Id: <201011121618.09040@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8291315158162901140=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "CZEH, Istvan" <iczeh@virusbuster.hu>
Cc: xfs@oss.sgi.com

--===============8291315158162901140==
Content-Type: multipart/signed;
  boundary="nextPart12432309.0zy2D7ORRa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart12432309.0zy2D7ORRa
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 12. November 2010 CZEH, Istvan wrote:
> I already made the things written in the FAQ (question 32.) but still
> having the problem. Maybe I should find the oldest data again? It
> won't be easy...

I guess the FAQ is a bit wrong here:

http://xfs.org/index.php/XFS_FAQ#Q:_Why_do_I_receive_No_space_left_on_devic=
e_after_xfs_growfs.3F

Because it is not the "oldest" data, but the data that is within the=20
space in the first TeraByte of the partition.

Dave Chinner explained to me, that XFS will split data equally amongst=20
all AGs. So if you have a partition with 4TB and 4 AGs, and you put 1TB=20
data on that partition, each AG will have around 250GB data, meaining=20
you still have 750GB free within the first TB.
When you do NOT use the inode64 option, all inodes will be placed in the=20
first TB *only*. Even when later you use the inode64 option, it might=20
not succeed in finding space for the inodes.

I can imaginge this would help
1) Run xfs_fsr, if it finds files below 1TB and defrags them to a space=20
>1TB, you're lucky
2) use the "noikeep" option before doing what XFS Q32 describes. If you=20
remove a large portion of inodes, and later move them back, they should=20
be newly allocated, and when you use inode64 then, chances are good the=20
go at a place >1TB.
3) Find files that are placed at <1TB. I think some xfs_db magic can do=20
that, but I never used it so someone else should say.

Anyway: Dave, I'd like to "repair" the FAQ question 32 to be more=20
correct and descriptive, would my description be correct?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart12432309.0zy2D7ORRa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzdWrAACgkQzhSR9xwSCbTqZwCdEUqNNv7TzI9wc2WHEi3ydatT
eRAAnAngfOwdKocXxTmd+6lxVgT2Kbi+
=7fY4
-----END PGP SIGNATURE-----

--nextPart12432309.0zy2D7ORRa--


--===============8291315158162901140==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8291315158162901140==--
