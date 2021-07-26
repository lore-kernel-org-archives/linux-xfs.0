Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28D3AC432BE
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A8CA60F37
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Jul 2021 11:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233463AbhGZLH0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhGZLHZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 07:07:25 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8A9C061757
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:52 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b6so12501467pji.4
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 04:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZF4y63uU6hnZ920vMzn/BsJLSgTQl2eJt7sXvx5M1v4=;
        b=jytO5hsK45n5qkq7UMSOdXrO1pmTr0GqaphFEEf0Foxvy4htk1omVSiGZgw3n8K+lB
         ifc81vDhgn+aJBInURRsQaQSW1jWcMOTK+evHJFcWgtfji2LFRZNBYAPkvTxQaHweznh
         7HWB4LXaKlDiEOiqr++//uH9gmz8+d0Jg3zGEWt7fLZnuca/laQg+t3xKNtxTULdtP+j
         Bgx+ViYX24SF9Av0fmKTrHh8DQFAec9YPFiY43Xr3CGrKKaJS4bYwmzCxQ31D3G9VnIH
         UMUZ8uzLlBid7ZIR7lIHN/WZBBAyzBRDEJ1XMRcWnGe9r8Ip7pq+YHqSDpbnLOhsYwp7
         psfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZF4y63uU6hnZ920vMzn/BsJLSgTQl2eJt7sXvx5M1v4=;
        b=O0iGpOwzgsaBDG8PSIgo+2MH2kjsS6i0dmba6JANB9swqVDHgruG9GB9Ktj2qy9gKD
         7F/RzA0j58IXDc6X2OUvnWo1vxl1gvcEGQKjEaKzGXFVXiYzLLxA4XGLB6wSQebc1Gk2
         fBlcy8Q9O/c40XhGIYdUUpccuvBncjoJNS9Fx/CGlEDl3a5a8dF9U2/XMsSwtMQvRN1G
         JxPhRQwNyRxyDulAWLkdu74epFZMb/De5zivEde2EJfsea2IFkzHf4fZJpIc+g5Slzw6
         mNWdcjRHP1LCUdUzYXpm4sOOEbKccK+5W50XLmLEvGTskgKKp6pvbA52Zw92Hi4rTTNs
         tysQ==
X-Gm-Message-State: AOAM533O9CeDzLeRuZ1Z142a/K/YgwYM1EK/fNUuJfrbrzM7DGqvhqeR
        rP9rFOZiHv/axg6va3ZvPuivw1PDXok=
X-Google-Smtp-Source: ABdhPJzLhwcAjeYr8v9TgYqUqX111ErX7FXGlZMCpccUwxbJXMvzbkl7Qd6bB9tbbdy+Hq+TtmN1bA==
X-Received: by 2002:aa7:818a:0:b029:309:a073:51cb with SMTP id g10-20020aa7818a0000b0290309a07351cbmr17960673pfi.40.1627300072327;
        Mon, 26 Jul 2021 04:47:52 -0700 (PDT)
Received: from localhost.localdomain ([122.179.41.55])
        by smtp.gmail.com with ESMTPSA id y10sm35936900pjy.18.2021.07.26.04.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:47:52 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, djwong@kernel.org
Subject: [PATCH V2 10/12] xfsprogs: Enable bulkstat ioctl to support 64-bit extent counters
Date:   Mon, 26 Jul 2021 17:17:22 +0530
Message-Id: <20210726114724.24956-11-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726114724.24956-1-chandanrlinux@gmail.com>
References: <20210726114724.24956-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds XFS_IOC_BULKSTAT_V6 to support 64-bit inode extent
counters. The new field xfs_bulkstat->bs_extents64 is added to hold data
extent count for filesystems supporting 64-bit data extent counters.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fsr/xfs_fsr.c      |   9 +-
 io/bulkstat.c      |  10 +-
 libfrog/bulkstat.c | 260 ++++++++++++++++++++++++++-------------------
 libfrog/bulkstat.h |   7 +-
 libfrog/fsgeom.h   |   5 +-
 libxfs/xfs_fs.h    |   7 +-
 6 files changed, 175 insertions(+), 123 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 3446944cb..db917d015 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -6,6 +6,7 @@
 
 #include "libxfs.h"
 #include "xfs.h"
+#include "xfs/xfs_fs.h"
 #include "xfs_types.h"
 #include "jdm.h"
 #include "xfs_bmap_btree.h"
@@ -604,9 +605,11 @@ cmp(const void *s1, const void *s2)
 	ASSERT((bs1->bs_version == XFS_BULKSTAT_VERSION_V1 &&
 		bs2->bs_version == XFS_BULKSTAT_VERSION_V1) ||
 		(bs1->bs_version == XFS_BULKSTAT_VERSION_V5 &&
-		bs2->bs_version == XFS_BULKSTAT_VERSION_V5));
+		bs2->bs_version == XFS_BULKSTAT_VERSION_V5) ||
+		(bs1->bs_version == XFS_BULKSTAT_VERSION_V6 &&
+		bs2->bs_version == XFS_BULKSTAT_VERSION_V6));
 
-	return (bs2->bs_extents32 - bs1->bs_extents32);
+	return (bs2->bs_extents64 - bs1->bs_extents64);
 }
 
 /*
@@ -670,7 +673,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		for (p = buf, endp = (buf + buflenout); p < endp ; p++) {
 			/* Do some obvious checks now */
 			if (((p->bs_mode & S_IFMT) != S_IFREG) ||
-			     (p->bs_extents32 < 2))
+			     (p->bs_extents64 < 2))
 				continue;
 
 			ret = open_handle(&file_fd, fshandlep, p,
diff --git a/io/bulkstat.c b/io/bulkstat.c
index 378048379..92fbbaadb 100644
--- a/io/bulkstat.c
+++ b/io/bulkstat.c
@@ -49,7 +49,7 @@ dump_bulkstat(
 	printf("\tbs_extsize_blks = %"PRIu32"\n", bstat->bs_extsize_blks);
 
 	printf("\tbs_nlink = %"PRIu32"\n", bstat->bs_nlink);
-	printf("\tbs_extents = %"PRIu32"\n", bstat->bs_extents32);
+	printf("\tbs_extents = %"PRIu64"\n", bstat->bs_extents64);
 	printf("\tbs_aextents = %"PRIu32"\n", bstat->bs_aextents);
 	printf("\tbs_version = %"PRIu16"\n", bstat->bs_version);
 	printf("\tbs_forkoff = %"PRIu16"\n", bstat->bs_forkoff);
@@ -86,6 +86,9 @@ set_xfd_flags(
 	case 5:
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V5;
 		break;
+	case 6:
+		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V6;
+		break;
 	default:
 		break;
 	}
@@ -153,8 +156,9 @@ bulkstat_f(
 				perror(optarg);
 				return 1;
 			}
-			if (ver != 1 && ver != 5) {
-				fprintf(stderr, "version must be 1 or 5.\n");
+			if (ver != 1 && ver != 5 && ver != 6) {
+				fprintf(stderr,
+					"version must be 1 or 5 or 6.\n");
 				return 1;
 			}
 			break;
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index 5a967d4b1..b169a1334 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -5,6 +5,7 @@
  */
 #include <string.h>
 #include <strings.h>
+#include <assert.h>
 #include "xfs.h"
 #include "fsgeom.h"
 #include "bulkstat.h"
@@ -42,6 +43,42 @@ xfrog_bulkstat_prep_v1_emulation(
 	return xfd_prepare_geometry(xfd);
 }
 
+/* Bulkstat a single inode using v6 ioctl. */
+static int
+xfrog_bulkstat_single6(
+	struct xfs_fd			*xfd,
+	uint64_t			ino,
+	unsigned int			flags,
+	struct xfs_bulkstat		*bulkstat)
+{
+	struct xfs_bulkstat_req		*req;
+	int				ret;
+
+	if (flags & ~(XFS_BULK_IREQ_SPECIAL))
+		return -EINVAL;
+
+	ret = xfrog_bulkstat_alloc_req(1, ino, &req);
+	if (ret)
+		return ret;
+
+	req->hdr.flags = flags;
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT_V6, req);
+	if (ret) {
+		ret = -errno;
+		goto free;
+	}
+
+	if (req->hdr.ocount == 0) {
+		ret = -ENOENT;
+		goto free;
+	}
+
+	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+free:
+	free(req);
+	return ret;
+}
+
 /* Bulkstat a single inode using v5 ioctl. */
 static int
 xfrog_bulkstat_single5(
@@ -73,6 +110,9 @@ xfrog_bulkstat_single5(
 	}
 
 	memcpy(bulkstat, req->bulkstat, sizeof(struct xfs_bulkstat));
+
+	xfrog_bulkstat_v5_to_v6(bulkstat);
+
 free:
 	free(req);
 	return ret;
@@ -104,34 +144,46 @@ xfrog_bulkstat_single1(
 	if (error)
 		return -errno;
 
-	xfrog_bulkstat_v1_to_v5(xfd, bulkstat, &bstat);
+	xfrog_bulkstat_v1_to_v6(xfd, bulkstat, &bstat);
 	return 0;
 }
 
 /* Bulkstat a single inode.  Returns zero or a negative error code. */
 int
 xfrog_bulkstat_single(
-	struct xfs_fd			*xfd,
-	uint64_t			ino,
-	unsigned int			flags,
-	struct xfs_bulkstat		*bulkstat)
+	struct xfs_fd		*xfd,
+	uint64_t		ino,
+	unsigned int		flags,
+	struct xfs_bulkstat	*bulkstat)
 {
-	int				error;
+	unsigned int		xfd_flags = 0;
+	int			error;
 
 	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
 		goto try_v1;
 
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5)
+		goto try_v5;
+
+	error = xfrog_bulkstat_single6(xfd, ino, flags, bulkstat);
+	if (error == 0 || xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V6)
+		return error;
+
+        if (error == -EOPNOTSUPP && error == -ENOTTY)
+		xfd_flags = XFROG_FLAG_BULKSTAT_FORCE_V5;
+
+try_v5:
 	error = xfrog_bulkstat_single5(xfd, ino, flags, bulkstat);
-	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
+	if (error == 0) {
+		xfd->flags |= xfd_flags;
+		return 0;
+	}
+
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5)
 		return error;
 
-	/* If the v5 ioctl wasn't found, we punt to v1. */
-	switch (error) {
-	case -EOPNOTSUPP:
-	case -ENOTTY:
+	if (error == -EOPNOTSUPP && error == -ENOTTY)
 		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
-		break;
-	}
 
 try_v1:
 	return xfrog_bulkstat_single1(xfd, ino, flags, bulkstat);
@@ -200,14 +252,14 @@ xfrog_bulk_req_v1_cleanup(
 	struct xfs_fsop_bulkreq	*bulkreq,
 	size_t			v1_rec_size,
 	uint64_t		(*v1_ino)(void *v1_rec),
-	void			*v5_records,
-	size_t			v5_rec_size,
+	void			*v6_records,
+	size_t			v6_rec_size,
 	void			(*cvt)(struct xfs_fd *xfd, void *v5, void *v1),
 	unsigned int		startino_adj,
 	int			error)
 {
 	void			*v1_rec = bulkreq->ubuffer;
-	void			*v5_rec = v5_records;
+	void			*v6_rec = v6_records;
 	unsigned int		i;
 
 	if (error == -ECANCELED) {
@@ -224,7 +276,7 @@ xfrog_bulk_req_v1_cleanup(
 	 */
 	for (i = 0;
 	     i < hdr->ocount;
-	     i++, v1_rec += v1_rec_size, v5_rec += v5_rec_size) {
+	     i++, v1_rec += v1_rec_size, v6_rec += v6_rec_size) {
 		uint64_t	ino = v1_ino(v1_rec);
 
 		/* Stop if we hit a different AG. */
@@ -233,7 +285,7 @@ xfrog_bulk_req_v1_cleanup(
 			hdr->ocount = i;
 			break;
 		}
-		cvt(xfd, v5_rec, v1_rec);
+		cvt(xfd, v6_rec, v1_rec);
 		hdr->ino = ino + startino_adj;
 	}
 
@@ -247,9 +299,23 @@ static uint64_t xfrog_bstat_ino(void *v1_rec)
 	return ((struct xfs_bstat *)v1_rec)->bs_ino;
 }
 
-static void xfrog_bstat_cvt(struct xfs_fd *xfd, void *v5, void *v1)
+static void xfrog_bstat_cvt(struct xfs_fd *xfd, void *v6, void *v1)
 {
-	xfrog_bulkstat_v1_to_v5(xfd, v5, v1);
+	xfrog_bulkstat_v1_to_v6(xfd, v6, v1);
+}
+
+/* Bulkstat a bunch of inodes using the v6 interface. */
+static int
+xfrog_bulkstat6(
+	struct xfs_fd		*xfd,
+	struct xfs_bulkstat_req	*req)
+{
+	int			ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT_V6, req);
+	if (ret)
+		return -errno;
+	return 0;
 }
 
 /* Bulkstat a bunch of inodes using the v5 interface. */
@@ -258,11 +324,17 @@ xfrog_bulkstat5(
 	struct xfs_fd		*xfd,
 	struct xfs_bulkstat_req	*req)
 {
+	struct xfs_bulk_ireq	*hdr = &req->hdr;
 	int			ret;
+	int			i;
 
 	ret = ioctl(xfd->fd, XFS_IOC_BULKSTAT_V5, req);
 	if (ret)
 		return -errno;
+
+	for (i = 0; i < hdr->ocount; i++)
+		xfrog_bulkstat_v5_to_v6(&req->bulkstat[i]);
+
 	return 0;
 }
 
@@ -303,118 +375,86 @@ xfrog_bulkstat(
 	struct xfs_fd		*xfd,
 	struct xfs_bulkstat_req	*req)
 {
+	unsigned int		xfd_flags = 0;
 	int			error;
 
 	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V1)
 		goto try_v1;
 
-	error = xfrog_bulkstat5(xfd, req);
-	if (error == 0 || (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5))
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5)
+		goto try_v5;
+
+        error = xfrog_bulkstat6(xfd, req);
+	if (error == 0 || xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V6)
 		return error;
 
-	/* If the v5 ioctl wasn't found, we punt to v1. */
-	switch (error) {
-	case -EOPNOTSUPP:
-	case -ENOTTY:
-		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
-		break;
+	if (error == -EOPNOTSUPP || error == -ENOTTY)
+		xfd_flags = XFROG_FLAG_BULKSTAT_FORCE_V5;
+
+try_v5:
+        error = xfrog_bulkstat5(xfd, req);
+	if (error == 0) {
+		xfd->flags |= xfd_flags;
+		return 0;
 	}
 
+	if (xfd->flags & XFROG_FLAG_BULKSTAT_FORCE_V5)
+		return error;
+
+	if (error == -EOPNOTSUPP || error == -ENOTTY)
+		xfd->flags |= XFROG_FLAG_BULKSTAT_FORCE_V1;
+
 try_v1:
 	return xfrog_bulkstat1(xfd, req);
 }
 
-static bool
-time_too_big(
-	uint64_t	time)
+/* Convert bulkstat data from v5 format to v6 format. */
+void
+xfrog_bulkstat_v5_to_v6(
+	struct xfs_bulkstat		*bs)
 {
-	time_t		TIME_MAX;
+	bs->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	memset(&TIME_MAX, 0xFF, sizeof(TIME_MAX));
-	return time > TIME_MAX;
-}
-
-/* Convert bulkstat data from v5 format to v1 format. */
-int
-xfrog_bulkstat_v5_to_v1(
-	struct xfs_fd			*xfd,
-	struct xfs_bstat		*bs1,
-	const struct xfs_bulkstat	*bs5)
-{
-	if (bs5->bs_aextents > UINT16_MAX ||
-	    cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks) > UINT32_MAX ||
-	    cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks) > UINT32_MAX ||
-	    time_too_big(bs5->bs_atime) ||
-	    time_too_big(bs5->bs_ctime) ||
-	    time_too_big(bs5->bs_mtime))
-		return -ERANGE;
-
-	bs1->bs_ino = bs5->bs_ino;
-	bs1->bs_mode = bs5->bs_mode;
-	bs1->bs_nlink = bs5->bs_nlink;
-	bs1->bs_uid = bs5->bs_uid;
-	bs1->bs_gid = bs5->bs_gid;
-	bs1->bs_rdev = bs5->bs_rdev;
-	bs1->bs_blksize = bs5->bs_blksize;
-	bs1->bs_size = bs5->bs_size;
-	bs1->bs_atime.tv_sec = bs5->bs_atime;
-	bs1->bs_mtime.tv_sec = bs5->bs_mtime;
-	bs1->bs_ctime.tv_sec = bs5->bs_ctime;
-	bs1->bs_atime.tv_nsec = bs5->bs_atime_nsec;
-	bs1->bs_mtime.tv_nsec = bs5->bs_mtime_nsec;
-	bs1->bs_ctime.tv_nsec = bs5->bs_ctime_nsec;
-	bs1->bs_blocks = bs5->bs_blocks;
-	bs1->bs_xflags = bs5->bs_xflags;
-	bs1->bs_extsize = cvt_off_fsb_to_b(xfd, bs5->bs_extsize_blks);
-	bs1->bs_extents = bs5->bs_extents32;
-	bs1->bs_gen = bs5->bs_gen;
-	bs1->bs_projid_lo = bs5->bs_projectid & 0xFFFF;
-	bs1->bs_forkoff = bs5->bs_forkoff;
-	bs1->bs_projid_hi = bs5->bs_projectid >> 16;
-	bs1->bs_sick = bs5->bs_sick;
-	bs1->bs_checked = bs5->bs_checked;
-	bs1->bs_cowextsize = cvt_off_fsb_to_b(xfd, bs5->bs_cowextsize_blks);
-	bs1->bs_dmevmask = 0;
-	bs1->bs_dmstate = 0;
-	bs1->bs_aextents = bs5->bs_aextents;
-	return 0;
+        assert(bs->bs_extents64 == 0);
+	bs->bs_extents64 = bs->bs_extents32;
+	bs->bs_extents32 = 0;
 }
 
 /* Convert bulkstat data from v1 format to v5 format. */
 void
-xfrog_bulkstat_v1_to_v5(
+xfrog_bulkstat_v1_to_v6(
 	struct xfs_fd			*xfd,
-	struct xfs_bulkstat		*bs5,
+	struct xfs_bulkstat		*bs6,
 	const struct xfs_bstat		*bs1)
 {
-	memset(bs5, 0, sizeof(*bs5));
-	bs5->bs_version = XFS_BULKSTAT_VERSION_V1;
-
-	bs5->bs_ino = bs1->bs_ino;
-	bs5->bs_mode = bs1->bs_mode;
-	bs5->bs_nlink = bs1->bs_nlink;
-	bs5->bs_uid = bs1->bs_uid;
-	bs5->bs_gid = bs1->bs_gid;
-	bs5->bs_rdev = bs1->bs_rdev;
-	bs5->bs_blksize = bs1->bs_blksize;
-	bs5->bs_size = bs1->bs_size;
-	bs5->bs_atime = bs1->bs_atime.tv_sec;
-	bs5->bs_mtime = bs1->bs_mtime.tv_sec;
-	bs5->bs_ctime = bs1->bs_ctime.tv_sec;
-	bs5->bs_atime_nsec = bs1->bs_atime.tv_nsec;
-	bs5->bs_mtime_nsec = bs1->bs_mtime.tv_nsec;
-	bs5->bs_ctime_nsec = bs1->bs_ctime.tv_nsec;
-	bs5->bs_blocks = bs1->bs_blocks;
-	bs5->bs_xflags = bs1->bs_xflags;
-	bs5->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
-	bs5->bs_extents32 = bs1->bs_extents;
-	bs5->bs_gen = bs1->bs_gen;
-	bs5->bs_projectid = bstat_get_projid(bs1);
-	bs5->bs_forkoff = bs1->bs_forkoff;
-	bs5->bs_sick = bs1->bs_sick;
-	bs5->bs_checked = bs1->bs_checked;
-	bs5->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
-	bs5->bs_aextents = bs1->bs_aextents;
+	memset(bs6, 0, sizeof(*bs6));
+	bs6->bs_version = XFS_BULKSTAT_VERSION_V1;
+
+	bs6->bs_ino = bs1->bs_ino;
+	bs6->bs_mode = bs1->bs_mode;
+	bs6->bs_nlink = bs1->bs_nlink;
+	bs6->bs_uid = bs1->bs_uid;
+	bs6->bs_gid = bs1->bs_gid;
+	bs6->bs_rdev = bs1->bs_rdev;
+	bs6->bs_blksize = bs1->bs_blksize;
+	bs6->bs_size = bs1->bs_size;
+	bs6->bs_atime = bs1->bs_atime.tv_sec;
+	bs6->bs_mtime = bs1->bs_mtime.tv_sec;
+	bs6->bs_ctime = bs1->bs_ctime.tv_sec;
+	bs6->bs_atime_nsec = bs1->bs_atime.tv_nsec;
+	bs6->bs_mtime_nsec = bs1->bs_mtime.tv_nsec;
+	bs6->bs_ctime_nsec = bs1->bs_ctime.tv_nsec;
+	bs6->bs_blocks = bs1->bs_blocks;
+	bs6->bs_xflags = bs1->bs_xflags;
+	bs6->bs_extsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_extsize);
+	bs6->bs_extents64 = bs1->bs_extents;
+	bs6->bs_gen = bs1->bs_gen;
+	bs6->bs_projectid = bstat_get_projid(bs1);
+	bs6->bs_forkoff = bs1->bs_forkoff;
+	bs6->bs_sick = bs1->bs_sick;
+	bs6->bs_checked = bs1->bs_checked;
+	bs6->bs_cowextsize_blks = cvt_b_to_off_fsbt(xfd, bs1->bs_cowextsize);
+	bs6->bs_aextents = bs1->bs_aextents;
 }
 
 /* Allocate a bulkstat request.  Returns zero or a negative error code. */
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 2f440b14f..504ceda9c 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -18,10 +18,9 @@ int xfrog_bulkstat(struct xfs_fd *xfd, struct xfs_bulkstat_req *req);
 
 int xfrog_bulkstat_alloc_req(uint32_t nr, uint64_t startino,
 		struct xfs_bulkstat_req **preq);
-int xfrog_bulkstat_v5_to_v1(struct xfs_fd *xfd, struct xfs_bstat *bs1,
-		const struct xfs_bulkstat *bstat);
-void xfrog_bulkstat_v1_to_v5(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
-		const struct xfs_bstat *bs1);
+void xfrog_bulkstat_v1_to_v6(struct xfs_fd *xfd, struct xfs_bulkstat *bstat,
+                             const struct xfs_bstat *bs1);
+void xfrog_bulkstat_v5_to_v6(struct xfs_bulkstat *bs);
 
 void xfrog_bulkstat_set_ag(struct xfs_bulkstat_req *req, uint32_t agno);
 
diff --git a/libfrog/fsgeom.h b/libfrog/fsgeom.h
index bef864fce..423b14ea9 100644
--- a/libfrog/fsgeom.h
+++ b/libfrog/fsgeom.h
@@ -48,7 +48,10 @@ struct xfs_fd {
 #define XFROG_FLAG_BULKSTAT_FORCE_V1	(1 << 0)
 
 /* Only use v5 bulkstat/inumbers ioctls. */
-#define XFROG_FLAG_BULKSTAT_FORCE_V5	(1 << 1)
+#define XFROG_FLAG_BULKSTAT_FORCE_V5 (1 << 1)
+
+/* Only use v6 bulkstat ioctls. */
+#define XFROG_FLAG_BULKSTAT_FORCE_V6	(1 << 2)
 
 /* Only use the old XFS swapext ioctl for file data exchanges. */
 #define XFROG_FLAG_FORCE_SWAPEXT	(1 << 2)
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d760a9695..bfa81af82 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -394,7 +394,7 @@ struct xfs_bulkstat {
 	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
 
 	uint32_t	bs_nlink;	/* number of links		*/
-	uint32_t	bs_extents32;	/* number of extents		*/
+	uint32_t	bs_extents32;	/* number of extents; v5 only	*/
 	uint32_t	bs_aextents;	/* attribute number of extents	*/
 	uint16_t	bs_version;	/* structure version		*/
 	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
@@ -403,12 +403,14 @@ struct xfs_bulkstat {
 	uint16_t	bs_checked;	/* checked inode metadata	*/
 	uint16_t	bs_mode;	/* type and mode		*/
 	uint16_t	bs_pad2;	/* zeroed			*/
+	uint64_t	bs_extents64;	/* number of extents; v6 only	*/
 
-	uint64_t	bs_pad[7];	/* zeroed			*/
+	uint64_t	bs_pad[6];	/* zeroed			*/
 };
 
 #define XFS_BULKSTAT_VERSION_V1	(1)
 #define XFS_BULKSTAT_VERSION_V5	(5)
+#define XFS_BULKSTAT_VERSION_V6 (6)
 
 /* bs_sick flags */
 #define XFS_BS_SICK_INODE	(1 << 0)  /* inode core */
@@ -856,6 +858,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_BULKSTAT_V5	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
 /*	FIEXCHANGE_RANGE ----------- hoisted 129	 */
+#define XFS_IOC_BULKSTAT_V6	     _IOR ('X', 130, struct xfs_bulkstat_req)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
-- 
2.30.2

