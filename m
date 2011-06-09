Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p595iQ0T151480 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 00:44:27 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9EBECD90A68
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 22:44:20 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id EA8K4dFfOTQfUE5z for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 22:44:20 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Small files perform much faster on newly formatted fs?
Date: Thu, 9 Jun 2011 07:44:12 +0200
References: <20110607163742.GH28625@pyre.virge.net> <201106081547.38266@zmi.at>
	<20110608185844.GB28625@pyre.virge.net>
In-Reply-To: <20110608185844.GB28625@pyre.virge.net>
MIME-Version: 1.0
Message-Id: <201106090744.18277@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9096402335672338738=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Norbert Veber <nveber@pyre.virge.net>

--===============9096402335672338738==
Content-Type: multipart/signed;
  boundary="nextPart1856266.RNKEPbcIMl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1856266.RNKEPbcIMl
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. Juni 2011 Norbert Veber wrote:
> I re-created the test filesystem to be the same size (20gb) as the
> original, and copied all the same files to it, so both are now 80%
> full.

But copying data at once leads to "perfectly" aligned data, and cannot=20
be compared to a filesystem that has aged over the years. Maybe you can=20
compare it like this:
1) remount the old partition with "noikeep"
2) mv /old/* /new
3) cp /new/* /old/

Maybe that would help? I'm interested to find the difference.

Also, as Eric said, both partitions are on different locations on the=20
disks, but I guess your old partition is more outside, thus in the=20
quicker region, than the new partition. Is that true?

Could it be that the old filesystem gets mounted with different=20
logbufs/logbsize values? Would the mount options=20
"logbufs=3D8,logbsize=3D256k" maybe make a difference?
Is the position of the log area fixed on disk? Maybe that is not stripe=20
aligned. Could you check with a newer kernel using "delaylog"?

[Dave wrote]
> Those mount options are ignored if the filesystem doesn't have the
> superblock feature bit set for aligned allocations. A filesystem
> with 0/0 for sunit/swidth does not have the superblock bit set....

And I guess it's not possible to set that bit now?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1856266.RNKEPbcIMl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3wXbIACgkQzhSR9xwSCbTSrQCg7SuTSwEnw+FoVZTWMDDM4dgE
RK8AoLS1VdvYCTXTFCouzLx/Jb0IKDDW
=xZh2
-----END PGP SIGNATURE-----

--nextPart1856266.RNKEPbcIMl--


--===============9096402335672338738==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9096402335672338738==--
