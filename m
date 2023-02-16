Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D51C8C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjBPU6C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjBPU6B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:58:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E5631E31
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:57:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16C69B82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F60C433D2;
        Thu, 16 Feb 2023 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581076;
        bh=ILMdEUeBruRY9kokNbKbmhhPLObrAUPJKa1EWWbVpEQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=pIKLDUhZltNKNe9ny0YuofIKBgZKEHo3J9q5CKXoYbdVc7pIcla+RH2NX2WE6TcrA
         jxtjavq0q4lrJX8VgOAMkmT/+CaIC6Ebv40UEfniQ5l4DJmoki+bQlMfbJxPUohdxN
         bDxS3SO4qifgEQ4StrfRgaHxUt5VQwu+v817+H6fJZeOncAJmOUZhi6+Sy5gI5hFNn
         68RBPEzZrsowQ/y/RV1pJipEl8a/S8PCY3/gF62ZO9W9q8wGMBC69+E+8+9NfBjhce
         Zj2dW/McGMopu0ddrUPVo6kUKTQmLB8v4kIsioTJHLnr3t/V3kXqUeZkVXGA5a6CdA
         Iuj671DN5W21g==
Date:   Thu, 16 Feb 2023 12:57:56 -0800
Subject: [PATCH 17/25] xfsprogs: Add parent pointer ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879137.3476112.1273779539233633833.stgit@magnolia>
In-Reply-To: <167657878885.3476112.11949206434283274332.stgit@magnolia>
References: <167657878885.3476112.11949206434283274332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: 5e5cdd593342c5ff8aeef9daaa93293f63079b4b

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_fs.h     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.c |   10 +++++++
 libxfs/xfs_parent.h |    2 +
 man/man3/xfsctl.3   |   55 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 141 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index b0b4d7a3..9e59a1fd 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 3f02271f..47ea6b89 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -30,6 +30,16 @@
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index 03900588..13040b9d 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -25,6 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 4a0d4d08..7cc97499 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -321,6 +321,61 @@ They are all subject to change and should not be called directly
 by applications.
 XFS_IOC_FSSETDM_BY_HANDLE is not supported as of Linux 5.5.
 
+.PP
+.TP
+.B XFS_IOC_GETPARENTS
+This command is used to get a files parent pointers.  Parent pointers are
+file attributes used to store meta data information about an inodes parent.
+This command takes a xfs_pptr_info structure with trailing array of
+struct xfs_parent_ptr as an input to store an inodes parents. The
+xfs_pptr_info_sizeof() and xfs_ppinfo_to_pp() routines are provided to
+create and iterate through these structures.  The number of pointers stored
+in the array is indicated by the xfs_pptr_info.used field, and the
+XFS_PPTR_OFLAG_DONE flag will be set in xfs_pptr_info.flags when there are
+no more parent pointers to be read.  The below code is an example
+of XFS_IOC_GETPARENTS usage:
+
+.nf
+#include<stdio.h>
+#include<string.h>
+#include<errno.h>
+#include<xfs/linux.h>
+#include<xfs/xfs.h>
+#include<xfs/xfs_types.h>
+#include<xfs/xfs_fs.h>
+
+int main() {
+	struct xfs_pptr_info	*pi;
+	struct xfs_parent_ptr	*p;
+	int			i, error, fd, nr_ptrs = 4;
+
+	unsigned char buffer[xfs_pptr_info_sizeof(nr_ptrs)];
+	memset(buffer, 0, sizeof(buffer));
+	pi = (struct xfs_pptr_info *)&buffer;
+	pi->pi_ptrs_size = nr_ptrs;
+
+	fd = open("/mnt/test/foo.txt", O_RDONLY | O_CREAT);
+	if (fd  == -1)
+		return errno;
+
+	do {
+		error = ioctl(fd, XFS_IOC_GETPARENTS, pi);
+		if (error)
+			return error;
+
+		for (i = 0; i < pi->pi_ptrs_used; i++) {
+			p = xfs_ppinfo_to_pp(pi, i);
+			printf("inode		= %llu\\n", (unsigned long long)p->xpp_ino);
+			printf("generation	= %u\\n", (unsigned int)p->xpp_gen);
+			printf("diroffset	= %u\\n", (unsigned int)p->xpp_diroffset);
+			printf("name		= \\"%s\\"\\n\\n", (char *)p->xpp_name);
+		}
+	} while (!pi->pi_flags & XFS_PPTR_OFLAG_DONE);
+
+	return 0;
+}
+.fi
+
 .SS Filesystem Operations
 In order to effect one of the following operations, the pathname
 and descriptor arguments passed to

