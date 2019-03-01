Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43108 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:31 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOrFY123191
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:29 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2qtupetenq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:29 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSTLB008621
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:29 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSScl021282
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:28 GMT
Subject: [PATCH 15/23] xfs_repair: fix uninitialized variable warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:27 -0800
Message-ID: <155148290771.16677.105321196673348401.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some uninitialized variable warnings because ASSERT disappears if
DEBUG is not defined.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index f670bf87..c0a56daa 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1176,8 +1176,8 @@ process_quota_inode(
 	struct xfs_buf		*bp;
 	xfs_filblks_t		dqchunklen;
 	uint			dqperchunk;
-	int			quota_type;
-	char			*quota_string;
+	int			quota_type = 0;
+	char			*quota_string = NULL;
 	xfs_dqid_t		dqid;
 	xfs_fileoff_t		qbno;
 	int			i;
