Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4T6b5o2036514 for <xfs@oss.sgi.com>; Fri, 29 May 2009 01:37:05 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A842B9553
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 23:37:18 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id 3nDfj050FapDJmZF for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 23:37:18 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 82B1510D1
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:37:17 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id C1E5140DC06
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:37:17 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH 7/9] Set default extN mount options
Date: Fri, 29 May 2009 08:37:17 +0200
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<200905281235.21485@zmi.at> <4A1EA62C.8060008@sandeen.net>
In-Reply-To: <4A1EA62C.8060008@sandeen.net>
MIME-Version: 1.0
Message-Id: <200905290837.17539@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0453121124541015953=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0453121124541015953==
Content-Type: multipart/signed;
  boundary="nextPart6966916.cL5FOGP90d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6966916.cL5FOGP90d
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Donnerstag 28 Mai 2009 Eric Sandeen wrote:
> 'd be happy to include support for reiserfs as well. =A0I'd be even
> happier if you tested this yourself and sent patches to make it work
> :)

I'm not a coder, really, but just changing your line:
+    ext2|ext3|ext4)
to:
+    ext2|ext3|ext4|reiserfs)
does the job here. I meant that part:

diff --git a/common.rc b/common.rc
index 78514f4..54c36f3 100644
=2D-- a/common.rc
+++ b/common.rc
@@ -49,6 +49,10 @@ _mount_opts()
     nfs)
        export MOUNT_OPTIONS=3D$NFS_MOUNT_OPTIONS
        ;;
+    ext2|ext3|ext4)
+       # acls & xattrs aren't turned on by default on ext$FOO
+       export MOUNT_OPTIONS=3D"-o acl,user_xattr $EXT_MOUNT_OPTIONS"

I never used xfstest as well, and won't realistically have time to do=20
it.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart6966916.cL5FOGP90d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkofgp0ACgkQzhSR9xwSCbRTdgCeI3wcWyTF7wHLd2BGFDgeZ949
fykAoOb+ocA0Nx80YJdKYMpdyHJZtFft
=TtAK
-----END PGP SIGNATURE-----

--nextPart6966916.cL5FOGP90d--


--===============0453121124541015953==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0453121124541015953==--
