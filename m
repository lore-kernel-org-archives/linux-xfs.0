Return-Path: <SRS0=NnDK=6T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23119C3A5A9
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED3FE206C0
	for <linux-xfs@archiver.kernel.org>; Tue,  5 May 2020 01:10:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="O2idCuD8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgEEBKV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 21:10:21 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49136 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:10:21 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04514JBx143396
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=usnAefvVwklBIYwqAfuhsZlQNCUKyyE3lxzZ19PdMP4=;
 b=O2idCuD8arpluVhp9Ic+7nyZxgta0EPrr+GFT+ga/NBeFdM5koe5rhDrH67ajjngaVAf
 Scbv9K/1KRsJSHBhvjXV9ozVYuzOj3JlNXoMiaYHmWUXEImk673bS1Wze4p75YN5XFw2
 s/4cfo6KEpJnrCas8ovZYTMzGvht+dDSfxKC478bWZR9RAucWL1oopbXnUDPmAUTsW1W
 Enn7M2vzkq4aW2hxLRuKPzQM4f2V017aYYm883vK4OBWh6/1WcXJVBICwKpWBR48Wr1L
 UvMCAqeRPZXNa6PpKyVxJtb20pti+eoCUJyXi1IPPax7PDnCPOjgRex9+kfgyhaJWEds /A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r231s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515St7145315
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjncknke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:10:19 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0451AHp5015655
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:10:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:10:17 -0700
Subject: [PATCH 1/3] xfs: clean up the error handling in xfs_swap_extents
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:10:16 -0700
Message-ID: <158864101600.182577.8313719136212435982.stgit@magnolia>
In-Reply-To: <158864100980.182577.10199078041909350877.stgit@magnolia>
References: <158864100980.182577.10199078041909350877.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=1
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we release resources properly if we cannot clean out the COW
extents in preparation for an extent swap.

Fixes: 96987eea537d6c ("xfs: cancel COW blocks before swapext")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f800f7fe888..cc23a3e23e2d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1606,7 +1606,7 @@ xfs_swap_extents(
 	if (xfs_inode_has_cow_data(tip)) {
 		error = xfs_reflink_cancel_cow_range(tip, 0, NULLFILEOFF, true);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	/*

