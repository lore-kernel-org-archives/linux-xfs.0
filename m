Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:46450 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCAX2A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NOFRu123053
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:59 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2qtwkut90x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:27:58 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRw1O032711
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:58 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x21NRwTQ021092
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:27:58 GMT
Subject: [PATCH 10/23] xfs_scrub: don't close mnt_fd when mnt_fd open fails
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:27:57 -0800
Message-ID: <155148287716.16677.16342591325551254606.stgit@magnolia>
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

If we fail to open the mountpoint during phase 1 of scrub, don't bother
trying to close the file descriptor since it's silly to spray error
messages about that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 6b472147..04a5f4a9 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -59,9 +59,11 @@ xfs_cleanup_fs(
 	if (ctx->datadev)
 		disk_close(ctx->datadev);
 	fshandle_destroy();
-	error = close(ctx->mnt_fd);
-	if (error)
-		str_errno(ctx, _("closing mountpoint fd"));
+	if (ctx->mnt_fd >= 0) {
+		error = close(ctx->mnt_fd);
+		if (error)
+			str_errno(ctx, _("closing mountpoint fd"));
+	}
 	fs_table_destroy();
 
 	return true;
