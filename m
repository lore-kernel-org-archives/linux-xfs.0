Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16766 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760319AbdKQSYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Nov 2017 13:24:09 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vAHIO7pU023370
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:08 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vAHIO7bn029507
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:07 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vAHIO7JB015191
        for <linux-xfs@vger.kernel.org>; Fri, 17 Nov 2017 18:24:07 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 11/17] Add the extra space requirements for parent pointer attributes when calculating the minimum log size during mkfs
Date: Fri, 17 Nov 2017 11:21:39 -0700
Message-Id: <1510942905-12897-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
References: <1510942905-12897-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_log_rlimit.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
index c105979..beec9bf 100644
--- a/fs/xfs/libxfs/xfs_log_rlimit.c
+++ b/fs/xfs/libxfs/xfs_log_rlimit.c
@@ -39,6 +39,40 @@ xfs_log_calc_max_attrsetm_res(
 {
 	int			size;
 	int			nblks;
+	struct xfs_trans_resv   *resp = M_RES(mp);
+
+	/* Calculate extra space needed for parent pointer attributes */
+	if (!xfs_sb_version_hasparent(&mp->m_sb)) {
+
+		/* rename can add/remove/modify 2 parent attributes */
+		resp->tr_rename.tr_logres +=
+			2 * max(resp->tr_attrsetm.tr_logres,
+				resp->tr_attrrm.tr_logres);
+		resp->tr_rename.tr_logcount +=
+			2 * max(resp->tr_attrsetm.tr_logcount,
+				resp->tr_attrrm.tr_logcount);
+
+		/* create will add 1 parent attribute */
+		resp->tr_create.tr_logres += resp->tr_attrsetm.tr_logres;
+		resp->tr_create.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+		/* mkdir will add 1 parent attribute */
+		resp->tr_mkdir.tr_logres += resp->tr_attrsetm.tr_logres;
+		resp->tr_mkdir.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+		/* link will add 1 parent attribute */
+		resp->tr_link.tr_logres += resp->tr_attrsetm.tr_logres;
+		resp->tr_link.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+		/* symlink will add 1 parent attribute */
+		resp->tr_symlink.tr_logres += resp->tr_attrsetm.tr_logres;
+		resp->tr_symlink.tr_logcount += resp->tr_attrsetm.tr_logcount;
+
+		/* remove will remove 1 parent attribute */
+		resp->tr_remove.tr_logres += resp->tr_attrrm.tr_logres;
+		resp->tr_remove.tr_logcount = resp->tr_attrrm.tr_logcount;
+	}
+
 
 	size = xfs_attr_leaf_entsize_local_max(mp->m_attr_geo->blksize) -
 	       MAXNAMELEN - 1;
-- 
2.7.4

