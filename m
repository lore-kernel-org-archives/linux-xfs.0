Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C4B877CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 09:54:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8508C304032
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:54:16 -0700 (PDT)
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66]) by
	cuda.sgi.com with ESMTP id WAkQL21AZkT2L4Dg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 07:54:13 -0700 (PDT)
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 6EB19209B7
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:54:10 +0200 (CEST)
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 3rX0WM3N82zyfr
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 16:54:07 +0200 (CEST)
Date: Sat, 18 Jun 2016 16:52:53 +0200
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 2/4] Simplify workaround for old glibc getsubopt()
Message-ID: <20160618145253.GB17768@nyan>
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

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/darwin.h      |  1 -
 include/freebsd.h     |  2 --
 include/gnukfreebsd.h |  2 --
 include/irix.h        |  2 --
 include/linux.h       |  4 +---
 mkfs/xfs_mkfs.c       | 16 ++++++++--------
 repair/xfs_repair.c   |  4 ++--
 7 files changed, 11 insertions(+), 20 deletions(-)

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
index b94de81..f6d0f80 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -133,9 +133,7 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 }
 
 #if (__GLIBC__ < 2) || ((__GLIBC__ == 2) && (__GLIBC_MINOR__ <= 1))
-# define constpp	const char * const *
-#else
-# define constpp	char * const *
+# define getsubopt(p, s, v)	getsubopt(p, (const char * const *)s, v)
 #endif
 
 #define ENOATTR		ENODATA	/* Attribute not found */
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 955dcfd..99c5eb5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1829,7 +1829,7 @@ main(
 				char	**subopts = (char **)bopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case B_LOG:
 					blocklog = getnum(value, &bopts, B_LOG);
@@ -1853,7 +1853,7 @@ main(
 				char	**subopts = (char **)dopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case D_AGCOUNT:
 					agcount = getnum(value, &dopts,
@@ -1933,7 +1933,7 @@ main(
 				char	**subopts = (char **)iopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case I_ALIGN:
 					sb_feat.inode_align = getnum(value,
@@ -1983,7 +1983,7 @@ main(
 				char	**subopts = (char **)lopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case L_AGNUM:
 					logagno = getnum(value, &lopts, L_AGNUM);
@@ -2055,7 +2055,7 @@ main(
 				char	**subopts = (char **)mopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case M_CRC:
 					sb_feat.crcs_enabled =
@@ -2084,7 +2084,7 @@ main(
 				char	**subopts = (char **)nopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case N_LOG:
 					dirblocklog = getnum(value, &nopts,
@@ -2140,7 +2140,7 @@ main(
 				char	**subopts = (char **)ropts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case R_EXTSIZE:
 					rtextsize = getstr(value, &ropts,
@@ -2173,7 +2173,7 @@ main(
 				char	**subopts = (char **)sopts.subopts;
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)subopts,
+				switch (getsubopt(&p, subopts,
 						  &value)) {
 				case S_LOG:
 				case S_SECTLOG:
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9d91f2d..5a433ed 100644
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
