Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A078D7F96
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BCD5304064
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vIbriqlWzAK2kDaE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:35 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2 11/11] xfsprogs: Prefix LIST_... macros to XFS_LIST_...
Date: Mon,  3 Aug 2015 16:39:49 +0200
Message-Id: <1438612789-17486-12-git-send-email-jtulak@redhat.com>
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

OS X has two conflicting LIST_ macros:
  - LIST_HEAD
  - LIST_HEAD_INIT

These results in tons of warnings like:

In file included from init.c:22:
In file included from ./libxfs_priv.h:63:
../include/xfs/list.h:32:9: warning: 'LIST_HEAD' macro redefined
[-Wmacro-redefined]
\#define LIST_HEAD(name) \

These macros are included from sys/queue.h through
sys/mount.h and possibly through more system libraries.
So far, I didn't found a way how to prevent the inclusion.

Attempted solution was to avoid including with
-D_SYS_QUEUE_H_ for the compiler, but this resulted in
another error:

In file included from crc32.c:36:
In file included from ../include/xfs/platform_defs.h:79:
In file included from ../include/xfs/darwin.h:26:
In file included from /usr/include/sys/mount.h:76:
In file included from /usr/include/sys/attr.h:42:
/usr/include/sys/ucred.h:90:2: error: type name requires a specifier or
qualifier
TAILQ_ENTRY(ucred)      cr_link; /* never modify this without KAUTH_CRE...

I tried renaming. This works, but it doesn't look like
a good solution. So this patch is still not final.

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
