Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 928EF7F37
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 09:24:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7F45D304048
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2015 07:24:34 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tMuh3b2gCMnt1U1O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 08 Sep 2015 07:24:33 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 09/11 v2] xfsprogs: Add statvfs64 for osx
Date: Tue,  8 Sep 2015 16:24:23 +0200
Message-Id: <1441722263-9194-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-9-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-9-git-send-email-jtulak@redhat.com>
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

Simply rename statvfs64 to statfs with a #define.

CHANGE:
remove dummy code, add rename

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/xfs_fsr.c        | 14 ++++++++++++++
 include/builddefs.in |  2 +-
 include/darwin.h     |  5 +++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index e1b7bd6..5f95cdc 100644
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
@@ -948,7 +954,11 @@ fsrfile_common(
 			fname, strerror(errno));
 		return -1;
 	}
+#ifndef statvfs64
 	bsize = vfss.f_frsize ? vfss.f_frsize : vfss.f_bsize;
+#else
+	bsize = vfss.f_bsize;
+#endif
 	if (statp->bs_blksize * statp->bs_blocks >
 	    vfss.f_bfree * bsize - minimumfree) {
 		fsrprintf(_("insufficient freespace for: %s: "
@@ -1728,7 +1738,11 @@ xfs_getrt(int fd, struct statvfs64 *sfbp)
 		close(fd);
 		return -1;
 	}
+#ifndef statvfs64
 	bsize = (sfbp->f_frsize ? sfbp->f_frsize : sfbp->f_bsize);
+#else
+	bsize = sfbp->f_bsize;
+#endif
 	factor = fsgeom.blocksize / bsize;         /* currently this is == 1 */
 	sfbp->f_bfree = (cnt.freertx * fsgeom.rtextsize) * factor;
 	return 0;
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
index 0d2f175..288ad1f 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -216,4 +216,9 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 	return getitimer(ITIMER_REAL, value);
 }
 
+/* FSR */
+
+#define statvfs64 statfs
+#define		_PATH_MOUNTED   "/etc/mtab"
+
 #endif	/* __XFS_DARWIN_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
