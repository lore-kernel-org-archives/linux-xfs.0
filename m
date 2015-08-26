Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 83A7E29E01
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 707118F8049
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PLYAkhH7DX7vno4Z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:52 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/11] xfsprogs: Add a timer implementation for OS X
Date: Wed, 26 Aug 2015 14:02:32 +0200
Message-Id: <1440590555-20463-8-git-send-email-jtulak@redhat.com>
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

OS X does not have the timer used in xfs_repair.
Add a simple implementation providing the required
capabilities.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h  | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 repair/progress.c | 16 ++++++++++++++--
 2 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index 94e7551..f5f28df 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -28,6 +28,7 @@
 #include <sys/ioctl.h>
 #include <sys/mount.h>
 #include <sys/types.h>
+#include <sys/time.h>
 #include <ftw.h>
 #include <mach/mach_time.h>
 #include <inttypes.h>
@@ -169,4 +170,51 @@ static inline int nftw64(const char *path, int (*fn)(const char *, const struct
 	return nftw(path, fn, depth, flags);
 }
 
+/*
+ * POSIX timer replacement.
+ * It really just do the minimum we need for xfs_repair.
+ * Also, as setitimer can't create multiple timers,
+ * the timerid things are useless - we have only one ITIMER_REAL
+ * timer.
+ */
+#define CLOCK_REALTIME ITIMER_REAL
+#define itimerspec itimerval
+typedef uint64_t timer_t;
+typedef double   timer_c;
+typedef clock_id_t clockid_t;
+
+
+static inline int timer_create (clockid_t __clock_id,
+                         struct sigevent *__restrict __evp,
+                         timer_t *__restrict timer)
+{
+	// set something, to initialize the variable, just in case
+	*timer = 0;
+	return 0;
+}
+
+static inline int timer_settime (timer_t timerid, int flags,
+                          const struct itimerspec *__restrict timerspec,
+                          struct itimerspec *__restrict ovalue)
+{
+	return setitimer(ITIMER_REAL, timerspec, ovalue);
+}
+
+static inline int timer_delete (timer_t timerid)
+{
+	struct itimerspec timespec;
+
+	timespec.it_interval.tv_sec=0;
+	timespec.it_interval.tv_usec=0;
+	timespec.it_value.tv_sec=0;
+	timespec.it_value.tv_usec=0;
+
+	return setitimer(ITIMER_REAL, &timespec, NULL);
+}
+
+static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
+{
+	return getitimer(ITIMER_REAL, value);
+}
+
 #endif	/* __XFS_DARWIN_H__ */
diff --git a/repair/progress.c b/repair/progress.c
index 27cbaef..0fee7dc 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -184,10 +184,22 @@ progress_rpt_thread (void *p)
 	 */
 
 	timespec.it_value.tv_sec = msgp->interval;
-	timespec.it_value.tv_nsec = 0;
 	timespec.it_interval.tv_sec = msgp->interval;
+	/*
+	 * On some platforms (like OS X), timers and time things are slightly
+	 * different: itimerspec is replaced with itimerval and timeval struct
+	 * has no tv_nsec, but just tv_usec member.
+	 * For compatibility, itimerspec is a macro defined to the existing
+	 * itimerval on these platforms, and in such case, use usec instead
+	 * of nsec.
+	 */
+#ifndef itimerspec
+	timespec.it_value.tv_nsec = 0;
 	timespec.it_interval.tv_nsec = 0;
-
+#else
+	timespec.it_value.tv_usec = 0;
+	timespec.it_interval.tv_usec = 0;
+#endif
 	if (timer_create (CLOCK_REALTIME, NULL, &timerid))
 		do_error(_("progress_rpt: cannot create timer\n"));
 
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
