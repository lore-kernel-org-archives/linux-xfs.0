Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:36722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbeK2KcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:32:19 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNSWO6160029
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:01 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2nxxkqn71k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:00 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wASNT0eH018261
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:00 GMT
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNSxwQ027481
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:29:00 GMT
Subject: [PATCH 1/6] xfs: fix symbolic enum printing in ftrace output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:28:58 -0800
Message-ID: <154344773868.4341.11083191144188175339.stgit@magnolia>
In-Reply-To: <154344773243.4341.5458822684407979916.stgit@magnolia>
References: <154344773243.4341.5458822684407979916.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

ftrace's __print_symbolic() has a (very poorly documented) requirement
that any enum values used in the symbol to string translation table be
wrapped in a TRACE_DEFINE_ENUM so that the enum value can be encoded in
the ftrace ring buffer.  Fix this unsatisfied requirement.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_trace.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cabe5c8010b0..dcde4e9907f7 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -640,6 +640,16 @@ DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
 
+/*
+ * ftrace's __print_symbolic requires that all enum values be wrapped in the
+ * TRACE_DEFINE_ENUM macro so that the enum value can be encoded in the ftrace
+ * ring buffer.  Somehow this was only worth mentioning in the ftrace sample
+ * code.
+ */
+TRACE_DEFINE_ENUM(PE_SIZE_PTE);
+TRACE_DEFINE_ENUM(PE_SIZE_PMD);
+TRACE_DEFINE_ENUM(PE_SIZE_PUD);
+
 TRACE_EVENT(xfs_filemap_fault,
 	TP_PROTO(struct xfs_inode *ip, enum page_entry_size pe_size,
 		 bool write_fault),
@@ -1208,6 +1218,12 @@ DEFINE_EVENT(xfs_readpage_class, name,	\
 DEFINE_READPAGE_EVENT(xfs_vm_readpage);
 DEFINE_READPAGE_EVENT(xfs_vm_readpages);
 
+TRACE_DEFINE_ENUM(XFS_IO_HOLE);
+TRACE_DEFINE_ENUM(XFS_IO_DELALLOC);
+TRACE_DEFINE_ENUM(XFS_IO_UNWRITTEN);
+TRACE_DEFINE_ENUM(XFS_IO_OVERWRITE);
+TRACE_DEFINE_ENUM(XFS_IO_COW);
+
 DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
 		 int type, struct xfs_bmbt_irec *irec),
