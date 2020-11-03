Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB3BC2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B822220757
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 18:37:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GI43GV81"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgKCShh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 13:37:37 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:41590 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCShh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 13:37:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3IU5B5071454
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 18:37:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=U/zzPldxamElWcQXtbIFQaFaUzClppu9zP/RkFZbuwQ=;
 b=GI43GV81PK/FK+Ayk0C6eYdYmjvaF1L5zi/F8uMpdlFKKxBjaSJLIN8ZOB6Ygy5TlPVe
 kknYbf3fyPcKu1HpBXJaZtwk5+qNjeUNJBLfCloJtxeUhHFz/wedPi2cdS4/cACw3byK
 O3Ie+JN+Rn77VgG4DAo412IvVmmitwQLUrZkqYy7g9b2G+xy2HiDGJwNCtNarpbCnSVu
 7HlK5ULnfUzfWmDURyNAvcjq2XOfAROWQDcrh985R5BakbqyU+N0n0chOxVRRoRdc+bb
 PXw3FOEKrhZb8HgEf3XzLsU4ZSabJf08qioVzqSkj54UeZCDOTLxUliqJMuMmTUra70V +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb22wxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 18:37:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3IPhg9029515
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 18:37:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34hvrw9btw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Nov 2020 18:37:35 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A3IbYUU008268
        for <linux-xfs@vger.kernel.org>; Tue, 3 Nov 2020 18:37:34 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 10:37:34 -0800
Date:   Tue, 3 Nov 2020 10:37:33 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: only flush the unshared range in xfs_reflink_unshare
Message-ID: <20201103183733.GI7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030125
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030125
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

There's no reason to flush an entire file when we're unsharing part of
a file.  Therefore, only initiate writeback on the selected range.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_reflink.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 16098dc42add..6fa05fb78189 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1502,7 +1502,8 @@ xfs_reflink_unshare(
 			&xfs_buffered_write_iomap_ops);
 	if (error)
 		goto out;
-	error = filemap_write_and_wait(inode->i_mapping);
+
+	error = filemap_write_and_wait_range(inode->i_mapping, offset, len);
 	if (error)
 		goto out;
 
