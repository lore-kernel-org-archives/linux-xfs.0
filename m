Return-Path: <SRS0=Nxvu=26=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5015DC282DD
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 221AA20678
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jan 2020 18:44:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UUDtnIn+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730517AbgAISoe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jan 2020 13:44:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59108 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729778AbgAISoe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jan 2020 13:44:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009Id4AF139869
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=dJWFBYuTa6HWJPyw7CwP69q67o4lIGK+Hgb6RxVPnK0=;
 b=UUDtnIn+kvbzShOwOVYemFJlU0b9XbPFVDtZqFkZc1BN88IU9SyWEtqmIuH4nFzxorFm
 TUkG2y7OPs7GLN7qFhdRsHr33lMQFmm3ty7PS2Wk0DQGVicC6G09laoItZscVVGQgey+
 JaM02H3/XKb1A/wK7OTJsflt7L1RLzgc78ICKOxLY2RqRQlXTet96OpKmyWYPmb/81VJ
 IYHnwv2yX7kCOflnoi+jAuqXxMRIdSNQFWVLU077UiRbcbdJMM7c6vv+MWgGY4ScuB51
 oNqeolIH01yms8rpPIpGkNNW9VePO0eL0LKZQ7P5oYoSMTcE+qMPZ1XulNYFHyrazvzw eg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbr4pr0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 009IdG5S171553
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2xdmryudnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jan 2020 18:44:32 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 009IiWux030715
        for <linux-xfs@vger.kernel.org>; Thu, 9 Jan 2020 18:44:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 Jan 2020 10:44:31 -0800
Subject: [PATCH 2/3] xfs: truncate should remove all blocks,
 not just to the end of the page cache
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 09 Jan 2020 10:44:30 -0800
Message-ID: <157859547075.163942.7214434913691255010.stgit@magnolia>
In-Reply-To: <157859545662.163942.11245536419486956862.stgit@magnolia>
References: <157859545662.163942.11245536419486956862.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001090154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9495 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001090154
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fc3aec26ef87..1979a0055763 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1518,7 +1518,6 @@ xfs_itruncate_extents_flags(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp = *tpp;
 	xfs_fileoff_t		first_unmap_block;
-	xfs_fileoff_t		last_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
 
@@ -1540,21 +1539,22 @@ xfs_itruncate_extents_flags(
 	 * the end of the file (in a crash where the space is allocated
 	 * but the inode size is not yet updated), simply remove any
 	 * blocks which show up between the new EOF and the maximum
-	 * possible file size.  If the first block to be removed is
-	 * beyond the maximum file size (ie it is the same as last_block),
-	 * then there is nothing to do.
+	 * possible file size.
+	 *
+	 * We have to free all the blocks to the bmbt maximum offset, even if
+	 * the page cache can't scale that far.
 	 */
 	first_unmap_block = XFS_B_TO_FSB(mp, (xfs_ufsize_t)new_size);
-	last_block = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
-	if (first_unmap_block == last_block)
+	if (first_unmap_block >= XFS_MAX_FILEOFF) {
+		WARN_ON_ONCE(first_unmap_block > XFS_MAX_FILEOFF);
 		return 0;
+	}
 
-	ASSERT(first_unmap_block < last_block);
-	unmap_len = last_block - first_unmap_block + 1;
-	while (!done) {
+	unmap_len = XFS_MAX_FILEOFF - first_unmap_block + 1;
+	while (unmap_len > 0) {
 		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = xfs_bunmapi(tp, ip, first_unmap_block, unmap_len, flags,
-				    XFS_ITRUNC_MAX_EXTENTS, &done);
+		error = __xfs_bunmapi(tp, ip, first_unmap_block, &unmap_len,
+				flags, XFS_ITRUNC_MAX_EXTENTS);
 		if (error)
 			goto out;
 
@@ -1574,7 +1574,7 @@ xfs_itruncate_extents_flags(
 	if (whichfork == XFS_DATA_FORK) {
 		/* Remove all pending CoW reservations. */
 		error = xfs_reflink_cancel_cow_blocks(ip, &tp,
-				first_unmap_block, last_block, true);
+				first_unmap_block, XFS_MAX_FILEOFF, true);
 		if (error)
 			goto out;
 

