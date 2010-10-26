Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9QMQE5x110219 for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 17:26:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B369198F5C2
	for <xfs@oss.sgi.com>; Tue, 26 Oct 2010 15:27:29 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id pXYhXD1NrOJ7cst7 for
	<xfs@oss.sgi.com>; Tue, 26 Oct 2010 15:27:29 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 0738117C
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:27:28 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 1028B401C3D
	for <xfs@oss.sgi.com>; Wed, 27 Oct 2010 00:27:27 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS journaling position
Date: Wed, 27 Oct 2010 00:27:26 +0200
References: <31c7e56286d37870011c17ee8e002760.squirrel@webmail.ics.forth.gr>
	<20101025161052.GC19425@sgi.com>
In-Reply-To: <20101025161052.GC19425@sgi.com>
MIME-Version: 1.0
Message-Id: <201010270027.26687@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4137908418372290270=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4137908418372290270==
Content-Type: multipart/signed;
  boundary="nextPart5805502.GqRqaSqsCg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5805502.GqRqaSqsCg
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 25. Oktober 2010 Geoffrey Wehrman wrote:
> I haven't found any documentation to support this, but I have been
> told that the middle was selected for the single disk case to
> minimize seek times.  The distance the head must travel to or from
> other locations on the disk is optimized by placing the log in the
> middle of the disk.

This is based on the assumption that
1) a disk is totally filled with data and
2) the partition that XFS resides on is the only one on the disk.

=46or PCs or small servers you normally have a swap partition, the=20
recommended size is RAMx2 (at least it was once suggested, I've always=20
only set it to RAM size). Then you have at least a root filesystem,=20
which often won't be XFS, and then the data partition, which could be a=20
single partition until the end of the disk. For a single 300GB disk,=20
this means that around 20-50GB will be used by "other" (swap, root,=20
windows?) partitions, then maybe a single 250-280GB partition for XFS.=20
If you place the journal in the middle of the partition, you are already=20
in an area where disks are slower than on the outside. And if you fill=20
only half of the partition, it means your log is totally on the end of=20
the disk, access-wise.

So for the average single-disk setup, wouldn't a log at 25%-35% of the=20
partition size be quicker than in the middle of the partition? Dave=20
Chinner just recently said that "a partition which is 85% filled is=20
full, from a filesystem view". That would already mean the log at 42% of=20
the partition size would be better. (Greetings to Douglas Adams, again=20
he was right ;-)

Just my 2=A2, but I don't have a single disk machine with performance=20
needs.

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

--nextPart5805502.GqRqaSqsCg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEUEABECAAYFAkzHVc4ACgkQzhSR9xwSCbSMVACgs+musV+L5/novruk0GmOvr+h
umQAmNCY2MsIrhOaGPiiCevGOI+sw+E=
=EhJ7
-----END PGP SIGNATURE-----

--nextPart5805502.GqRqaSqsCg--


--===============4137908418372290270==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4137908418372290270==--
