Return-Path: <SRS0=pdRq=4R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8250DC3F2D1
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 582022468A
	for <linux-xfs@archiver.kernel.org>; Sat, 29 Feb 2020 01:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CxHBas17"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgB2Bsw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Feb 2020 20:48:52 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37330 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbgB2Bsv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Feb 2020 20:48:51 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1jDxv179486
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=oAn2DPk5y7T8A2M+b8653pwNSNes38lxYyuwmuLTOjU=;
 b=CxHBas17plSFtWoTQsh6PmVC1EDEGH95/bAk9xhuKDBq35oAZwuPcyrL+G5vvdxEbgBr
 VWcXv64ljH1QraZHSsdS5xJ4IFuL68sB5HwBgSqmMX4avwG/qEzqfPrk4QyNJ53fCq3t
 ozNp0DCgrSRc5nj2lpHZSl8fnskOrt4MOdin1DANRXz5G7pgDl2imIzh0FiD2hnTD2dI
 35aJMKO2Qu2oSY0Ryoksb/Bhi/4sVw74FiNGKmobNF94SObk7M87PKZ/1hoOgeXrdRF2
 IHFHpMiF7K1gy/qBOd8sMfn45nouNYfQFreL9ZSl8trvdfiWhrzSLrSDMYh5AuwLs2bo NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2yf0dmcdx5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01T1iZ5s190991
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yfd2v5rj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01T1mnv4020539
        for <linux-xfs@vger.kernel.org>; Sat, 29 Feb 2020 01:48:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Feb 2020 17:48:49 -0800
Subject: [PATCH 2/4] xfs: check owner of dir3 free blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Feb 2020 17:48:48 -0800
Message-ID: <158294092825.1729975.10937805307008830676.stgit@magnolia>
In-Reply-To: <158294091582.1729975.287494493433729349.stgit@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=997 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=3
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9545 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002290008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the owner field of dir3 free block headers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index f622ede7119e..79b917e62ac3 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -194,6 +194,8 @@ xfs_dir3_free_header_check(
 			return __this_address;
 		if (be32_to_cpu(hdr3->nvalid) < be32_to_cpu(hdr3->nused))
 			return __this_address;
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
 	} else {
 		struct xfs_dir2_free_hdr *hdr = bp->b_addr;
 

