Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B65B6C47404
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F98021848
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 16:48:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SSPQfL9Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731158AbfJIQsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 12:48:47 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58774 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731375AbfJIQsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 12:48:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GjkEV039894
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/Wz+DerBV1FDv/bgz5Ti8Yq6z0cyryhRTY22px8o7qE=;
 b=SSPQfL9YQB+7LZTyxM2/WHVozeTxOIgwFHtATIGKSNQDT7cobEkMZ1QNBbxsoSmmSlQ6
 HiqTOLvboX07yLiHDXHtowpqwVVIzlkQYgX74r+FL5iRKZGRNIHKdWNPC3rNrMiLB7i1
 ix+2UHCdZp819+9NKSo3mVVlldmTGa4Al2LBhTLiKpN/LteQ7wzzkEa3Dn99QbaSDULU
 Mg5yfwWCv1GtNjbL4Hw78hrBx7gbJycoo0dOXBOKELvZvHFQz35cLHZ7Jvlemfnnt2dy
 Tf+dZHGmu+ZheyQS3vrUW/HqLnwc/jPhYeFK5ujLVxEdRQSZwtKrUnMThUqHnPj4V7B5 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2vejkup0wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x99GibQC144798
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2vh8k14526-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 09 Oct 2019 16:48:44 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x99GmgPO004023
        for <linux-xfs@vger.kernel.org>; Wed, 9 Oct 2019 16:48:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 09:48:41 -0700
Subject: [PATCH 1/3] xfs: xrep_reap_extents should not destroy the bitmap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 09 Oct 2019 09:48:40 -0700
Message-ID: <157063972033.2913192.3828052500812376869.stgit@magnolia>
In-Reply-To: <157063971218.2913192.8762913814390092382.stgit@magnolia>
References: <157063971218.2913192.8762913814390092382.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910090147
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910090147
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the xfs_bitmap_destroy call from the end of xrep_reap_extents
because this sort of violates our rule that the function initializing a
structure should destroy it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/agheader_repair.c |    2 +-
 fs/xfs/scrub/repair.c          |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 7a1a38b636a9..8fcd43040c96 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -698,7 +698,7 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	return xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+	error = xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
 	xfs_bitmap_destroy(&agfl_extents);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index b70a88bc975e..3a58788e0bd8 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -613,11 +613,9 @@ xrep_reap_extents(
 
 		error = xrep_reap_block(sc, fsbno, oinfo, type);
 		if (error)
-			goto out;
+			break;
 	}
 
-out:
-	xfs_bitmap_destroy(bitmap);
 	return error;
 }
 

