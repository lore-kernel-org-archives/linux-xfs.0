Return-Path: <SRS0=wiGc=ZD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C805C43331
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C2C9206DF
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Nov 2019 01:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pCCp2HTp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfKKBSt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 Nov 2019 20:18:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45390 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfKKBSs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Nov 2019 20:18:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1IUCu117132;
        Mon, 11 Nov 2019 01:18:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=PawLnizGg+VitxEOtEIvZO5KT41ozCnq8697IpT13V4=;
 b=pCCp2HTpRH6UrG1DMnbrA+y/Fp2jT1MEB7nQzk490YFgcWNzmCYRKqsoTV2hClURd1iw
 VRlsaMQ/tUoUGjAAXytbH5pBo3Vhsmh16EtfdcgYYebUk2FjKY8fgKQuOS7kIJmnmecf
 B0KU6QxyDDLpZ2zaqQOZkW3nc2oXXVM2+bT+GsEgOYZrdtvPxveRsI/WzsgAlEwKSNry
 C22LlWOVulDTEjfDiyg34Fvxqxg7Q7BEA0VImmyp8hqBWI/fxAASKV5/tHG91WKxFTWE
 aUw3eXsv/BZS7qAthFuU5jhYObx2kWW3OBL4ifM3SN2z3VkfCb1Z4OaI1Tf1cVlW6pSG wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2w5mvtc666-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAB1Ib59091548;
        Mon, 11 Nov 2019 01:18:37 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2w66ytmfsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 01:18:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAB1ITNh017631;
        Mon, 11 Nov 2019 01:18:29 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 10 Nov 2019 17:18:29 -0800
Subject: [PATCH 2/3] xfs: attach dquots and reserve quota blocks during
 unwritten conversion
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Sun, 10 Nov 2019 17:18:27 -0800
Message-ID: <157343510780.1948946.16275987302017348487.stgit@magnolia>
In-Reply-To: <157343509505.1948946.5379830250503479422.stgit@magnolia>
References: <157343509505.1948946.5379830250503479422.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_iomap_write_unwritten, we need to ensure that dquots are attached
to the inode and quota blocks reserved so that we capture in the quota
counters any blocks allocated to handle a bmbt split.  This can happen
on the first unwritten extent conversion to a preallocated sparse file
on a fresh mount.

This was found by running generic/311 with quotas enabled.  The bug
seems to have been introduced in "[XFS] rework iocore infrastructure,
remove some code and make it more" from ~2002?

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |   10 ++++++++++
 1 file changed, 10 insertions(+)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f234929b4f15..97dbe3b2aec0 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -539,6 +539,11 @@ xfs_iomap_write_unwritten(
 	 */
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 
+	/* Attach dquots so that bmbt splits are accounted correctly. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	do {
 		/*
 		 * Set up a transaction to convert the range of extents
@@ -557,6 +562,11 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
+		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */

