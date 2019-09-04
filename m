Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F13C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B96522CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:37:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iP5IeWml"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfIDEht (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:37:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58974 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfIDEht (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:37:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844aQVx040106;
        Wed, 4 Sep 2019 04:37:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=4gJr5DJSa4hVHYROKw6fgAlTUhLMODPmOxYUtMHMHD8=;
 b=iP5IeWmlsEi4SEZfxwhW2a6LKyRrGD7upL5UO2zvi6xhBwt5b2iQGyMpkMDIpBViiS3n
 XJZavPKPdXtGDgOgUgdMVgI8iARaPP/rLQ4eJuqvOyRCR0LBZdVpp3oFER43Iwr4hQXa
 igYLEfEMvm9aY5cQBRUqj5BQLUaQmF9pijL5k+vfDpTjQS6lTugTjzEzlneUY4nhYGik
 whwFVxayTxzCP4dGY7R2OZT8vEvfHEQQjFFdZw9alvu79GXtlVmZWaCKN0f2dR9cLE2g
 v5X8myEMnIsv1FdzeXwgDSzaowOJ2nxh6K3bTU8tQ/lXabMf9MM2T2PXLSHhjOIqgF9K NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2ut6d1r0b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:37:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x844XkQW163008;
        Wed, 4 Sep 2019 04:35:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2usu52bfym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 04:35:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x844Zgfq003765;
        Wed, 4 Sep 2019 04:35:42 GMT
Received: from localhost (/10.159.228.126)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 21:35:42 -0700
Subject: [PATCH 8/8] libfrog: refactor open-coded INUMBERS calls
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 03 Sep 2019 21:35:40 -0700
Message-ID: <156757174089.1836891.5922232574019988618.stgit@magnolia>
In-Reply-To: <156757168368.1836891.15043200811666785244.stgit@magnolia>
References: <156757168368.1836891.15043200811666785244.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040047
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040047
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the INUMBERS ioctl callsites into helper functions.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 io/imap.c          |   34 +++++++++++++++++-----------------
 io/open.c          |   24 ++++++++++++------------
 libfrog/bulkstat.c |   26 ++++++++++++++++++++++++++
 libfrog/bulkstat.h |    4 ++++
 scrub/fscounters.c |   20 ++++++++------------
 scrub/inodes.c     |   17 ++++++-----------
 6 files changed, 73 insertions(+), 52 deletions(-)


diff --git a/io/imap.c b/io/imap.c
index 9667289a..86d8bda3 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -8,18 +8,21 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "fsgeom.h"
+#include "libfrog/bulkstat.h"
 
 static cmdinfo_t imap_cmd;
 
 static int
 imap_f(int argc, char **argv)
 {
-	int		count;
-	int		nent;
-	int		i;
-	__u64		last = 0;
-	struct xfs_inogrp *t;
-	struct xfs_fsop_bulkreq bulkreq;
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
+	struct xfs_inogrp	*t;
+	uint64_t		last = 0;
+	uint32_t		count;
+	uint32_t		nent;
+	int			i;
+	int			error;
 
 	if (argc != 2)
 		nent = 1;
@@ -30,14 +33,8 @@ imap_f(int argc, char **argv)
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
+	while ((error = xfrog_inumbers(&xfd, &last, nent, t, &count)) == 0 &&
+	       count > 0) {
 		for (i = 0; i < count; i++) {
 			printf(_("ino %10llu count %2d mask %016llx\n"),
 				(unsigned long long)t[i].xi_startino,
@@ -45,9 +42,12 @@ imap_f(int argc, char **argv)
 				(unsigned long long)t[i].xi_allocmask);
 		}
 	}
-	perror("xfsctl(XFS_IOC_FSINUMBERS)");
-	exitcode = 1;
-out_free:
+
+	if (error) {
+		errno = error;
+		perror("xfsctl(XFS_IOC_FSINUMBERS)");
+		exitcode = 1;
+	}
 	free(t);
 	return 0;
 }
diff --git a/io/open.c b/io/open.c
index eab85fd7..169f375c 100644
--- a/io/open.c
+++ b/io/open.c
@@ -676,24 +676,24 @@ inode_help(void)
 "\n"));
 }
 
+#define IGROUP_NR	(1024)
 static __u64
 get_last_inode(void)
 {
-	__u64			lastip = 0;
-	__u64			lastgrp = 0;
-	__s32			ocount = 0;
+	struct xfs_fd		xfd = XFS_FD_INIT(file->fd);
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
+		int		ret;
+
+		ret = xfrog_inumbers(&xfd, &lastip, IGROUP_NR, igroup,
+				&ocount);
+		if (ret) {
+			errno = ret;
 			perror("XFS_IOC_FSINUMBERS");
 			return 0;
 		}
diff --git a/libfrog/bulkstat.c b/libfrog/bulkstat.c
index a61e2fd3..fa10f298 100644
--- a/libfrog/bulkstat.c
+++ b/libfrog/bulkstat.c
@@ -51,3 +51,29 @@ xfrog_bulkstat(
 		return errno;
 	return 0;
 }
+
+/*
+ * Query inode allocation bitmask information.  Returns zero or a positive
+ * error code.
+ */
+int
+xfrog_inumbers(
+	struct xfs_fd		*xfd,
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
+	int			ret;
+
+	ret = ioctl(xfd->fd, XFS_IOC_FSINUMBERS, &bulkreq);
+	if (ret)
+		return errno;
+	return 0;
+}
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 17520913..83ac0e37 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -13,4 +13,8 @@ int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino,
 int xfrog_bulkstat(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
 		struct xfs_bstat *ubuffer, uint32_t *ocount);
 
+struct xfs_inogrp;
+int xfrog_inumbers(struct xfs_fd *xfd, uint64_t *lastino, uint32_t icount,
+		struct xfs_inogrp *ubuffer, uint32_t *ocount);
+
 #endif	/* __LIBFROG_BULKSTAT_H__ */
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index ea6af156..f8cc1e94 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -15,6 +15,7 @@
 #include "xfs_scrub.h"
 #include "common.h"
 #include "fscounters.h"
+#include "libfrog/bulkstat.h"
 
 /*
  * Filesystem counter collection routines.  We can count the number of
@@ -41,30 +42,25 @@ xfs_count_inodes_range(
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
-	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
-	while (!error && igrplen && inogrp.xi_startino < last_ino) {
+	while (!(error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
+			&igrplen))) {
+		if (igrplen == 0 || inogrp.xi_startino >= last_ino)
+			break;
 		nr += inogrp.xi_alloccount;
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
 	}
 
 	if (error) {
-		str_errno(ctx, descr);
+		str_liberror(ctx, error, descr);
 		return false;
 	}
 
diff --git a/scrub/inodes.c b/scrub/inodes.c
index c2cbe260..bf98f6ee 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -91,16 +91,15 @@ xfs_iterate_inodes_range(
 	xfs_inode_iter_fn	fn,
 	void			*arg)
 {
-	struct xfs_fsop_bulkreq	igrpreq = {NULL};
 	struct xfs_handle	handle;
 	struct xfs_inogrp	inogrp;
 	struct xfs_bstat	bstat[XFS_INODES_PER_CHUNK];
 	char			idescr[DESCR_BUFSZ];
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
@@ -109,11 +108,6 @@ xfs_iterate_inodes_range(
 
 	memset(bstat, 0, XFS_INODES_PER_CHUNK * sizeof(struct xfs_bstat));
 
-	igrpreq.lastip  = &igrp_ino;
-	igrpreq.icount  = 1;
-	igrpreq.ubuffer = &inogrp;
-	igrpreq.ocount  = &igrplen;
-
 	memcpy(&handle.ha_fsid, fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
@@ -121,7 +115,7 @@ xfs_iterate_inodes_range(
 
 	/* Find the inode chunk & alloc mask */
 	igrp_ino = first_ino;
-	error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
+	error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp, &igrplen);
 	while (!error && igrplen) {
 		/* Load the inodes. */
 		ino = inogrp.xi_startino - 1;
@@ -181,12 +175,13 @@ _("Changed too many times during scan; giving up."));
 
 		stale_count = 0;
 igrp_retry:
-		error = ioctl(ctx->mnt.fd, XFS_IOC_FSINUMBERS, &igrpreq);
+		error = xfrog_inumbers(&ctx->mnt, &igrp_ino, 1, &inogrp,
+				&igrplen);
 	}
 
 err:
 	if (error) {
-		str_errno(ctx, descr);
+		str_liberror(ctx, error, descr);
 		moveon = false;
 	}
 out:

