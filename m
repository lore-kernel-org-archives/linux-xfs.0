Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 22:10:21 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBL6ACqw024862
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 22:10:14 -0800
Message-Id: <200612210609.RAA24334@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: [PATCH] Return failure error if something fails in xfs_growfs
Date: Thu, 21 Dec 2006 17:15:05 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_017F_01C72523.8FCA6E80"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@corp.sgi.com
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_017F_01C72523.8FCA6E80
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

A very simple patch that return error rather than success if something
fails in xfs_growfs.

Barry.

------=_NextPart_000_017F_01C72523.8FCA6E80
Content-Type: application/octet-stream;
	name="growfs_error.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="growfs_error.diff"

--- a/xfsprogs/growfs/xfs_growfs.c	2006-12-21 17:07:16.000000000 +1100
+++ b/xfsprogs/growfs/xfs_growfs.c	2006-12-21 17:06:16.639597863 +1100
@@ -448,5 +448,5 @@
 	if (geo.rtextsize !=3D ngeo.rtextsize)
 		printf(_("realtime extent size changed from %d to %d\n"),
 			geo.rtextsize, ngeo.rtextsize);
-	exit(0);
+	exit(error);
 }

------=_NextPart_000_017F_01C72523.8FCA6E80--
