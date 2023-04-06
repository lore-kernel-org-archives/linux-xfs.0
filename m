Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB89C76196
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237098AbjDFTfE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236921AbjDFTfD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C1786A5
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:34:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F5F964B97
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C139C433D2;
        Thu,  6 Apr 2023 19:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809697;
        bh=zi8a8zpliJ7aEelYQcewBp6t8xww1DEDi+oCivBoZtc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IfTGDkbU+jubgnlsDb89MieOBy5uWLyHFgcvnIy0dWR/mMORG+kloEOTVB91tbT1K
         o2JJzfJsH0yPSV9vACthF9PlbKSU98nacJue1qY23DRT9f6cWZGw38rtTFpjJtk+7X
         +wAnwbg0fhryzaqO2L6LZLDUjSXqDyZs0KECqDmNtBDcAjLTWuYu0G/zsV+gQD8jTv
         FaPQQWKXMVB/rSnbKl0aZwpZT5liFf63Zc7toO6dx6MtswwKreqRncq5KkonxNo60T
         5FR9aiBsjDZ8CylzuCwQF/PIjZoQIDPePacGTY/bnXUKwdz1hv6Fqj180DT0Yg7VaI
         UzZN1mq8r+wLA==
Date:   Thu, 06 Apr 2023 12:34:57 -0700
Subject: [PATCH 13/32] xfs: Add parent pointer ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827728.616793.892984000897631824.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: move new ioctl to xfs_fs_staging.h, adjust to new ondisk format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h         |    1 +
 libxfs/xfs_fs_staging.h |   66 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_parent.c     |   40 ++++++++++++++++++++++++++++
 libxfs/xfs_parent.h     |   23 ++++++++++++++++
 man/man3/xfsctl.3       |   63 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 193 insertions(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 1cfd5bc65..390b8cbe2 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -796,6 +796,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+/*	XFS_IOC_GETPARENTS ---- staging 62         */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index bc97193dd..fe11ad6f2 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -15,4 +15,70 @@
  * explaining where it went.
  */
 
+/* Iterating parent pointers of files. */
+
+/* return parents of the handle, not the open fd */
+#define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
+
+/* target was the root directory */
+#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_GETPARENTS_OFLAG_DONE	(1U << 2)
+
+#define XFS_GETPARENTS_FLAG_ALL		(XFS_GETPARENTS_IFLAG_HANDLE | \
+					 XFS_GETPARENTS_OFLAG_ROOT | \
+					 XFS_GETPARENTS_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_getparents_rec {
+	__u64		gpr_ino;	/* Inode number */
+	__u32		gpr_gen;	/* Inode generation */
+	__u32		gpr_pad;	/* Reserved */
+	__u64		gpr_rsvd;	/* Reserved */
+	__u8		gpr_name[];	/* File name and null terminator */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_getparents {
+	/* File handle, if XFS_GETPARENTS_IFLAG_HANDLE is set */
+	struct xfs_handle		gp_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	gp_cursor;
+
+	/* Operational flags: XFS_GETPARENTS_*FLAG* */
+	__u32				gp_flags;
+
+	/* Must be set to zero */
+	__u32				gp_reserved;
+
+	/* Size of the buffer in bytes, including this header */
+	__u32				gp_bufsize;
+
+	/* # of entries filled in (output) */
+	__u32				gp_count;
+
+	/* Must be set to zero */
+	__u64				gp_reserved2[5];
+
+	/* Byte offset of each record within the buffer */
+	__u32				gp_offsets[];
+};
+
+static inline struct xfs_getparents_rec*
+xfs_getparents_rec(
+	struct xfs_getparents	*info,
+	unsigned int		idx)
+{
+	return (struct xfs_getparents_rec *)((char *)info +
+					     info->gp_offsets[idx]);
+}
+
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index 9f61b9fc6..e276a1d91 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -276,3 +276,43 @@ xfs_parent_calc_space_res(
 	return XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) +
 	       XFS_NEXTENTADD_SPACE_RES(mp, namelen, XFS_ATTR_FORK);
 }
+
+/* Convert an ondisk parent pointer to the incore format. */
+void
+xfs_parent_irec_from_disk(
+	struct xfs_parent_name_irec	*irec,
+	const struct xfs_parent_name_rec *rec,
+	const void			*value,
+	unsigned int			valuelen)
+{
+	irec->p_ino = be64_to_cpu(rec->p_ino);
+	irec->p_gen = be32_to_cpu(rec->p_gen);
+	irec->p_namehash = be32_to_cpu(rec->p_namehash);
+	irec->p_namelen = valuelen;
+	memcpy(irec->p_name, value, valuelen);
+}
+
+/* Convert an incore parent pointer to the ondisk attr name format. */
+void
+xfs_parent_irec_to_disk(
+	struct xfs_parent_name_rec	*rec,
+	const struct xfs_parent_name_irec *irec)
+{
+	rec->p_ino = cpu_to_be64(irec->p_ino);
+	rec->p_gen = cpu_to_be32(irec->p_gen);
+	rec->p_namehash = cpu_to_be32(irec->p_namehash);
+}
+
+/* Compute p_namehash for the this parent pointer. */
+void
+xfs_parent_irec_hashname(
+	struct xfs_mount		*mp,
+	struct xfs_parent_name_irec	*irec)
+{
+	struct xfs_name			dname = {
+		.name			= irec->p_name,
+		.len			= irec->p_namelen,
+	};
+
+	irec->p_namehash = xfs_dir2_hashname(mp, &dname);
+}
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index f4a0793bc..1cc477896 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -78,4 +78,27 @@ xfs_parent_finish(
 unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 		unsigned int namelen);
 
+/*
+ * Incore version of a parent pointer, also contains dirent name so callers
+ * can pass/obtain all the parent pointer information in a single structure
+ */
+struct xfs_parent_name_irec {
+	/* Parent pointer attribute name fields */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+	xfs_dahash_t		p_namehash;
+
+	/* Parent pointer attribute value fields */
+	uint8_t			p_namelen;
+	unsigned char		p_name[MAXNAMELEN];
+};
+
+void xfs_parent_irec_from_disk(struct xfs_parent_name_irec *irec,
+		const struct xfs_parent_name_rec *rec, const void *value,
+		unsigned int valuelen);
+void xfs_parent_irec_to_disk(struct xfs_parent_name_rec *rec,
+		const struct xfs_parent_name_irec *irec);
+void xfs_parent_irec_hashname(struct xfs_mount *mp,
+		struct xfs_parent_name_irec *irec);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index 4a0d4d08d..e663b64a8 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -321,6 +321,69 @@ They are all subject to change and should not be called directly
 by applications.
 XFS_IOC_FSSETDM_BY_HANDLE is not supported as of Linux 5.5.
 
+.PP
+.TP
+.B XFS_IOC_GETPARENTS
+This command is used to get a file's parent pointers.
+Parent pointers point upwards in the directory tree towards directories that
+have entries pointing downwards.
+
+Calling programs should allocate a large memory buffer, initialize the head
+structure to zeroes, set gp_bufsize to the size of the buffer, and call the
+ioctl.
+The kernel will fill out the gp_offsets array with integer offsets to
+struct xfs_getparents_rec objects that are written within the provided memory
+buffer.
+The size of the gp_offsets array is given by gp_count.
+The XFS_GETPARENTS_OFLAG_DONE flag will be set in gp_flags when there are no
+more parent pointers to be read.
+The below code is an example of XFS_IOC_GETPARENTS usage:
+
+.nf
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <xfs/linux.h>
+#include <xfs/xfs.h>
+#include <xfs/xfs_types.h>
+#include <xfs/xfs_fs.h>
+#include <xfs/xfs_fs_staging.h>
+
+int main() {
+	struct xfs_getparents		*pi;
+	struct xfs_getparents_rec	*p;
+	int				i, error, fd, nr_ptrs = 4;
+
+	error = malloc(65536);
+	if (!error) {
+		perror("malloc");
+		return 1;
+	}
+
+	memset(pi, 0, sizeof(*pi));
+	pi->gp_bufsize = 65536;
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
+		for (i = 0; i < pi->gp_count; i++) {
+			p = xfs_getparents_rec(pi, i);
+			printf("inode		= %llu\\n", (unsigned long long)p->gpr_ino);
+			printf("generation	= %u\\n", (unsigned int)p->gpr_gen);
+			printf("name		= \\"%s\\"\\n\\n", (char *)p->gpr_name);
+		}
+	} while (!(pi->gp_flags & XFS_GETPARENTS_OFLAG_DONE));
+
+	return 0;
+}
+.fi
+
 .SS Filesystem Operations
 In order to effect one of the following operations, the pathname
 and descriptor arguments passed to

