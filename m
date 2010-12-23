Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBNGtEFg205855 for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 10:55:14 -0600
Received: from passage.avira.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0187D1CF4A3A
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 08:57:12 -0800 (PST)
Received: from passage.avira.com (passage.avira.com [89.238.222.20]) by
	cuda.sgi.com with ESMTP id CEAVAa8E7ijEjsKf for
	<xfs@oss.sgi.com>; Thu, 23 Dec 2010 08:57:12 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by passage.avira.com (Postfix/AVIRA) with ESMTP id 4D1F41249F9
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 18:57:10 +0200 (EET)
Received: from naliboat.bu.avira.com (dasapass.avira.com [89.238.222.18])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "mail.bu.avira.com",
	Issuer "Avira Intermediate Certificate Authority 2010-2020" (not
	verified))
	by passage.avira.com (Postfix/AVIRA) with ESMTPS id 40D941249F9
	for <xfs@oss.sgi.com>; Thu, 23 Dec 2010 18:57:10 +0200 (EET)
Date: Thu, 23 Dec 2010 18:55:32 +0200
From: Petre Rodan <petre.rodan@simplex.ro>
Subject: xfssyncd and disk spin down
Message-ID: <20101223165532.GA23813@peter.simplex.ro>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3820780320863783328=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3820780320863783328==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello,

I have a problem with a hard drive that never managed to spin down. this dr=
ive is a storage space, not a system disk, the only thing that generated wr=
ites is the nfs server that exports its contents. it has only one large xfs=
 partition on it.

upon closer inspection it turns out that after the first Write action to th=
at partition, an xfssyncd process continues to write to that partition each=
 36 seconds and it doesn't stop doing that, even if there are no more Write=
s from the exterior. this keeps the drive busy with varying consequences. m=
ore about that later.

I found that the only easy way to stop the xfssyncd process poking the driv=
e is to run a `mount -o remount /mnt/space`. this will silence any internal=
 xfs process to acessing the drive, thus allowing it to spin down and only =
be woken up by a NFS access.

here are some simple steps to replicate the problem:

# echo 3 > /proc/sys/vm/drop_caches # free cached fs entities=20
# ( blktrace -d /dev/sdb -o - | blkparse -i - ) &
# mount -o remount /mnt/space
# find /mnt/space/ -type f > /dev/null  # generate some non-cached Read req=
uests
# # absolutely no writes have been performed to the drive,=20
# # it could spin down now if enough time would pass
# touch /mnt/space/foo
# # process 1352 will start writing to the drive at a 35-36s interval,
# # even if there has been no other write request.

  8,16   1    36591  6306.873151576  1352  A WBS 976985862 + 2 <- (8,17) 97=
6985799
  8,16   1    36592  6306.873152998  1352  Q WBS 976985862 + 2 [xfssyncd/sd=
b1]
[..]
  8,16   1    36600  6342.875151286  1352  A WBS 976985864 + 2 <- (8,17) 97=
6985801
  8,16   1    36601  6342.875152938  1352  Q WBS 976985864 + 2 [xfssyncd/sd=
b1]
[..]
  8,16   1    36609  6378.877225211  1352  A WBS 976985866 + 2 <- (8,17) 97=
6985803
  8,16   1    36610  6378.877226935  1352  Q WBS 976985866 + 2 [xfssyncd/sd=
b1]

there was no file at or near the 976985799 inode (I presume that's an inode=
?)

I found that the only way to stop it is to remount the partition. I also tr=
ied sync(1), but to no avail.=20

so is there an XFS option somewhere that would make the filesystem be more =
forgiving with the hardware beneath it? without loosing the journal of cour=
se.

I'm using a vanilla 2.6.36.2 kernel patched with grsecurity, default mkfs.x=
fs options, rw,nosuid,nodev,noexec,noatime,attr2,noquota mount options, and=
 xfs_info looks like this:

meta-data=3D/dev/sdb1              isize=3D256    agcount=3D4, agsize=3D610=
47500 blks
         =3D                       sectsz=3D512   attr=3D2
data     =3D                       bsize=3D4096   blocks=3D244190000, imaxp=
ct=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D32768, version=
=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D0
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0



a probably related issue is with modern Western Digital/Hitachi hard drives=
 that use a Ramp load/unload technology that automatically parks the heads =
at stupidly small inactivity intervals (some small as 8 seconds), so look w=
hat happens when using such a drive and xfs:

# smartctl -a /dev/sda
[..]
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WCAZA0101731
Firmware Version: 50.0AB50
[..]
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always   =
    -       17
[..]
  9 Power_On_Hours          0x0032   096   096   000    Old_age   Always   =
    -       3351
[..]
193 Load_Cycle_Count        0x0032   066   066   000    Old_age   Always   =
    -       403405


this hard drive has exceeded it's 300k load/unload maximum from the specs i=
n only 140 days, which means it was woken up every 30s or so. not willingly.

cheers,
peter


--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk0TfwQACgkQixMPpwVd7zHwQgCgg50zqHPI744lJ6fi0/LZVNaO
m8cAmgImSrmW9RrM41CH38U4Y2I21CwR
=Sv/q
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--


--===============3820780320863783328==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3820780320863783328==--
