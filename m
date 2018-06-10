Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932153AbeFJFKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:10:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57V76095331
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:16 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2jg7hwstd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:16 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AFSH024588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:16 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A5AF3Y003841
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:10:15 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v2 17/27] xfsprogs: Add helper function xfs_attr_list_context_init
Date: Sat,  9 Jun 2018 22:07:42 -0700
Message-Id: <1528607272-11122-18-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
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
index f388f5f..54f82f5 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -179,6 +179,9 @@ int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_remove_args(struct xfs_da_args *args, int flags, bool roll_trans);
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

