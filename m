Return-Path: <SRS0=euis=5T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4458C43331
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 881AE2078C
	for <linux-xfs@archiver.kernel.org>; Fri,  3 Apr 2020 22:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UElmjsQZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgDCWMN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 18:12:13 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbgDCWMM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Apr 2020 18:12:12 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M9e7l092971
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=5AjYuJWFw789GLaUtg6Orr4j1918LrqXtTZ+VEY/uOA=;
 b=UElmjsQZx89nFoZmXp/jc77wLbmydXApPjL8zhwMljtaO5G+mVDoRhS5kcre5qAYDC5Z
 diQFPhFzGbEUKaWNu42VP3KrCAMJt5nSXjuke9xA0/gUEMt1YRAttwx4VrArzttcc7Hm
 QKz2Q0wJ4g1HjJ2ysulP9N8LcZKIawa366AvAposRsHMOk9oIL9VyTZkE4GfpDel0JtC
 rXWRMLaMH8eTTS5yveCNc8gCPf7aFjMdNCkXXKjiq9i3wI3xAESeLHyTt4H/OItb8XTj
 VCde8S2E+fgUqi9NlMr36h7dVEkgyxwYaA+o/4Ug4GQAu+T6LcljGS4igEp6ORBM5DJg fQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yunp0n6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:12:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 033M7BZE171071
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 302g2p2bue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 03 Apr 2020 22:10:10 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 033MA9RB005652
        for <linux-xfs@vger.kernel.org>; Fri, 3 Apr 2020 22:10:09 GMT
Received: from localhost.localdomain (/67.1.1.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Apr 2020 15:10:08 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v8 15/39] xfsprogs: move the legacy xfs_attr_list to xfs_ioctl.c
Date:   Fri,  3 Apr 2020 15:09:34 -0700
Message-Id: <20200403220958.4944-16-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200403220958.4944-1-allison.henderson@oracle.com>
References: <20200403220958.4944-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=1 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9580 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=1 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004030171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The old xfs_attr_list code is only used by the attrlist by handle
ioctl.  Move it to xfs_ioctl.c with its user.  Also move the
attrlist and attrlist_ent structure to xfs_fs.h, as they are exposed
user ABIs.  They are used through libattr headers with the same name
by at least xfsdump.  Also document this relation so that it doesn't
require a research project to figure out.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.h | 23 -----------------------
 libxfs/xfs_fs.h   | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 23 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 31c0ffd..0e3c213 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -49,27 +49,6 @@ struct xfs_attr_list_context;
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
 /*
- * Define how lists of attribute names are returned to the user from
- * the attr_list() call.  A large, 32bit aligned, buffer is passed in
- * along with its size.  We put an array of offsets at the top that each
- * reference an attrlist_ent_t and pack the attrlist_ent_t's at the bottom.
- */
-typedef struct attrlist {
-	__s32	al_count;	/* number of entries in attrlist */
-	__s32	al_more;	/* T/F: more attrs (do call again) */
-	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
-} attrlist_t;
-
-/*
- * Show the interesting info about one attribute.  This is what the
- * al_offset[i] entry points to.
- */
-typedef struct attrlist_ent {	/* data from attr_list() */
-	__u32	a_valuelen;	/* number bytes in value of attr */
-	char	a_name[1];	/* attr name (NULL terminated) */
-} attrlist_ent_t;
-
-/*
  * Kernel-internal version of the attrlist cursor.
  */
 typedef struct attrlist_cursor_kern {
@@ -131,8 +110,6 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
-int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
-		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index e362fc8..51a688f 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -593,6 +593,26 @@ typedef struct xfs_attrlist_cursor {
 	__u32		opaque[4];
 } xfs_attrlist_cursor_t;
 
+/*
+ * Define how lists of attribute names are returned to userspace from the
+ * XFS_IOC_ATTRLIST_BY_HANDLE ioctl.  struct xfs_attrlist is the header at the
+ * beginning of the returned buffer, and a each entry in al_offset contains the
+ * relative offset of an xfs_attrlist_ent containing the actual entry.
+ *
+ * NOTE: struct xfs_attrlist must match struct attrlist defined in libattr, and
+ * struct xfs_attrlist_ent must match struct attrlist_ent defined in libattr.
+ */
+struct xfs_attrlist {
+	__s32	al_count;	/* number of entries in attrlist */
+	__s32	al_more;	/* T/F: more attrs (do call again) */
+	__s32	al_offset[1];	/* byte offsets of attrs [var-sized] */
+};
+
+struct xfs_attrlist_ent {	/* data from attr_list() */
+	__u32	a_valuelen;	/* number bytes in value of attr */
+	char	a_name[1];	/* attr name (NULL terminated) */
+};
+
 typedef struct xfs_fsop_attrlist_handlereq {
 	struct xfs_fsop_handlereq	hreq; /* handle interface structure */
 	struct xfs_attrlist_cursor	pos; /* opaque cookie, list offset */
-- 
2.7.4

