Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0CCpHpF014094 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 06:51:18 -0600
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 528F61C4677B
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 04:52:11 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id OHPf6kavlpCGCLYK for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2010 04:52:11 -0800 (PST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Fwd: [TuxOnIce-devel] Latest updates.
Date: Tue, 12 Jan 2010 13:51:58 +0100
MIME-Version: 1.0
Message-Id: <201001121352.06224.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4546324078763836193=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>

--===============4546324078763836193==
Content-Type: multipart/signed;
  boundary="nextPart9729447.EbZOFvyFvj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9729447.EbZOFvyFvj
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Please keep CC to TuxOnIce devel list.


Hi!

Nigel, who develops the alternative TuxOnIce hibernation / snapshot=20
infrastructure, implemented checking last mount time of filesystem as a=20
safety feature for Ext 2, 3 and 4.

He would like this also for XFS. Does XFS record the last mount time=20
somewhere? If not, could this be added?

Ciao,
Martin

=2D---------  Weitergeleitete Nachricht  ----------

Subject: [TuxOnIce-devel] Latest updates.
Date: Montag 11 Januar 2010
=46rom: Nigel Cunningham <ncunningham@crca.org.au>
To: TuxOnIce Devel List <tuxonice-devel@lists.tuxonice.net>

Hi everyone.

I'm pushing some updates to the git trees at the moment. These add
support for storing the last mount time of filesystems in the image
header. At resume time, we can then check that the value is the same,
and refuse to resume if the filesystem has been mounted again in the
meantime. At the moment, I've only implemented this for ext filesystems.
I've looked for a last mount time in the xfs superblock structure, but
can't find one. Can anyone help there?

Nigel
_______________________________________________
TuxOnIce-devel mailing list
TuxOnIce-devel@lists.tuxonice.net
http://lists.tuxonice.net/listinfo/tuxonice-devel

=2D------------------------------------------------------

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart9729447.EbZOFvyFvj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAktMcG8ACgkQmRvqrKWZhMf1TQCgqKZzH+3Is/eUnhFLV9IKT8HO
bKoAnRWNNgkBRjW9FPlveYrpY+CuP+pr
=LYtl
-----END PGP SIGNATURE-----

--nextPart9729447.EbZOFvyFvj--


--===============4546324078763836193==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4546324078763836193==--
