Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbeIZQiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANuOC073253
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mnd5thjs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPouY027414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPoNN018441
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:50 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 23/30] xfs_io: Add delayed attributes error tag
Date: Wed, 26 Sep 2018 03:23:26 -0700
Message-Id: <1537957413-10630-24-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds an error tag that we can use to test
delayed attribute recovery and replay

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 io/inject.c           | 1 +
 libxfs/xfs_errortag.h | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/io/inject.c b/io/inject.c
index 2061c95..8711bdb 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -53,6 +53,7 @@ error_tag(char *name)
 		{ XFS_ERRTAG_BUF_LRU_REF,		"buf_lru_ref" },
 		{ XFS_ERRTAG_FORCE_SCRUB_REPAIR,	"force_repair" },
 		{ XFS_ERRTAG_FORCE_SUMMARY_RECALC,	"bad_summary" },
+		{ XFS_ERRTAG_DELAYED_ATTR,		"delayed_attr" },
 		{ XFS_ERRTAG_MAX,			NULL }
 	};
 	int	count;
diff --git a/libxfs/xfs_errortag.h b/libxfs/xfs_errortag.h
index 66077a1..5cd408d 100644
--- a/libxfs/xfs_errortag.h
+++ b/libxfs/xfs_errortag.h
@@ -54,7 +54,8 @@
 #define XFS_ERRTAG_BUF_LRU_REF				31
 #define XFS_ERRTAG_FORCE_SCRUB_REPAIR			32
 #define XFS_ERRTAG_FORCE_SUMMARY_RECALC			33
-#define XFS_ERRTAG_MAX					34
+#define XFS_ERRTAG_DELAYED_ATTR				34
+#define XFS_ERRTAG_MAX					35
 
 /*
  * Random factors for above tags, 1 means always, 2 means 1/2 time, etc.
@@ -93,5 +94,6 @@
 #define XFS_RANDOM_BUF_LRU_REF				2
 #define XFS_RANDOM_FORCE_SCRUB_REPAIR			1
 #define XFS_RANDOM_FORCE_SUMMARY_RECALC			1
+#define XFS_RANDOM_DELAYED_ATTR				1
 
 #endif /* __XFS_ERRORTAG_H_ */
-- 
2.7.4
