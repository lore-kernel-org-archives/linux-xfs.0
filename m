Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 02 Aug 2008 08:14:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m72FEYI7005704
	for <xfs@oss.sgi.com>; Sat, 2 Aug 2008 08:14:34 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F410353E6B
	for <xfs@oss.sgi.com>; Sat,  2 Aug 2008 08:15:45 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id yt1yFZt6yWuWZNjr for <xfs@oss.sgi.com>; Sat, 02 Aug 2008 08:15:45 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m72FFjIF020042
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 2 Aug 2008 17:15:46 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m72FFjmm020040
	for xfs@oss.sgi.com; Sat, 2 Aug 2008 17:15:45 +0200
Date: Sat, 2 Aug 2008 17:15:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup dmapi filesystem interface
Message-ID: <20080802151545.GB19689@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently the filesystem passes in a small operation vector where
the most important method is one to obtain more methods in a really
awkward way and the file_system_type as a search key.  Changes this
to one single operation vector (renamed to struct dmapi_operations)
taht includes all methods and the search key.

Inside the dmapi remove the utterly convoluted mess dealing with the
operations and replace it with a trivial linked list that can be
searched to find the right operations vector.

Note that this does not fix the existing lifetime issues where
the operations can go away before they are used.  This is left for
another patch.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/dmapi/dmapi_kern.h
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_kern.h	2008-08-01 23:54:17.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_kern.h	2008-08-02 01:38:39.000000000 +0200
@@ -35,6 +35,8 @@
 
 #include <linux/fs.h>
 
+struct dmapi_operations;
+
 union sys_dmapi_uarg {
 	void *p;
 	__u64 u;
@@ -66,27 +68,9 @@ struct dm_handle_t;
 #define DM_FLAGS_NDELAY		0x001	/* return EAGAIN after dm_pending() */
 #define DM_FLAGS_UNWANTED	0x002	/* event not in fsys dm_eventset_t */
 
-/* Possible code levels reported by dm_code_level(). */
-
-#define DM_CLVL_INIT	0	/* DMAPI prior to X/Open compliance */
 #define DM_CLVL_XOPEN	1	/* X/Open compliant DMAPI */
 
 
-/*
- * Filesystem operations accessed by the DMAPI core.
- */
-struct filesystem_dmapi_operations {
-	int (*get_fsys_vector)(struct super_block *sb, void *addr);
-	int (*fh_to_inode)(struct super_block *sb, struct inode **ip,
-			   dm_fid_t *fid);
-	const struct file_operations * (*get_invis_ops)(struct inode *ip);
-	int (*inode_to_fh)(struct inode *ip, dm_fid_t *fid,
-			   dm_fsid_t *fsid );
-	void (*get_fsid)(struct super_block *sb, dm_fsid_t *fsid);
-#define HAVE_DM_QUEUE_FLUSH
-	int (*flushing)(struct inode *ip);
-};
-
 
 /* Prototypes used outside of the DMI module/directory. */
 
@@ -133,8 +117,6 @@ void		dm_send_unmount_event(
 			int		retcode,
 			int		flags);
 
-int		dm_code_level(void);
-
 int		dm_ip_to_handle (
 			struct inode	*ip,
 			dm_handle_t	*handlep);
@@ -146,78 +128,10 @@ int		dm_release_threads(
 			int			errno);
 
 void		dmapi_register(
-			struct file_system_type *fstype,
-			struct filesystem_dmapi_operations *dmapiops);
+			struct dmapi_operations *dmapiops);
 
 void		dmapi_unregister(
-			struct file_system_type *fstype);
-
-int		dmapi_registered(
-			struct file_system_type *fstype,
-			struct filesystem_dmapi_operations **dmapiops);
-
-
-/* The following prototypes and definitions are used by DMAPI as its
-   interface into the filesystem code.	Communication between DMAPI and the
-   filesystem are established as follows:
-   1. DMAPI uses the VFS_DMAPI_FSYS_VECTOR to ask for the addresses
-      of all the functions within the filesystem that it may need to call.
-   2. The filesystem returns an array of function name/address pairs which
-      DMAPI builds into a function vector.
-   The VFS_DMAPI_FSYS_VECTOR call is only made one time for a particular
-   filesystem type.  From then on, DMAPI uses its function vector to call the
-   filesystem functions directly.  Functions in the array which DMAPI doesn't
-   recognize are ignored.  A dummy function which returns ENOSYS is used for
-   any function that DMAPI needs but which was not provided by the filesystem.
-   If XFS doesn't recognize the VFS_DMAPI_FSYS_VECTOR, DMAPI assumes that it
-   doesn't have the X/Open support code; in this case DMAPI uses the XFS-code
-   originally bundled within DMAPI.
-
-   The goal of this interface is allow incremental changes to be made to
-   both the filesystem and to DMAPI while minimizing inter-patch dependencies,
-   and to eventually allow DMAPI to support multiple filesystem types at the
-   same time should that become necessary.
-*/
-
-typedef enum {
-	DM_FSYS_CLEAR_INHERIT		=  0,
-	DM_FSYS_CREATE_BY_HANDLE	=  1,
-	DM_FSYS_DOWNGRADE_RIGHT		=  2,
-	DM_FSYS_GET_ALLOCINFO_RVP	=  3,
-	DM_FSYS_GET_BULKALL_RVP		=  4,
-	DM_FSYS_GET_BULKATTR_RVP	=  5,
-	DM_FSYS_GET_CONFIG		=  6,
-	DM_FSYS_GET_CONFIG_EVENTS	=  7,
-	DM_FSYS_GET_DESTROY_DMATTR	=  8,
-	DM_FSYS_GET_DIOINFO		=  9,
-	DM_FSYS_GET_DIRATTRS_RVP	= 10,
-	DM_FSYS_GET_DMATTR		= 11,
-	DM_FSYS_GET_EVENTLIST		= 12,
-	DM_FSYS_GET_FILEATTR		= 13,
-	DM_FSYS_GET_REGION		= 14,
-	DM_FSYS_GETALL_DMATTR		= 15,
-	DM_FSYS_GETALL_INHERIT		= 16,
-	DM_FSYS_INIT_ATTRLOC		= 17,
-	DM_FSYS_MKDIR_BY_HANDLE		= 18,
-	DM_FSYS_PROBE_HOLE		= 19,
-	DM_FSYS_PUNCH_HOLE		= 20,
-	DM_FSYS_READ_INVIS_RVP		= 21,
-	DM_FSYS_RELEASE_RIGHT		= 22,
-	DM_FSYS_REMOVE_DMATTR		= 23,
-	DM_FSYS_REQUEST_RIGHT		= 24,
-	DM_FSYS_SET_DMATTR		= 25,
-	DM_FSYS_SET_EVENTLIST		= 26,
-	DM_FSYS_SET_FILEATTR		= 27,
-	DM_FSYS_SET_INHERIT		= 28,
-	DM_FSYS_SET_REGION		= 29,
-	DM_FSYS_SYMLINK_BY_HANDLE	= 30,
-	DM_FSYS_SYNC_BY_HANDLE		= 31,
-	DM_FSYS_UPGRADE_RIGHT		= 32,
-	DM_FSYS_WRITE_INVIS_RVP		= 33,
-	DM_FSYS_OBJ_REF_HOLD		= 34,
-	DM_FSYS_MAX			= 35
-} dm_fsys_switch_t;
-
+			struct dmapi_operations *dmapiops);
 
 #define DM_FSYS_OBJ	0x1		/* object refers to a fsys handle */
 
@@ -466,63 +380,58 @@ typedef int	(*dm_fsys_write_invis_rvp_t)
 typedef void	(*dm_fsys_obj_ref_hold_t)(
 			struct inode	*ip);
 
+/*
+ * Filesystem operations accessed by the DMAPI core.
+ */
+typedef struct dmapi_operations {
+	struct list_head	list;
+	struct file_system_type	*fstype;
 
-/* Structure definitions used by the VFS_DMAPI_FSYS_VECTOR call. */
-
-typedef struct {
-	dm_fsys_switch_t  func_no;	/* function number */
-	union {
-		dm_fsys_clear_inherit_t clear_inherit;
-		dm_fsys_create_by_handle_t create_by_handle;
-		dm_fsys_downgrade_right_t downgrade_right;
-		dm_fsys_get_allocinfo_rvp_t get_allocinfo_rvp;
-		dm_fsys_get_bulkall_rvp_t get_bulkall_rvp;
-		dm_fsys_get_bulkattr_rvp_t get_bulkattr_rvp;
-		dm_fsys_get_config_t get_config;
-		dm_fsys_get_config_events_t get_config_events;
-		dm_fsys_get_destroy_dmattr_t get_destroy_dmattr;
-		dm_fsys_get_dioinfo_t get_dioinfo;
-		dm_fsys_get_dirattrs_rvp_t get_dirattrs_rvp;
-		dm_fsys_get_dmattr_t get_dmattr;
-		dm_fsys_get_eventlist_t get_eventlist;
-		dm_fsys_get_fileattr_t get_fileattr;
-		dm_fsys_get_region_t get_region;
-		dm_fsys_getall_dmattr_t getall_dmattr;
-		dm_fsys_getall_inherit_t getall_inherit;
-		dm_fsys_init_attrloc_t init_attrloc;
-		dm_fsys_mkdir_by_handle_t mkdir_by_handle;
-		dm_fsys_probe_hole_t probe_hole;
-		dm_fsys_punch_hole_t punch_hole;
-		dm_fsys_read_invis_rvp_t read_invis_rvp;
-		dm_fsys_release_right_t release_right;
-		dm_fsys_remove_dmattr_t remove_dmattr;
-		dm_fsys_request_right_t request_right;
-		dm_fsys_set_dmattr_t set_dmattr;
-		dm_fsys_set_eventlist_t set_eventlist;
-		dm_fsys_set_fileattr_t set_fileattr;
-		dm_fsys_set_inherit_t set_inherit;
-		dm_fsys_set_region_t set_region;
-		dm_fsys_symlink_by_handle_t symlink_by_handle;
-		dm_fsys_sync_by_handle_t sync_by_handle;
-		dm_fsys_upgrade_right_t upgrade_right;
-		dm_fsys_write_invis_rvp_t write_invis_rvp;
-		dm_fsys_obj_ref_hold_t obj_ref_hold;
-	} u_fc;
-} fsys_function_vector_t;
-
-struct dm_fcntl_vector {
-	int	code_level;
-	int	count;		/* Number of functions in the vector */
-	fsys_function_vector_t *vecp;
-};
-typedef struct dm_fcntl_vector dm_fcntl_vector_t;
+	int (*fh_to_inode)(struct super_block *sb, struct inode **ip,
+			   dm_fid_t *fid);
+	const struct file_operations * (*get_invis_ops)(struct inode *ip);
+	int (*inode_to_fh)(struct inode *ip, dm_fid_t *fid,
+			   dm_fsid_t *fsid);
+	void (*get_fsid)(struct super_block *sb, dm_fsid_t *fsid);
+#define HAVE_DM_QUEUE_FLUSH
+	int (*flushing)(struct inode *ip);
 
-struct dm_fcntl_mapevent {
-	size_t	length;			/* length of transfer */
-	dm_eventtype_t	max_event;	/* Maximum (WRITE or READ)  event */
-	int	error;			/* returned error code */
-};
-typedef struct dm_fcntl_mapevent dm_fcntl_mapevent_t;
+	dm_fsys_clear_inherit_t clear_inherit;
+	dm_fsys_create_by_handle_t create_by_handle;
+	dm_fsys_downgrade_right_t downgrade_right;
+	dm_fsys_get_allocinfo_rvp_t get_allocinfo_rvp;
+	dm_fsys_get_bulkall_rvp_t get_bulkall_rvp;
+	dm_fsys_get_bulkattr_rvp_t get_bulkattr_rvp;
+	dm_fsys_get_config_t get_config;
+	dm_fsys_get_config_events_t get_config_events;
+	dm_fsys_get_destroy_dmattr_t get_destroy_dmattr;
+	dm_fsys_get_dioinfo_t get_dioinfo;
+	dm_fsys_get_dirattrs_rvp_t get_dirattrs_rvp;
+	dm_fsys_get_dmattr_t get_dmattr;
+	dm_fsys_get_eventlist_t get_eventlist;
+	dm_fsys_get_fileattr_t get_fileattr;
+	dm_fsys_get_region_t get_region;
+	dm_fsys_getall_dmattr_t getall_dmattr;
+	dm_fsys_getall_inherit_t getall_inherit;
+	dm_fsys_init_attrloc_t init_attrloc;
+	dm_fsys_mkdir_by_handle_t mkdir_by_handle;
+	dm_fsys_probe_hole_t probe_hole;
+	dm_fsys_punch_hole_t punch_hole;
+	dm_fsys_read_invis_rvp_t read_invis_rvp;
+	dm_fsys_release_right_t release_right;
+	dm_fsys_remove_dmattr_t remove_dmattr;
+	dm_fsys_request_right_t request_right;
+	dm_fsys_set_dmattr_t set_dmattr;
+	dm_fsys_set_eventlist_t set_eventlist;
+	dm_fsys_set_fileattr_t set_fileattr;
+	dm_fsys_set_inherit_t set_inherit;
+	dm_fsys_set_region_t set_region;
+	dm_fsys_symlink_by_handle_t symlink_by_handle;
+	dm_fsys_sync_by_handle_t sync_by_handle;
+	dm_fsys_upgrade_right_t upgrade_right;
+	dm_fsys_write_invis_rvp_t write_invis_rvp;
+	dm_fsys_obj_ref_hold_t obj_ref_hold;
+} dm_fsys_vector_t;
 
 #endif	/* __KERNEL__ */
 
Index: linux-2.6-xfs/fs/dmapi/dmapi_mountinfo.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_mountinfo.c	2008-08-01 23:54:17.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,527 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
- *
- * Further, this software is distributed without any warranty that it is
- * free of the rightful claim of any third person regarding infringement
- * or the like.	 Any license provided herein, whether implied or
- * otherwise, applies only to this software file.  Patent licenses, if
- * any, provided herein do not apply to combinations of this program with
- * other software, or any other product whatsoever.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * Contact information: Silicon Graphics, Inc., 1600 Amphitheatre Pkwy,
- * Mountain View, CA  94043, or:
- *
- * http://www.sgi.com
- *
- * For further information regarding this notice, see:
- *
- * http://oss.sgi.com/projects/GenInfo/SGIGPLNoticeExplan/
- */
-#include "dmapi.h"
-#include "dmapi_kern.h"
-#include "dmapi_private.h"
-
-static LIST_HEAD(dm_fsys_map);
-static spinlock_t dm_fsys_lock = SPIN_LOCK_UNLOCKED;
-
-int
-dm_code_level(void)
-{
-	return DM_CLVL_XOPEN;	/* initial X/Open compliant release */
-}
-
-
-/* Dummy routine which is stored in each function vector slot for which the
-   filesystem provides no function of its own.	If an application calls the
-   function, he will just get ENOSYS.
-*/
-
-static int
-dm_enosys(void)
-{
-	return -ENOSYS;		/* function not supported by filesystem */
-}
-
-
-/* dm_query_fsys_for_vector() asks a filesystem for its list of supported
-   DMAPI functions, and builds a dm_vector_map_t structure based upon the
-   reply.  We ignore functions supported by the filesystem which we do not
-   know about, and we substitute the subroutine 'dm_enosys' for each function
-   we know about but the filesystem does not support.
-*/
-
-static void
-dm_query_fsys_for_vector(
-	dm_vector_map_t		*map)
-{
-	struct super_block	*sb = map->sb;
-	fsys_function_vector_t	*vecp;
-	dm_fcntl_vector_t	vecrq;
-	dm_fsys_vector_t	*vptr;
-	struct filesystem_dmapi_operations *dmapiops = map->dmapiops;
-	int			error;
-	int			i;
-
-
-	/* Allocate a function vector and initialize all fields with a
-	   dummy function that returns ENOSYS.
-	*/
-
-	vptr = map->vptr = kmem_cache_alloc(dm_fsys_vptr_cachep, GFP_KERNEL);
-	if (vptr == NULL) {
-		printk("%s/%d: kmem_cache_alloc(dm_fsys_vptr_cachep) returned NULL\n", __FUNCTION__, __LINE__);
-		return;
-	}
-
-	vptr->code_level = 0;
-	vptr->clear_inherit = (dm_fsys_clear_inherit_t)dm_enosys;
-	vptr->create_by_handle = (dm_fsys_create_by_handle_t)dm_enosys;
-	vptr->downgrade_right = (dm_fsys_downgrade_right_t)dm_enosys;
-	vptr->get_allocinfo_rvp = (dm_fsys_get_allocinfo_rvp_t)dm_enosys;
-	vptr->get_bulkall_rvp = (dm_fsys_get_bulkall_rvp_t)dm_enosys;
-	vptr->get_bulkattr_rvp = (dm_fsys_get_bulkattr_rvp_t)dm_enosys;
-	vptr->get_config = (dm_fsys_get_config_t)dm_enosys;
-	vptr->get_config_events = (dm_fsys_get_config_events_t)dm_enosys;
-	vptr->get_destroy_dmattr = (dm_fsys_get_destroy_dmattr_t)dm_enosys;
-	vptr->get_dioinfo = (dm_fsys_get_dioinfo_t)dm_enosys;
-	vptr->get_dirattrs_rvp = (dm_fsys_get_dirattrs_rvp_t)dm_enosys;
-	vptr->get_dmattr = (dm_fsys_get_dmattr_t)dm_enosys;
-	vptr->get_eventlist = (dm_fsys_get_eventlist_t)dm_enosys;
-	vptr->get_fileattr = (dm_fsys_get_fileattr_t)dm_enosys;
-	vptr->get_region = (dm_fsys_get_region_t)dm_enosys;
-	vptr->getall_dmattr = (dm_fsys_getall_dmattr_t)dm_enosys;
-	vptr->getall_inherit = (dm_fsys_getall_inherit_t)dm_enosys;
-	vptr->init_attrloc = (dm_fsys_init_attrloc_t)dm_enosys;
-	vptr->mkdir_by_handle = (dm_fsys_mkdir_by_handle_t)dm_enosys;
-	vptr->probe_hole = (dm_fsys_probe_hole_t)dm_enosys;
-	vptr->punch_hole = (dm_fsys_punch_hole_t)dm_enosys;
-	vptr->read_invis_rvp = (dm_fsys_read_invis_rvp_t)dm_enosys;
-	vptr->release_right = (dm_fsys_release_right_t)dm_enosys;
-	vptr->request_right = (dm_fsys_request_right_t)dm_enosys;
-	vptr->remove_dmattr = (dm_fsys_remove_dmattr_t)dm_enosys;
-	vptr->set_dmattr = (dm_fsys_set_dmattr_t)dm_enosys;
-	vptr->set_eventlist = (dm_fsys_set_eventlist_t)dm_enosys;
-	vptr->set_fileattr = (dm_fsys_set_fileattr_t)dm_enosys;
-	vptr->set_inherit = (dm_fsys_set_inherit_t)dm_enosys;
-	vptr->set_region = (dm_fsys_set_region_t)dm_enosys;
-	vptr->symlink_by_handle = (dm_fsys_symlink_by_handle_t)dm_enosys;
-	vptr->sync_by_handle = (dm_fsys_sync_by_handle_t)dm_enosys;
-	vptr->upgrade_right = (dm_fsys_upgrade_right_t)dm_enosys;
-	vptr->write_invis_rvp = (dm_fsys_write_invis_rvp_t)dm_enosys;
-	vptr->obj_ref_hold = (dm_fsys_obj_ref_hold_t)dm_enosys;
-
-	/* Issue a call to the filesystem in order to obtain
-	   its vector of filesystem-specific DMAPI routines.
-	*/
-
-	vecrq.count = 0;
-	vecrq.vecp = NULL;
-
-  	error = -ENOSYS;
-	ASSERT(dmapiops);
-	if (dmapiops->get_fsys_vector)
-		error = dmapiops->get_fsys_vector(sb, (caddr_t)&vecrq);
-
-	/* If we still have an error at this point, then the filesystem simply
-	   does not support DMAPI, so we give up with all functions set to
-	   ENOSYS.
-	*/
-
-	if (error || vecrq.count == 0) {
-		kmem_cache_free(dm_fsys_vptr_cachep, vptr);
-		map->vptr = NULL;
-		return;
-	}
-
-	/* The request succeeded and we were given a vector which we need to
-	   map to our current level.  Overlay the dummy function with every
-	   filesystem function we understand.
-	*/
-
-	vptr->code_level = vecrq.code_level;
-	vecp = vecrq.vecp;
-	for (i = 0; i < vecrq.count; i++) {
-		switch (vecp[i].func_no) {
-		case DM_FSYS_CLEAR_INHERIT:
-			vptr->clear_inherit = vecp[i].u_fc.clear_inherit;
-			break;
-		case DM_FSYS_CREATE_BY_HANDLE:
-			vptr->create_by_handle = vecp[i].u_fc.create_by_handle;
-			break;
-		case DM_FSYS_DOWNGRADE_RIGHT:
-			vptr->downgrade_right = vecp[i].u_fc.downgrade_right;
-			break;
-		case DM_FSYS_GET_ALLOCINFO_RVP:
-			vptr->get_allocinfo_rvp = vecp[i].u_fc.get_allocinfo_rvp;
-			break;
-		case DM_FSYS_GET_BULKALL_RVP:
-			vptr->get_bulkall_rvp = vecp[i].u_fc.get_bulkall_rvp;
-			break;
-		case DM_FSYS_GET_BULKATTR_RVP:
-			vptr->get_bulkattr_rvp = vecp[i].u_fc.get_bulkattr_rvp;
-			break;
-		case DM_FSYS_GET_CONFIG:
-			vptr->get_config = vecp[i].u_fc.get_config;
-			break;
-		case DM_FSYS_GET_CONFIG_EVENTS:
-			vptr->get_config_events = vecp[i].u_fc.get_config_events;
-			break;
-		case DM_FSYS_GET_DESTROY_DMATTR:
-			vptr->get_destroy_dmattr = vecp[i].u_fc.get_destroy_dmattr;
-			break;
-		case DM_FSYS_GET_DIOINFO:
-			vptr->get_dioinfo = vecp[i].u_fc.get_dioinfo;
-			break;
-		case DM_FSYS_GET_DIRATTRS_RVP:
-			vptr->get_dirattrs_rvp = vecp[i].u_fc.get_dirattrs_rvp;
-			break;
-		case DM_FSYS_GET_DMATTR:
-			vptr->get_dmattr = vecp[i].u_fc.get_dmattr;
-			break;
-		case DM_FSYS_GET_EVENTLIST:
-			vptr->get_eventlist = vecp[i].u_fc.get_eventlist;
-			break;
-		case DM_FSYS_GET_FILEATTR:
-			vptr->get_fileattr = vecp[i].u_fc.get_fileattr;
-			break;
-		case DM_FSYS_GET_REGION:
-			vptr->get_region = vecp[i].u_fc.get_region;
-			break;
-		case DM_FSYS_GETALL_DMATTR:
-			vptr->getall_dmattr = vecp[i].u_fc.getall_dmattr;
-			break;
-		case DM_FSYS_GETALL_INHERIT:
-			vptr->getall_inherit = vecp[i].u_fc.getall_inherit;
-			break;
-		case DM_FSYS_INIT_ATTRLOC:
-			vptr->init_attrloc = vecp[i].u_fc.init_attrloc;
-			break;
-		case DM_FSYS_MKDIR_BY_HANDLE:
-			vptr->mkdir_by_handle = vecp[i].u_fc.mkdir_by_handle;
-			break;
-		case DM_FSYS_PROBE_HOLE:
-			vptr->probe_hole = vecp[i].u_fc.probe_hole;
-			break;
-		case DM_FSYS_PUNCH_HOLE:
-			vptr->punch_hole = vecp[i].u_fc.punch_hole;
-			break;
-		case DM_FSYS_READ_INVIS_RVP:
-			vptr->read_invis_rvp = vecp[i].u_fc.read_invis_rvp;
-			break;
-		case DM_FSYS_RELEASE_RIGHT:
-			vptr->release_right = vecp[i].u_fc.release_right;
-			break;
-		case DM_FSYS_REMOVE_DMATTR:
-			vptr->remove_dmattr = vecp[i].u_fc.remove_dmattr;
-			break;
-		case DM_FSYS_REQUEST_RIGHT:
-			vptr->request_right = vecp[i].u_fc.request_right;
-			break;
-		case DM_FSYS_SET_DMATTR:
-			vptr->set_dmattr = vecp[i].u_fc.set_dmattr;
-			break;
-		case DM_FSYS_SET_EVENTLIST:
-			vptr->set_eventlist = vecp[i].u_fc.set_eventlist;
-			break;
-		case DM_FSYS_SET_FILEATTR:
-			vptr->set_fileattr = vecp[i].u_fc.set_fileattr;
-			break;
-		case DM_FSYS_SET_INHERIT:
-			vptr->set_inherit = vecp[i].u_fc.set_inherit;
-			break;
-		case DM_FSYS_SET_REGION:
-			vptr->set_region = vecp[i].u_fc.set_region;
-			break;
-		case DM_FSYS_SYMLINK_BY_HANDLE:
-			vptr->symlink_by_handle = vecp[i].u_fc.symlink_by_handle;
-			break;
-		case DM_FSYS_SYNC_BY_HANDLE:
-			vptr->sync_by_handle = vecp[i].u_fc.sync_by_handle;
-			break;
-		case DM_FSYS_UPGRADE_RIGHT:
-			vptr->upgrade_right = vecp[i].u_fc.upgrade_right;
-			break;
-		case DM_FSYS_WRITE_INVIS_RVP:
-			vptr->write_invis_rvp = vecp[i].u_fc.write_invis_rvp;
-			break;
-		case DM_FSYS_OBJ_REF_HOLD:
-			vptr->obj_ref_hold = vecp[i].u_fc.obj_ref_hold;
-			break;
-		default:		/* ignore ones we don't understand */
-			break;
-		}
-	}
-}
-
-
-/* Must hold dm_fsys_lock.
- * This returns the prototype for all instances of the fstype.
- */
-static dm_vector_map_t *
-dm_fsys_map_by_fstype(
-	struct file_system_type *fstype)
-{
-	struct list_head *p;
-	dm_vector_map_t *proto = NULL;
-	dm_vector_map_t *m;
-
-	ASSERT_ALWAYS(fstype);
-	list_for_each(p, &dm_fsys_map) {
-		m = list_entry(p, dm_vector_map_t, ftype_list);
-		if (m->f_type == fstype) {
-			proto = m;
-			break;
-		}
-	}
-	return proto;
-}
-
-
-/* Must hold dm_fsys_lock */
-static dm_vector_map_t *
-dm_fsys_map_by_sb(
-	struct super_block *sb)
-{
-	struct list_head *p;
-	dm_vector_map_t *proto;
-	dm_vector_map_t *m;
-	dm_vector_map_t *foundmap = NULL;
-
-	proto = dm_fsys_map_by_fstype(sb->s_type);
-	if(proto == NULL) {
-		return NULL;
-	}
-
-	list_for_each(p, &proto->sb_list) {
-		m = list_entry(p, dm_vector_map_t, sb_list);
-		if (m->sb == sb) {
-			foundmap = m;
-			break;
-		}
-	}
-	return foundmap;
-}
-
-
-#ifdef CONFIG_DMAPI_DEBUG
-static void
-sb_list(
-	struct super_block *sb)
-{
-	struct list_head *p;
-	dm_vector_map_t *proto;
-	dm_vector_map_t *m;
-
-	proto = dm_fsys_map_by_fstype(sb->s_type);
-	ASSERT(proto);
-
-printk("%s/%d: Current sb_list\n", __FUNCTION__, __LINE__);
-	list_for_each(p, &proto->sb_list) {
-		m = list_entry(p, dm_vector_map_t, sb_list);
-printk("%s/%d: map 0x%p, sb 0x%p, vptr 0x%p, dmapiops 0x%p\n", __FUNCTION__, __LINE__, m, m->sb, m->vptr, m->dmapiops);
-	}
-printk("%s/%d: Done sb_list\n", __FUNCTION__, __LINE__);
-}
-#else
-#define sb_list(x)
-#endif
-
-#ifdef CONFIG_DMAPI_DEBUG
-static void
-ftype_list(void)
-{
-	struct list_head *p;
-	dm_vector_map_t *m;
-
-printk("%s/%d: Current ftype_list\n", __FUNCTION__, __LINE__);
-	list_for_each(p, &dm_fsys_map) {
-		m = list_entry(p, dm_vector_map_t, ftype_list);
-		printk("%s/%d: FS 0x%p, ftype 0x%p %s\n", __FUNCTION__, __LINE__, m, m->f_type, m->f_type->name);
-	}
-printk("%s/%d: Done ftype_list\n", __FUNCTION__, __LINE__);
-}
-#else
-#define ftype_list()
-#endif
-
-/* Ask for vptr for this filesystem instance.
- * The caller knows this inode is on a dmapi-managed filesystem.
- */
-dm_fsys_vector_t *
-dm_fsys_vector(
-	struct inode	*ip)
-{
-	dm_vector_map_t *map;
-
-	spin_lock(&dm_fsys_lock);
-	ftype_list();
-	map = dm_fsys_map_by_sb(ip->i_sb);
-	spin_unlock(&dm_fsys_lock);
-	ASSERT(map);
-	ASSERT(map->vptr);
-	return map->vptr;
-}
-
-
-/* Ask for the dmapiops for this filesystem instance.  The caller is
- * also asking if this is a dmapi-managed filesystem.
- */
-struct filesystem_dmapi_operations *
-dm_fsys_ops(
-	struct super_block	*sb)
-{
-	dm_vector_map_t *proto = NULL;
-	dm_vector_map_t *map;
-
-	spin_lock(&dm_fsys_lock);
-	ftype_list();
-	sb_list(sb);
-	map = dm_fsys_map_by_sb(sb);
-	if (map == NULL)
-		proto = dm_fsys_map_by_fstype(sb->s_type);
-	spin_unlock(&dm_fsys_lock);
-
-	if ((map == NULL) && (proto == NULL))
-		return NULL;
-
-	if (map == NULL) {
-		/* Find out if it's dmapi-managed */
-		dm_vector_map_t *m;
-
-		ASSERT(proto);
-		m = kmem_cache_alloc(dm_fsys_map_cachep, GFP_KERNEL);
-		if (m == NULL) {
-			printk("%s/%d: kmem_cache_alloc(dm_fsys_map_cachep) returned NULL\n", __FUNCTION__, __LINE__);
-			return NULL;
-		}
-		memset(m, 0, sizeof(*m));
-		m->dmapiops = proto->dmapiops;
-		m->f_type = sb->s_type;
-		m->sb = sb;
-		INIT_LIST_HEAD(&m->sb_list);
-		INIT_LIST_HEAD(&m->ftype_list);
-
-		dm_query_fsys_for_vector(m);
-		if (m->vptr == NULL) {
-			/* This isn't dmapi-managed */
-			kmem_cache_free(dm_fsys_map_cachep, m);
-			return NULL;
-		}
-
-		spin_lock(&dm_fsys_lock);
-		if ((map = dm_fsys_map_by_sb(sb)) == NULL)
-			list_add(&m->sb_list, &proto->sb_list);
-		spin_unlock(&dm_fsys_lock);
-
-		if (map) {
-			kmem_cache_free(dm_fsys_vptr_cachep, m->vptr);
-			kmem_cache_free(dm_fsys_map_cachep, m);
-		}
-		else {
-			map = m;
-		}
-	}
-
-	return map->dmapiops;
-}
-
-
-
-/* Called when a filesystem instance is unregistered from dmapi */
-void
-dm_fsys_ops_release(
-	struct super_block	*sb)
-{
-	dm_vector_map_t *map;
-
-	spin_lock(&dm_fsys_lock);
-	ASSERT(!list_empty(&dm_fsys_map));
-	map = dm_fsys_map_by_sb(sb);
-	ASSERT(map);
-	list_del(&map->sb_list);
-	spin_unlock(&dm_fsys_lock);
-
-	ASSERT(map->vptr);
-	kmem_cache_free(dm_fsys_vptr_cachep, map->vptr);
-	kmem_cache_free(dm_fsys_map_cachep, map);
-}
-
-
-/* Called by a filesystem module that is loading into the kernel.
- * This creates a new dm_vector_map_t which serves as the prototype
- * for instances of this fstype and also provides the list_head
- * for instances of this fstype.  The prototypes are the only ones
- * on the fstype_list, and will never be on the sb_list.
- */
-void
-dmapi_register(
-	struct file_system_type *fstype,
-	struct filesystem_dmapi_operations *dmapiops)
-{
-	dm_vector_map_t *proto;
-
-	proto = kmem_cache_alloc(dm_fsys_map_cachep, GFP_KERNEL);
-	if (proto == NULL) {
-		printk("%s/%d: kmem_cache_alloc(dm_fsys_map_cachep) returned NULL\n", __FUNCTION__, __LINE__);
-		return;
-	}
-	memset(proto, 0, sizeof(*proto));
-	proto->dmapiops = dmapiops;
-	proto->f_type = fstype;
-	INIT_LIST_HEAD(&proto->sb_list);
-	INIT_LIST_HEAD(&proto->ftype_list);
-
-	spin_lock(&dm_fsys_lock);
-	ASSERT(dm_fsys_map_by_fstype(fstype) == NULL);
-	list_add(&proto->ftype_list, &dm_fsys_map);
-	ftype_list();
-	spin_unlock(&dm_fsys_lock);
-}
-
-/* Called by a filesystem module that is unloading from the kernel */
-void
-dmapi_unregister(
-	struct file_system_type *fstype)
-{
-	struct list_head *p;
-	dm_vector_map_t *proto;
-	dm_vector_map_t *m;
-
-	spin_lock(&dm_fsys_lock);
-	ASSERT(!list_empty(&dm_fsys_map));
-	proto = dm_fsys_map_by_fstype(fstype);
-	ASSERT(proto);
-	list_del(&proto->ftype_list);
-	spin_unlock(&dm_fsys_lock);
-
-	p = &proto->sb_list;
-	while (!list_empty(p)) {
-		m = list_entry(p->next, dm_vector_map_t, sb_list);
-		list_del(&m->sb_list);
-		ASSERT(m->vptr);
-		kmem_cache_free(dm_fsys_vptr_cachep, m->vptr);
-		kmem_cache_free(dm_fsys_map_cachep, m);
-	}
-	kmem_cache_free(dm_fsys_map_cachep, proto);
-}
-
-
-int
-dmapi_registered(
-	struct file_system_type *fstype,
-	struct filesystem_dmapi_operations **dmapiops)
-{
-	return 0;
-}
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-08-02 00:43:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-08-02 01:36:44.000000000 +0200
@@ -2930,103 +2930,6 @@ xfs_dm_obj_ref_hold(
 }
 
 
-static fsys_function_vector_t	xfs_fsys_vector[DM_FSYS_MAX];
-
-
-STATIC int
-xfs_dm_get_dmapiops(
-	struct super_block	*sb,
-	void			*addr)
-{
-	static	int		initialized = 0;
-	dm_fcntl_vector_t	*vecrq;
-	fsys_function_vector_t	*vecp;
-	int			i = 0;
-
-	vecrq = (dm_fcntl_vector_t *)addr;
-	vecrq->count =
-		sizeof(xfs_fsys_vector) / sizeof(xfs_fsys_vector[0]);
-	vecrq->vecp = xfs_fsys_vector;
-	if (initialized)
-		return(0);
-	vecrq->code_level = DM_CLVL_XOPEN;
-	vecp = xfs_fsys_vector;
-
-	vecp[i].func_no = DM_FSYS_CLEAR_INHERIT;
-	vecp[i++].u_fc.clear_inherit = xfs_dm_clear_inherit;
-	vecp[i].func_no = DM_FSYS_CREATE_BY_HANDLE;
-	vecp[i++].u_fc.create_by_handle = xfs_dm_create_by_handle;
-	vecp[i].func_no = DM_FSYS_DOWNGRADE_RIGHT;
-	vecp[i++].u_fc.downgrade_right = xfs_dm_downgrade_right;
-	vecp[i].func_no = DM_FSYS_GET_ALLOCINFO_RVP;
-	vecp[i++].u_fc.get_allocinfo_rvp = xfs_dm_get_allocinfo_rvp;
-	vecp[i].func_no = DM_FSYS_GET_BULKALL_RVP;
-	vecp[i++].u_fc.get_bulkall_rvp = xfs_dm_get_bulkall_rvp;
-	vecp[i].func_no = DM_FSYS_GET_BULKATTR_RVP;
-	vecp[i++].u_fc.get_bulkattr_rvp = xfs_dm_get_bulkattr_rvp;
-	vecp[i].func_no = DM_FSYS_GET_CONFIG;
-	vecp[i++].u_fc.get_config = xfs_dm_get_config;
-	vecp[i].func_no = DM_FSYS_GET_CONFIG_EVENTS;
-	vecp[i++].u_fc.get_config_events = xfs_dm_get_config_events;
-	vecp[i].func_no = DM_FSYS_GET_DESTROY_DMATTR;
-	vecp[i++].u_fc.get_destroy_dmattr = xfs_dm_get_destroy_dmattr;
-	vecp[i].func_no = DM_FSYS_GET_DIOINFO;
-	vecp[i++].u_fc.get_dioinfo = xfs_dm_get_dioinfo;
-	vecp[i].func_no = DM_FSYS_GET_DIRATTRS_RVP;
-	vecp[i++].u_fc.get_dirattrs_rvp = xfs_dm_get_dirattrs_rvp;
-	vecp[i].func_no = DM_FSYS_GET_DMATTR;
-	vecp[i++].u_fc.get_dmattr = xfs_dm_get_dmattr;
-	vecp[i].func_no = DM_FSYS_GET_EVENTLIST;
-	vecp[i++].u_fc.get_eventlist = xfs_dm_get_eventlist;
-	vecp[i].func_no = DM_FSYS_GET_FILEATTR;
-	vecp[i++].u_fc.get_fileattr = xfs_dm_get_fileattr;
-	vecp[i].func_no = DM_FSYS_GET_REGION;
-	vecp[i++].u_fc.get_region = xfs_dm_get_region;
-	vecp[i].func_no = DM_FSYS_GETALL_DMATTR;
-	vecp[i++].u_fc.getall_dmattr = xfs_dm_getall_dmattr;
-	vecp[i].func_no = DM_FSYS_GETALL_INHERIT;
-	vecp[i++].u_fc.getall_inherit = xfs_dm_getall_inherit;
-	vecp[i].func_no = DM_FSYS_INIT_ATTRLOC;
-	vecp[i++].u_fc.init_attrloc = xfs_dm_init_attrloc;
-	vecp[i].func_no = DM_FSYS_MKDIR_BY_HANDLE;
-	vecp[i++].u_fc.mkdir_by_handle = xfs_dm_mkdir_by_handle;
-	vecp[i].func_no = DM_FSYS_PROBE_HOLE;
-	vecp[i++].u_fc.probe_hole = xfs_dm_probe_hole;
-	vecp[i].func_no = DM_FSYS_PUNCH_HOLE;
-	vecp[i++].u_fc.punch_hole = xfs_dm_punch_hole;
-	vecp[i].func_no = DM_FSYS_READ_INVIS_RVP;
-	vecp[i++].u_fc.read_invis_rvp = xfs_dm_read_invis_rvp;
-	vecp[i].func_no = DM_FSYS_RELEASE_RIGHT;
-	vecp[i++].u_fc.release_right = xfs_dm_release_right;
-	vecp[i].func_no = DM_FSYS_REMOVE_DMATTR;
-	vecp[i++].u_fc.remove_dmattr = xfs_dm_remove_dmattr;
-	vecp[i].func_no = DM_FSYS_REQUEST_RIGHT;
-	vecp[i++].u_fc.request_right = xfs_dm_request_right;
-	vecp[i].func_no = DM_FSYS_SET_DMATTR;
-	vecp[i++].u_fc.set_dmattr = xfs_dm_set_dmattr;
-	vecp[i].func_no = DM_FSYS_SET_EVENTLIST;
-	vecp[i++].u_fc.set_eventlist = xfs_dm_set_eventlist;
-	vecp[i].func_no = DM_FSYS_SET_FILEATTR;
-	vecp[i++].u_fc.set_fileattr = xfs_dm_set_fileattr;
-	vecp[i].func_no = DM_FSYS_SET_INHERIT;
-	vecp[i++].u_fc.set_inherit = xfs_dm_set_inherit;
-	vecp[i].func_no = DM_FSYS_SET_REGION;
-	vecp[i++].u_fc.set_region = xfs_dm_set_region;
-	vecp[i].func_no = DM_FSYS_SYMLINK_BY_HANDLE;
-	vecp[i++].u_fc.symlink_by_handle = xfs_dm_symlink_by_handle;
-	vecp[i].func_no = DM_FSYS_SYNC_BY_HANDLE;
-	vecp[i++].u_fc.sync_by_handle = xfs_dm_sync_by_handle;
-	vecp[i].func_no = DM_FSYS_UPGRADE_RIGHT;
-	vecp[i++].u_fc.upgrade_right = xfs_dm_upgrade_right;
-	vecp[i].func_no = DM_FSYS_WRITE_INVIS_RVP;
-	vecp[i++].u_fc.write_invis_rvp = xfs_dm_write_invis_rvp;
-	vecp[i].func_no = DM_FSYS_OBJ_REF_HOLD;
-	vecp[i++].u_fc.obj_ref_hold = xfs_dm_obj_ref_hold;
-
-	return(0);
-}
-
-
 /*	xfs_dm_send_mmap_event - send events needed for memory mapping a file.
  *
  *	This is a workaround called for files that are about to be
@@ -3291,12 +3194,47 @@ xfs_dm_get_fsid(
 /*
  * Filesystem operations accessed by the DMAPI core.
  */
-static struct filesystem_dmapi_operations xfs_dmapiops = {
-	.get_fsys_vector	= xfs_dm_get_dmapiops,
+static struct dmapi_operations xfs_dmapiops = {
+	.fstype			= &xfs_fs_type,
 	.fh_to_inode		= xfs_dm_fh_to_inode,
 	.get_invis_ops		= xfs_dm_get_invis_ops,
 	.inode_to_fh		= xfs_dm_inode_to_fh,
 	.get_fsid		= xfs_dm_get_fsid,
+	.clear_inherit		= xfs_dm_clear_inherit,
+	.create_by_handle	= xfs_dm_create_by_handle,
+	.downgrade_right	= xfs_dm_downgrade_right,
+	.get_allocinfo_rvp	= xfs_dm_get_allocinfo_rvp,
+	.get_bulkall_rvp	= xfs_dm_get_bulkall_rvp,
+	.get_bulkattr_rvp	= xfs_dm_get_bulkattr_rvp,
+	.get_config		= xfs_dm_get_config,
+	.get_config_events	= xfs_dm_get_config_events,
+	.get_destroy_dmattr	= xfs_dm_get_destroy_dmattr,
+	.get_dioinfo		= xfs_dm_get_dioinfo,
+	.get_dirattrs_rvp	= xfs_dm_get_dirattrs_rvp,
+	.get_dmattr		= xfs_dm_get_dmattr,
+	.get_eventlist		= xfs_dm_get_eventlist,
+	.get_fileattr		= xfs_dm_get_fileattr,
+	.get_region		= xfs_dm_get_region,
+	.getall_dmattr		= xfs_dm_getall_dmattr,
+	.getall_inherit		= xfs_dm_getall_inherit,
+	.init_attrloc		= xfs_dm_init_attrloc,
+	.mkdir_by_handle	= xfs_dm_mkdir_by_handle,
+	.probe_hole		= xfs_dm_probe_hole,
+	.punch_hole		= xfs_dm_punch_hole,
+	.read_invis_rvp		= xfs_dm_read_invis_rvp,
+	.release_right		= xfs_dm_release_right,
+	.remove_dmattr		= xfs_dm_remove_dmattr,
+	.request_right		= xfs_dm_request_right,
+	.set_dmattr		= xfs_dm_set_dmattr,
+	.set_eventlist		= xfs_dm_set_eventlist,
+	.set_fileattr		= xfs_dm_set_fileattr,
+	.set_inherit		= xfs_dm_set_inherit,
+	.set_region		= xfs_dm_set_region,
+	.symlink_by_handle	= xfs_dm_symlink_by_handle,
+	.sync_by_handle		= xfs_dm_sync_by_handle,
+	.upgrade_right		= xfs_dm_upgrade_right,
+	.write_invis_rvp	= xfs_dm_write_invis_rvp,
+	.obj_ref_hold		= xfs_dm_obj_ref_hold,
 };
 
 static int __init
@@ -3304,14 +3242,14 @@ xfs_dm_init(void)
 {
 	printk(KERN_INFO "SGI XFS Data Management API subsystem\n");
 
-	dmapi_register(&xfs_fs_type, &xfs_dmapiops);
+	dmapi_register(&xfs_dmapiops);
 	return 0;
 }
 
 static void __exit
 xfs_dm_exit(void)
 {
-	dmapi_unregister(&xfs_fs_type);
+	dmapi_unregister(&xfs_dmapiops);
 }
 
 MODULE_AUTHOR("Silicon Graphics, Inc.");
Index: linux-2.6-xfs/fs/dmapi/dmapi_private.h
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_private.h	2008-08-01 23:54:17.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_private.h	2008-08-02 01:38:20.000000000 +0200
@@ -44,8 +44,6 @@
 extern struct kmem_cache	*dm_fsreg_cachep;
 extern struct kmem_cache	*dm_tokdata_cachep;
 extern struct kmem_cache	*dm_session_cachep;
-extern struct kmem_cache	*dm_fsys_map_cachep;
-extern struct kmem_cache	*dm_fsys_vptr_cachep;
 
 typedef struct dm_tokdata {
 	struct dm_tokdata *td_next;
@@ -243,60 +241,6 @@ typedef struct dm_fsreg {
 #define DM_MAX_MSG_DATA		3960
 
 
-
-/* Supported filesystem function vector functions. */
-
-
-typedef struct {
-	int				code_level;
-	dm_fsys_clear_inherit_t		clear_inherit;
-	dm_fsys_create_by_handle_t	create_by_handle;
-	dm_fsys_downgrade_right_t	downgrade_right;
-	dm_fsys_get_allocinfo_rvp_t	get_allocinfo_rvp;
-	dm_fsys_get_bulkall_rvp_t	get_bulkall_rvp;
-	dm_fsys_get_bulkattr_rvp_t	get_bulkattr_rvp;
-	dm_fsys_get_config_t		get_config;
-	dm_fsys_get_config_events_t	get_config_events;
-	dm_fsys_get_destroy_dmattr_t	get_destroy_dmattr;
-	dm_fsys_get_dioinfo_t		get_dioinfo;
-	dm_fsys_get_dirattrs_rvp_t	get_dirattrs_rvp;
-	dm_fsys_get_dmattr_t		get_dmattr;
-	dm_fsys_get_eventlist_t		get_eventlist;
-	dm_fsys_get_fileattr_t		get_fileattr;
-	dm_fsys_get_region_t		get_region;
-	dm_fsys_getall_dmattr_t		getall_dmattr;
-	dm_fsys_getall_inherit_t	getall_inherit;
-	dm_fsys_init_attrloc_t		init_attrloc;
-	dm_fsys_mkdir_by_handle_t	mkdir_by_handle;
-	dm_fsys_probe_hole_t		probe_hole;
-	dm_fsys_punch_hole_t		punch_hole;
-	dm_fsys_read_invis_rvp_t	read_invis_rvp;
-	dm_fsys_release_right_t		release_right;
-	dm_fsys_remove_dmattr_t		remove_dmattr;
-	dm_fsys_request_right_t		request_right;
-	dm_fsys_set_dmattr_t		set_dmattr;
-	dm_fsys_set_eventlist_t		set_eventlist;
-	dm_fsys_set_fileattr_t		set_fileattr;
-	dm_fsys_set_inherit_t		set_inherit;
-	dm_fsys_set_region_t		set_region;
-	dm_fsys_symlink_by_handle_t	symlink_by_handle;
-	dm_fsys_sync_by_handle_t	sync_by_handle;
-	dm_fsys_upgrade_right_t		upgrade_right;
-	dm_fsys_write_invis_rvp_t	write_invis_rvp;
-	dm_fsys_obj_ref_hold_t		obj_ref_hold;
-} dm_fsys_vector_t;
-
-
-typedef struct	{
-	struct list_head	ftype_list;	/* list of fstypes */
-	struct list_head	sb_list;	/* list of sb's per fstype */
-	struct file_system_type *f_type;
-	struct filesystem_dmapi_operations *dmapiops;
-	dm_fsys_vector_t	*vptr;
-	struct super_block	*sb;
-} dm_vector_map_t;
-
-
 extern	dm_session_t	*dm_sessions;		/* head of session list */
 extern	dm_fsreg_t	*dm_registers;
 extern	lock_t		dm_reg_lock;		/* lock for registration list */
@@ -462,12 +406,9 @@ void		dm_remove_fsys_entry(
 dm_fsys_vector_t *dm_fsys_vector(
 			struct inode	*ip);
 
-struct filesystem_dmapi_operations *dm_fsys_ops(
+struct dmapi_operations *dm_fsys_ops(
 			struct super_block	*sb);
 
-void dm_fsys_ops_release(
-			 struct super_block	*sb);
-
 int		dm_waitfor_disp_session(
 			struct super_block	*sb,
 			dm_tokevent_t	*tevp,
Index: linux-2.6-xfs/fs/dmapi/dmapi_sysent.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_sysent.c	2008-08-01 23:54:17.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_sysent.c	2008-08-02 01:42:42.000000000 +0200
@@ -54,8 +54,56 @@
 struct kmem_cache	*dm_fsreg_cachep = NULL;
 struct kmem_cache	*dm_tokdata_cachep = NULL;
 struct kmem_cache	*dm_session_cachep = NULL;
-struct kmem_cache	*dm_fsys_map_cachep = NULL;
-struct kmem_cache	*dm_fsys_vptr_cachep = NULL;
+
+
+static LIST_HEAD(dm_fsys_map);
+static DEFINE_SPINLOCK(dm_fsys_lock);
+
+
+/*
+ * Ask for the dmapiops for this filesystem instance.  The caller is
+ * also asking if this is a dmapi-managed filesystem.
+ */
+struct dmapi_operations *dm_fsys_ops(struct super_block *sb)
+{
+	struct dmapi_operations *ops;
+
+	spin_lock(&dm_fsys_lock);
+	list_for_each_entry(ops, &dm_fsys_map, list) {
+		if (ops->fstype == sb->s_type) {
+			spin_unlock(&dm_fsys_lock);
+			return ops;
+		}
+	}
+	spin_unlock(&dm_fsys_lock);
+	return NULL;
+}
+
+struct dmapi_operations *dm_fsys_vector(struct inode *inode)
+{
+	return dm_fsys_ops(inode->i_sb);
+}
+
+/*
+ * Called by a filesystem module that is loading into the kernel
+ * to register it's dmapi operation vector.
+ */
+void dmapi_register(struct dmapi_operations *dmapiops)
+{
+	spin_lock(&dm_fsys_lock);
+	list_add_tail(&dmapiops->list, &dm_fsys_map);
+	spin_unlock(&dm_fsys_lock);
+}
+
+/*
+ * Called by a filesystem module that is unloading from the kernel.
+ */
+void dmapi_unregister(struct dmapi_operations *dmapiops)
+{
+	spin_lock(&dm_fsys_lock);
+	list_del(&dmapiops->list);
+	spin_unlock(&dm_fsys_lock);
+}
 
 static int
 dmapi_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
@@ -741,28 +789,15 @@ int __init dmapi_init(void)
 	if (dm_session_cachep == NULL)
 		goto out_free_fsreg_cachep;
 
-	dm_fsys_map_cachep = kmem_cache_create("dm_fsys_map",
-				sizeof(dm_vector_map_t), 0, 0, NULL);
-	if (dm_fsys_map_cachep == NULL)
-		goto out_free_session_cachep;
-	dm_fsys_vptr_cachep = kmem_cache_create("dm_fsys_vptr",
-				sizeof(dm_fsys_vector_t), 0, 0, NULL);
-	if (dm_fsys_vptr_cachep == NULL)
-		goto out_free_fsys_map_cachep;
-
 	ret = misc_register(&dmapi_dev);
 	if (ret) {
 		printk(KERN_ERR "dmapi_init: misc_register returned %d\n", ret);
-		goto out_free_fsys_vptr_cachep;
+		goto out_free_session_cachep;
 	}
 
 	dmapi_init_procfs(dmapi_dev.minor);
 	return 0;
 
- out_free_fsys_vptr_cachep:
-	kmem_cache_destroy(dm_fsys_vptr_cachep);
- out_free_fsys_map_cachep:
-	kmem_cache_destroy(dm_fsys_map_cachep);
  out_free_session_cachep:
 	kmem_cache_destroy(dm_session_cachep);
  out_free_fsreg_cachep:
@@ -781,8 +816,6 @@ void __exit dmapi_uninit(void)
 	kmem_cache_destroy(dm_tokdata_cachep);
 	kmem_cache_destroy(dm_fsreg_cachep);
 	kmem_cache_destroy(dm_session_cachep);
-	kmem_cache_destroy(dm_fsys_map_cachep);
-	kmem_cache_destroy(dm_fsys_vptr_cachep);
 }
 #endif
 
@@ -801,5 +834,4 @@ EXPORT_SYMBOL(dm_send_destroy_event);
 EXPORT_SYMBOL(dm_ip_to_handle);
 EXPORT_SYMBOL(dmapi_register);
 EXPORT_SYMBOL(dmapi_unregister);
-EXPORT_SYMBOL(dmapi_registered);
 EXPORT_SYMBOL(dm_release_threads);
Index: linux-2.6-xfs/fs/dmapi/dmapi_register.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_register.c	2008-08-02 01:35:34.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_register.c	2008-08-02 01:38:00.000000000 +0200
@@ -206,7 +206,7 @@ dm_add_fsys_entry(
 	void		*msg;
 	unsigned long	lc;			/* lock cookie */
 	dm_fsid_t	fsid;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	dops = dm_fsys_ops(sb);
 	ASSERT(dops);
@@ -297,7 +297,7 @@ dm_change_fsys_entry(
 	int		seq_error;
 	unsigned long	lc;			/* lock cookie */
 	dm_fsid_t	fsid;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	/* Find the filesystem referenced by the sb's fsid_t.	 This should
 	   always succeed.
@@ -393,7 +393,7 @@ dm_remove_fsys_entry(
 	dm_fsreg_t	**fsrpp;
 	dm_fsreg_t	*fsrp;
 	unsigned long	lc;			/* lock cookie */
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 	dm_fsid_t	fsid;
 
 	dops = dm_fsys_ops(sb);
@@ -464,7 +464,6 @@ dm_remove_fsys_entry(
 	remove_proc_entry(buf, NULL);
 	}
 #endif
-	dm_fsys_ops_release(sb);
 	sv_destroy(&fsrp->fr_dispq);
 	sv_destroy(&fsrp->fr_queue);
 	spinlock_destroy(&fsrp->fr_lock);
@@ -506,7 +505,7 @@ dm_handle_to_ip(
 	struct super_block *sb;
 	struct inode	*ip;
 	int		filetype;
-	struct filesystem_dmapi_operations *dmapiops;
+	struct dmapi_operations *dmapiops;
 
 	if ((fsrp = dm_find_fsreg_and_lock(&handlep->ha_fsid, &lc)) == NULL)
 		return NULL;
@@ -591,7 +590,7 @@ dm_ip_to_handle(
 	dm_fid_t	fid;
 	dm_fsid_t	fsid;
 	int		hsize;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	dops = dm_fsys_ops(ip->i_sb);
 	ASSERT(dops);
@@ -683,7 +682,7 @@ dm_waitfor_disp(
 	dm_session_t	*s;
 	dm_fsreg_t	*fsrp;
 	dm_fsid_t	fsid;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	dops = dm_fsys_ops(sb);
 	ASSERT(dops);
@@ -864,7 +863,7 @@ dm_path_to_hdl(
 	struct inode *inode;
 	size_t		len;
 	char		*name;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	/* XXX get things straightened out so getname() works here? */
 	if (!(len = strnlen_user(path, PATH_MAX)))
@@ -940,7 +939,7 @@ dm_path_to_fshdl(
 	struct inode *inode;
 	size_t		len;
 	char		*name;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	/* XXX get things straightened out so getname() works here? */
 	if(!(len = strnlen_user(path, PATH_MAX)))
@@ -1577,7 +1576,7 @@ dm_open_by_handle_rvp(
 	}
 
 	if (td_type == DM_TDT_REG) {
-		struct filesystem_dmapi_operations *dmapiops;
+		struct dmapi_operations *dmapiops;
 		dmapiops = dm_fsys_ops(inodep->i_sb);
 		if (dmapiops && dmapiops->get_invis_ops) {
 			/* invisible operation should not change atime */
Index: linux-2.6-xfs/fs/dmapi/Makefile
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/Makefile	2008-08-02 01:42:50.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/Makefile	2008-08-02 01:42:56.000000000 +0200
@@ -46,7 +46,6 @@ dmapi-y				+= dmapi_sysent.o \
 				   dmapi_handle.o \
 				   dmapi_hole.o \
 				   dmapi_io.o \
-				   dmapi_mountinfo.o \
 				   dmapi_region.o \
 				   dmapi_register.o \
 				   dmapi_right.o \
Index: linux-2.6-xfs/fs/dmapi/dmapi_event.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_event.c	2008-08-02 01:37:00.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_event.c	2008-08-02 01:37:14.000000000 +0200
@@ -199,7 +199,7 @@ dm_sb_data(
 	dm_right_t	right)
 {
 	dm_tokdata_t	*tdp;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 	dm_fsid_t	fsid;
 
 	dops = dm_fsys_ops(sb);
Index: linux-2.6-xfs/fs/dmapi/dmapi_session.c
===================================================================
--- linux-2.6-xfs.orig/fs/dmapi/dmapi_session.c	2008-08-02 01:37:19.000000000 +0200
+++ linux-2.6-xfs/fs/dmapi/dmapi_session.c	2008-08-02 01:37:29.000000000 +0200
@@ -1381,7 +1381,7 @@ dm_enqueue(
 			return tevp->te_reply;
 		}
 		else {
-			struct filesystem_dmapi_operations *dops;
+			struct dmapi_operations *dops;
 			dm_tokdata_t	*tdp;
 			int		errno = 0;
 
@@ -1767,7 +1767,7 @@ dm_release_threads(
 	int		i;
 	int		found_events = 0;
 	dm_fsid_t	fsid;
-	struct filesystem_dmapi_operations *dops;
+	struct dmapi_operations *dops;
 
 	ASSERT(sb);
 	dops = dm_fsys_ops(sb);
