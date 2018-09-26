Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33584 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727493AbeIZQiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANdfm073174
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:52 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2mnd5thjs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:51 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPkbY027144
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPkAC018429
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 09/30] xfsprogs: Add attr context to log item
Date: Wed, 26 Sep 2018 03:23:12 -0700
Message-Id: <1537957413-10630-10-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch modifies xfs_attr_item to store a xfs_da_args, a xfs_buf pointer
and a new state type. We will use these in the next patch when
we modify xfs_set_attr_args to roll transactions by returning EAGAIN.
Because the subroutines of this function modify the contents of these
structures, we need to find a place to store them where they remain
instantiated across multiple calls to xfs_set_attr_args.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 1225c42..ad2a73c 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -74,6 +74,12 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 	char	a_name[1];	/* attr name (NULL terminated) */
 } attrlist_ent_t;
 
+/* Attr state machine types */
+typedef enum {
+	XFS_ATTR_STATE1 = 1,
+	XFS_ATTR_STATE2 = 2,
+} xfs_attr_state_t;
+
 /*
  * List of attrs to commit later.
  */
@@ -85,7 +91,16 @@ struct xfs_attr_item {
 	void*		  xattri_name;	      /* attr name */
 	uint32_t	  xattri_name_len;    /* length of name */
 	uint32_t	  xattri_flags;       /* attr flags */
-	struct list_head  xattri_list;
+
+	/*
+	 * Delayed attr parameters that need to remain instantiated
+	 * across transaction rolls during the defer finish
+	 */
+	struct xfs_buf		*xattri_leaf_bp;  /* Leaf buf to release */
+	xfs_attr_state_t	xattri_state;	  /* state machine marker */
+	struct xfs_da_args	xattri_args;	  /* args context */
+
+	struct list_head	xattri_list;
 
 	/*
 	 * A byte array follows the header containing the file name and
-- 
2.7.4
