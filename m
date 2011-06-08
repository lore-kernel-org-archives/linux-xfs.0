Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p58DlhKV095337 for <xfs@oss.sgi.com>; Wed, 8 Jun 2011 08:47:44 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77ADED8073A
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 06:47:40 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id RN4ikaqqLPqdKmG9 for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 06:47:40 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Small files perform much faster on newly formatted fs?
Date: Wed, 8 Jun 2011 15:47:33 +0200
References: <20110607163742.GH28625@pyre.virge.net> <201106080911.11286@zmi.at>
	<20110608122638.GQ28625@pyre.virge.net>
In-Reply-To: <20110608122638.GQ28625@pyre.virge.net>
MIME-Version: 1.0
Message-Id: <201106081547.38266@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6403145711645162345=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Norbert Veber <nveber@pyre.virge.net>

--===============6403145711645162345==
Content-Type: multipart/signed;
  boundary="nextPart3036893.VkC3Ibz6SB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3036893.VkC3Ibz6SB
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. Juni 2011 Norbert Veber wrote:
> Yes its already mounted this way as I mentioned in my original
> message: /dev/mapper/vg0-shared on /shared type xfs
> (rw,noatime,sunit=3D128,swidth=3D256)

Oh, I did only look at the xfs_info output.
=20
> Both filesystems are on the same MD raid 5 which consists of 3 1 tb
> WD Black hard drive.

The difference could be that your filesystem is very much aged, and the=20
free space clustered around to new files get heavily fragmented. Did you=20
run xfs_defrag often? How full is your filesystem?

Also the log has sunit=3D0 against 16, maybe there's the diff.
Are you on a newer kernel that supports delaylog? Then try that.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3036893.VkC3Ibz6SB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3vfXoACgkQzhSR9xwSCbSSrgCgmVn84Lt14jJNjD9e+iRjVDZp
d5sAoIhizYgCximf7thAHUsQ4JWp6oI7
=P0O9
-----END PGP SIGNATURE-----

--nextPart3036893.VkC3Ibz6SB--


--===============6403145711645162345==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6403145711645162345==--
