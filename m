Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 992FB29E0B
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1FBD7AC001
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NHvMxC3Repk7GVm6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:56 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 11/11] xfsprogs: add dummy mremap for OS X
Date: Wed, 26 Aug 2015 14:02:35 +0200
Message-Id: <1440590555-20463-11-git-send-email-jtulak@redhat.com>
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

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index d47c96c..2e16f65 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -33,6 +33,7 @@
 #include <mach/mach_time.h>
 #include <inttypes.h>
 #include <stdio.h>
+#include <sys/mman.h>
 
 #include <machine/endian.h>
 #define __BYTE_ORDER	BYTE_ORDER
@@ -217,6 +218,14 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 	return getitimer(ITIMER_REAL, value);
 }
 
+#define MREMAP_FIXED 1
+#define MREMAP_MAYMOVE 2
+static inline void *mremap(void *old_address, size_t old_size,
+                    size_t new_size, int flags, ...)
+{
+	return MAP_FAILED;
+}
+
 /* FSR */
 
 //#define statvfs64 statfs
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
