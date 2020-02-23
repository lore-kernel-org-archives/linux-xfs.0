Return-Path: <SRS0=wjSb=4L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A402C35671
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27CEB206E0
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Feb 2020 07:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWH2U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 02:28:20 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8870 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbgBWH2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Feb 2020 02:28:20 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01N7OJbD107224;
        Sun, 23 Feb 2020 02:28:17 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb0g23pp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:17 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01N7S7r4113672;
        Sun, 23 Feb 2020 02:28:16 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb0g23pnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 02:28:16 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01N7RMJa028529;
        Sun, 23 Feb 2020 07:28:15 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma03wdc.us.ibm.com with ESMTP id 2yaux5skuq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Feb 2020 07:28:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01N7SFJB48431514
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Feb 2020 07:28:15 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DC2F112062;
        Sun, 23 Feb 2020 07:28:15 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAE64112061;
        Sun, 23 Feb 2020 07:28:12 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.102.2.13])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Feb 2020 07:28:12 +0000 (GMT)
From:   Chandan Rajendra <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Rajendra <chandanrlinux@gmail.com>, david@fromorbit.com,
        chandan@linux.ibm.com, darrick.wong@oracle.com, bfoster@redhat.com
Subject: [PATCH V4 5/7] xfs: xfs_attr_calc_size: Explicitly pass mp, namelen and valuelen args
Date:   Sun, 23 Feb 2020 13:00:42 +0530
Message-Id: <20200223073044.14215-5-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20200223073044.14215-1-chandanrlinux@gmail.com>
References: <20200223073044.14215-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-22_08:2020-02-21,2020-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 suspectscore=1 mlxscore=0
 clxscore=1034 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002230063
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In a future commit, xfs_attr_calc_size() will be invoked from a function that
does not have a 'struct xfs_da_args' handy. Hence this commit changes
xfs_attr_calc_size() to let invokers to explicitly pass 'struct xfs_mount *',
namelen and valuelen arguments.

Signed-off-by: Chandan Rajendra <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_attr.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 921acac71e5d9..f781724bf85ce 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -138,22 +138,24 @@ xfs_attr_get(
  */
 STATIC void
 xfs_attr_calc_size(
-	struct xfs_da_args		*args,
+	struct xfs_mount		*mp,
 	struct xfs_attr_set_resv	*resv,
+	int				namelen,
+	int				valuelen,
 	int				*local)
 {
-	struct xfs_mount		*mp = args->dp->i_mount;
+	unsigned int			blksize = mp->m_attr_geo->blksize;
 	int				size;
 
 	/*
 	 * Determine space new attribute will use, and if it would be
 	 * "local" or "remote" (note: local != inline).
 	 */
-	size = xfs_attr_leaf_newentsize(args->geo, args->namelen,
-			args->valuelen, local);
+	size = xfs_attr_leaf_newentsize(mp->m_attr_geo, namelen, valuelen,
+			local);
 	resv->total_dablks = XFS_DAENTER_BLOCKS(mp, XFS_ATTR_FORK);
 	if (*local) {
-		if (size > (args->geo->blksize / 2)) {
+		if (size > (blksize / 2)) {
 			/* Double split possible */
 			resv->total_dablks *= 2;
 		}
@@ -163,7 +165,7 @@ xfs_attr_calc_size(
 		 * Out of line attribute, cannot double split, but
 		 * make room for the attribute value itself.
 		 */
-		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
+		resv->rmt_blks = xfs_attr3_rmt_blocks(mp, valuelen);
 	}
 
 	resv->bmbt_blks = XFS_NEXTENTADD_SPACE_RES(mp,
@@ -329,7 +331,8 @@ xfs_attr_set(
 		XFS_STATS_INC(mp, xs_attr_set);
 
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		xfs_attr_calc_size(args, &resv, &local);
+		xfs_attr_calc_size(mp, &resv, args->namelen, args->valuelen,
+				&local);
 		args->total = resv.alloc_blks;
 
 		/*
-- 
2.19.1

