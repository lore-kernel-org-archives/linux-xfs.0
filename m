Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7318C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1157206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:12:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="raNcc89I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgEEBMj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:12:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37428 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBMj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:12:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 045135oD054618
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=C+fjLmsnQ4Sun2wW6mcX7KU8Jrkm31pirvzQFIqyD9g=;
 b=raNcc89INP2Dy2gUXjeEnmsGKbw+hQ6U1/QI0iMrMWspzgJIlUFnPwUxraoRG8vn0m3A
 eL7f2/jlJMwgNNe9ACTi/UbKtOQszOQFkrE6NT8GtrkL0bxJm9WkfFsvTSBcB5Mbv85S
 o+5v6xLVTJDVkHU1/oQhh/xWXVBh8zHdYXo+bdH8JQp4t2QONlR2jiDKZZZzsOl0gMGU
 nRv9Viw/ul/PCGEpo+jFt2JnK3dFjd7UbEJLFhNBFR389whxPjcWw5O1DmJPoKNop011
 Bc5nZvsHhXmXuK9CUj8lryP0A7YvCamOCsySii0nSlBHKArFhLkorD5+HwEsqRDnZ0Is 4A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30s0tma19a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04516fp0149300
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30sjjxarjw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:12:36 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451CakZ015152
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:12:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:12:36 -0700
Subject: [PATCH 19/28] xfs: refactor xlog_recover_process_unlinked
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:12:35 -0700
Message-ID: <158864115522.182683.9248036319539577559.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 mlxscore=0 phishscore=0
 bulkscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Hoist the unlinked inode processing logic out of the AG loop and into
its own function.  No functional changes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_unlink_recover.c |   91 +++++++++++++++++++++++++------------------
 1 file changed, 52 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/xfs_unlink_recover.c b/fs/xfs/xfs_unlink_recover.c
index 2a19d096e88d..413b34085640 100644
--- a/fs/xfs/xfs_unlink_recover.c
+++ b/fs/xfs/xfs_unlink_recover.c
@@ -145,54 +145,67 @@ xlog_recover_process_one_iunlink(
  * scheduled on this CPU to ensure other scheduled work can run without undue
  * latency.
  */
-void
-xlog_recover_process_unlinked(
-	struct xlog		*log)
+STATIC int
+xlog_recover_process_iunlinked(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
-	struct xfs_mount	*mp;
 	struct xfs_agi		*agi;
 	struct xfs_buf		*agibp;
-	xfs_agnumber_t		agno;
 	xfs_agino_t		agino;
 	int			bucket;
 	int			error;
 
-	mp = log->l_mp;
-
-	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
-		/*
-		 * Find the agi for this ag.
-		 */
-		error = xfs_read_agi(mp, NULL, agno, &agibp);
-		if (error) {
-			/*
-			 * AGI is b0rked. Don't process it.
-			 *
-			 * We should probably mark the filesystem as corrupt
-			 * after we've recovered all the ag's we can....
-			 */
-			continue;
-		}
+	/*
+	 * Find the agi for this ag.
+	 */
+	error = xfs_read_agi(mp, NULL, agno, &agibp);
+	if (error) {
 		/*
-		 * Unlock the buffer so that it can be acquired in the normal
-		 * course of the transaction to truncate and free each inode.
-		 * Because we are not racing with anyone else here for the AGI
-		 * buffer, we don't even need to hold it locked to read the
-		 * initial unlinked bucket entries out of the buffer. We keep
-		 * buffer reference though, so that it stays pinned in memory
-		 * while we need the buffer.
+		 * AGI is b0rked. Don't process it.
+		 *
+		 * We should probably mark the filesystem as corrupt
+		 * after we've recovered all the ag's we can....
 		 */
-		agi = agibp->b_addr;
-		xfs_buf_unlock(agibp);
-
-		for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
-			agino = be32_to_cpu(agi->agi_unlinked[bucket]);
-			while (agino != NULLAGINO) {
-				agino = xlog_recover_process_one_iunlink(mp,
-							agno, agino, bucket);
-				cond_resched();
-			}
+		return error;
+	}
+
+	/*
+	 * Unlock the buffer so that it can be acquired in the normal
+	 * course of the transaction to truncate and free each inode.
+	 * Because we are not racing with anyone else here for the AGI
+	 * buffer, we don't even need to hold it locked to read the
+	 * initial unlinked bucket entries out of the buffer. We keep
+	 * buffer reference though, so that it stays pinned in memory
+	 * while we need the buffer.
+	 */
+	agi = agibp->b_addr;
+	xfs_buf_unlock(agibp);
+
+	for (bucket = 0; bucket < XFS_AGI_UNLINKED_BUCKETS; bucket++) {
+		agino = be32_to_cpu(agi->agi_unlinked[bucket]);
+		while (agino != NULLAGINO) {
+			agino = xlog_recover_process_one_iunlink(mp,
+						agno, agino, bucket);
+			cond_resched();
 		}
-		xfs_buf_rele(agibp);
+	}
+	xfs_buf_rele(agibp);
+
+	return 0;
+}
+
+void
+xlog_recover_process_unlinked(
+	struct xlog		*log)
+{
+	struct xfs_mount	*mp = log->l_mp;
+	xfs_agnumber_t		agno;
+	int			error;
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = xlog_recover_process_iunlinked(mp, agno);
+		if (error)
+			break;
 	}
 }

