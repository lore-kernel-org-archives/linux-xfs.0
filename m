Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 15 Jan 2007 17:07:53 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l0G17jqw023071
	for <xfs@oss.sgi.com>; Mon, 15 Jan 2007 17:07:46 -0800
Received: from pcbnaujok (pc-bnaujok.melbourne.sgi.com [134.14.55.58]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id MAA22290 for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 12:06:51 +1100
Message-Id: <200701160106.MAA22290@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: REVIEW: 031 QA failure with xfs_repair
Date: Tue, 16 Jan 2007 12:12:18 +1100
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_051B_01C73967.91347F60"
In-Reply-To: <200701160045.LAA21869@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

------=_NextPart_000_051B_01C73967.91347F60
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Well, Dave has already replied, but here is the patch again with out the
line break crap and tabs intact.
 
> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Barry Naujok
> Sent: Tuesday, 16 January 2007 11:51 AM
> To: xfs@oss.sgi.com
> Subject: FW: REVIEW: 031 QA failure with xfs_repair
> 
>  
> QA 030 and 031 are failing with xfs_repair as the "zeroed log" is
> different 
> on IRIX and Linux.
> 
> xfs_repair must be coded to handle the different platform log 
> formats.
> 
> ==========================
> 
> Need a review please:

(see attached)

------=_NextPart_000_051B_01C73967.91347F60
Content-Type: application/octet-stream;
	name="031-fix.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="031-fix.diff"

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/darwin.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/darwin.c_1.12     Mon Jan 15 =
17:30:37 2007
+++ xfsprogs/libxfs/darwin.c    Mon Jan 15 16:53:25 2007
@@ -22,6 +22,7 @@
 #include <sys/ioctl.h>
 #include <xfs/libxfs.h>

+int platform_has_uuid =3D 0;
 extern char *progname;

 int

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/freebsd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/freebsd.c_1.15    Mon Jan 15 =
17:30:37 2007
+++ xfsprogs/libxfs/freebsd.c   Mon Jan 15 16:53:35 2007
@@ -22,6 +22,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>

+int platform_has_uuid =3D 0;
 extern char *progname;

 int

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/init.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/init.h_1.12       Mon Jan 15 =
17:30:37 2007
+++ xfsprogs/libxfs/init.h      Mon Jan 15 16:52:09 2007
@@ -34,5 +34,6 @@
 extern int platform_align_blockdev (void);
 extern int platform_aio_init (int aio_count);
 extern int platform_nproc(void);
+extern int platform_has_uuid;

 #endif /* LIBXFS_INIT_H */

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/irix.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/irix.c_1.13       Mon Jan 15 =
17:30:37 2007
+++ xfsprogs/libxfs/irix.c      Mon Jan 15 16:53:49 2007
@@ -21,6 +21,7 @@
 #include <diskinfo.h>
 #include <sys/sysmp.h>

+int platform_has_uuid =3D 0;
 extern char *progname;
 extern __int64_t findsize(char *);


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxfs/linux.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxfs/linux.c_1.16      Mon Jan 15 =
17:30:37 2007
+++ xfsprogs/libxfs/linux.c     Mon Jan 15 16:53:10 2007
@@ -26,6 +26,7 @@
 #include <sys/mount.h>
 #include <sys/ioctl.h>

+int platform_has_uuid =3D 1;
 extern char *progname;
 static int max_block_alignment;


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/libxlog/xfs_log_recover.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- /usr/tmp/TmpDir.5868489-0/xfsprogs/libxlog/xfs_log_recover.c_1.30   Mon=
 Jan 15 17:30:37 2007
+++ xfsprogs/libxlog/xfs_log_recover.c  Mon Jan 15 16:54:50 2007
@@ -258,6 +258,7 @@
 	uint		first_half_cycle, last_half_cycle;
 	uint		stop_on_cycle;
 	int		error, log_bbnum =3D log->l_logBBsize;
+	extern int	platform_has_uuid;

 	/* Is the end of the log device zeroed? */
 	if ((error =3D xlog_find_zeroed(log, &first_blk)) =3D=3D -1) {
@@ -264,7 +265,7 @@
 		*return_head_blk =3D first_blk;

 		/* Is the whole lot zeroed? */
-		if (!first_blk) {
+		if (!first_blk && platform_has_uuid) {
 			/* Linux XFS shouldn't generate totally zeroed logs -
 			 * mkfs etc write a dummy unmount record to a fresh
 			 * log so we can store the uuid in there

------=_NextPart_000_051B_01C73967.91347F60--
