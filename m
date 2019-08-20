Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4991FC3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5DF22D6D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 20:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbfHTUVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:21:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTUVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Aug 2019 16:21:38 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIuDQ157962;
        Tue, 20 Aug 2019 20:21:36 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7qrxdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7KKIJZw165000;
        Tue, 20 Aug 2019 20:21:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ugj7p4h8y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Aug 2019 20:21:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7KKLXP2015813;
        Tue, 20 Aug 2019 20:21:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Aug 2019 13:21:33 -0700
Subject: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
From:   "Darrick J. Wong" <djwong@maple.djwong.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 20 Aug 2019 13:21:32 -0700
Message-ID: <156633249273.1207741.14136110846397501551.stgit@magnolia>
In-Reply-To: <156633248668.1207741.376678690204909405.stgit@magnolia>
References: <156633248668.1207741.376678690204909405.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908200181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1034
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908200181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a helper to unlink, recreate, and reserve space in a file so that
we don't have two open-coded versions.  We lose the broken ALLOCSP code
since it never worked anyway.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 restore/dirattr.c |   97 ++++++++++++++++++-----------------------------------
 restore/dirattr.h |    2 +
 restore/namreg.c  |   70 +++-----------------------------------
 3 files changed, 41 insertions(+), 128 deletions(-)


diff --git a/restore/dirattr.c b/restore/dirattr.c
index 806f282..5cd22a8 100644
--- a/restore/dirattr.c
+++ b/restore/dirattr.c
@@ -55,6 +55,37 @@
 #include "openutil.h"
 #include "mmap.h"
 
+/* Create a file, try to reserve space for it, and return the fd. */
+int
+create_filled_file(
+	const char	*pathname,
+	off64_t		size)
+{
+	struct flock64	fl = {
+		.l_len = size,
+	};
+	int		fd;
+	int		ret;
+
+	(void)unlink(pathname);
+
+	fd = open(pathname, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR);
+	if (fd < 0)
+		return fd;
+
+	ret = ioctl(fd, XFS_IOC_RESVSP64, &fl);
+	if (ret && errno != ENOTTY)
+		mlog(MLOG_VERBOSE | MLOG_NOTE,
+_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
+				size, pathname, "XFS_IOC_RESVSP64",
+				strerror(errno), errno);
+	if (ret == 0)
+		goto done;
+
+done:
+	return fd;
+}
+
 /* structure definitions used locally ****************************************/
 
 /* node handle limits
@@ -238,13 +269,8 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the dirattr file, first unlinking any older version
-		 * laying around
-		 */
-		(void)unlink(dtp->dt_pathname);
-		dtp->dt_fd = open(dtp->dt_pathname,
-				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR);
+		dtp->dt_fd = create_filled_file(dtp->dt_pathname,
+			DIRATTR_PERS_SZ + (dircnt * sizeof(struct dirattr)));
 		if (dtp->dt_fd < 0) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create directory attributes file %s: "
@@ -253,63 +279,6 @@ dirattr_init(char *hkdir, bool_t resume, uint64_t dircnt)
 			      strerror(errno));
 			return BOOL_FALSE;
 		}
-
-		/* reserve space for the backing store. try to use RESVSP64.
-		 * if doesn't work, try ALLOCSP64. the former is faster, as
-		 * it does not zero the space.
-		 */
-		{
-		bool_t successpr;
-		unsigned int ioctlcmd;
-		int loglevel;
-		size_t trycnt;
-
-		for (trycnt = 0,
-		      successpr = BOOL_FALSE,
-		      ioctlcmd = XFS_IOC_RESVSP64,
-		      loglevel = MLOG_VERBOSE
-		      ;
-		      !successpr && trycnt < 2
-		      ;
-		      trycnt++,
-		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
-			off64_t initsz;
-			struct flock64 flock64;
-			int rval;
-
-			if (!ioctlcmd) {
-				continue;
-			}
-
-			initsz = (off64_t)DIRATTR_PERS_SZ
-				 +
-				 ((off64_t)dircnt * sizeof(dirattr_t));
-			flock64.l_whence = 0;
-			flock64.l_start = 0;
-			flock64.l_len = initsz;
-			rval = ioctl(dtp->dt_fd, ioctlcmd, &flock64);
-			if (rval) {
-				if (errno != ENOTTY) {
-					mlog(loglevel | MLOG_NOTE, _(
-					      "attempt to reserve %lld bytes for %s "
-					      "using %s "
-					      "failed: %s (%d)\n"),
-					      initsz,
-					      dtp->dt_pathname,
-					      ioctlcmd == XFS_IOC_RESVSP64
-					      ?
-					      "XFS_IOC_RESVSP64"
-					      :
-					      "XFS_IOC_ALLOCSP64",
-					      strerror(errno),
-					      errno);
-				}
-			} else {
-				successpr = BOOL_TRUE;
-			}
-		}
-		}
 	}
 
 	/* mmap the persistent descriptor
diff --git a/restore/dirattr.h b/restore/dirattr.h
index 232822e..cdfa4fc 100644
--- a/restore/dirattr.h
+++ b/restore/dirattr.h
@@ -88,4 +88,6 @@ extern bool_t dirattr_cb_extattr(dah_t dah,
 				  extattrhdr_t *ahdrp,
 				  void *ctxp);
 
+int create_filled_file(const char *pathname, off64_t size);
+
 #endif /* DIRATTR_H */
diff --git a/restore/namreg.c b/restore/namreg.c
index fe159e4..594e325 100644
--- a/restore/namreg.c
+++ b/restore/namreg.c
@@ -37,6 +37,10 @@
 #include "namreg.h"
 #include "openutil.h"
 #include "mmap.h"
+#include "global.h"
+#include "content.h"
+#include "content_inode.h"
+#include "dirattr.h"
 
 /* structure definitions used locally ****************************************/
 
@@ -153,13 +157,8 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			return BOOL_FALSE;
 		}
 	} else {
-		/* create the namreg file, first unlinking any older version
-		 * laying around
-		 */
-		(void)unlink(ntp->nt_pathname);
-		ntp->nt_fd = open(ntp->nt_pathname,
-				   O_RDWR | O_CREAT | O_EXCL,
-				   S_IRUSR | S_IWUSR);
+		ntp->nt_fd = create_filled_file(ntp->nt_pathname,
+			NAMREG_PERS_SZ + (inocnt * NAMREG_AVGLEN));
 		if (ntp->nt_fd < 0) {
 			mlog(MLOG_NORMAL | MLOG_ERROR, _(
 			      "could not create name registry file %s: "
@@ -168,63 +167,6 @@ namreg_init(char *hkdir, bool_t resume, uint64_t inocnt)
 			      strerror(errno));
 			return BOOL_FALSE;
 		}
-
-		/* reserve space for the backing store. try to use RESVSP64.
-		 * if doesn't work, try ALLOCSP64. the former is faster, as
-		 * it does not zero the space.
-		 */
-		{
-		bool_t successpr;
-		unsigned int ioctlcmd;
-		int loglevel;
-		size_t trycnt;
-
-		for (trycnt = 0,
-		      successpr = BOOL_FALSE,
-		      ioctlcmd = XFS_IOC_RESVSP64,
-		      loglevel = MLOG_VERBOSE
-		      ;
-		      !successpr && trycnt < 2
-		      ;
-		      trycnt++,
-		      ioctlcmd = XFS_IOC_ALLOCSP64,
-		      loglevel = max(MLOG_NORMAL, loglevel - 1)) {
-			off64_t initsz;
-			struct flock64 flock64;
-			int rval;
-
-			if (!ioctlcmd) {
-				continue;
-			}
-
-			initsz = (off64_t)NAMREG_PERS_SZ
-				 +
-				 ((off64_t)inocnt * NAMREG_AVGLEN);
-			flock64.l_whence = 0;
-			flock64.l_start = 0;
-			flock64.l_len = initsz;
-			rval = ioctl(ntp->nt_fd, ioctlcmd, &flock64);
-			if (rval) {
-				if (errno != ENOTTY) {
-					mlog(loglevel | MLOG_NOTE, _(
-					      "attempt to reserve %lld bytes for %s "
-					      "using %s "
-					      "failed: %s (%d)\n"),
-					      initsz,
-					      ntp->nt_pathname,
-					      ioctlcmd == XFS_IOC_RESVSP64
-					      ?
-					      "XFS_IOC_RESVSP64"
-					      :
-					      "XFS_IOC_ALLOCSP64",
-					      strerror(errno),
-					      errno);
-				}
-			} else {
-				successpr = BOOL_TRUE;
-			}
-		}
-		}
 	}
 
 	/* mmap the persistent descriptor

