Return-Path: <SRS0=4Z0m=Y3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBDECCA9EB0
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B378D2190F
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Nov 2019 22:24:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bhPeloPi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfKCWYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Nov 2019 17:24:01 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:38810 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfKCWYB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Nov 2019 17:24:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MM2YQ071408
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=u0eN7S/LjkZEZdrD/PSJa2hcn95eA4vwzb01lheFnDs=;
 b=bhPeloPi/nx638pquFX1vCfjreXgUM6d+Zm/Le7PaWmCDbBlp3SOg0BeQBLJDaJ7mcAb
 ITMoIWWkBeGpJ+6MAS4DI+vOiOqBgy1VFjpsL0c0LmIIaQwCNnrxiF8MUZEd01rL/wLO
 378Qnqv/9+7stF1RXQ0WY1bXD7DB+sGuIrIFpJvlnF4OiXzdfp9xqbJgP80uI3LMWuee
 6EY6O2WXOxNavtVFHjPK0AaAM61Nuy5atL8ATL8Beubgno8gQEPyhtFXnDYfsBO1nZ6Y
 6O+sg0ATkxsi1UUrTJ938DTamOsmCRYB1P9up1WBEdq2YRxrOOQNK7vHRh3hxk+45J+p HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2w11rpm470-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:23:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA3MNJsC072696
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2w1k8tmsdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Nov 2019 22:23:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA3MNvU8016239
        for <linux-xfs@vger.kernel.org>; Sun, 3 Nov 2019 22:23:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 03 Nov 2019 14:23:57 -0800
Subject: [PATCH 2/3] xfs: constify the buffer pointer arguments to error
 functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 03 Nov 2019 14:23:55 -0800
Message-ID: <157281983593.4150947.13692433066759624464.stgit@magnolia>
In-Reply-To: <157281982341.4150947.10288936972373805803.stgit@magnolia>
References: <157281982341.4150947.10288936972373805803.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911030234
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9430 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911030233
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Some of the xfs error message functions take a pointer to a buffer that
will be dumped to the system log.  The logging functions don't change
the contents, so constify all the parameters.  This enables the next
patch to ensure that we log bad metadata when we encounter it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c   |    6 +++---
 fs/xfs/xfs_error.h   |    6 +++---
 fs/xfs/xfs_message.c |    2 +-
 fs/xfs/xfs_message.h |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..0b156cc88108 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -329,7 +329,7 @@ xfs_corruption_error(
 	const char		*tag,
 	int			level,
 	struct xfs_mount	*mp,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsize,
 	const char		*filename,
 	int			linenum,
@@ -350,7 +350,7 @@ xfs_buf_verifier_error(
 	struct xfs_buf		*bp,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
@@ -402,7 +402,7 @@ xfs_inode_verifier_error(
 	struct xfs_inode	*ip,
 	int			error,
 	const char		*name,
-	void			*buf,
+	const void		*buf,
 	size_t			bufsz,
 	xfs_failaddr_t		failaddr)
 {
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index 602aa7d62b66..e6a22cfb542f 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -12,16 +12,16 @@ extern void xfs_error_report(const char *tag, int level, struct xfs_mount *mp,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_corruption_error(const char *tag, int level,
-			struct xfs_mount *mp, void *buf, size_t bufsize,
+			struct xfs_mount *mp, const void *buf, size_t bufsize,
 			const char *filename, int linenum,
 			xfs_failaddr_t failaddr);
 extern void xfs_buf_verifier_error(struct xfs_buf *bp, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 extern void xfs_verifier_error(struct xfs_buf *bp, int error,
 			xfs_failaddr_t failaddr);
 extern void xfs_inode_verifier_error(struct xfs_inode *ip, int error,
-			const char *name, void *buf, size_t bufsz,
+			const char *name, const void *buf, size_t bufsz,
 			xfs_failaddr_t failaddr);
 
 #define	XFS_ERROR_REPORT(e, lvl, mp)	\
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..c57e8ad39712 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -105,7 +105,7 @@ assfail(char *expr, char *file, int line)
 }
 
 void
-xfs_hex_dump(void *p, int length)
+xfs_hex_dump(const void *p, int length)
 {
 	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_OFFSET, 16, 1, p, length, 1);
 }
diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index 34447dca97d1..7f040b04b739 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -60,6 +60,6 @@ do {									\
 extern void assfail(char *expr, char *f, int l);
 extern void asswarn(char *expr, char *f, int l);
 
-extern void xfs_hex_dump(void *p, int length);
+extern void xfs_hex_dump(const void *p, int length);
 
 #endif	/* __XFS_MESSAGE_H */

