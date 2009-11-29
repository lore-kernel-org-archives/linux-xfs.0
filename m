Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nATDr3Ou072635 for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 07:53:03 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1C071D9E499
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 05:53:30 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Hgauh5bSokkovosS for
	<xfs@oss.sgi.com>; Sun, 29 Nov 2009 05:53:30 -0800 (PST)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 6CE8BC00423
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 14:53:29 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 422F483C825
	for <xfs@oss.sgi.com>; Sun, 29 Nov 2009 14:55:36 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: XFS & LVM: unexpected cp when issuing mv
Date: Sun, 29 Nov 2009 14:52:16 +0100
MIME-Version: 1.0
Message-Id: <200911291452.20646@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6025403473003858614=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6025403473003858614==
Content-Type: multipart/signed;
  boundary="nextPart9872530.FGTL40oqJy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart9872530.FGTL40oqJy
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I have an unexpected behaviour and I hope someone can explain me the=20
reasons:

This is an openSUSE 11.2 virtual machine within XENserver. XENserver can=20
only create 2TB disks, but I needed more. So I create 2x 2TB disks for=20
that VM. These disks have no partitions, but are straight LVM:
# pvscan
  PV /dev/xvdb   VG sharestore   lvm2 [1,95 TB / 0    free]
  PV /dev/xvdc   VG sharestore   lvm2 [1,95 TB / 0    free]
  Total: 2 [3,91 TB] / in use: 2 [3,91 TB] / in no VG: 0 [0   ]

I created one VG, and then one LV:
# vgscan
  Reading all physical volumes.  This may take a while...
  Found volume group "sharestore" using metadata type lvm2
# lvscan
  ACTIVE            '/dev/sharestore/public' [3,91 TB] inherit

On that LV, I created an XFS filesystem, mounted from /etc/fstab:
/dev/sharestore/public /disks/sharestore  xfs       =20
noatime,nodiratime,logbufs=3D8,logbsize=3D256k,attr2,nobarrier,largeio,swal=
loc,inode64,prjquota

Now when I move from one dir to another, example
mv /disks/sharestore/upload/* /disks/sharestore/download/

within some dirs it's a simple mv where only metadata is moved, but with=20
some dirs it's a physical cp+rm of the files. You can easily see that by=20
the speed of the mv, plus with iostat:
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-
sz avgqu-sz   await  svctm  %util
xvdb              0,00     0,00    0,00  647,31     0,00 28424,75   =20
87,82    18,46   29,71   0,24  15,65
xvdc              0,00     0,40  631,14    2,40 26928,54    76,65   =20
85,25     5,56    8,69   1,56  98,84

Until now I believed that a mv within one filesystem is always just a=20
metadata mv. But it seems I found a case now where even within the same=20
filesystem a physical cp+rm is done. Can someone explain me

1) why this happens
2) how I can prevent this?

We have files >5G there, often 20G or more, so a mv should just be a=20
metadata mv, everything else is inacceptable.
Could it be the way I created the VG + LV, that there's a cp instead mv?
How could I create all that to get a normal behaviour?

Maybe like this?:
1) create VG only on one disk
2) create LV on that disk
3) create XFS
4) extend VG to 2nd disk
5) extend LV to 2nd disk
6) xfs_growfs to 2nd disk

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart9872530.FGTL40oqJy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksSfJQACgkQzhSR9xwSCbRddACfYC1TdvouxzRYzXgGA3h7ctYF
tSUAoPdYSft++tcCmL24zUr5x+2dBVvD
=SBnk
-----END PGP SIGNATURE-----

--nextPart9872530.FGTL40oqJy--


--===============6025403473003858614==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6025403473003858614==--
