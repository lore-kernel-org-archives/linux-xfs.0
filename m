Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4I7pdLD039182 for <xfs@oss.sgi.com>; Tue, 18 May 2010 02:51:40 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A55EA9CBCBB
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 00:54:55 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id cO9e9bQ3vZBKKdOz for
	<xfs@oss.sgi.com>; Tue, 18 May 2010 00:54:55 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id D09D2800139
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 09:53:52 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 7C61C83C804
	for <xfs@oss.sgi.com>; Tue, 18 May 2010 09:53:52 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs_repair 3.1.1 doesnt repair broken filesystem
Date: Tue, 18 May 2010 09:53:47 +0200
MIME-Version: 1.0
Message-Id: <201005180953.51892@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7855803982785113304=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7855803982785113304==
Content-Type: multipart/signed;
  boundary="nextPart1702446.OcipcPCo6O";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1702446.OcipcPCo6O
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I do a repair on a broken filesystem, which reports no problems. Then I=20
mount and "ls -l", and you can easily see all those broken entries,=20
which should be directories. They are not repaired. What could I do?

# xfs_repair -v /dev/bigbak/bigbak                             =20
Phase 1 - find and verify superblock...                                    =
     =20
        - block cache size set to 8536 entries                             =
     =20
Phase 2 - using internal log                                               =
     =20
        - zero log...                                                      =
     =20
XFS: totally zeroed log                                                    =
     =20
zero_log: head block 0 tail block 0                                        =
     =20
        - scan filesystem freespace and inode maps...                      =
     =20
        - found root inode chunk                                           =
     =20
Phase 3 - for each AG...                                                   =
     =20
        - scan and clear agi unlinked lists...                             =
     =20
        - process known inodes and perform inode discovery...              =
     =20
        - agno =3D 0                                                       =
       =20
        - agno =3D 1                                                       =
       =20
        - agno =3D 2                                                       =
       =20
        - agno =3D 3                                                       =
       =20
        - agno =3D 4                                                       =
       =20
        - agno =3D 5                                                       =
       =20
        - agno =3D 6                                                       =
       =20
        - agno =3D 7                                                       =
       =20
        - agno =3D 8                                                       =
       =20
        - agno =3D 9                                                       =
       =20
        - agno =3D 10                                                      =
       =20
        - agno =3D 11                                                      =
       =20
        - agno =3D 12                                                      =
       =20
        - agno =3D 13                                                      =
       =20
        - agno =3D 14                                                      =
       =20
        - agno =3D 15                                                      =
       =20
        - agno =3D 16                                                      =
       =20
        - agno =3D 17                                                      =
       =20
        - agno =3D 18                                                      =
       =20
        - agno =3D 19                                                      =
       =20
        - agno =3D 20                                                      =
       =20
        - agno =3D 21                                                      =
       =20
        - agno =3D 22                                                      =
       =20
        - agno =3D 23                                                      =
       =20
        - agno =3D 24                                                      =
       =20
        - agno =3D 25                                                      =
       =20
        - agno =3D 26                                                      =
       =20
        - agno =3D 27                                                      =
       =20
        - agno =3D 28                                                      =
       =20
        - agno =3D 29                                                      =
       =20
        - agno =3D 30                                                      =
       =20
        - agno =3D 31                                                      =
       =20
        - process newly discovered inodes...                               =
     =20
Phase 4 - check for duplicate blocks...                                    =
     =20
        - setting up duplicate extent list...                              =
     =20
        - check for inodes claiming duplicate blocks...                    =
     =20
        - agno =3D 0                                                       =
       =20
        - agno =3D 1                                                       =
       =20
        - agno =3D 2                                                       =
       =20
        - agno =3D 3                                                       =
       =20
        - agno =3D 4                                                       =
       =20
        - agno =3D 5                                                       =
       =20
        - agno =3D 6                                                       =
       =20
        - agno =3D 7                                                       =
       =20
        - agno =3D 8                                                       =
       =20
        - agno =3D 9                                                       =
       =20
        - agno =3D 10                                                      =
       =20
        - agno =3D 11                                                      =
       =20
        - agno =3D 12                                                      =
       =20
        - agno =3D 13                                                      =
       =20
        - agno =3D 14                                                      =
       =20
        - agno =3D 15                                                      =
       =20
        - agno =3D 16                                                      =
       =20
        - agno =3D 17                                                      =
       =20
        - agno =3D 18                                                      =
       =20
        - agno =3D 19                                                      =
       =20
        - agno =3D 20                                                      =
       =20
        - agno =3D 21                                                      =
       =20
        - agno =3D 22                                                      =
       =20
        - agno =3D 23                                                      =
       =20
        - agno =3D 24                                                      =
       =20
        - agno =3D 25                                                      =
       =20
        - agno =3D 26                                                      =
       =20
        - agno =3D 27                                                      =
       =20
        - agno =3D 28                                                      =
       =20
        - agno =3D 29                                                      =
       =20
        - agno =3D 30                                                      =
       =20
        - agno =3D 31                                                      =
       =20
Phase 5 - rebuild AG headers and trees...                                  =
     =20
        - agno =3D 0                                                       =
       =20
        - agno =3D 1                                                       =
       =20
        - agno =3D 2                                                       =
       =20
        - agno =3D 3                                                       =
       =20
        - agno =3D 4                                                       =
       =20
        - agno =3D 5                                                       =
       =20
        - agno =3D 6                                                       =
       =20
        - agno =3D 7                                                       =
       =20
        - agno =3D 8                                                       =
       =20
        - agno =3D 9                                                       =
       =20
        - agno =3D 10                                                      =
       =20
        - agno =3D 11                                                      =
       =20
        - agno =3D 12                                                      =
       =20
        - agno =3D 13                                                      =
       =20
        - agno =3D 14                                                      =
       =20
        - agno =3D 15                                                      =
       =20
        - agno =3D 16                                                      =
       =20
        - agno =3D 17                                                      =
       =20
        - agno =3D 18                                                      =
       =20
        - agno =3D 19                                                      =
       =20
        - agno =3D 20                                                      =
       =20
        - agno =3D 21                                                      =
       =20
        - agno =3D 22                                                      =
       =20
        - agno =3D 23                                                      =
       =20
        - agno =3D 24                                                      =
       =20
        - agno =3D 25                                                      =
       =20
        - agno =3D 26                                                      =
       =20
        - agno =3D 27                                                      =
       =20
        - agno =3D 28                                                      =
       =20
        - agno =3D 29                                                      =
       =20
        - agno =3D 30                                                      =
       =20
        - agno =3D 31                                                      =
       =20
        - reset superblock...                                              =
     =20
Phase 6 - check inode connectivity...                                      =
     =20
        - resetting contents of realtime bitmap and summary inodes         =
     =20
        - traversing filesystem ...                                        =
     =20
        - agno =3D 0                                                       =
       =20
        - agno =3D 1                                                       =
       =20
        - agno =3D 2                                                       =
       =20
        - agno =3D 3                                                       =
       =20
        - agno =3D 4                                                       =
       =20
        - agno =3D 5                                                       =
       =20
        - agno =3D 6                                                       =
       =20
        - agno =3D 7                                                       =
       =20
        - agno =3D 8                                                       =
       =20
        - agno =3D 9                                                       =
       =20
        - agno =3D 10                                                      =
       =20
        - agno =3D 11                                                      =
       =20
        - agno =3D 12                                                      =
       =20
        - agno =3D 13                                                      =
       =20
        - agno =3D 14                                                      =
       =20
        - agno =3D 15                                                      =
       =20
        - agno =3D 16                                                      =
       =20
        - agno =3D 17                                                      =
       =20
        - agno =3D 18                                                      =
       =20
        - agno =3D 19                                                      =
       =20
        - agno =3D 20                                                      =
       =20
        - agno =3D 21                                                      =
       =20
        - agno =3D 22                                                      =
       =20
        - agno =3D 23                                                      =
       =20
        - agno =3D 24                                                      =
       =20
        - agno =3D 25                                                      =
       =20
        - agno =3D 26                                                      =
       =20
        - agno =3D 27                                                      =
       =20
        - agno =3D 28                                                      =
       =20
        - agno =3D 29                                                      =
       =20
        - agno =3D 30                                                      =
       =20
        - agno =3D 31                                                      =
       =20
        - traversal finished ...                                           =
     =20
        - moving disconnected inodes to lost+found ...                     =
     =20
Phase 7 - verify and correct link counts...                                =
     =20

        XFS_REPAIR Summary    Tue May 18 09:50:35 2010

Phase           Start           End             Duration
Phase 1:        05/18 09:48:12  05/18 09:48:12         =20
Phase 2:        05/18 09:48:12  05/18 09:48:44  32 seconds
Phase 3:        05/18 09:48:44  05/18 09:49:39  55 seconds
Phase 4:        05/18 09:49:39  05/18 09:49:54  15 seconds
Phase 5:        05/18 09:49:54  05/18 09:49:54           =20
Phase 6:        05/18 09:49:54  05/18 09:50:35  41 seconds
Phase 7:        05/18 09:50:35  05/18 09:50:35           =20

Total run time: 2 minutes, 23 seconds
done
# mount /dev/bigbak/bigbak /disks/bigbak/
# l /disks/bigbak/
ls: Zugriff auf /disks/bigbak/lama nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/maza nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/paan nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/public nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/tmp nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/upload nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/vop nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
ls: Zugriff auf /disks/bigbak/zmi nicht m=C3=B6glich: Das Argument ist=20
ung=C3=BCltig
insgesamt 20
drwxrwx---  14 root    1000 4096 12. Mai 09:36 ./
drwxr-xr-x   7 root root     184 17. Mai 12:40 ../
drwx------   6 1007 nogroup 4096  9. Jan 15:51 anse/
=2Drw-r--r--   1 root root     155 12. Mai 09:42 du.20100512
=2Drwx------   1 root root     141 26. M=C3=A4r 14:51 find-inode.sh*
drwx------   2 1006 nogroup   68 23. Nov 15:15 hope/
drwxrwxr-x+  4 1007 nogroup   49 29. Nov 12:32 itm/
drwx------   2 1002 nogroup   68 23. Nov 15:14 jog/
???????????  ? ?    ?          ?             ? lama
???????????  ? ?    ?          ?             ? maza
???????????  ? ?    ?          ?             ? paan
???????????  ? ?    ?          ?             ? public
???????????  ? ?    ?          ?             ? tmp
???????????  ? ?    ?          ?             ? upload
???????????  ? ?    ?          ?             ? vop
???????????  ? ?    ?          ?             ? zmi

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1702446.OcipcPCo6O
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkvyR48ACgkQzhSR9xwSCbTxrwCcCSZfnOi1Q+A6WPWfNcCfXMh+
7mEAoO9CdzVJSIwkM/uQ9J71u/lAvmbC
=4SgW
-----END PGP SIGNATURE-----

--nextPart1702446.OcipcPCo6O--


--===============7855803982785113304==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7855803982785113304==--
