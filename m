Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DDD1F7F55
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 07:57:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8442CAC007
	for <xfs@oss.sgi.com>; Mon, 20 Jul 2015 05:57:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id H6Tcc1okttZpSJBV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jul 2015 05:57:08 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 1/4] xfsprogs: Prefix LIST_... macros to XFS_LIST_...
Date: Mon, 20 Jul 2015 14:56:55 +0200
Message-Id: <1437397018-12864-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
References: <1437397018-12864-1-git-send-email-jtulak@redhat.com>
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

OS X has some conflicting LIST_ macros, so prefix the XFS ones.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/list.h  | 6 +++---
 repair/phase6.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/list.h b/include/list.h
index 3f087a4..7e9f748 100644
--- a/include/list.h
+++ b/include/list.h
@@ -27,10 +27,10 @@ struct list_head {
 	struct list_head *prev;
 };
 
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
+#define XFS_LIST_HEAD_INIT(name) { &(name), &(name) }
 
-#define LIST_HEAD(name) \
-		struct list_head name = LIST_HEAD_INIT(name)
+#define XFS_LIST_HEAD(name) \
+		struct list_head name = XFS_LIST_HEAD_INIT(name)
 
 #define INIT_LIST_HEAD(list) list_head_init(list)
 static inline void list_head_init(struct list_head *list)
diff --git a/repair/phase6.c b/repair/phase6.c
index 9a5cba7..87732e1 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -49,7 +49,7 @@ typedef struct dotdot_update {
 	int			ino_offset;
 } dotdot_update_t;
 
-static LIST_HEAD(dotdot_update_list);
+static XFS_LIST_HEAD(dotdot_update_list);
 static int			dotdot_update;
 
 static void
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
