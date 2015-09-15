Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B7A257F8D
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A9B88304051
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:53 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id iK0bl3OunDv9JRp6 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:52 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 3B7DC8E3E9
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:52 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 14/14] xfsprogs: rename lstat64 to lstat for OS X
Date: Tue, 15 Sep 2015 11:59:24 +0200
Message-Id: <1442311164-12921-15-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
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

OS X has a different means to distinguish between
a 32 and 64bit calls - using xxx64 is deprecated.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/darwin.h b/include/darwin.h
index 16ead12..4ad2de1 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -224,6 +224,7 @@ static inline int timer_gettime (timer_t timerid, struct itimerspec *value)
 #include <sys/ucred.h>
 #include <errno.h>
 #define statvfs64 statfs
+#define lstat64 lstat
 #define		_PATH_MOUNTED   "/etc/mtab"
 
 struct mntent
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
