Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM3vh4044405 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:58 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282206.o5SM6g8H018238@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:06:42 -0500
Subject: [PATCH 14/15] xfs: kill redundant DMAPI definitions
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

A whole bunch of definitions in "xfs_dmapi.h" are never used inside
XFS proper.  They can be moved into the (out-of-tree) DMAPI support
code where they're actually used.  This includes the the DMAPI right
and event types, as well as the standard DM_FLAGS_* values, which
can now be taken from a standard DMAPI header in the (out-of-tree)
XFS portion of the DMAPI implementatino.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/xfs_dmapi.h |  140 +++--------------------------------------------------
 1 file changed, 8 insertions(+), 132 deletions(-)

Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -18,135 +18,6 @@
 #ifndef __XFS_DMAPI_H__
 #define __XFS_DMAPI_H__
 
-#undef XFS_DMAPI
-#if defined(CONFIG_XFS_DMAPI) || defined(CONFIG_XFS_DMAPI_MODULE)
-#define XFS_DMAPI
-#endif
-
-/*	Values used to define the on-disk version of dm_attrname_t. All
- *	on-disk attribute names start with the 8-byte string "SGI_DMI_".
- *
- *      In the on-disk inode, DMAPI attribute names consist of the user-provided
- *      name with the DMATTR_PREFIXSTRING pre-pended.  This string must NEVER be
- *      changed.
- */
-
-#define DMATTR_PREFIXLEN	8
-#define DMATTR_PREFIXSTRING	"SGI_DMI_"
-
-typedef enum {
-	DM_EVENT_INVALID	= -1,
-	DM_EVENT_CANCEL		= 0,		/* not supported */
-	DM_EVENT_MOUNT		= 1,
-	DM_EVENT_PREUNMOUNT	= 2,
-	DM_EVENT_UNMOUNT	= 3,
-	DM_EVENT_DEBUT		= 4,		/* not supported */
-	DM_EVENT_CREATE		= 5,
-	DM_EVENT_CLOSE		= 6,		/* not supported */
-	DM_EVENT_POSTCREATE	= 7,
-	DM_EVENT_REMOVE		= 8,
-	DM_EVENT_POSTREMOVE	= 9,
-	DM_EVENT_RENAME		= 10,
-	DM_EVENT_POSTRENAME	= 11,
-	DM_EVENT_LINK		= 12,
-	DM_EVENT_POSTLINK	= 13,
-	DM_EVENT_SYMLINK	= 14,
-	DM_EVENT_POSTSYMLINK	= 15,
-	DM_EVENT_READ		= 16,
-	DM_EVENT_WRITE		= 17,
-	DM_EVENT_TRUNCATE	= 18,
-	DM_EVENT_ATTRIBUTE	= 19,
-	DM_EVENT_DESTROY	= 20,
-	DM_EVENT_NOSPACE	= 21,
-	DM_EVENT_USER		= 22,
-	DM_EVENT_MAX		= 23
-} dm_eventtype_t;
-#define HAVE_DM_EVENTTYPE_T
-
-typedef enum {
-	DM_RIGHT_NULL,
-	DM_RIGHT_SHARED,
-	DM_RIGHT_EXCL
-} dm_right_t;
-#define HAVE_DM_RIGHT_T
-
-#define DM_XFS_VALID_FS_EVENTS		( \
-	(1 << DM_EVENT_PREUNMOUNT)	| \
-	(1 << DM_EVENT_UNMOUNT)		| \
-	(1 << DM_EVENT_NOSPACE)		| \
-	(1 << DM_EVENT_DEBUT)		| \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events valid in dm_set_eventlist() when called with a file handle for
-   a regular file or a symlink.  These events are persistent.
-*/
-
-#define	DM_XFS_VALID_FILE_EVENTS	( \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events valid in dm_set_eventlist() when called with a file handle for
-   a directory.  These events are persistent.
-*/
-
-#define	DM_XFS_VALID_DIRECTORY_EVENTS	( \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-/* Events supported by the XFS filesystem. */
-#define	DM_XFS_SUPPORTED_EVENTS		( \
-	(1 << DM_EVENT_MOUNT)		| \
-	(1 << DM_EVENT_PREUNMOUNT)	| \
-	(1 << DM_EVENT_UNMOUNT)		| \
-	(1 << DM_EVENT_NOSPACE)		| \
-	(1 << DM_EVENT_CREATE)		| \
-	(1 << DM_EVENT_POSTCREATE)	| \
-	(1 << DM_EVENT_REMOVE)		| \
-	(1 << DM_EVENT_POSTREMOVE)	| \
-	(1 << DM_EVENT_RENAME)		| \
-	(1 << DM_EVENT_POSTRENAME)	| \
-	(1 << DM_EVENT_LINK)		| \
-	(1 << DM_EVENT_POSTLINK)	| \
-	(1 << DM_EVENT_SYMLINK)		| \
-	(1 << DM_EVENT_POSTSYMLINK)	| \
-	(1 << DM_EVENT_READ)		| \
-	(1 << DM_EVENT_WRITE)		| \
-	(1 << DM_EVENT_TRUNCATE)	| \
-	(1 << DM_EVENT_ATTRIBUTE)	| \
-	(1 << DM_EVENT_DESTROY)		)
-
-
-/*
- *	Definitions used for the flags field on dm_send_*_event().
- */
-
-#define DM_FLAGS_NDELAY		0x001	/* return EAGAIN after dm_pending() */
-#define DM_FLAGS_UNWANTED	0x002	/* event not in fsys dm_eventset_t */
-#define DM_FLAGS_IMUX		0x004	/* thread holds i_mutex */
-#define DM_FLAGS_IALLOCSEM_RD	0x010	/* thread holds i_alloc_sem rd */
-#define DM_FLAGS_IALLOCSEM_WR	0x020	/* thread holds i_alloc_sem wr */
-
 /*
  * Prototypes and functions for the Data Migration subsystem.
  */
@@ -154,7 +25,12 @@ typedef enum {
 extern int	xfs_dmops_get(struct xfs_mount *);
 extern void	xfs_dmops_put(struct xfs_mount *);
 
-#ifdef XFS_DMAPI
+#if defined(CONFIG_XFS_DMAPI) || defined(CONFIG_XFS_DMAPI_MODULE)
+
+#define XFS_DMAPI	/* XFS DMAPI support enabled (module or not) */
+
+#include <dmapi.h>
+#include <dmapi_kern.h>
 
 extern struct xfs_dmops xfs_dmcore_xfs;
 
@@ -232,7 +108,7 @@ extern void	xfs_dmapi_event_attribute(st
 extern void	xfs_dmapi_event_destroy(struct xfs_inode *);
 extern int	xfs_dmapi_event_nospace(struct xfs_inode *);
 
-#else /* ! XFS_DMAPI */
+#else /* !(defined(CONFIG_XFS_DMAPI) || defined(CONFIG_XFS_DMAPI_MODULE)) */
 
 #define xfs_dmapi_event_enabled(i, e)				0
 
@@ -259,7 +135,7 @@ extern int	xfs_dmapi_event_nospace(struc
 #define xfs_dmapi_event_destroy(ip)				(void) 0
 #define xfs_dmapi_event_nospace(ip) 				0
 
-#endif /* ! XFS_DMAPI */
+#endif /* !(defined(CONFIG_XFS_DMAPI) || defined(CONFIG_XFS_DMAPI_MODULE)) */
 
 #endif  /* __XFS_DMAPI_H__ */
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
