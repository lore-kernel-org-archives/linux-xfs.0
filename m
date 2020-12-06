Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3FCC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4929E2310B
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Dec 2020 23:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgLFXNy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Dec 2020 18:13:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:58092 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbgLFXNw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 6 Dec 2020 18:13:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6N6YSw182481
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:13:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=EVHFx3B23oECeeh/6hykWPXtq2XyOvqALbN7shfya1A=;
 b=Sx/cWZzUf8v4+adTQWk0g9bWF+7PUpT8zlHmLp+OXERPrrkUXuLE4DMZTGYla8vgqSO6
 BcCm5FYMw/FJ3Oc2oTaA1z7QM3AJcf/ofzMV4roQ5l0oinwNnRNwT8nW7W1qM0TIaxbu
 uQOljzhvhmWcIVJl9f92jnYa1BBNr9rYlnDYlz6bJd31SLXHa/A/8d3iibS23a2uaQ1t
 rHTX5lS/mgu9LO+GDrNQ0DVzwafb6N/+z98ksbTP26jUnfGYZEJYegrFBaC3C8fkfi30
 LumcpVNiF+l+HlZD7dLqEmNqZqAMUgdaSOVHxVFGJKi7MuunWFslNlNEb2kp5mQ5/zKe hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 35825ktukd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:13:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B6NAMCi005640
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:11:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 358m3vpe4q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 06 Dec 2020 23:11:10 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B6NBAMb012491
        for <linux-xfs@vger.kernel.org>; Sun, 6 Dec 2020 23:11:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 06 Dec 2020 15:11:10 -0800
Subject: [PATCH 3/4] xfs: refactor file range validation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 06 Dec 2020 15:11:09 -0800
Message-ID: <160729626928.1608297.12355625902682243490.stgit@magnolia>
In-Reply-To: <160729625074.1608297.13414859761208067117.stgit@magnolia>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9827 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501 mlxscore=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012060151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor all the open-coded validation of file block ranges into a
single helper, and teach the bmap scrubber to check the ranges.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c  |    2 +-
 fs/xfs/libxfs/xfs_types.c |   25 +++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_types.h |    3 +++
 fs/xfs/scrub/bmap.c       |    4 ++++
 fs/xfs/xfs_bmap_item.c    |    2 +-
 fs/xfs/xfs_rmap_item.c    |    2 +-
 6 files changed, 35 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7bcf498ef6b2..dcf56bcafb8f 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6227,7 +6227,7 @@ xfs_bmap_validate_extent(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	if (irec->br_startoff + irec->br_blockcount <= irec->br_startoff)
+	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
 		return __this_address;
 
 	if (XFS_IS_REALTIME_INODE(ip) && whichfork == XFS_DATA_FORK) {
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 7b310eb296b7..b254fbeaaa50 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -258,3 +258,28 @@ xfs_verify_dablk(
 
 	return dabno <= max_dablk;
 }
+
+/* Check that a file block offset does not exceed the maximum. */
+bool
+xfs_verify_fileoff(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off)
+{
+	return off <= XFS_MAX_FILEOFF;
+}
+
+/* Check that a range of file block offsets do not exceed the maximum. */
+bool
+xfs_verify_fileext(
+	struct xfs_mount	*mp,
+	xfs_fileoff_t		off,
+	xfs_fileoff_t		len)
+{
+	if (off + len <= off)
+		return false;
+
+	if (!xfs_verify_fileoff(mp, off))
+		return false;
+
+	return xfs_verify_fileoff(mp, off + len - 1);
+}
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 18e83ce46568..064bd6e8c922 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -203,5 +203,8 @@ bool xfs_verify_icount(struct xfs_mount *mp, unsigned long long icount);
 bool xfs_verify_dablk(struct xfs_mount *mp, xfs_fileoff_t off);
 void xfs_icount_range(struct xfs_mount *mp, unsigned long long *min,
 		unsigned long long *max);
+bool xfs_verify_fileoff(struct xfs_mount *mp, xfs_fileoff_t off);
+bool xfs_verify_fileext(struct xfs_mount *mp, xfs_fileoff_t off,
+		xfs_fileoff_t len);
 
 #endif	/* __XFS_TYPES_H__ */
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index cce8ac7d3973..bce4421acdb9 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -329,6 +329,10 @@ xchk_bmap_iextent(
 		xchk_fblock_set_corrupt(info->sc, info->whichfork,
 				irec->br_startoff);
 
+	if (!xfs_verify_fileext(mp, irec->br_startoff, irec->br_blockcount))
+		xchk_fblock_set_corrupt(info->sc, info->whichfork,
+				irec->br_startoff);
+
 	xchk_bmap_dirattr_extent(ip, info, irec);
 
 	/* There should never be a "hole" extent in either extent list. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 5c9706760e68..9a2e54b7ccb9 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -449,7 +449,7 @@ xfs_bui_validate(
 	if (!xfs_verify_ino(mp, bmap->me_owner))
 		return false;
 
-	if (bmap->me_startoff + bmap->me_len <= bmap->me_startoff)
+	if (!xfs_verify_fileext(mp, bmap->me_startoff, bmap->me_len))
 		return false;
 
 	return xfs_verify_fsbext(mp, bmap->me_startblock, bmap->me_len);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 4fa875237422..49cebd68b672 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -490,7 +490,7 @@ xfs_rui_validate_map(
 	    !xfs_verify_ino(mp, rmap->me_owner))
 		return false;
 
-	if (rmap->me_startoff + rmap->me_len <= rmap->me_startoff)
+	if (!xfs_verify_fileext(mp, rmap->me_startoff, rmap->me_len))
 		return false;
 
 	return xfs_verify_fsbext(mp, rmap->me_startblock, rmap->me_len);

