Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F77DC433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F9D3207D8
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 02:53:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OZlBuLTG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgEVCxT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 22:53:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35126 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbgEVCxS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 22:53:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2oh3l124550;
        Fri, 22 May 2020 02:53:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZFDLWaEKIRrO0Kvw52IZ3NYXF1IH4XypqMPGXtRrXpo=;
 b=OZlBuLTG/uDFedui9RKYCXu+i+pt2vbxf55Y4lswYxw/N9wpR1/CrLMIpdAOKH9zVmQc
 HTdCBkWXEmTK5rMifkz4+0+BXf8sk/eV2DPy6+A4xJxTD1zIAWsh1QB24JlOd6gW+Svw
 hCywd7dujeQRu8zmHzHkzMCalWsl2MywrfPQKqDjP5jxlp8XiNam/uPMM+Fayj8PlPkg
 RxFOxO9+vznEtjqrJMmlyRj+JW8cNcyy3ZyTjFmXTCLSoCbm3V3OKxr5+P/022jghLl8
 fRc0HEwYeYGcGDNNiVnhoNPqYtWIHw2CG6ZFMdBwsQtKRDMfLTBaaC1ydXAlQ746UyVL gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 3127krkk00-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 02:53:13 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04M2nELO173920;
        Fri, 22 May 2020 02:53:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 312t3d3vk8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 02:53:12 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04M2rBdM004429;
        Fri, 22 May 2020 02:53:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 21 May 2020 19:53:11 -0700
Subject: [PATCH 2/4] xfs: measure all contiguous previous extents for prealloc
 size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, bfoster@redhat.com
Date:   Thu, 21 May 2020 19:53:09 -0700
Message-ID: <159011598984.76931.15076402801787913960.stgit@magnolia>
In-Reply-To: <159011597442.76931.7800023221007221972.stgit@magnolia>
References: <159011597442.76931.7800023221007221972.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9628 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=1 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220021
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're estimating a new speculative preallocation length for an
extending write, we should walk backwards through the extent list to
determine the number of number of blocks that are physically and
logically contiguous with the write offset, and use that as an input to
the preallocation size computation.

This way, preallocation length is truly measured by the effectiveness of
the allocator in giving us contiguous allocations without being
influenced by the state of a given extent.  This fixes both the problem
where ZERO_RANGE within an EOF can reduce preallocation, and prevents
the unnecessary shrinkage of preallocation when delalloc extents are
turned into unwritten extents.

This was found as a regression in xfs/014 after changing delalloc writes
to create unwritten extents during writeback.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c |   37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ac970b13b1f8..6a308af93893 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -377,15 +377,17 @@ xfs_iomap_prealloc_size(
 	loff_t			count,
 	struct xfs_iext_cursor	*icur)
 {
+	struct xfs_iext_cursor	ncur = *icur; /* struct copy */
+	struct xfs_bmbt_irec	prev, got;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	struct xfs_bmbt_irec	prev;
-	int			shift = 0;
 	int64_t			freesp;
 	xfs_fsblock_t		qblocks;
-	int			qshift = 0;
 	xfs_fsblock_t		alloc_blocks = 0;
+	xfs_extlen_t		plen;
+	int			shift = 0;
+	int			qshift = 0;
 
 	if (offset + count <= XFS_ISIZE(ip))
 		return 0;
@@ -413,16 +415,27 @@ xfs_iomap_prealloc_size(
 	 * preallocation size.
 	 *
 	 * If the extent is a hole, then preallocation is essentially disabled.
-	 * Otherwise we take the size of the preceding data extent as the basis
-	 * for the preallocation size. If the size of the extent is greater than
-	 * half the maximum extent length, then use the current offset as the
-	 * basis. This ensures that for large files the preallocation size
-	 * always extends to MAXEXTLEN rather than falling short due to things
-	 * like stripe unit/width alignment of real extents.
+	 * Otherwise we take the size of the preceding data extents as the basis
+	 * for the preallocation size. Note that we don't care if the previous
+	 * extents are written or not.
+	 *
+	 * If the size of the extents is greater than half the maximum extent
+	 * length, then use the current offset as the basis. This ensures that
+	 * for large files the preallocation size always extends to MAXEXTLEN
+	 * rather than falling short due to things like stripe unit/width
+	 * alignment of real extents.
 	 */
-	if (prev.br_blockcount <= (MAXEXTLEN >> 1))
-		alloc_blocks = prev.br_blockcount << 1;
-	else
+	plen = prev.br_blockcount;
+	while (xfs_iext_prev_extent(ifp, &ncur, &got)) {
+		if (plen > MAXEXTLEN / 2 ||
+		    got.br_startoff + got.br_blockcount != prev.br_startoff ||
+		    got.br_startblock + got.br_blockcount != prev.br_startblock)
+			break;
+		plen += got.br_blockcount;
+		prev = got;
+	}
+	alloc_blocks = plen * 2;
+	if (alloc_blocks > MAXEXTLEN)
 		alloc_blocks = XFS_B_TO_FSB(mp, offset);
 	if (!alloc_blocks)
 		goto check_writeio;

