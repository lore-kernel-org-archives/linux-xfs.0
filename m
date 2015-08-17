Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C90EF7F4E
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A92A28F8040
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nog1WKu4npE3N2PT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:51 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 04/11] xfsprogs: Add includes required for OS X builds
Date: Mon, 17 Aug 2015 18:23:19 +0200
Message-Id: <1439828606-7886-5-git-send-email-jtulak@redhat.com>
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

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index abdf4e3..8b5a661 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -18,12 +18,20 @@
 #ifndef __XFS_DARWIN_H__
 #define __XFS_DARWIN_H__
 
+#include <unistd.h>
+#include <sys/types.h>
+#include <string.h>
 #include <uuid/uuid.h>
 #include <libgen.h>
 #include <sys/vm.h>
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
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
