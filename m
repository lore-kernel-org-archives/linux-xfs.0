Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM20Nc044154 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:00 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282204.o5SM4gph018113@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:04:42 -0500
Subject: [PATCH 02/15] xfs: rename and move definition of HAVE_DMAPI
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Change the HAVE_DMAPI symbol to be XFS_DMAPI instead, so it
is more appropriately restricted to the XFS name space.  Move
its definition into "xfs_dmapi.h"; the only other file that
needs it #includes that file.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dmapi.h |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -18,6 +18,11 @@
 #ifndef __XFS_DMAPI_H__
 #define __XFS_DMAPI_H__
 
+#undef XFS_DMAPI
+#if defined(CONFIG_XFS_DMAPI) || defined(CONFIG_XFS_DMAPI_MODULE)
+#define XFS_DMAPI
+#endif
+
 /*	Values used to define the on-disk version of dm_attrname_t. All
  *	on-disk attribute names start with the 8-byte string "SGI_DMI_".
  *
@@ -66,15 +71,15 @@ typedef enum {
 #define HAVE_DM_RIGHT_T
 
 /* Defines for determining if an event message should be sent. */
-#ifdef HAVE_DMAPI
+#ifdef XFS_DMAPI
 #define	DM_EVENT_ENABLED(ip, event) ( \
 	unlikely ((ip)->i_mount->m_flags & XFS_MOUNT_DMAPI) && \
 		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
 		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
 	)
-#else
+#else /* ! XFS_DMAPI */
 #define DM_EVENT_ENABLED(ip, event)	(0)
-#endif
+#endif /* ! XFS_DMAPI */
 
 #define DM_XFS_VALID_FS_EVENTS		( \
 	(1 << DM_EVENT_PREUNMOUNT)	| \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
