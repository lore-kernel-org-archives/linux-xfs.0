Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48638 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbeIZQiH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANpb0037055
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2mnvtur9by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:50 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPor4013166
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:50 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPoLj018411
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:50 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 21/30] xfsprogs: Add helper function xfs_attr_list_context_init
Date: Wed, 26 Sep 2018 03:23:24 -0700
Message-Id: <1537957413-10630-22-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a helper function xfs_attr_list_context_init
used by xfs_attr_list.  This function initializes the
xfs_attr_list_context structure passed to xfs_attr_list_int.
We will need this later to call xfs_attr_list_int_ilocked when
the node is already locked.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 126a024..9afa5eb 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -185,6 +185,9 @@ int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
+int xfs_attr_list_context_init(struct xfs_inode *dp, char *buffer, int bufsize,
+		int flags, struct attrlist_cursor_kern *cursor,
+		struct xfs_attr_list_context *context);
 int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
-- 
2.7.4
