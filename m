Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50520 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbfHIVi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYVck071898
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:26 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4yp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcObP112194
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcNUs019449
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:23 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v1 18/19] xfsprogs: Add delayed attributes error tag
Date: Fri,  9 Aug 2019 14:38:03 -0700
Message-Id: <20190809213804.32628-19-allison.henderson@oracle.com>
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index cabfc3e..05bd4db 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -54,6 +54,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
 		{ XFS_ERRTAG_IUNLINK_FALLBACK,		"iunlink_fallback" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 79e6c4f..85d5850 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -55,7 +55,8 @@
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
 #define XFS_ERRTAG_IUNLINK_FALLBACK			34
-#define XFS_ERRTAG_MAX					35
+#define XFS_ERRTAG_DELAYED_ATTR				35
+#define XFS_ERRTAG_MAX					36
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -95,5 +96,6 @@
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
 #define XFS_RANDOM_IUNLINK_FALLBACK			(XFS_RANDOM_DEFAULT/10)
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4
