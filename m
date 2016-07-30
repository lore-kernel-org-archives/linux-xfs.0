Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DD5E37CA1
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 08:37:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id ADA4230405F
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 06:37:44 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id CKqdYEfpz3DNKpR5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 30 Jul 2016 06:37:41 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id D493320BB6
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 15:37:38 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3s1mqk2YYdz104Q
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2016 15:37:38 +0200 (CEST)
Date: Sat, 30 Jul 2016 15:37:25 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH xfsprogs 1/2] Remove workaround for getsubopt() on <glibc-2.2
Message-ID: <20160730133725.GA5895@nyan>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The workaround addressed only a const-correctness warning.
It was wrongly applied also to alternative c libraries on linux.

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/darwin.h      |  1 -
 include/freebsd.h     |  2 --
 include/gnukfreebsd.h |  2 --
 include/irix.h        |  2 --
 include/linux.h       |  6 ------
 mkfs/xfs_mkfs.c       | 24 ++++++++----------------
 repair/xfs_repair.c   |  4 ++--
 7 files changed, 10 insertions(+), 31 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index a52030d..45e0c03 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -160,7 +160,6 @@ typedef int64_t		xfs_daddr_t;
 
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
-#define constpp		char * const *
 
 #define HAVE_FID	1
 
diff --git a/include/freebsd.h b/include/freebsd.h
index f7e0c75..6e77427 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -43,8 +43,6 @@
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
-#define constpp	char * const *
-
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 64167b2..d55acfb 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -33,8 +33,6 @@
 #include <paths.h>
 #include <mntent.h>
 
-#define constpp	char * const *
-
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 
diff --git a/include/irix.h b/include/irix.h
index c2191ee..b92e01b 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -184,8 +184,6 @@ typedef struct xfs_efd_log_format_32 {
 #define inline		__inline
 #endif
 
-#define constpp		char * const *
-
 /*ARGSUSED*/
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *arg)
 {
diff --git a/include/linux.h b/include/linux.h
index 0c616f4..5614719 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -133,12 +133,6 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
-#if (__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1))
-# define constpp	const char * const *
-#else
-# define constpp	char * const *
-#endif
-
 #define ENOATTR		ENODATA	/* Attribute not found */
 #define EFSCORRUPTED	EUCLEAN	/* Filesystem is corrupted */
 #define EFSBADCRC	EBADMSG	/* Bad CRC detected */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8007dd0..8b02983 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1521,8 +1521,7 @@ main(
 				char	**subopts = (char **)bopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case B_LOG:
 					blocklog = getnum(value, &bopts, B_LOG);
 					blocksize = 1 << blocklog;
@@ -1545,8 +1544,7 @@ main(
 				char	**subopts = (char **)dopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case D_AGCOUNT:
 					agcount = getnum(value, &dopts,
 							 D_AGCOUNT);
@@ -1625,8 +1623,7 @@ main(
 				char	**subopts = (char **)iopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case I_ALIGN:
 					sb_feat.inode_align = getnum(value,
 								&iopts, I_ALIGN);
@@ -1675,8 +1672,7 @@ main(
 				char	**subopts = (char **)lopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case L_AGNUM:
 					logagno = getnum(value, &lopts, L_AGNUM);
 					laflag = 1;
@@ -1747,8 +1743,7 @@ main(
 				char	**subopts = (char **)mopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
 						getnum(value, &mopts, M_CRC);
@@ -1776,8 +1771,7 @@ main(
 				char	**subopts = (char **)nopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case N_LOG:
 					dirblocklog = getnum(value, &nopts,
 							     N_LOG);
@@ -1832,8 +1826,7 @@ main(
 				char	**subopts = (char **)ropts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case R_EXTSIZE:
 					rtextsize = getstr(value, &ropts,
 							   R_EXTSIZE);
@@ -1865,8 +1858,7 @@ main(
 				char	**subopts = (char **)sopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
-						  &value)) {
+				switch (getsubopt(&p, subopts, &value)) {
 				case S_LOG:
 				case S_SECTLOG:
 					if (lssflag)
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index bbf0edc..50a1ac9 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -225,7 +225,7 @@ process_args(int argc, char **argv)
 			while (*p != '\0')  {
 				char *val;
 
-				switch (getsubopt(&p, (constpp)o_opts, &val))  {
+				switch (getsubopt(&p, o_opts, &val))  {
 				case ASSUME_XFS:
 					if (val)
 						noval('o', o_opts, ASSUME_XFS);
@@ -276,7 +276,7 @@ process_args(int argc, char **argv)
 			while (*p) {
 				char *val;
 
-				switch (getsubopt(&p, (constpp)c_opts, &val)) {
+				switch (getsubopt(&p, c_opts, &val)) {
 				case CONVERT_LAZY_COUNT:
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
-- 
2.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
