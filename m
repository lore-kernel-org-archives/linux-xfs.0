Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 75A2629DF6
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B3A18F8049
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id okoGfFtkxZg4sZtF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:53 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 09/11] xfsprogs: Add statvfs64 for osx
Date: Wed, 26 Aug 2015 14:02:33 +0200
Message-Id: <1440590555-20463-9-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-1-git-send-email-jtulak@redhat.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
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

Use dummy stuff. It is used only in xfs_fsr, so it is not a big issue.
However, there is a part of an attempted solution to translate it to
OS X variant - statfs.

OS X statfs is missing f_frsize member in the struct, so its use would
require some #ifdef in fsr code. Because of this, the dummy stuff is used.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/xfs_fsr.c        |  6 ++++++
 include/builddefs.in |  2 +-
 include/darwin.h     | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index e1b7bd6..b7ac1b2 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -36,6 +36,12 @@
 #  include <mntent.h>
 #endif
 
+#ifdef __APPLE__
+//#  define statvfs64 statfs;
+#  include <sys/param.h>
+#  include <sys/mount.h>
+#endif
+
 #ifndef XFS_XFLAG_NODEFRAG
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
 #endif
diff --git a/include/builddefs.in b/include/builddefs.in
index 25b8816..31e21ba 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -123,7 +123,7 @@ PCFLAGS = -D_GNU_SOURCE $(GCCFLAGS)
 endif
 ifeq ($(PKG_PLATFORM),darwin)
 PCFLAGS = $(GCCFLAGS)
-DEPENDFLAGS = -D__APPLE__
+DEPENDFLAGS = -D__APPLE__ -D_DARWIN_FEATURE_64_BIT_INODE
 endif
 ifeq ($(PKG_PLATFORM),irix)
 PLDLIBS = -ldisk -lgen
diff --git a/include/darwin.h b/include/darwin.h
index f5f28df..c8fcb3c 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -217,4 +217,37 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 	return getitimer(ITIMER_REAL, value);
 }
 
+/* FSR */
+
+//#define statvfs64 statfs
+#define		_PATH_MOUNTED   "/etc/mtab"
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
+static inline int statvfs64 (const char *__restrict __file,
+							 struct statfs *__restrict __buf)
+{
+	return 0;
+}
+
 #endif	/* __XFS_DARWIN_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
