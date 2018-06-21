Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeFUSbn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITGNC147014
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:43 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2jmt01u75x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:43 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVgoI000509
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:42 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w5LIVgQ0028659
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:42 GMT
Subject: [PATCH 6/8] xfs: fix uninitialized field in rtbitmap fsmap backend
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:41 -0700
Message-ID: <152960590105.26246.13020311829179912536.stgit@magnolia>
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Initialize the extent count field of the high key so that when we use
the high key to synthesize an 'unknown owner' record (i.e. used space
record) at the end of the queried range we have a field with which to
compute rm_blockcount.  This is not strictly necessary because the
synthesizer never uses the rm_blockcount field, but we can shut up the
static code analysis anyway.

Coverity-id: 1437358
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsmap.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index c34fa9c342f2..2be795b01ce0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -531,6 +531,7 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 
 	/* Report any gaps at the end of the rtbitmap */
 	info->last = true;
+	ahigh.ar_extcount = 0;
 	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
 	if (error)
 		goto err;

