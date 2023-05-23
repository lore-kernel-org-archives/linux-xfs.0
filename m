Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A7ABC7EE2A
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235537AbjEWJBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjEWJBT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF0B109
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:17 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6EF9o027118;
        Tue, 23 May 2023 09:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=Lwr5U15JmUjh17Ts8ZhFj0Kqpr/F6zbqkmi9G0yk9As=;
 b=3X2mJ0sOnuFSC3mvuS2uGkZH0TaojPty0Red/8J196MHjhcsOpHgHygL/65Djf4ABTrX
 kRuyHyzYgjWtUwgPkwyQcrR6iyKrF57qENQKyELRCqynovirLIWfyQ1HaS1tfIgNvBb6
 MBqBwDy36mQVr5amZUIKk0WE6TSr189V3gFAGcdaiyWSca7xyCYU1dVGAeMP5rLVJygF
 ZnJf9kB8240NE+eCRMykAl8b3fDuobUVpCmNfZfTt0DXHEOIJ3pD1u3V5rDGuiQrgNZu
 +owCE2NQXgCyKTDZ7n71Vl5iBVwHCj0KEXr6FDiTZrZ3ZgodN9bEBuNME1p+TaANLtmP GA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp8ccp8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8v8oO029531;
        Tue, 23 May 2023 09:01:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:14 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrl007681;
        Tue, 23 May 2023 09:01:13 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-13;
        Tue, 23 May 2023 09:01:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 12/24] metadump: Define metadump ops for v2 format
Date:   Tue, 23 May 2023 14:30:38 +0530
Message-Id: <20230523090050.373545-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-ORIG-GUID: knDoZdKgI-4LwYePe3RnwcF-1vkugHj5
X-Proofpoint-GUID: knDoZdKgI-4LwYePe3RnwcF-1vkugHj5
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit adds functionality to dump metadata from an XFS filesystem in
newly introduced v2 format.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 70 insertions(+), 3 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 9d7ad76ae..627436e68 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -3037,6 +3037,69 @@ static struct metadump_ops metadump1_ops = {
 	.release_metadump = release_metadump_v1,
 };
 
+static int
+init_metadump_v2(void)
+{
+	struct xfs_metadump_header xmh = {0};
+	uint32_t compat_flags = 0;
+
+	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
+	xmh.xmh_version = 2;
+
+	if (metadump.obfuscate)
+		compat_flags |= XFS_MD2_INCOMPAT_OBFUSCATED;
+	if (!metadump.zero_stale_data)
+		compat_flags |= XFS_MD2_INCOMPAT_FULLBLOCKS;
+	if (metadump.dirty_log)
+		compat_flags |= XFS_MD2_INCOMPAT_DIRTYLOG;
+
+	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+
+	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	return 0;
+}
+
+static int
+write_metadump_v2(
+	enum typnm	type,
+	char		*data,
+	int64_t		off,
+	int		len)
+{
+	struct xfs_meta_extent	xme;
+	uint64_t		addr;
+
+	addr = off;
+	if (type == TYP_ELOG)
+		addr |= XME_ADDR_LOG_DEVICE;
+	else
+		addr |= XME_ADDR_DATA_DEVICE;
+
+	xme.xme_addr = cpu_to_be64(addr);
+	xme.xme_len = cpu_to_be32(len);
+
+	if (fwrite(&xme, sizeof(xme), 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	if (fwrite(data, len << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct metadump_ops metadump2_ops = {
+	.init_metadump = init_metadump_v2,
+	.write_metadump = write_metadump_v2,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3178,7 +3241,10 @@ metadump_f(
 		}
 	}
 
-	metadump.mdops = &metadump1_ops;
+	if (metadump.version == 1)
+		metadump.mdops = &metadump1_ops;
+	else
+		metadump.mdops = &metadump2_ops;
 
 	ret = metadump.mdops->init_metadump();
 	if (ret)
@@ -3203,7 +3269,7 @@ metadump_f(
 		exitcode = !copy_log(log_type);
 
 	/* write the remaining index */
-	if (!exitcode)
+	if (!exitcode && metadump.mdops->end_write_metadump)
 		exitcode = metadump.mdops->end_write_metadump() < 0;
 
 	if (metadump.progress_since_warning)
@@ -3223,7 +3289,8 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	metadump.mdops->release_metadump();
+	if (metadump.mdops->release_metadump)
+		metadump.mdops->release_metadump();
 
 out:
 	return 0;
-- 
2.39.1

