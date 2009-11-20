Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAKAqW7u147491 for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 04:52:33 -0600
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A2661BFFCF8
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 02:52:54 -0800 (PST)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id R6ms8couoi8P5h6R for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2009 02:52:54 -0800 (PST)
Received: from mailsrv.i.zmi.at (unknown [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 2415EC00AD9
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 11:52:53 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 62EB483C821
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2009 11:54:17 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: XFS, NFS and inode64 on 2.6.27
Date: Fri, 20 Nov 2009 11:52:43 +0100
MIME-Version: 1.0
Message-Id: <200911201152.43809@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5332786714834209463=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5332786714834209463==
Content-Type: multipart/signed;
  boundary="nextPart2031676.ht96NbcuM0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2031676.ht96NbcuM0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Dear all,

after searching for a long time I guess I found that inode64 on XFS with=20
kernel 2.6.27 (shipped with openSUSE 11.1) is incompatible with NFS.=20
Sorry if this was already know, it wasn't for me and finding the problem=20
was complicated.

This is my nfs4 root (fsid=3D0):

# ls -li
insgesamt 0
4666 drwxr-xr-x 2 root root 48 15. Nov 19:54 daten
4668 drwxr-xr-x 2 root root 48 15. Nov 19:54 download2
4667 drwxr-xr-x 2 root root 48 15. Nov 19:54 dvd-images
4661 drwxr-xr-x 2 root root 48 19. Nov 06:51 mailsrv-backup
4669 drwxr-xr-x 2 root root 48 15. Nov 19:54 q
4670 drwxr-xr-x 2 root root 48 15. Nov 19:54 z

Then I mount those subdirs (mount --bind ....) to fill it with the dirs=20
I want to share:

# ls -li
insgesamt 20
        256 drwxr-xr-x 14 root root  4096 19. Nov 03:01 daten
 6454034730 drwxrwx---  3 zmi  users   61 26. M=C3=A4r 2009  download2
    4070671 drwxr-xr-x  2 root root    76 13. Nov 12:17 dvd-images
 6500330752 drwxr-xr-x  5 root root  4096  8. Nov 04:31 mailsrv-backup
 8591091465 drwxr-xr-x 17 root root  4096 12. Nov 02:01 q
 2147483904 drwxrwx--- 31 zmi  bh    4096  7. Nov 09:58 z

The shares "daten" and "dvd-images" can be mounted from other servers. I=20
simply went to the original dirs of this mount-bind, and created several=20
new dirs:
mkdir 1 2 3 4 5 6 7 8 9
and one of them had an inode < 2G, so I moved the contents there and=20
renamed the dirs, remounted the --bind mounts and now have this:

# ls -li
insgesamt 20
      256 drwxr-xr-x 14 root root 4096 19. Nov 07:22 daten
184637244 drwxr-xr-x  3 root root   61 19. Nov 07:30 download2
  4070671 drwxr-xr-x  2 root root   76 13. Nov 12:17 dvd-images
960533297 drwxr-xr-x  5 root root 4096 19. Nov 07:27 mailsrv-backup
184190222 drwxr-xr-x 16 root root 4096 19. Nov 07:41 q
184637237 drwxr-xr-x 30 root root 4096 19. Nov 07:42 z

And everything mounts fine now.

(I still have one server that can mount, but not write, to such a share,=20
but that may be another problem)

Just to let others know that can be a problem.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4

--nextPart2031676.ht96NbcuM0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAksGdPsACgkQzhSR9xwSCbSSUgCgi+N0kXQ7tx7y1AO8MOL6el5K
VhUAnAwahG2Os4aM5lWJs2TwaBRBRrXL
=WO4q
-----END PGP SIGNATURE-----

--nextPart2031676.ht96NbcuM0--


--===============5332786714834209463==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5332786714834209463==--
