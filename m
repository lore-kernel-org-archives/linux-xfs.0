Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727974AbfAaXSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:18:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0VNEHff027972
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2q8d2eku78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:36 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNIZLG027648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:35 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0VNIZwc031507
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 23:18:35 GMT
Subject: [PATCH 7/8] xfs: add tracepoints for high level iunlink operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 31 Jan 2019 15:18:34 -0800
Message-ID: <154897671399.26065.15247361285974787568.stgit@magnolia>
In-Reply-To: <154897667054.26065.13164381203002725289.stgit@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add tracepoints so we can associate high level operations with low level
updates.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    4 ++++
 fs/xfs/xfs_trace.h |    3 +++
 2 files changed, 7 insertions(+)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d5b3f8fdac7e..56349497d75b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2030,6 +2030,8 @@ xfs_iunlink(
 	ASSERT(VFS_I(ip)->i_mode != 0);
 	ASSERT(xfs_verify_ino(mp, ip->i_ino));
 
+	trace_xfs_iunlink(ip);
+
 	agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
@@ -2199,6 +2201,8 @@ xfs_iunlink_remove(
 	short			bucket_index;
 	int			error;
 
+	trace_xfs_iunlink_remove(ip);
+
 	if (!xfs_verify_ino(mp, ip->i_ino))
 		return -EFSCORRUPTED;
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fbec8f0e1a9a..22d4729143b5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3423,6 +3423,9 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		  __entry->new_ptr)
 );
 
+DEFINE_INODE_EVENT(xfs_iunlink);
+DEFINE_INODE_EVENT(xfs_iunlink_remove);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
