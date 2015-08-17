Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0AE4529E0A
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D4397304051
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id l03lHRWmy1mQl6KE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:52 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/11] xfsprogs: missing and dummy calls for OS X support
Date: Mon, 17 Aug 2015 18:23:20 +0200
Message-Id: <1439828606-7886-6-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Add and update various API, macros and types where is some change
in OS X or xfsprogs. Most changes are in darwin.h.

Add dummy implementations where native support is nonexistent
and the tools are not expected to work anyway, so all tools can be
at least compiled.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fsr/xfs_fsr.c    |   8 +++
 include/darwin.h | 153 +++++++++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 145 insertions(+), 16 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 7c1d776..b4ff136 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -43,6 +43,14 @@
 #define _PATH_FSRLAST		"/var/tmp/.fsrlast_xfs"
 #define _PATH_PROC_MOUNTS	"/proc/mounts"
 
+#ifdef USE_DUMMY_XATTR
+	/* OS X has fsetxattr with different number of arguments.
+	 * Because it won't work anyway (no fstab/mtab and so on),
+	 * hijack the call to a dummy function so it can at least
+	 * compile.
+	 */
+#  define fsetxattr(a,b,c,d,e) dummy_fsetxattr(a,b,c,d,e)
+#endif
 
 char *progname;
 
diff --git a/include/darwin.h b/include/darwin.h
index 8b5a661..775dfc8 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -76,45 +76,37 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	return uuid_compare(uu1, uu2, NULL);
+	return uuid_compare((const unsigned char *) uu1, (const unsigned char*) uu2);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	uint32_t status;
-	char *s;
-	uuid_to_string(uu, &s, &status);
-	if (status == uuid_s_ok)
-		strcpy(buffer, s);
-	else buffer[0] = '\0';
-	free(s);
+	uuid_unparse(*uu, buffer);
 }
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	uint32_t status;
-	uuid_from_string(buffer, uu, &status);
-	return (status == uuid_s_ok);
+	return uuid_parse(buffer, *uu);
 }
 
 static __inline__ int platform_uuid_is_null(uuid_t *uu)
 {
-	return uuid_is_nil(uu, NULL);
+	return uuid_is_null(*uu);
 }
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	uuid_create(uu, NULL);
+	uuid_generate(*uu);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	uuid_create_nil(uu, NULL);
+	uuid_clear(*uu);
 }
 
 static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 {
-	memcpy(dst, src, sizeof(uuid_t));
+	uuid_copy(*dst, *src);
 }
 
 typedef unsigned char		__u8;
@@ -159,11 +151,13 @@ typedef int64_t		xfs_daddr_t;
 #define O_SYNC          0
 #endif
 
-#define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
 
+#define XATTR_SIZE_MAX 65536    /* size of an extended attribute value (64k) */
+#define XATTR_LIST_MAX 65536    /* size of extended attribute namelist (64k) */
+
 #define HAVE_FID	1
 
 static __inline__ int
@@ -172,4 +166,131 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+
+/*
+ * Dummy POSIX timer replacement
+ */
+#define CLOCK_REALTIME 1
+typedef uint64_t timer_t;
+typedef double   timer_c;
+typedef clock_id_t clockid_t;
+struct itimerspec
+  {
+    struct timespec it_interval;
+    struct timespec it_value;
+  };
+
+static inline int timer_create (clockid_t __clock_id,
+                         struct sigevent *__restrict __evp,
+                         timer_t *__restrict __timerid)
+{
+	return 0;
+}
+
+static inline int timer_settime (timer_t __timerid, int __flags,
+                          const struct itimerspec *__restrict __value,
+                          struct itimerspec *__restrict __ovalue)
+{
+	return 0;
+}
+
+static inline int timer_delete (timer_t __timerid)
+{
+	return 0;
+}
+
+static inline int timer_gettime (timer_t __timerid, struct itimerspec *__value)
+{
+	return 0;
+}
+
+static inline int nftw64(const char *path, int (*fn)(const char *, const struct stat *ptr, int flag, struct FTW *), int depth,
+         int flags)
+{
+	return nftw(path, fn, depth, flags);
+}
+
+#define MREMAP_FIXED 1
+#define MREMAP_MAYMOVE 2
+static inline void *mremap(void *old_address, size_t old_size,
+                    size_t new_size, int flags, ... /* void *new_address */)
+{
+	return NULL;
+}
+
+/* FSR */
+
+#define		_PATH_MOUNTED   "/etc/mtab"
+#define		USE_DUMMY_XATTR
+
+typedef int __fsblkcnt_t;
+typedef int __fsfilcnt_t;
+typedef long long int __fsblkcnt64_t;
+typedef long long int __fsfilcnt64_t;
+
+struct statvfs64
+{
+	unsigned long int f_bsize;
+	unsigned long int f_frsize;
+	__fsblkcnt64_t f_blocks;
+	__fsblkcnt64_t f_bfree;
+	__fsblkcnt64_t f_bavail;
+	__fsfilcnt64_t f_files;
+	__fsfilcnt64_t f_ffree;
+	__fsfilcnt64_t f_favail;
+	unsigned long int f_fsid;
+	int __f_unused;
+	unsigned long int f_flag;
+	unsigned long int f_namemax;
+	int __f_spare[6];
+};
+
+struct mntent
+{
+	char *mnt_fsname;		/* Device or server for filesystem.  */
+	char *mnt_dir;		/* Directory mounted on.  */
+	char *mnt_type;		/* Type of filesystem: ufs, nfs, etc.  */
+	char *mnt_opts;		/* Comma-separated options for fs.  */
+	int mnt_freq;		/* Dump frequency (in days).  */
+	int mnt_passno;		/* Pass number for `fsck'.  */
+};
+
+static inline FILE *setmntent(const char *filename, const char *type)
+{
+	return NULL;
+}
+
+static inline int endmntent(FILE *fp)
+{
+	return 0;
+}
+
+static inline struct mntent *getmntent(FILE *fp)
+{
+	return NULL;
+}
+
+static inline int addmntent(FILE *fp, const struct mntent *mnt)
+{
+	return 0;
+}
+
+static inline char *hasmntopt(const struct mntent *mnt, const char *opt)
+{
+	return NULL;
+}
+
+static inline int statvfs64 (const char *__restrict __file, 
+							 struct statvfs64 *__restrict __buf)
+{
+	return 0;
+}
+
+static inline int dummy_fsetxattr (int filedes, const char *name,
+                       const void *value, size_t size, int flags)
+{
+	return 0;
+}
+
+
 #endif	/* __XFS_DARWIN_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
