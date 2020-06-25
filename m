Return-Path: <SRS0=UnAH=AG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 843CDC433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:17:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BF0B2078D
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Jun 2020 01:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mykunHYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgFYBR7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 21:17:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52840 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388863AbgFYBR6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jun 2020 21:17:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18TKV062755;
        Thu, 25 Jun 2020 01:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DJsKRkSho2zNcXgsT1dRbJf/6CnPAPmD1rib0EBL8F8=;
 b=mykunHYt6CVYmU9Tay26dOZuPD2klYFk/KCVyR+378HGdnI8msZtXIgxJzYmJBv+7sNn
 wzSW3IBkbzbK27uAfWa+QuH3UVJKW8IvlTwx/Gf9ZgrvaA8MHVkyhuWQgHmiCuH/kceb
 7gzgDLKeBlXZ4r3utsqa4eBQ0F+XwhOZe0hbVFYgn+LusAbsn4W2zB2qX7bhaMs8TY1L
 kaw3at98iZ6i58kNsbKSx2BPGBjhDu4O6q0cno+xINniQGiPSo/Mie3OErcVG2gbwT9l
 iNrYwUiRn5j7jy2Fhd129b2coYEHwrlxSx9qj/kQq9h7ED0sTlBkxqG6VzKpMLjdapK+ 9A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 31uustnvqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 01:17:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05P18WQR013795;
        Thu, 25 Jun 2020 01:17:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 31uur85aht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 01:17:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05P1HsbW012978;
        Thu, 25 Jun 2020 01:17:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 01:17:54 +0000
Subject: [PATCH 2/9] xfs: rename xfs_bmap_is_real_extent to is_written_extent
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, edwin@etorok.net
Date:   Wed, 24 Jun 2020 18:17:52 -0700
Message-ID: <159304787204.874036.10765296473918147829.stgit@magnolia>
In-Reply-To: <159304785928.874036.4735877085735285950.stgit@magnolia>
References: <159304785928.874036.4735877085735285950.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxlogscore=999 adultscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=1 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The name of this predicate is a little misleading -- it decides if the
extent mapping is allocated and written.  Change the name to be more
direct, as we're going to add a new predicate in the next patch.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 +-
 fs/xfs/xfs_reflink.c         |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6028a3c825ba..2b18338d0643 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -163,7 +163,7 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  * Return true if the extent is a real, allocated extent, or false if it is  a
  * delayed allocation, and unwritten extent or a hole.
  */
-static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
 	return irec->br_state != XFS_EXT_UNWRITTEN &&
 		irec->br_startblock != HOLESTARTBLOCK &&
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 9498ced947be..1d9fa8a300f1 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ xfs_rtbuf_get(
 	if (error)
 		return error;
 
-	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_real_extent(&map)))
+	if (XFS_IS_CORRUPT(mp, nmap == 0 || !xfs_bmap_is_written_extent(&map)))
 		return -EFSCORRUPTED;
 
 	ASSERT(map.br_startblock != NULLFSBLOCK);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index d89201d40891..22fdea6d69d3 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -179,7 +179,7 @@ xfs_reflink_trim_around_shared(
 	int			error = 0;
 
 	/* Holes, unwritten, and delalloc extents cannot be shared */
-	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_real_extent(irec)) {
+	if (!xfs_is_cow_inode(ip) || !xfs_bmap_is_written_extent(irec)) {
 		*shared = false;
 		return 0;
 	}
@@ -655,7 +655,7 @@ xfs_reflink_end_cow_extent(
 	 * preallocations can leak into the range we are called upon, and we
 	 * need to skip them.
 	 */
-	if (!xfs_bmap_is_real_extent(&got)) {
+	if (!xfs_bmap_is_written_extent(&got)) {
 		*end_fsb = del.br_startoff;
 		goto out_cancel;
 	}
@@ -996,7 +996,7 @@ xfs_reflink_remap_extent(
 	xfs_off_t		new_isize)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_real_extent(irec);
+	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
 	unsigned int		resblks;
 	struct xfs_bmbt_irec	uirec;

