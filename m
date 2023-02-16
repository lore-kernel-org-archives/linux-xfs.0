Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC50C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:12:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjBPVMT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBPVMT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:12:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71292BF17
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:12:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 848EA60A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3908C433D2;
        Thu, 16 Feb 2023 21:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581936;
        bh=KBLlmPl1kyYmza4O1Amh/NzzWPgoYW+hdJsWmlaEIOA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=putqZglIMJFSjvRq6X+ZxXiqwKg+CBIqfhtrXCATwVbeb8Y1vUIkCxVbW8Tab3jBb
         Tjzbh5SaG7FAzw5auiM8eyXQIx0PmEF8SOM5d1mu5z7RcWlcZay6OgsrdQOvo0F+fY
         x2IsesrRwcvjUPjExu5q+lJudCRY/wOJkl1cl49Q5TM9sbt3Jos5MgkcmKdsaueSUs
         ASOUdxanWcyBRbOh5amUeBN2lDR002TYfrczvbxxBBUpi+y6kteWVfWD1tzmo8tvA5
         vElpTlaAWPXQtxdOH5CWam9PvKXBMpHbVacH5duJtZIf8bY8WoikZvw9zcVVrlmk18
         jzdQA0x0p1KGg==
Date:   Thu, 16 Feb 2023 13:12:16 -0800
Subject: [PATCH 1/3] xfs: rename xfs_pptr_info to xfs_getparents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882759.3478223.9534389676327770055.stgit@magnolia>
In-Reply-To: <167657882746.3478223.17677270918788774260.stgit@magnolia>
References: <167657882746.3478223.17677270918788774260.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rename the head structure of the parent pointer ioctl to match the name
of the ioctl (XFS_IOC_GETPARENTS).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c       |    4 ++--
 libfrog/pptrs.c   |   28 ++++++++++++++--------------
 libfrog/pptrs.h   |    2 +-
 libxfs/xfs_fs.h   |   51 ++++++++++++++++++++++++++-------------------------
 man/man3/xfsctl.3 |   16 ++++++++--------
 5 files changed, 51 insertions(+), 50 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 36522f26..1c1453f2 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -24,14 +24,14 @@ struct pptr_args {
 
 static int
 pptr_print(
-	struct xfs_pptr_info	*pi,
+	struct xfs_getparents	*pi,
 	struct xfs_parent_ptr	*pptr,
 	void			*arg)
 {
 	struct pptr_args	*args = arg;
 	unsigned int		namelen;
 
-	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+	if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT) {
 		printf(_("Root directory.\n"));
 		return 0;
 	}
diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 61fd1fb9..3bb441f0 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -12,17 +12,17 @@
 #include "libfrog/pptrs.h"
 
 /* Allocate a buffer large enough for some parent pointer records. */
-static inline struct xfs_pptr_info *
+static inline struct xfs_getparents *
 alloc_pptr_buf(
 	size_t			nr_ptrs)
 {
-	struct xfs_pptr_info	*pi;
+	struct xfs_getparents	*pi;
 
-	pi = malloc(xfs_pptr_info_sizeof(nr_ptrs));
+	pi = malloc(xfs_getparents_sizeof(nr_ptrs));
 	if (!pi)
 		return NULL;
-	memset(pi, 0, sizeof(struct xfs_pptr_info));
-	pi->pi_ptrs_size = nr_ptrs;
+	memset(pi, 0, sizeof(struct xfs_getparents));
+	pi->gp_ptrs_size = nr_ptrs;
 	return pi;
 }
 
@@ -37,7 +37,7 @@ handle_walk_parents(
 	walk_pptr_fn		fn,
 	void			*arg)
 {
-	struct xfs_pptr_info	*pi;
+	struct xfs_getparents	*pi;
 	struct xfs_parent_ptr	*p;
 	unsigned int		i;
 	ssize_t			ret = -1;
@@ -47,25 +47,25 @@ handle_walk_parents(
 		return errno;
 
 	if (handle) {
-		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
-		pi->pi_flags = XFS_PPTR_IFLAG_HANDLE;
+		memcpy(&pi->gp_handle, handle, sizeof(struct xfs_handle));
+		pi->gp_flags = XFS_GETPARENTS_IFLAG_HANDLE;
 	}
 
 	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	while (!ret) {
-		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT) {
 			ret = fn(pi, NULL, arg);
 			goto out_pi;
 		}
 
-		for (i = 0; i < pi->pi_ptrs_used; i++) {
-			p = xfs_ppinfo_to_pp(pi, i);
+		for (i = 0; i < pi->gp_ptrs_used; i++) {
+			p = xfs_getparents_rec(pi, i);
 			ret = fn(pi, p, arg);
 			if (ret)
 				goto out_pi;
 		}
 
-		if (pi->pi_flags & XFS_PPTR_OFLAG_DONE)
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)
 			break;
 
 		ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
@@ -128,7 +128,7 @@ static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
 
 static int
 handle_walk_parent_path_ptr(
-	struct xfs_pptr_info		*pi,
+	struct xfs_getparents		*pi,
 	struct xfs_parent_ptr		*p,
 	void				*arg)
 {
@@ -136,7 +136,7 @@ handle_walk_parent_path_ptr(
 	struct walk_ppaths_info		*wpi = wpli->wpi;
 	int				ret = 0;
 
-	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT)
+	if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
 	ret = path_component_change(wpli->pc, p->xpp_name,
diff --git a/libfrog/pptrs.h b/libfrog/pptrs.h
index 1666de06..ab1d0f2f 100644
--- a/libfrog/pptrs.h
+++ b/libfrog/pptrs.h
@@ -8,7 +8,7 @@
 
 struct path_list;
 
-typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi,
+typedef int (*walk_pptr_fn)(struct xfs_getparents *pi,
 		struct xfs_parent_ptr *pptr, void *arg);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index c65345d2..2a23c010 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -752,19 +752,20 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
-#define XFS_PPTR_MAXNAMELEN				256
+#define XFS_GETPARENTS_MAXNAMELEN	256
 
 /* return parents of the handle, not the open fd */
-#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+#define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
 
 /* target was the root directory */
-#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 1)
 
 /* Cursor is done iterating pptrs */
-#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+#define XFS_GETPARENTS_OFLAG_DONE	(1U << 2)
 
- #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
-				XFS_PPTR_OFLAG_DONE)
+#define XFS_GETPARENTS_FLAG_ALL		(XFS_GETPARENTS_IFLAG_HANDLE | \
+					 XFS_GETPARENTS_OFLAG_ROOT | \
+					 XFS_GETPARENTS_OFLAG_DONE)
 
 /* Get an inode parent pointer through ioctl */
 struct xfs_parent_ptr {
@@ -772,57 +773,57 @@ struct xfs_parent_ptr {
 	__u32		xpp_gen;			/* Inode generation */
 	__u32		xpp_rsvd;			/* Reserved */
 	__u64		xpp_rsvd2;			/* Reserved */
-	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+	__u8		xpp_name[XFS_GETPARENTS_MAXNAMELEN];	/* File name */
 };
 
 /* Iterate through an inodes parent pointers */
-struct xfs_pptr_info {
-	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
-	struct xfs_handle		pi_handle;
+struct xfs_getparents {
+	/* File handle, if XFS_GETPARENTS_IFLAG_HANDLE is set */
+	struct xfs_handle		gp_handle;
 
 	/*
 	 * Structure to track progress in iterating the parent pointers.
 	 * Must be initialized to zeroes before the first ioctl call, and
 	 * not touched by callers after that.
 	 */
-	struct xfs_attrlist_cursor	pi_cursor;
+	struct xfs_attrlist_cursor	gp_cursor;
 
-	/* Operational flags: XFS_PPTR_*FLAG* */
-	__u32				pi_flags;
+	/* Operational flags: XFS_GETPARENTS_*FLAG* */
+	__u32				gp_flags;
 
 	/* Must be set to zero */
-	__u32				pi_reserved;
+	__u32				gp_reserved;
 
 	/* # of entries in array */
-	__u32				pi_ptrs_size;
+	__u32				gp_ptrs_size;
 
 	/* # of entries filled in (output) */
-	__u32				pi_ptrs_used;
+	__u32				gp_ptrs_used;
 
 	/* Must be set to zero */
-	__u64				pi_reserved2[6];
+	__u64				gp_reserved2[6];
 
 	/*
 	 * An array of struct xfs_parent_ptr follows the header
-	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * information. Use xfs_getparents_rec() to access the
 	 * parent pointer array entries.
 	 */
-	struct xfs_parent_ptr		pi_parents[];
+	struct xfs_parent_ptr		gp_parents[];
 };
 
 static inline size_t
-xfs_pptr_info_sizeof(int nr_ptrs)
+xfs_getparents_sizeof(int nr_ptrs)
 {
-	return sizeof(struct xfs_pptr_info) +
+	return sizeof(struct xfs_getparents) +
 	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
 }
 
 static inline struct xfs_parent_ptr*
-xfs_ppinfo_to_pp(
-	struct xfs_pptr_info	*info,
-	int			idx)
+xfs_getparents_rec(
+	struct xfs_getparents	*info,
+	unsigned int		idx)
 {
-	return &info->pi_parents[idx];
+	return &info->gp_parents[idx];
 }
 
 /*
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 42ba3bba..0bcf8886 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -326,12 +326,12 @@ XFS_IOC_FSSETDM_BY_HANDLE is not supported as of Linux 5.5.
 .B XFS_IOC_GETPARENTS
 This command is used to get a files parent pointers.  Parent pointers are
 file attributes used to store meta data information about an inodes parent.
-This command takes a xfs_pptr_info structure with trailing array of
+This command takes a xfs_getparents structure with trailing array of
 struct xfs_parent_ptr as an input to store an inodes parents. The
-xfs_pptr_info_sizeof() and xfs_ppinfo_to_pp() routines are provided to
+xfs_getparents_sizeof() and xfs_getparents_rec() routines are provided to
 create and iterate through these structures.  The number of pointers stored
-in the array is indicated by the xfs_pptr_info.used field, and the
-XFS_PPTR_OFLAG_DONE flag will be set in xfs_pptr_info.flags when there are
+in the array is indicated by the xfs_getparents.used field, and the
+XFS_PPTR_OFLAG_DONE flag will be set in xfs_getparents.flags when there are
 no more parent pointers to be read.  The below code is an example
 of XFS_IOC_GETPARENTS usage:
 
@@ -345,13 +345,13 @@ of XFS_IOC_GETPARENTS usage:
 #include<xfs/xfs_fs.h>
 
 int main() {
-	struct xfs_pptr_info	*pi;
+	struct xfs_getparents	*pi;
 	struct xfs_parent_ptr	*p;
 	int			i, error, fd, nr_ptrs = 4;
 
-	unsigned char buffer[xfs_pptr_info_sizeof(nr_ptrs)];
+	unsigned char buffer[xfs_getparents_sizeof(nr_ptrs)];
 	memset(buffer, 0, sizeof(buffer));
-	pi = (struct xfs_pptr_info *)&buffer;
+	pi = (struct xfs_getparents *)&buffer;
 	pi->pi_ptrs_size = nr_ptrs;
 
 	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
@@ -364,7 +364,7 @@ int main() {
 			return error;
 
 		for (i = 0; i < pi->pi_ptrs_used; i++) {
-			p = xfs_ppinfo_to_pp(pi, i);
+			p = xfs_getparents_rec(pi, i);
 			printf("inode		= %llu\\n", (unsigned long long)p->xpp_ino);
 			printf("generation	= %u\\n", (unsigned int)p->xpp_gen);
 			printf("name		= \\"%s\\"\\n\\n", (char *)p->xpp_name);

