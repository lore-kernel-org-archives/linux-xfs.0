Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC63C433DB
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C66123A69
	for <linux-xfs@archiver.kernel.org>; Sat,  9 Jan 2021 06:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbhAIG3Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 Jan 2021 01:29:25 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40304 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbhAIG3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 Jan 2021 01:29:25 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10969EBX110756;
        Sat, 9 Jan 2021 06:28:43 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 35y4ekg8j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 09 Jan 2021 06:28:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1096Aa2Y033295;
        Sat, 9 Jan 2021 06:28:43 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 35y2h9nhyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 09 Jan 2021 06:28:43 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1096Sg02028023;
        Sat, 9 Jan 2021 06:28:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 09 Jan 2021 06:28:41 +0000
Subject: [PATCH 1/3] misc: fix valgrind complaints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 08 Jan 2021 22:28:40 -0800
Message-ID: <161017372088.1142776.17470250928392025583.stgit@magnolia>
In-Reply-To: <161017371478.1142776.6610535704942901172.stgit@magnolia>
References: <161017371478.1142776.6610535704942901172.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101090040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9858 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1034
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101090040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Zero the memory that we pass to the kernel via ioctls so that we never
pass userspace heap/stack garbage around.  This silences valgrind
complaints about uninitialized padding areas.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libhandle/handle.c |    7 ++++++-
 scrub/inodes.c     |    1 +
 scrub/spacemap.c   |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)


diff --git a/libhandle/handle.c b/libhandle/handle.c
index 5c1686b3..a6b35b09 100644
--- a/libhandle/handle.c
+++ b/libhandle/handle.c
@@ -235,9 +235,12 @@ obj_to_handle(
 {
 	char		hbuf [MAXHANSIZ];
 	int		ret;
-	uint32_t	handlen;
+	uint32_t	handlen = 0;
 	xfs_fsop_handlereq_t hreq;
 
+	memset(&hreq, 0, sizeof(hreq));
+	memset(hbuf, 0, MAXHANSIZ);
+
 	if (opcode == XFS_IOC_FD_TO_HANDLE) {
 		hreq.fd      = obj.fd;
 		hreq.path    = NULL;
@@ -280,6 +283,7 @@ open_by_fshandle(
 	if ((fsfd = handle_to_fsfd(fshanp, &path)) < 0)
 		return -1;
 
+	memset(&hreq, 0, sizeof(hreq));
 	hreq.fd       = 0;
 	hreq.path     = NULL;
 	hreq.oflags   = rw | O_LARGEFILE;
@@ -387,6 +391,7 @@ attr_list_by_handle(
 	if ((fd = handle_to_fsfd(hanp, &path)) < 0)
 		return -1;
 
+	memset(&alhreq, 0, sizeof(alhreq));
 	alhreq.hreq.fd       = 0;
 	alhreq.hreq.path     = NULL;
 	alhreq.hreq.oflags   = O_LARGEFILE;
diff --git a/scrub/inodes.c b/scrub/inodes.c
index 4550db83..f2bce16f 100644
--- a/scrub/inodes.c
+++ b/scrub/inodes.c
@@ -129,6 +129,7 @@ scan_ag_inodes(
 				minor(ctx->fsinfo.fs_datadev),
 				agno);
 
+	memset(&handle, 0, sizeof(handle));
 	memcpy(&handle.ha_fsid, ctx->fshandle, sizeof(handle.ha_fsid));
 	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
 			sizeof(handle.ha_fid.fid_len);
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 9653916d..9362710e 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -47,7 +47,7 @@ scrub_iterate_fsmap(
 	int			i;
 	int			error;
 
-	head = malloc(fsmap_sizeof(FSMAP_NR));
+	head = calloc(1, fsmap_sizeof(FSMAP_NR));
 	if (!head)
 		return errno;
 

