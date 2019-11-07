Return-Path: <SRS0=aC/G=Y7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B31FA372C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81BB52077C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Nov 2019 03:03:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mbrMF3xa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbfKGDDA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 22:03:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:55880 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727665AbfKGDDA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 22:03:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72xMA5024054
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=QwV3w06CJzSvvD8v/D78RkfTlYCRFqyo+tIO4M1E9Bc=;
 b=mbrMF3xa3woSA5xQw1/28BJ4A+K7FdnefGGnIfnZLDQYwLqDGmt3HOk3B+wy3JRwmMag
 pIz3/HyjyQV096IKce/ef72rgx32yw0tpDGewZwd60dFBxjJq1vZWX5qf8sYzwvjHDZg
 g7osg8QrRY+Q8caGBxRRIrWBCKQGOIvzX8XuhdWX445P9+bBj47iIfkFfiHNe53H7dh9
 61OHmkkq1Csx4smDtmRE5peax4I3dphp2VQ2WTNtkE4Yew7OC3JalEQ/qeHvVINsXNdX
 9EQo09OyN6/ELZPjBjxxXMdR5Fi+m4/smO5ABhrvJBPlaZDmKxZl1QPU7dxekCcLs6rj +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2w41w0u0me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA72wiSc151749
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2w41w8kqgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 07 Nov 2019 03:02:57 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA732uvs003361
        for <linux-xfs@vger.kernel.org>; Thu, 7 Nov 2019 03:02:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 19:02:56 -0800
Subject: [PATCH 5/6] xfs: "optimize" buffer item log segment bitmap setting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 06 Nov 2019 19:02:55 -0800
Message-ID: <157309577521.46520.17834347718436642749.stgit@magnolia>
In-Reply-To: <157309573874.46520.18107298984141751739.stgit@magnolia>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=641
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911070030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=728 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911070031
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Optimize the setting of full words of bits in xfs_buf_item_log_segment.
The optimization is purely within the bug triage process.  No functional
changes.

Coverity-id: 1446793
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf_item.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index d74fbd1e9d3e..6b69e6137b2b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -851,7 +851,7 @@ xfs_buf_item_log_segment(
 	 * first_bit and last_bit.
 	 */
 	while ((bits_to_set - bits_set) >= NBWORD) {
-		*wordp |= 0xffffffff;
+		*wordp = 0xffffffff;
 		bits_set += NBWORD;
 		wordp++;
 	}

