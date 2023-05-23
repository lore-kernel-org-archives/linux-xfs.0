Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF64C7EE26
	for <linux-xfs@archiver.kernel.org>; Tue, 23 May 2023 09:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236266AbjEWJBU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 May 2023 05:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbjEWJBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03A8109
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6E7tF024581;
        Tue, 23 May 2023 09:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=wTsdLbgC0mtKQFX6G0zvNlufcDBEAudO9GKzyPdksPE=;
 b=wdIVXjVeimx0LyOrggnm4sqGHkQpwXGx1yt5wzvqCyzvvSAW79zHkJL8ad66kaY9Fjj7
 WDf53jp2eF2gNBoULCh0OlUuJvkyvv0nVsdVrW8f5X4wAqF07rCbYTI7saHIzah/KqUO
 wtowPvavHk7k9KQiKK5Iu7vTTMbTEuEuLD+BuoZaUT11V+E5xv/ZBPRVZ89dRki8ZR6X
 l4n4y6D8LuVNJsmVvmLW6WMmnqDuxpHBPTTwxXMeSKtFlnjb3b/89VYJ8VFE6RAsLPgT
 HVqdvOnYd0I1WXomLRPtKgE+a8yxoS6Trd+CKS250d/KrBzaKQyFwC0jy7drcS5NQKZw FQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp7yvkws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N747hp028892;
        Tue, 23 May 2023 09:01:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:11 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrf007681;
        Tue, 23 May 2023 09:01:11 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-10;
        Tue, 23 May 2023 09:01:11 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 09/24] metadump: Introduce metadump v1 operations
Date:   Tue, 23 May 2023 14:30:35 +0530
Message-Id: <20230523090050.373545-10-chandan.babu@oracle.com>
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
X-Proofpoint-ORIG-GUID: wgEHke315t0Hdehwn-yVhL9QpfCWpbOr
X-Proofpoint-GUID: wgEHke315t0Hdehwn-yVhL9QpfCWpbOr
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This commit moves functionality associated with writing metadump to disk into
a new function. It also renames metadump initialization, write and release
functions to reflect the fact that they work with v1 metadump files.

The metadump initialization, write and release functions are now invoked via
metadump_ops->init_metadump(), metadump_ops->write_metadump() and
metadump_ops->release_metadump() respectively.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 db/metadump.c | 124 +++++++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 63 deletions(-)

diff --git a/db/metadump.c b/db/metadump.c
index 56d8c3bdf..7265f73ec 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -135,59 +135,6 @@ print_progress(const char *fmt, ...)
 	metadump.progress_since_warning = 1;
 }
 
-/*
- * A complete dump file will have a "zero" entry in the last index block,
- * even if the dump is exactly aligned, the last index will be full of
- * zeros. If the last index entry is non-zero, the dump is incomplete.
- * Correspondingly, the last chunk will have a count < num_indices.
- *
- * Return 0 for success, -1 for failure.
- */
-
-static int
-write_index(void)
-{
-	struct xfs_metablock *metablock = metadump.metablock;
-	/*
-	 * write index block and following data blocks (streaming)
-	 */
-	metablock->mb_count = cpu_to_be16(metadump.cur_index);
-	if (fwrite(metablock, (metadump.cur_index + 1) << BBSHIFT, 1,
-			metadump.outf) != 1) {
-		print_warning("error writing to target file");
-		return -1;
-	}
-
-	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
-	metadump.cur_index = 0;
-	return 0;
-}
-
-/*
- * Return 0 for success, -errno for failure.
- */
-static int
-write_buf_segment(
-	char		*data,
-	int64_t		off,
-	int		len)
-{
-	int		i;
-	int		ret;
-
-	for (i = 0; i < len; i++, off++, data += BBSIZE) {
-		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
-		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
-			data, BBSIZE);
-		if (++metadump.cur_index == metadump.num_indices) {
-			ret = write_index();
-			if (ret)
-				return -EIO;
-		}
-	}
-	return 0;
-}
-
 /*
  * we want to preserve the state of the metadata in the dump - whether it is
  * intact or corrupt, so even if the buffer has a verifier attached to it we
@@ -224,15 +171,16 @@ write_buf(
 
 	/* handle discontiguous buffers */
 	if (!buf->bbmap) {
-		ret = write_buf_segment(buf->data, buf->bb, buf->blen);
+		ret = metadump.mdops->write_metadump(buf->typ->typnm, buf->data,
+				buf->bb, buf->blen);
 		if (ret)
 			return ret;
 	} else {
 		int	len = 0;
 		for (i = 0; i < buf->bbmap->nmaps; i++) {
-			ret = write_buf_segment(buf->data + BBTOB(len),
-						buf->bbmap->b[i].bm_bn,
-						buf->bbmap->b[i].bm_len);
+			ret = metadump.mdops->write_metadump(buf->typ->typnm,
+				buf->data + BBTOB(len), buf->bbmap->b[i].bm_bn,
+				buf->bbmap->b[i].bm_len);
 			if (ret)
 				return ret;
 			len += buf->bbmap->b[i].bm_len;
@@ -2994,7 +2942,7 @@ done:
 }
 
 static int
-init_metadump(void)
+init_metadump_v1(void)
 {
 	metadump.metablock = (xfs_metablock_t *)calloc(BBSIZE + 1, BBSIZE);
 	if (metadump.metablock == NULL) {
@@ -3035,12 +2983,60 @@ init_metadump(void)
         return 0;
 }
 
+static int
+end_write_metadump_v1(void)
+{
+	/*
+	 * write index block and following data blocks (streaming)
+	 */
+	metadump.metablock->mb_count = cpu_to_be16(metadump.cur_index);
+	if (fwrite(metadump.metablock, (metadump.cur_index + 1) << BBSHIFT, 1, metadump.outf) != 1) {
+		print_warning("error writing to target file");
+		return -1;
+	}
+
+	memset(metadump.block_index, 0, metadump.num_indices * sizeof(__be64));
+	metadump.cur_index = 0;
+	return 0;
+}
+
+static int
+write_metadump_v1(
+	enum typnm	type,
+	char		*data,
+	int64_t		off,
+	int		len)
+{
+	int		i;
+	int		ret;
+
+        for (i = 0; i < len; i++, off++, data += BBSIZE) {
+		metadump.block_index[metadump.cur_index] = cpu_to_be64(off);
+		memcpy(&metadump.block_buffer[metadump.cur_index << BBSHIFT],
+			data, BBSIZE);
+		if (++metadump.cur_index == metadump.num_indices) {
+			ret = end_write_metadump_v1();
+			if (ret)
+				return -EIO;
+		}
+	}
+
+        return 0;
+}
+
 static void
-release_metadump(void)
+release_metadump_v1(void)
 {
 	free(metadump.metablock);
 }
 
+static struct metadump_ops metadump1_ops = {
+	.init_metadump = init_metadump_v1,
+	.write_metadump = write_metadump_v1,
+	.end_write_metadump = end_write_metadump_v1,
+	.release_metadump = release_metadump_v1,
+};
+
 static int
 metadump_f(
 	int 		argc,
@@ -3182,9 +3178,11 @@ metadump_f(
 		}
 	}
 
-	ret = init_metadump();
+	metadump.mdops = &metadump1_ops;
+
+	ret = metadump.mdops->init_metadump();
 	if (ret)
-		return 0;
+		goto out;
 
 	exitcode = 0;
 
@@ -3206,7 +3204,7 @@ metadump_f(
 
 	/* write the remaining index */
 	if (!exitcode)
-		exitcode = write_index() < 0;
+		exitcode = metadump.mdops->end_write_metadump() < 0;
 
 	if (metadump.progress_since_warning)
 		fputc('\n', metadump.stdout_metadump ? stderr : stdout);
@@ -3225,7 +3223,7 @@ metadump_f(
 	while (iocur_sp > start_iocur_sp)
 		pop_cur();
 
-	release_metadump();
+	metadump.mdops->release_metadump();
 
 out:
 	return 0;
-- 
2.39.1

