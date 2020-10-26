Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03978C55178
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C59A7206FB
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H9eUEZbZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407264AbgJZXil (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:38:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57238 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407243AbgJZXil (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:38:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNOXmF164641;
        Mon, 26 Oct 2020 23:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=D3xC4UODBw4xylCXAbvcd+DIhRHxxlNFSXeshrngZf4=;
 b=H9eUEZbZWIdnqhUXxJdmZP8iO8g5j4f38ZsPdq/xQsccDTDGfGltlfrbXXdkkyWYHCIO
 vZRMyW4R8gOyNkcHRvGxmIuAGWZeITFgZlkryZm0DmbvezEm/u7ikLPsISjgxpCWVKVW
 Wi4z6JIrL5qBKvtE4rNF42cwgRCl/7lIAqFXVNOH/6EBdtvr3N5XIJP9yZAXDOkZTK1j
 91zsCzl2nNvNM2v6s9ZOxe5++2xhnPXirzfOpbx1bJAFCVPEPSnGcvjssUFb2BsE1DNK
 R3iNMq8YI84ZpZRNi1aTbXfa6wQZoO8WL820N/0L+hMKzOKOTdjo+nXaZ5hnb4uu6Ect 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34dgm3vuxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:38:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxkW110446;
        Mon, 26 Oct 2020 23:38:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 34cx5wftwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:38:34 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNcX8M030431;
        Mon, 26 Oct 2020 23:38:33 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:38:33 -0700
Subject: [PATCH 15/21] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:38:32 -0700
Message-ID: <160375551194.882906.1246656019413196331.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 929b92f64048d90d23e40a59c47adf59f5026903

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

Doing this means that the log item recovery functions get to determine
the transaction reservation instead of abusing tr_itruncate in yet
another part of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_defer.c |    3 +++
 libxfs/xfs_defer.h |    3 +++
 2 files changed, 6 insertions(+)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index fc5c860e5d56..8e660f1a6cfc 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -577,6 +577,9 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
 
+	/* Preserve the log reservation size. */
+	dfc->dfc_logres = tp->t_log_res;
+
 	return dfc;
 }
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 5c0e59b69ffa..6cde6f0713f7 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -79,6 +79,9 @@ struct xfs_defer_capture {
 	/* Block reservations for the data and rt devices. */
 	unsigned int		dfc_blkres;
 	unsigned int		dfc_rtxres;
+
+	/* Log reservation saved from the transaction. */
+	unsigned int		dfc_logres;
 };
 
 /*

