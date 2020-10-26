Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5054C4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE3B207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DD/CqeZy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407159AbgJZXg3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:36:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37828 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407157AbgJZXg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:36:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPKDn158046;
        Mon, 26 Oct 2020 23:36:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/dW2Sjur6ZsWxFDaX5/0GbgCLnwJKu0goJnYRUzWcAc=;
 b=DD/CqeZynanOrl7Eaxvw8GP79pNL50lvzY37Z30cYqgo9UobH+im4rxVBQ5rrvhBqM61
 6qLv0MXh9HYb+UgHOYU88QZkGC7xo+p9x8Zmr0blmVtkpNz0TPdHtsILzMUDqhrXrm98
 TG/FEIz4OPhOuWZqPoXsfIahwASE4nZZJrcH2lnv5XnqXEQBCX0wgmA5+Bt6AaUFCWZP
 d4lIYfQX09QC+KV+UCYIOoifkfLHcpIIc3a6zJ23uwEeTvfG2OHmlkBN6X5i1Hi7QC+J
 Ptr65bB47hucwBwsO5bdCzvNJe4PkKMRC3hpsKw8dFjs58vnSSj/OwGWqattBlFQssL7 CQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 34cc7kq8np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:36:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxGh110443;
        Mon, 26 Oct 2020 23:34:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 34cx5wfrw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:34:26 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNYQQ1007428;
        Mon, 26 Oct 2020 23:34:26 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:34:26 -0700
Subject: [PATCH 03/26] libfrog: define LIBFROG_BULKSTAT_CHUNKSIZE to remove
 dependence on XFS_INODES_PER_CHUNK
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:34:25 -0700
Message-ID: <160375526530.881414.1004347326416234607.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

"Online" XFS programs like scrub have no business importing the internal
disk format headers to discover things like the optimum number of inodes
to request through a bulkstat request.  That number can be derived from
the ioctl definition, so define a new constant in terms of that instead
of pulling in the ondisk format unnecessarily.

Note: This patch will be needed to work around new definitions in the
bigtime patchset that will break scrub builds, so clean this up instead
of adding more #includes to the two scrub source files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs.h      |    2 ++
 libfrog/bulkstat.h |    4 ++++
 scrub/fscounters.c |    1 -
 scrub/inodes.c     |    5 ++---
 4 files changed, 8 insertions(+), 4 deletions(-)


diff --git a/include/xfs.h b/include/xfs.h
index af0d36cef361..e97158c8d223 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -38,6 +38,8 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 #endif
 
+#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
+
 #include <xfs/xfs_types.h>
 /* Include deprecated/compat pre-vfs xfs-specific symbols */
 #include <xfs/xfs_fs_compat.h>
diff --git a/libfrog/bulkstat.h b/libfrog/bulkstat.h
index 56ef7f9a8237..2f440b14f93d 100644
--- a/libfrog/bulkstat.h
+++ b/libfrog/bulkstat.h
@@ -6,6 +6,10 @@
 #ifndef __LIBFROG_BULKSTAT_H__
 #define __LIBFROG_BULKSTAT_H__
 
+/* This is the minimum reasonable size of a bulkstat request. */
+#define LIBFROG_BULKSTAT_CHUNKSIZE \
+		(NBBY * sizeof_field(struct xfs_inumbers, xi_allocmask))
+
 /* Bulkstat wrappers */
 struct xfs_bstat;
 int xfrog_bulkstat_single(struct xfs_fd *xfd, uint64_t ino, unsigned int flags,
diff --git a/scrub/fscounters.c b/scrub/fscounters.c
index 9a240d49477b..f21b24e0935c 100644
--- a/scrub/fscounters.c
+++ b/scrub/fscounters.c
@@ -9,7 +9,6 @@
 #include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "xfs_arch.h"
-#include "xfs_format.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
 #include "xfs_scrub.h"
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 5ef752fe39d3..bdc12df31479 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -10,7 +10,6 @@
 #include <sys/statvfs.h>
 #include "platform_defs.h"
 #include "xfs_arch.h"
-#include "xfs_format.h"
 #include "handle.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
@@ -74,7 +73,7 @@ bulkstat_for_inumbers(
 	 * Check each of the stats we got back to make sure we got the inodes
 	 * we asked for.
 	 */
-	for (i = 0, bs = bstat; i < XFS_INODES_PER_CHUNK; i++) {
+	for (i = 0, bs = bstat; i < LIBFROG_BULKSTAT_CHUNKSIZE; i++) {
 		if (!(inumbers->xi_allocmask & (1ULL << i)))
 			continue;
 		if (bs->bs_ino == inumbers->xi_startino + i) {
@@ -134,7 +133,7 @@ scan_ag_inodes(
 			sizeof(handle.ha_fid.fid_len);
 	handle.ha_fid.fid_pad = 0;
 
-	error = -xfrog_bulkstat_alloc_req(XFS_INODES_PER_CHUNK, 0, &breq);
+	error = -xfrog_bulkstat_alloc_req(LIBFROG_BULKSTAT_CHUNKSIZE, 0, &breq);
 	if (error) {
 		str_liberror(ctx, error, descr);
 		si->aborted = true;

