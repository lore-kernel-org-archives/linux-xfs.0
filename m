Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 594B47F81
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 456C9304059
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o71BOAUIEl2RqMHF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:28 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 06/11] xfsprogs: Add includes required for OS X builds
Date: Mon,  3 Aug 2015 16:39:44 +0200
Message-Id: <1438612789-17486-7-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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
 include/darwin.h | 5 +++++
 libdisk/fstype.c | 1 +
 2 files changed, 6 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 30f0052..2b470b4 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -24,6 +24,11 @@
 #include <sys/stat.h>
 #include <sys/ioctl.h>
 #include <sys/mount.h>
+#include <sys/types.h>
+#include <ftw.h>
+#include <mach/mach_time.h>
+#include <inttypes.h>
+#include <stdio.h>
 
 #include <machine/endian.h>
 #define __BYTE_ORDER	BYTE_ORDER
diff --git a/libdisk/fstype.c b/libdisk/fstype.c
index 548f297..c8bde34 100644
--- a/libdisk/fstype.c
+++ b/libdisk/fstype.c
@@ -22,6 +22,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/types.h>
 #include "fstype.h"
 
 /*
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
