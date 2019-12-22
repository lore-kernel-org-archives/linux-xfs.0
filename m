Return-Path: <SRS0=cf1J=2M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BD46C2D0C0
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 16:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4458B206D3
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Dec 2019 16:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Tw9097qK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfLVQge (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Dec 2019 11:36:34 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55576 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfLVQge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Dec 2019 11:36:34 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBMGYOlr075490
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=+nDbHn1fqKfrercfnLlWeAqmTsXyxsAdKheh/FmhNuY=;
 b=Tw9097qKGii5zr5BHl0YTH7/PM/VdUbXViWX2TOxJoWBu3dMq1sawSNOxdb4I75PFFbE
 aXP7iKdYDWR1DXBmmf2AWeQZwHCSR0gS0Siro7aJg+MqWUUpOBdWI5xtt6OH0t+nex4V
 dyx9xeQqRfq3eeAZOv9Il2QbOXzuc3wn051pWFbxAqNh0TNj64A88hv68bpQU1Ig2xji
 ig3rXd1zwNpYH8AR/OBtZhiSvFFQ83GMGg6yLBD5bhDIhzd/cZQNlh4CN9hk2m6CDVl1
 VoAVmP2gV6emF4SEiSu7wVVvtlJqAzok7Go8rAEJoB9fbp+uAG8DM4eLv2dRRWV3o4lc wA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2x1bbpkpd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:36:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBMGYNgr107507
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:36:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2x1wj7sv34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:36:32 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBMGaVUp003519
        for <linux-xfs@vger.kernel.org>; Sun, 22 Dec 2019 16:36:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Dec 2019 08:36:31 -0800
Date:   Sun, 22 Dec 2019 08:36:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: truncate should remove all blocks, not just to the end
 of the page cache
Message-ID: <20191222163630.GS7489@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912220150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9479 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912220150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_itruncate_extents_flags() is supposed to unmap every block in a file
from EOF onwards.  Oddly, it uses s_maxbytes as the upper limit to the
bunmapi range, even though s_maxbytes reflects the highest offset the
pagecache can support, not the highest offset that XFS supports.

The result of this confusion is that if you create a 20T file on a
64-bit machine, mount the filesystem on a 32-bit machine, and remove the
file, we leak everything above 16T.  Fix this by capping the bunmapi
request at the maximum possible block offset, not s_maxbytes.

Fixes: 32972383ca462 ("xfs: make largest supported offset less shouty")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 401da197f012..eaa85d5933cb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1544,9 +1544,12 @@ xfs_itruncate_extents_flags(
 	 * possible file size.  If the first block to be removed is
 	 * beyond the maximum file size (ie it is the same as last_block),
 	 * then there is nothing to do.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
+	last_block = (1ULL << BMBT_STARTOFF_BITLEN) - 1;
 	if (first_unmap_block == last_block)
 		return 0;
 
