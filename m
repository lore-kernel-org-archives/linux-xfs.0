Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36948 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbdK1RkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 12:40:11 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASHeAHI028351
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vASHeAgb026459
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:10 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vASHeAiZ020096
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:10 GMT
Subject: [PATCH 3/3] xfs: scrub inode mode properly
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 09:40:09 -0800
Message-ID: <151189080917.14861.14134834648175888048.stgit@magnolia>
In-Reply-To: <151189079681.14861.10709810493861130558.stgit@magnolia>
References: <151189079681.14861.10709810493861130558.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we've used up all the bits in i_mode, the existing mode check
doesn't actually do anything useful.  However, we've not used all the
bit values in the format portion of i_mode, so we /do/ need to test
that for bad values.

Fixes: 80e4e1268 ("xfs: scrub inodes")
Fixes-coverity-id: 1423992
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/inode.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 637b7a8..f120fb2 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -318,8 +318,20 @@ xfs_scrub_dinode(
 
 	/* di_mode */
 	mode = be16_to_cpu(dip->di_mode);
-	if (mode & ~(S_IALLUGO | S_IFMT))
+	switch (mode & S_IFMT) {
+	case S_IFLNK:
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFIFO:
+	case S_IFSOCK:
+		/* mode is recognized */
+		break;
+	default:
 		xfs_scrub_ino_set_corrupt(sc, ino, bp);
+		break;
+	}
 
 	/* v1/v2 fields */
 	switch (dip->di_version) {

