Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BBD867F37
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 03:22:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 503BEAC007
	for <xfs@oss.sgi.com>; Wed, 30 Sep 2015 01:22:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tJBdanOhG66baHsK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Sep 2015 01:22:00 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/14 v2] xfsprogs: Add statvfs64 for osx
Date: Wed, 30 Sep 2015 10:21:55 +0200
Message-Id: <1443601315-774-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-12-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-12-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

UPDATE:
- removing unnecessary include lines (again)

Simply rename statvfs64 to statfs with a #define.
OSX version of statvfs is missing some members, so if the renaming
is in effect (stavfs64 is defined), don't try to use them and go
directly for the other member value.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 fsr/xfs_fsr.c        | 8 ++++++++
 include/builddefs.in | 2 +-
 include/darwin.h     | 5 +++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index e1b7bd6..c8ef18f 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -948,7 +948,11 @@ fsrfile_common(
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
@@ -1728,7 +1732,11 @@ xfs_getrt(int fd, struct statvfs64 *sfbp)
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
2.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
