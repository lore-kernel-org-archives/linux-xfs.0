Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:38342 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbfETXRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:17:18 -0400
Subject: [PATCH 05/12] libxfs: refactor open-coded INUMBERS calls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 20 May 2019 16:17:12 -0700
Message-ID: <155839423260.68606.10599769594679056156.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the INUMBERS ioctl callsites into helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/linux.h    |    4 ++++
 io/imap.c          |   30 +++++++++++++-----------------
 io/open.c          |   19 +++++++------------
 libhandle/ioctl.c  |   18 ++++++++++++++++++
 scrub/fscounters.c |   17 ++++++-----------
 scrub/inodes.c     |   21 +++++++--------------
 6 files changed, 55 insertions(+), 54 deletions(-)


diff --git a/include/linux.h b/include/linux.h
index 98750e18..39190e11 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -333,4 +333,8 @@ int xfs_bulkstat_single(int fd, uint64_t ino, struct xfs_bstat *ubuffer);
 int xfs_bulkstat(int fd, uint64_t *lastino, uint32_t icount,
 		struct xfs_bstat *ubuffer, uint32_t *ocount);
 
+struct xfs_inogrp;
+int xfs_inumbers(int fd, uint64_t *lastino, uint32_t icount,
+		struct xfs_inogrp *ubuffer, uint32_t *ocount);
+
 #endif	/* __XFS_LINUX_H__ */
diff --git a/io/imap.c b/io/imap.c
index fbc8e9e1..49917545 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -14,12 +14,12 @@ static cmdinfo_t imap_cmd;
 static int
 imap_f(int argc, char **argv)
 {
-	int		count;
-	int		nent;
-	int		i;
-	__u64		last = 0;
-	xfs_inogrp_t	*t;
-	xfs_fsop_bulkreq_t bulkreq;
+	struct xfs_inogrp	*t;
+	uint64_t		last = 0;
+	uint32_t		count;
+	uint32_t		nent;
+	int			i;
+	int			error;
 
 	if (argc != 2)
 		nent = 1;
@@ -30,14 +30,8 @@ imap_f(int argc, char **argv)
 	if (!t)
 		return 0;
 
-	bulkreq.lastip  = &last;
-	bulkreq.icount  = nent;
-	bulkreq.ubuffer = (void *)t;
-	bulkreq.ocount  = &count;
-
-	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
-		if (count == 0)
-			goto out_free;
+	while ((error = xfs_inumbers(file->fd, &last, nent, t, &count)) == 0 &&
+	       count > 0) {
 		for (i = 0; i < count; i++) {
 			printf(_("ino %10llu count %2d mask %016llx\n"),
 				(unsigned long long)t[i].xi_startino,
@@ -45,9 +39,11 @@ imap_f(int argc, char **argv)
 				(unsigned long long)t[i].xi_allocmask);
 		}
 	}
-	perror("xfsctl(XFS_IOC_FSINUMBERS)");
-	exitcode = 1;
-out_free:
+
+	if (error) {
+		perror("xfsctl(XFS_IOC_FSINUMBERS)");
+		exitcode = 1;
+	}
 	free(t);
 	return 0;
 }
diff --git a/io/open.c b/io/open.c
index 6ceff18d..11805cd7 100644
--- a/io/open.c
+++ b/io/open.c
@@ -668,24 +668,19 @@ inode_help(void)
 "\n"));
 }
 
+#define IGROUP_NR	(1024)
 static __u64
 get_last_inode(void)
 {
-	__u64			lastip = 0;
-	__u64			lastgrp = 0;
-	__s32			ocount = 0;
+	uint64_t		lastip = 0;
+	uint32_t		lastgrp = 0;
+	uint32_t		ocount = 0;
 	__u64			last_ino;
-	struct xfs_inogrp	igroup[1024];
-	struct xfs_fsop_bulkreq	bulkreq;
-
-	bulkreq.lastip = &lastip;
-	bulkreq.ubuffer = &igroup;
-	bulkreq.icount = sizeof(igroup) / sizeof(struct xfs_inogrp);
-	bulkreq.ocount = &ocount;
+	struct xfs_inogrp	igroup[IGROUP_NR];
 
 	for (;;) {
-		if (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS,
-				&bulkreq)) {
+		if (xfs_inumbers(file->fd, &lastip, IGROUP_NR, igroup,
+					&ocount)) {
 			perror("XFS_IOC_FSINUMBERS");
 			return 0;
 		}
diff --git a/libhandle/ioctl.c b/libhandle/ioctl.c
index a4676fea..599fdf3e 100644
--- a/libhandle/ioctl.c
+++ b/libhandle/ioctl.c
@@ -62,3 +62,21 @@ xfs_bulkstat(
 	return ioctl(fd, XFS_IOC_FSBULKSTAT, &bulkreq);
 }
 
+/* Query inode allocation bitmask information. */
+int
+xfs_inumbers(
+	int			fd,
+	uint64_t		*lastino,
+	uint32_t		icount,
+	struct xfs_inogrp	*ubuffer,
+	uint32_t		*ocount)
+{
+	struct xfs_fsop_bulkreq	bulkreq = {
+		.lastip		= (__u64 *)lastino,
+		.icount		= icount,
+		.ubuffer	= ubuffer,
+		.ocount		= (__s32 *)ocount,
+	};
+
+	return ioctl(fd, XFS_IOC_FSINUMBERS, &bulkreq);
+}
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9e93e2a6..13f46e17 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -41,26 +41,21 @@ xfs_count_inodes_range(
 	uint64_t		last_ino,
 	uint64_t		*count)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_inogrp	inogrp;
-	__u64			igrp_ino;
+	uint64_t		igrp_ino;
 	uint64_t		nr = 0;
-	__s32			igrplen = 0;
+	uint32_t		igrplen = 0;
 	int			error;
 
 	ASSERT(!(first_ino & (XFS_INODES_PER_CHUNK - 1)));
 	ASSERT((last_ino & (XFS_INODES_PER_CHUNK - 1)));
 
-	igrpreq.lastip  = &igrp_ino;
-	igrpreq.icount  = 1;
-	igrpreq.ubuffer = &inogrp;
-	igrpreq.ocount  = &igrplen;
-
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen && inogrp.xi_startino < last_ino) {
+	while ((error = xfs_inumbers(ctx->mnt_fd, &igrp_ino, 1, &inogrp,
+					&igrplen)) == 0 &&
+	       igrplen > 0 &&
+	       inogrp.xi_startino < last_ino) {
 		nr += inogrp.xi_alloccount;
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 	if (error) {
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 702b7d50..b27edef7 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -89,17 +89,16 @@ xfs_iterate_inodes_range(
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
 	char			idescr[DESCR_BUFSZ];
 	char			buf[DESCR_BUFSZ];
 	struct xfs_bstat	*bs;
-	__u64			igrp_ino;
+	uint64_t		igrp_ino;
 	uint64_t		ino;
 	uint32_t		bulklen = 0;
-	__s32			igrplen = 0;
+	uint32_t		igrplen = 0;
 	bool			moveon = true;
 	int			i;
 	int			error;
@@ -108,11 +107,6 @@ xfs_iterate_inodes_range(
 
 	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
 
-	igrpreq.lastip  = &igrp_ino;
-	igrpreq.icount  = 1;
-	igrpreq.ubuffer = &inogrp;
-	igrpreq.ocount  = &igrplen;
-
 	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
@@ -120,8 +114,9 @@ xfs_iterate_inodes_range(
 
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen) {
+	while ((error = xfs_inumbers(ctx->mnt_fd, &igrp_ino, 1, &inogrp,
+					&igrplen)) == 0 &&
+	       igrplen > 0) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
 
@@ -130,7 +125,7 @@ xfs_iterate_inodes_range(
 		 * there are more than 64 inodes per block.  Skip these.
 		 */
 		if (inogrp.xi_alloccount == 0)
-			goto igrp_retry;
+			continue;
 		error = xfs_bulkstat(ctx->mnt_fd, &ino, inogrp.xi_alloccount,
 				bstat, &bulklen);
 		if (error)
@@ -154,7 +149,7 @@ xfs_iterate_inodes_range(
 				stale_count++;
 				if (stale_count < 30) {
 					igrp_ino = inogrp.xi_startino;
-					goto igrp_retry;
+					continue;
 				}
 				snprintf(idescr, DESCR_BUFSZ, "inode %"PRIu64,
 						(uint64_t)bs->bs_ino);
@@ -176,8 +171,6 @@ _("Changed too many times during scan; giving up."));
 		}
 
 		stale_count = 0;
-igrp_retry:
-		error = ioctl(ctx->mnt_fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 err:
