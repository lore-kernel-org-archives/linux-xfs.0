Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065B6C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbjEZCYq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE599B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:24:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C3E564C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCA2C433D2;
        Fri, 26 May 2023 02:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067882;
        bh=4AtpfouBPprLqz68MPnhTVZXGa/u5A7PV6OU3W3FHYE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=p9Ir+9y3nTp0JUPOJeNzl6tFqhUOwiZwV6A/l9McBgG6tVZyPcBMcUBeWYCDJV806
         DZSz8cqro1uJ918RYfW1q0ZGMWbgo98Zzr91OXkOWooNgFsco8zSj04Be2Kdh/bBnn
         4GoLTTQrTu1P+ZPX5vFUf/PmfhumDz5Svu6wNr3vEXJw6jlUGD1ZvneCcuPL8N3gZY
         huGuStzv6D3jETQ1dIYvlfXtYP7otSC2zBo7PIN/XihEDB1mtU98wsrFrWh18H+rT0
         2NgJQtCNQI3Ex7xM9I51500MolUj8otp16xHiaQnonf8Sf4e3ZHRQ5YU8xiDgD29iO
         jvC8shLZ5BOLA==
Date:   Thu, 25 May 2023 19:24:42 -0700
Subject: [PATCH 11/30] xfs: Add parent pointer ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506078037.3749421.14369016032968756040.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
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
index cf909dbeed8..51b31e987a0 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -807,6 +807,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+/*	XFS_IOC_GETPARENTS ---- staging 62         */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 0453e7f31af..5a9236334c3 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -104,4 +104,70 @@ struct xfs_exch_range {
 
 #define XFS_IOC_EXCHANGE_RANGE	_IOWR('X', 129, struct xfs_exch_range)
 
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
index fe27dabc50d..b1890f48722 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -283,3 +283,43 @@ __xfs_parent_cancel(
 		xlog_drop_incompat_feat(mp->m_log, XLOG_INCOMPAT_FEAT_XATTRS);
 	kmem_cache_free(xfs_parent_intent_cache, parent);
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
index 637f99fba9d..0f4808990ce 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -75,4 +75,27 @@ xfs_parent_finish(
 		__xfs_parent_cancel(mp, p);
 }
 
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
index 4a0d4d08d08..e663b64a81b 100644
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

