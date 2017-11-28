Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36881 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbdK1RkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 12:40:06 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vASHe4dH028242
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vASHe4TI029520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:04 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vASHe4b7020029
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 17:40:04 GMT
Subject: [PATCH 2/3] xfs: remove unused parameter from xfs_writepage_map
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 28 Nov 2017 09:40:03 -0800
Message-ID: <151189080319.14861.3665951105884303570.stgit@magnolia>
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

The first thing that xfs_writepage_map does is clobber the offset
parameter.  Since we never use the passed-in value, turn the parameter
into a local variable.  This gets rid of an UBSAN warning in generic/466.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b0cccf8..21e2d70 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -896,13 +896,13 @@ xfs_writepage_map(
 	struct writeback_control *wbc,
 	struct inode		*inode,
 	struct page		*page,
-	loff_t			offset,
-	uint64_t              end_offset)
+	uint64_t		end_offset)
 {
 	LIST_HEAD(submit_list);
 	struct xfs_ioend	*ioend, *next;
 	struct buffer_head	*bh, *head;
 	ssize_t			len = i_blocksize(inode);
+	uint64_t		offset;
 	int			error = 0;
 	int			count = 0;
 	int			uptodate = 1;
@@ -1146,7 +1146,7 @@ xfs_do_writepage(
 		end_offset = offset;
 	}
 
-	return xfs_writepage_map(wpc, wbc, inode, page, offset, end_offset);
+	return xfs_writepage_map(wpc, wbc, inode, page, end_offset);
 
 redirty:
 	redirty_page_for_writepage(wbc, page);

