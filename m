Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0819E7FF7
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 05:15:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7A5D6AC00B
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 03:15:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id fFZxN3awfc2lRMOT (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 03:15:46 -0700 (PDT)
Received: from [88.128.80.19] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZAy0S-0003pz-GL
	for xfs@oss.sgi.com; Fri, 03 Jul 2015 10:15:46 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/13] xfsprogs: remove the constpp define
Date: Fri,  3 Jul 2015 12:12:21 +0200
Message-Id: <1435918341-10128-14-git-send-email-hch@lst.de>
In-Reply-To: <1435918341-10128-1-git-send-email-hch@lst.de>
References: <1435918341-10128-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a workaround for the long obsolete glibc 2.0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h      |  1 -
 include/freebsd.h     |  2 --
 include/gnukfreebsd.h |  2 --
 include/irix.h        |  2 --
 include/linux.h       |  6 ------
 mkfs/xfs_mkfs.c       | 16 ++++++++--------
 repair/xfs_repair.c   |  4 ++--
 7 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index abdf4e3..fe533a2 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -154,7 +154,6 @@ typedef int64_t		xfs_daddr_t;
 #define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
-#define constpp		char * const *
 
 #define HAVE_FID	1
 
diff --git a/include/freebsd.h b/include/freebsd.h
index 902b940..6c51d3f 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -42,8 +42,6 @@
 #define fdatasync	fsync
 #define memalign(a,sz)	valloc(sz)
 
-#define constpp	char * const *
-
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 95c4c13..6686b86 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -32,8 +32,6 @@
 #include <libgen.h>
 #include <paths.h>
 
-#define constpp	char * const *
-
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 
diff --git a/include/irix.h b/include/irix.h
index 28564c8..806c94f 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -183,8 +183,6 @@ typedef struct xfs_efd_log_format_32 {
 #define inline		__inline
 #endif
 
-#define constpp		char * const *
-
 /*ARGSUSED*/
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *arg)
 {
diff --git a/include/linux.h b/include/linux.h
index 8804c2d..596dab4 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -130,12 +130,6 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
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
index 80cdd10..95f29f3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1086,7 +1086,7 @@ main(
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)bopts, &value)) {
+				switch (getsubopt(&p, bopts, &value)) {
 				case B_LOG:
 					if (!value || *value == '\0')
 						reqval('b', bopts, B_LOG);
@@ -1127,7 +1127,7 @@ main(
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)dopts, &value)) {
+				switch (getsubopt(&p, dopts, &value)) {
 				case D_AGCOUNT:
 					if (!value || *value == '\0')
 						reqval('d', dopts, D_AGCOUNT);
@@ -1304,7 +1304,7 @@ main(
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)iopts, &value)) {
+				switch (getsubopt(&p, iopts, &value)) {
 				case I_ALIGN:
 					if (!value || *value == '\0')
 						value = "1";
@@ -1407,7 +1407,7 @@ main(
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)lopts, &value)) {
+				switch (getsubopt(&p, lopts, &value)) {
 				case L_AGNUM:
 					if (!value || *value == '\0')
 						reqval('l', lopts, L_AGNUM);
@@ -1555,7 +1555,7 @@ main(
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)mopts, &value)) {
+				switch (getsubopt(&p, mopts, &value)) {
 				case M_CRC:
 					if (!value || *value == '\0')
 						reqval('m', mopts, M_CRC);
@@ -1588,7 +1588,7 @@ _("cannot specify both crc and ftype\n"));
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)nopts, &value)) {
+				switch (getsubopt(&p, nopts, &value)) {
 				case N_LOG:
 					if (!value || *value == '\0')
 						reqval('n', nopts, N_LOG);
@@ -1672,7 +1672,7 @@ _("cannot specify both crc and ftype\n"));
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)ropts, &value)) {
+				switch (getsubopt(&p, ropts, &value)) {
 				case R_EXTSIZE:
 					if (!value || *value == '\0')
 						reqval('r', ropts, R_EXTSIZE);
@@ -1717,7 +1717,7 @@ _("cannot specify both crc and ftype\n"));
 			while (*p != '\0') {
 				char	*value;
 
-				switch (getsubopt(&p, (constpp)sopts, &value)) {
+				switch (getsubopt(&p, sopts, &value)) {
 				case S_LOG:
 				case S_SECTLOG:
 					if (!value || *value == '\0')
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index db703d0..9518812 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -224,7 +224,7 @@ process_args(int argc, char **argv)
 			while (*p != '\0')  {
 				char *val;
 
-				switch (getsubopt(&p, (constpp)o_opts, &val))  {
+				switch (getsubopt(&p, o_opts, &val))  {
 				case ASSUME_XFS:
 					if (val)
 						noval('o', o_opts, ASSUME_XFS);
@@ -275,7 +275,7 @@ process_args(int argc, char **argv)
 			while (*p) {
 				char *val;
 
-				switch (getsubopt(&p, (constpp)c_opts, &val)) {
+				switch (getsubopt(&p, c_opts, &val)) {
 				case CONVERT_LAZY_COUNT:
 					lazy_count = (int)strtol(val, NULL, 0);
 					convert_lazy_count = 1;
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
