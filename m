Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 Apr 2008 21:46:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3F4k9rT001092
	for <xfs@oss.sgi.com>; Mon, 14 Apr 2008 21:46:11 -0700
Date: Tue, 15 Apr 2008 14:47:29 +1000
Subject: [REVIEW] tweak xfs_repair's memory usage limits
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------nuEYvAlzxPzV5q6YnEGIv6
MIME-Version: 1.0
Message-ID: <op.t9mx9fhp3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

------------nuEYvAlzxPzV5q6YnEGIv6
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: Quoted-Printable

This patch introduces two changes:
  - easier to specify desired maximum memory usage
  - use ulimits

I've added a -m <megabytes> option to xfs_repair for the user to
specify the maximum memory repair should run with. This obsoletes
the "-o bhash=3D<num>" option.

Also, I've added a call to getrlimit() to get the process's
virtual address limit that can be used. If it's not there,
sets it to LONG_MAX bytes (ie. half the possible address
space).

This should also address the reported problem of 32-bit systems
with more than 4GB of RAM and xfs_repair trying to use more
than 4GB.



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/man/man8/xfs_repair.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/man/man8/xfs_repair.8	2008-04-15 14:41:15.000000000 +1000
+++ b/xfsprogs/man/man8/xfs_repair.8	2008-04-15 14:30:39.725643493 +1000
@@ -6,6 +6,9 @@ xfs_repair \- repair an XFS filesystem
  [
  .B \-dfLnPv
  ] [
+.B \-m
+.I maxmem
+] [
  .B \-o
  .I subopt\c
  [\c
@@ -85,6 +88,18 @@ No modify mode. Specifies that
  .B xfs_repair
  should not modify the filesystem but should only scan the
  filesystem and indicate what repairs would have been made.
+.TP
+.BI \-m " maxmem"
+Specifies the approximate maximum amount of memory, in megabytes, to use=
=20=20
for
+.BR xfs_repair .
+.B xfs_repair
+has its own internal block cache which will scale out up to the lesser of=
=20=20
the
+process's virtual address limit or about 75% of the system's physical RAM.
+This option overrides these limits.
+.IP
+.B NOTE:
+These memory limits are only approximate and may use more than the=20=20
specified
+limit.
  .HP
  .B \-o
  .I subopt\c

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/xfs_repair.c	2008-04-15 14:41:15.000000000 +1000
+++ b/xfsprogs/repair/xfs_repair.c	2008-04-15 14:40:10.504301019 +1000
@@ -17,6 +17,7 @@
   */

  #include <xfs/libxlog.h>
+#include <sys/resource.h>
  #include "avl.h"
  #include "avl64.h"
  #include "globals.h"
@@ -66,12 +67,13 @@ char *o_opts[] =3D {

  static int	ihash_option_used;
  static int	bhash_option_used;
+static long	max_mem_specified;	/* in megabytes */

  static void
  usage(void)
  {
  	do_warn(
-_("Usage: %s [-nLvV] [-o subopt[=3Dvalue]] [-l logdev] [-r rtdev]=20=20
devname\n"),
+_("Usage: %s [-nLvV] [-m memMB] [-o subopt[=3Dvalue]] [-l logdev] [-r=20=
=20
rtdev] devname\n"),
  		progname);
  	exit(1);
  }
@@ -191,7 +193,7 @@ process_args(int argc, char **argv)
  	 * XXX have to add suboption processing here
  	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
  	 */
-	while ((c =3D getopt(argc, argv, "o:fl:r:LnDvVdPMt:")) !=3D EOF)  {
+	while ((c =3D getopt(argc, argv, "o:fl:m:r:LnDvVdPt:")) !=3D EOF)  {
  		switch (c) {
  		case 'D':
  			dumpcore =3D 1;
@@ -222,6 +224,9 @@ process_args(int argc, char **argv)
  					ihash_option_used =3D 1;
  					break;
  				case BHASH_SIZE:
+					if (max_mem_specified)
+						do_abort(
+			_("-o bhash option cannot be used with -m option\n"));
  					libxfs_bhash_size =3D (int) strtol(val, 0, 0);
  					bhash_option_used =3D 1;
  					break;
@@ -245,6 +250,12 @@ process_args(int argc, char **argv)
  		case 'f':
  			isa_file =3D 1;
  			break;
+		case 'm':
+			if (bhash_option_used)
+				do_abort(_("-m option cannot be used with "
+						"-o bhash option\n"));
+			max_mem_specified =3D strtol(optarg, 0, 0);
+			break;
  		case 'L':
  			zap_log =3D 1;
  			break;
@@ -550,9 +561,10 @@ main(int argc, char **argv)
  	 * Calculations are done in kilobyte units.
  	 */

-	if (!bhash_option_used) {
+	if (!bhash_option_used || max_mem_specified) {
  		unsigned long 	mem_used;
-		unsigned long	phys_mem;
+		unsigned long	max_mem;
+		struct rlimit	rlim;

  		libxfs_icache_purge();
  		libxfs_bcache_purge();
@@ -560,27 +572,46 @@ main(int argc, char **argv)
  		cache_destroy(libxfs_bcache);

  		mem_used =3D (mp->m_sb.sb_icount >> (10 - 2)) +
-					(mp->m_sb.sb_dblocks >> (10 + 1));
-		phys_mem =3D libxfs_physmem() * 3 / 4;
+					(mp->m_sb.sb_dblocks >> (10 + 1)) +
+					50000;	/* rough estimate of 50MB overhead */
+		max_mem =3D max_mem_specified ? max_mem_specified * 1024 :
+						libxfs_physmem() * 3 / 4;
+
+		if (getrlimit(RLIMIT_AS, &rlim) !=3D -1 &&
+					rlim.rlim_cur !=3D RLIM_INFINITY) {
+			rlim.rlim_cur =3D rlim.rlim_max;
+			setrlimit(RLIMIT_AS, &rlim);
+			/* use approximately 80% of rlimit to avoid overrun */
+			max_mem =3D MIN(max_mem, rlim.rlim_cur / 1280);
+		} else
+			max_mem =3D MIN(max_mem, (LONG_MAX >> 10) + 1);

  		if (verbose > 1)
-			do_log(_("        - icount =3D %llu, imem =3D %lu, "
-				"dblock =3D %llu, dmem =3D %lu\n"),
-				mp->m_sb.sb_icount, mp->m_sb.sb_icount >> (10 - 2),
-				mp->m_sb.sb_dblocks, mp->m_sb.sb_dblocks >> (10 + 1));
+			do_log(_("        - max_mem =3D %lu, icount =3D %llu, "
+				"imem =3D %llu, dblock =3D %llu, dmem =3D %llu\n"),
+				max_mem, mp->m_sb.sb_icount,
+				mp->m_sb.sb_icount >> (10 - 2),
+				mp->m_sb.sb_dblocks,
+				mp->m_sb.sb_dblocks >> (10 + 1));

-		if (phys_mem <=3D mem_used) {
+		if (max_mem <=3D mem_used) {
  			/*
  			 * Turn off prefetch and minimise libxfs cache if
  			 * physical memory is deemed insufficient
  			 */
+			if (max_mem_specified)
+				do_abort(_("Required memory for repair is "
+					"greater that the maximum specified "
+					"with the -m option. Please increase "
+					"it to at least %lu.\n"),
+					mem_used / 1024);
  			do_prefetch =3D 0;
  			libxfs_bhash_size =3D 64;
  		} else {
-			phys_mem -=3D mem_used;
-			if (phys_mem >=3D (1 << 30))
-				phys_mem =3D 1 << 30;
-			libxfs_bhash_size =3D phys_mem / (HASH_CACHE_RATIO *
+			max_mem -=3D mem_used;
+			if (max_mem >=3D (1 << 30))
+				max_mem =3D 1 << 30;
+			libxfs_bhash_size =3D max_mem / (HASH_CACHE_RATIO *
  					(mp->m_inode_cluster_size >> 10));
  			if (libxfs_bhash_size < 512)
  				libxfs_bhash_size =3D 512;
------------nuEYvAlzxPzV5q6YnEGIv6
Content-Disposition: attachment; filename=repair_memory_tweak.patch
Content-Type: text/x-patch; name=repair_memory_tweak.patch
Content-Transfer-Encoding: Quoted-Printable


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/man/man8/xfs_repair.8
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/man/man8/xfs_repair.8	2008-04-15 14:41:15.000000000 +1000
+++ b/xfsprogs/man/man8/xfs_repair.8	2008-04-15 14:30:39.725643493 +1000
@@ -6,6 +6,9 @@ xfs_repair \- repair an XFS filesystem
 [
 .B \-dfLnPv
 ] [
+.B \-m
+.I maxmem
+] [
 .B \-o
 .I subopt\c
 [\c
@@ -85,6 +88,18 @@ No modify mode. Specifies that
 .B xfs_repair
 should not modify the filesystem but should only scan the
 filesystem and indicate what repairs would have been made.
+.TP
+.BI \-m " maxmem"
+Specifies the approximate maximum amount of memory, in megabytes, to use f=
or
+.BR xfs_repair .
+.B xfs_repair
+has its own internal block cache which will scale out up to the lesser of =
the
+process's virtual address limit or about 75% of the system's physical RAM.
+This option overrides these limits.
+.IP
+.B NOTE:
+These memory limits are only approximate and may use more than the specifi=
ed
+limit.
 .HP
 .B \-o
 .I subopt\c

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
xfsprogs/repair/xfs_repair.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

--- a/xfsprogs/repair/xfs_repair.c	2008-04-15 14:41:15.000000000 +1000
+++ b/xfsprogs/repair/xfs_repair.c	2008-04-15 14:40:10.504301019 +1000
@@ -17,6 +17,7 @@
  */
=20
 #include <xfs/libxlog.h>
+#include <sys/resource.h>
 #include "avl.h"
 #include "avl64.h"
 #include "globals.h"
@@ -66,12 +67,13 @@ char *o_opts[] =3D {
=20
 static int	ihash_option_used;
 static int	bhash_option_used;
+static long	max_mem_specified;	/* in megabytes */
=20
 static void
 usage(void)
 {
 	do_warn(
-_("Usage: %s [-nLvV] [-o subopt[=3Dvalue]] [-l logdev] [-r rtdev] devname\=
n"),
+_("Usage: %s [-nLvV] [-m memMB] [-o subopt[=3Dvalue]] [-l logdev] [-r rtde=
v] devname\n"),
 		progname);
 	exit(1);
 }
@@ -191,7 +193,7 @@ process_args(int argc, char **argv)
 	 * XXX have to add suboption processing here
 	 * attributes, quotas, nlinks, aligned_inos, sb_fbits
 	 */
-	while ((c =3D getopt(argc, argv, "o:fl:r:LnDvVdPMt:")) !=3D EOF)  {
+	while ((c =3D getopt(argc, argv, "o:fl:m:r:LnDvVdPt:")) !=3D EOF)  {
 		switch (c) {
 		case 'D':
 			dumpcore =3D 1;
@@ -222,6 +224,9 @@ process_args(int argc, char **argv)
 					ihash_option_used =3D 1;
 					break;
 				case BHASH_SIZE:
+					if (max_mem_specified)
+						do_abort(
+			_("-o bhash option cannot be used with -m option\n"));
 					libxfs_bhash_size =3D (int) strtol(val, 0, 0);
 					bhash_option_used =3D 1;
 					break;
@@ -245,6 +250,12 @@ process_args(int argc, char **argv)
 		case 'f':
 			isa_file =3D 1;
 			break;
+		case 'm':
+			if (bhash_option_used)
+				do_abort(_("-m option cannot be used with "
+						"-o bhash option\n"));
+			max_mem_specified =3D strtol(optarg, 0, 0);
+			break;
 		case 'L':
 			zap_log =3D 1;
 			break;
@@ -550,9 +561,10 @@ main(int argc, char **argv)
 	 * Calculations are done in kilobyte units.
 	 */
=20
-	if (!bhash_option_used) {
+	if (!bhash_option_used || max_mem_specified) {
 		unsigned long 	mem_used;
-		unsigned long	phys_mem;
+		unsigned long	max_mem;
+		struct rlimit	rlim;
=20
 		libxfs_icache_purge();
 		libxfs_bcache_purge();
@@ -560,27 +572,46 @@ main(int argc, char **argv)
 		cache_destroy(libxfs_bcache);
=20
 		mem_used =3D (mp->m_sb.sb_icount >> (10 - 2)) +
-					(mp->m_sb.sb_dblocks >> (10 + 1));
-		phys_mem =3D libxfs_physmem() * 3 / 4;
+					(mp->m_sb.sb_dblocks >> (10 + 1)) +
+					50000;	/* rough estimate of 50MB overhead */
+		max_mem =3D max_mem_specified ? max_mem_specified * 1024 :
+						libxfs_physmem() * 3 / 4;
+
+		if (getrlimit(RLIMIT_AS, &rlim) !=3D -1 &&
+					rlim.rlim_cur !=3D RLIM_INFINITY) {
+			rlim.rlim_cur =3D rlim.rlim_max;
+			setrlimit(RLIMIT_AS, &rlim);
+			/* use approximately 80% of rlimit to avoid overrun */
+			max_mem =3D MIN(max_mem, rlim.rlim_cur / 1280);
+		} else
+			max_mem =3D MIN(max_mem, (LONG_MAX >> 10) + 1);
=20
 		if (verbose > 1)
-			do_log(_("        - icount =3D %llu, imem =3D %lu, "
-				"dblock =3D %llu, dmem =3D %lu\n"),
-				mp->m_sb.sb_icount, mp->m_sb.sb_icount >> (10 - 2),
-				mp->m_sb.sb_dblocks, mp->m_sb.sb_dblocks >> (10 + 1));
+			do_log(_("        - max_mem =3D %lu, icount =3D %llu, "
+				"imem =3D %llu, dblock =3D %llu, dmem =3D %llu\n"),
+				max_mem, mp->m_sb.sb_icount,
+				mp->m_sb.sb_icount >> (10 - 2),
+				mp->m_sb.sb_dblocks,
+				mp->m_sb.sb_dblocks >> (10 + 1));
=20
-		if (phys_mem <=3D mem_used) {
+		if (max_mem <=3D mem_used) {
 			/*
 			 * Turn off prefetch and minimise libxfs cache if
 			 * physical memory is deemed insufficient
 			 */
+			if (max_mem_specified)
+				do_abort(_("Required memory for repair is "
+					"greater that the maximum specified "
+					"with the -m option. Please increase "
+					"it to at least %lu.\n"),
+					mem_used / 1024);
 			do_prefetch =3D 0;
 			libxfs_bhash_size =3D 64;
 		} else {
-			phys_mem -=3D mem_used;
-			if (phys_mem >=3D (1 << 30))
-				phys_mem =3D 1 << 30;
-			libxfs_bhash_size =3D phys_mem / (HASH_CACHE_RATIO *
+			max_mem -=3D mem_used;
+			if (max_mem >=3D (1 << 30))
+				max_mem =3D 1 << 30;
+			libxfs_bhash_size =3D max_mem / (HASH_CACHE_RATIO *
 					(mp->m_inode_cluster_size >> 10));
 			if (libxfs_bhash_size < 512)
 				libxfs_bhash_size =3D 512;

------------nuEYvAlzxPzV5q6YnEGIv6--
