Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B9EC17F7C
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 07:46:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9A062304048
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 05:46:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id udLePoglUZUlLXxP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Jul 2015 05:46:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 4E75FBC916
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 12:46:55 +0000 (UTC)
Received: from jtulak-t430.brq.redhat.com (jtulak.brq.redhat.com [10.34.1.5])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id t6FCkr9o023337
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2015 08:46:54 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] Prefix LIST_... macros to XFS_LIST_...
Date: Wed, 15 Jul 2015 14:46:51 +0200
Message-Id: <1436964412-12093-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
References: <1436964412-12093-1-git-send-email-jtulak@redhat.com>
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

OS X has some conflicting LIST_ macros, so prefix the XFS ones.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/hlist.h           | 10 +++++-----
 include/irix.h            |  4 ++--
 include/list.h            |  8 ++++----
 libhandle/handle.c        |  2 +-
 libxfs/trans.c            |  2 +-
 libxfs/xfs_fs.h           |  4 ++--
 libxlog/xfs_log_recover.c |  6 +++---
 man/man3/xfsctl.3         |  2 +-
 repair/incore.h           |  2 +-
 repair/phase6.c           |  4 ++--
 10 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/hlist.h b/include/hlist.h
index 9ee096c..0d9c5d6 100644
--- a/include/hlist.h
+++ b/include/hlist.h
@@ -15,8 +15,8 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
-#ifndef __HLIST_H__
-#define __HLIST_H__
+#ifndef __HXFS_LIST_H__
+#define __HXFS_LIST_H__
 
 struct hlist_node {
 	struct hlist_node *next;
@@ -26,8 +26,8 @@ struct hlist_head {
 	struct hlist_node *first;
 };
 
-#define HLIST_HEAD_INIT { .first = NULL }
-static inline void INIT_HLIST_NODE(struct hlist_node *h)
+#define HXFS_LIST_HEAD_INIT { .first = NULL }
+static inline void INIT_HXFS_LIST_NODE(struct hlist_node *h)
 {
 	h->next = NULL;
 	h->pprev = NULL;
@@ -71,4 +71,4 @@ static inline void hlist_del(struct hlist_node *n)
 	     pos = pos->next)
 
 
-#endif	/* __LIST_H__ */
+#endif	/* __XFS_LIST_H__ */
diff --git a/include/irix.h b/include/irix.h
index 31050c4..c7f87d7 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -230,7 +230,7 @@ static __inline__ int xfsctl(const char *path, int fd, int cmd, void *arg)
 					((xfs_fsop_handlereq_t*)arg)->ihandlen,
 					((xfs_fsop_handlereq_t*)arg)->ohandle,
 					((xfs_fsop_handlereq_t*)arg)->ohandlen);
-		case SGI_ATTR_LIST_BY_HANDLE:
+		case SGI_ATTR_XFS_LIST_BY_HANDLE:
 			return syssgi(cmd,
 					((xfs_fsop_attrlist_handlereq_t*)arg)->hreq.ihandle,
 					((xfs_fsop_attrlist_handlereq_t*)arg)->hreq.ihandlen,
@@ -403,7 +403,7 @@ static __inline__ char * strsep(char **s, const char *ct)
 #define XFS_IOC_FREEZE			XFS_FS_FREEZE
 #define XFS_IOC_THAW			XFS_FS_THAW
 #define XFS_IOC_FSSETDM_BY_HANDLE	SGI_FSSETDM_BY_HANDLE
-#define XFS_IOC_ATTRLIST_BY_HANDLE	SGI_ATTR_LIST_BY_HANDLE
+#define XFS_IOC_ATTRXFS_LIST_BY_HANDLE	SGI_ATTR_XFS_LIST_BY_HANDLE
 #define XFS_IOC_ATTRMULTI_BY_HANDLE	SGI_ATTR_MULTI_BY_HANDLE
 #define XFS_IOC_FSGEOMETRY		XFS_FS_GEOMETRY
 #define XFS_IOC_GOINGDOWN		XFS_FS_GOINGDOWN
diff --git a/include/list.h b/include/list.h
index 3f087a4..84fdce0 100644
--- a/include/list.h
+++ b/include/list.h
@@ -27,12 +27,12 @@ struct list_head {
 	struct list_head *prev;
 };
 
-#define LIST_HEAD_INIT(name) { &(name), &(name) }
+#define XFS_LIST_HEAD_INIT(name) { &(name), &(name) }
 
-#define LIST_HEAD(name) \
-		struct list_head name = LIST_HEAD_INIT(name)
+#define XFS_LIST_HEAD(name) \
+		struct list_head name = XFS_LIST_HEAD_INIT(name)
 
-#define INIT_LIST_HEAD(list) list_head_init(list)
+#define INIT_XFS_LIST_HEAD(list) list_head_init(list)
 static inline void list_head_init(struct list_head *list)
 {
 	list->next = list->prev = list;
diff --git a/libhandle/handle.c b/libhandle/handle.c
index 54e6f71..76c8142 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -399,7 +399,7 @@ attr_list_by_handle(
 	if (alhreq.buflen > XATTR_LIST_MAX)
 		alhreq.buflen = XATTR_LIST_MAX;
 
-	error = xfsctl(path, fd, XFS_IOC_ATTRLIST_BY_HANDLE, &alhreq);
+	error = xfsctl(path, fd, XFS_IOC_ATTRXFS_LIST_BY_HANDLE, &alhreq);
 
 	memcpy(cursor, &alhreq.pos, sizeof(alhreq.pos));
 	return error;
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 0388950..f7ff11d 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -169,7 +169,7 @@ libxfs_trans_alloc(
 	}
 	ptr->t_mountp = mp;
 	ptr->t_type = type;
-	INIT_LIST_HEAD(&ptr->t_items);
+	INIT_XFS_LIST_HEAD(&ptr->t_items);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "allocated new transaction %p\n", ptr);
 #endif
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 89689c6..8c37e08 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -403,7 +403,7 @@ typedef struct xfs_fsop_handlereq {
 /*
  * Compound structures for passing args through Handle Request interfaces
  * xfs_fssetdm_by_handle, xfs_attrlist_by_handle, xfs_attrmulti_by_handle
- * - ioctls: XFS_IOC_FSSETDM_BY_HANDLE, XFS_IOC_ATTRLIST_BY_HANDLE, and
+ * - ioctls: XFS_IOC_FSSETDM_BY_HANDLE, XFS_IOC_ATTRXFS_LIST_BY_HANDLE, and
  *	     XFS_IOC_ATTRMULTI_BY_HANDLE
  */
 
@@ -553,7 +553,7 @@ typedef struct xfs_swapext
 #endif
 
 #define XFS_IOC_FSSETDM_BY_HANDLE    _IOW ('X', 121, struct xfs_fsop_setdm_handlereq)
-#define XFS_IOC_ATTRLIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
+#define XFS_IOC_ATTRXFS_LIST_BY_HANDLE   _IOW ('X', 122, struct xfs_fsop_attrlist_handlereq)
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index a80c431..1782db0 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -1018,9 +1018,9 @@ xlog_recover_new_tid(
 	trans = kmem_zalloc(sizeof(xlog_recover_t), KM_SLEEP);
 	trans->r_log_tid   = tid;
 	trans->r_lsn	   = lsn;
-	INIT_LIST_HEAD(&trans->r_itemq);
+	INIT_XFS_LIST_HEAD(&trans->r_itemq);
 
-	INIT_HLIST_NODE(&trans->r_list);
+	INIT_HXFS_LIST_NODE(&trans->r_list);
 	hlist_add_head(&trans->r_list, head);
 }
 
@@ -1031,7 +1031,7 @@ xlog_recover_add_item(
 	xlog_recover_item_t	*item;
 
 	item = kmem_zalloc(sizeof(xlog_recover_item_t), KM_SLEEP);
-	INIT_LIST_HEAD(&item->ri_list);
+	INIT_XFS_LIST_HEAD(&item->ri_list);
 	list_add_tail(&item->ri_list, head);
 }
 
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index e84b829..756f4b8 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -459,7 +459,7 @@ reports unwritten=1, then the filesystem was made to flag unwritten extents.
 .B XFS_IOC_FD_TO_HANDLE
 .B XFS_IOC_OPEN_BY_HANDLE
 .B XFS_IOC_READLINK_BY_HANDLE
-.B XFS_IOC_ATTR_LIST_BY_HANDLE
+.B XFS_IOC_ATTR_XFS_LIST_BY_HANDLE
 .B XFS_IOC_ATTR_MULTI_BY_HANDLE
 .fi
 .PD 0
diff --git a/repair/incore.h b/repair/incore.h
index c92475e..0420a10 100644
--- a/repair/incore.h
+++ b/repair/incore.h
@@ -254,7 +254,7 @@ int		count_bcnt_extents(xfs_agnumber_t);
  * connected.
  */
 
-#define PLIST_CHUNK_SIZE	4
+#define PXFS_LIST_CHUNK_SIZE	4
 
 typedef xfs_ino_t parent_entry_t;
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 9a5cba7..ae9f9fa 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -49,7 +49,7 @@ typedef struct dotdot_update {
 	int			ino_offset;
 } dotdot_update_t;
 
-static LIST_HEAD(dotdot_update_list);
+static XFS_LIST_HEAD(dotdot_update_list);
 static int			dotdot_update;
 
 static void
@@ -64,7 +64,7 @@ add_dotdot_update(
 		do_error(_("malloc failed add_dotdot_update (%zu bytes)\n"),
 			sizeof(dotdot_update_t));
 
-	INIT_LIST_HEAD(&dir->list);
+	INIT_XFS_LIST_HEAD(&dir->list);
 	dir->irec = irec;
 	dir->agno = agno;
 	dir->ino_offset = ino_offset;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
