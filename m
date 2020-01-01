Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA0FC2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F32B2064B
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:07:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YIfloep7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgAABHB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:07:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51836 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbgAABHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:07:00 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00116xtg108571
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Cz862Zfb8fPjgskiwJvGFjmgXqFrsYsFd+k5FFT95Js=;
 b=YIfloep7mayWoUo4BpQU04V3+/4s3tArczwRVKIHv4l2ptDnjEQoUWGF/cULi18QTqSk
 JRl3GTMVecBCj/hsUymLa00uReR3+5XcQ5R8PtYa7ahwbWLmAn+FSzV/238kfIy19e4m
 rY0EGQB5uOekFQkCgi9ZYAfYKlNgqQOYtVaekb9LNcNupz0W7vLyD/RW2i0ezV5KpjG1
 DCrAV17VhtvoTs6pBWIpHBVahM+RnVsHqzW0KzYFh4ogGywKqFz9OlMJ6JsRVtkUp9mC
 j8AldoVDjDH/g7+f8nL4hmDmI73ABhGOgnjGTixxSXvESXT+SXfDn2vPd2F9QOE7ehGB 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Fmj006734
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2x8guee2pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:06:58 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00116wBT026798
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:06:58 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:06:58 -0800
Subject: [PATCH 09/11] xfs: use bool for done in xfs_inode_ag_walk
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:06:56 -0800
Message-ID: <157784081608.1360343.8892190103324406330.stgit@magnolia>
In-Reply-To: <157784075463.1360343.1278255546758019580.stgit@magnolia>
References: <157784075463.1360343.1278255546758019580.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a boolean variable, so use the bool type.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index fbe0d8fb59c1..c3964af55979 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -799,11 +799,11 @@ xfs_inode_ag_walk(
 	uint32_t		first_index;
 	int			last_error = 0;
 	int			skipped;
-	int			done;
+	bool			done;
 	int			nr_found;
 
 restart:
-	done = 0;
+	done = false;
 	skipped = 0;
 	first_index = 0;
 	nr_found = 0;
@@ -855,7 +855,7 @@ xfs_inode_ag_walk(
 				continue;
 			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
 			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
-				done = 1;
+				done = true;
 		}
 
 		/* unlock now we've grabbed the inodes. */

