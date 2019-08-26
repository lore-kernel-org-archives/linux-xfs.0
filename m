Return-Path: <SRS0=ZZxK=WW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD09C3A59F
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C5FE217F5
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Aug 2019 21:49:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CPLox4Ho"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfHZVtu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Aug 2019 17:49:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42664 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbfHZVtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Aug 2019 17:49:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLnNbO189261
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=UcvoY63H8W1KfwNGqSXr2Oeu409zxpXtdjJGdtWBRPA=;
 b=CPLox4HorYFuST0R7OnnbLjaOmAk2jNC3TrfnldsRJS6042rVuDSWllExynG1ixICRDp
 ikhNw3+i38awbCi3gd9FN6S6ZQK6Kwx5EqI2yjz5VMhf3dyVoR6/S8U7/6vGj8uch7sy
 RuWzEXs4Ap6HutFycD8XIl5iOLz7cO52VuG3xjYRu3n1y1PEgaCaHc5B9iyacfWF4nyW
 LRLS2YO5lywYhn9EcFp2HwnvTT1iclmXSVBWIo7CTb7BZqZjA7UqcKEH3wedk3j50unP
 I0SXZtYow+uhuBQ5r3gWvG1wgkJZHpIP0hc4ejTW8uxYdCazhN6/eEMvsukmlFfr2eYH FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2umq5t84tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7QLmCGD035898
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2umhu7xe6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:48 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7QLnl3a008647
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2019 21:49:47 GMT
Received: from localhost (/10.159.144.227)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 14:49:47 -0700
Subject: [PATCH 5/5] xfs: reinitialize rm_flags when unpacking an offset
 into an rmap irec
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 26 Aug 2019 14:49:46 -0700
Message-ID: <156685618619.2853674.16603505107055424362.stgit@magnolia>
In-Reply-To: <156685615360.2853674.5160169873645196259.stgit@magnolia>
References: <156685615360.2853674.5160169873645196259.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=914
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908260202
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=976 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908260202
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In xfs_rmap_irec_offset_unpack, we should always clear the contents of
rm_flags before we begin unpacking the encoded (ondisk) offset into the
incore rm_offset and incore rm_flags fields.  Remove the open-coded
field zeroing as this encourages api misuse.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |    1 -
 fs/xfs/libxfs/xfs_rmap.h |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 56769826a5ca..424c5f7343e1 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -168,7 +168,6 @@ xfs_rmap_btrec_to_irec(
 	union xfs_btree_rec	*rec,
 	struct xfs_rmap_irec	*irec)
 {
-	irec->rm_flags = 0;
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
 	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 0c2c3cb73429..abe633403fd1 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -68,6 +68,7 @@ xfs_rmap_irec_offset_unpack(
 	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
 		return -EFSCORRUPTED;
 	irec->rm_offset = XFS_RMAP_OFF(offset);
+	irec->rm_flags = 0;
 	if (offset & XFS_RMAP_OFF_ATTR_FORK)
 		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
 	if (offset & XFS_RMAP_OFF_BMBT_BLOCK)

