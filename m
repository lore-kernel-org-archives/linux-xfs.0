Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Dec 2006 10:42:14 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBKIg4qw005191
	for <xfs@oss.sgi.com>; Wed, 20 Dec 2006 10:42:07 -0800
Message-Id: <200611230052.LAA09114@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: Re: Unexpected inode type 0160000 causes abort of xfs_repair
Date: Thu, 23 Nov 2006 11:55:35 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_1289_01C70EF6.496D6C00"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Jonathan Groll' <lists@groll.co.za>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_1289_01C70EF6.496D6C00
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Can you try the attached patch and see how xfs_repair goes? 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Jonathan Groll
> Sent: Thursday, 23 November 2006 7:12 AM
> To: xfs@oss.sgi.com
> Subject: Unexpected inode type 0160000 causes abort of xfs_repair
> 
> I'm unsuccesfully trying to repair an XFS filesystem 
> 
> xfs_repair /dev/md1 and the same with -L both end with
> bad (negative) size -2150115811482766770 on inode 1539849750
> cleared inode 1539849750
> bad magic number 0x859b on inode 1539849751, resetting magic number
> bad version number 0xffffff88 on inode 1539849751, resetting version
> number
> Unexpected inode type 0160000 inode 1539849751
> Aborted
> 
> OS: debian sarge (stable)
> Kernel: 2.6.15.7
> xfsprogs       2.8.11-1
> 
> Is there anything I can possibly do?
> 
> Many thanks,
> Jonathan Groll
> 
> 




------=_NextPart_000_1289_01C70EF6.496D6C00
Content-Type: application/octet-stream;
	name="xfs_repair.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="xfs_repair.diff"

--- a/xfsprogs/repair/dinode.c	2006-11-23 11:47:17.000000000 +1100
+++ b/xfsprogs/repair/dinode.c	2006-11-23 11:40:31.219340329 +1100
@@ -2060,11 +2060,21 @@
 		type =3D XR_INO_FIFO;
 		break;
 	default:
-		type =3D XR_INO_UNKNOWN;
-		do_warn(_("Unexpected inode type %#o inode %llu\n"),
-			(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
-		abort();
-		break;
+		retval++;
+		if (!verify_mode)  {
+			do_warn(_("bad inode type %#o inode %llu\n"),
+				(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
+			if (!no_modify)=20=20
+				*dirty +=3D clear_dinode(mp, dino, lino);
+			else=20
+				*dirty =3D 1;
+			*cleared =3D 1;
+			*used =3D is_free;
+		} else if (!uncertain)  {
+			do_warn(_("bad inode type %#o inode %llu\n"),
+				(int) (INT_GET(dinoc->di_mode, ARCH_CONVERT) & S_IFMT), lino);
+		}
+		return 1;
 	}
=20
 	/*

------=_NextPart_000_1289_01C70EF6.496D6C00--
