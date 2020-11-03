Return-Path: <SRS0=RpwR=EJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5E8C2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7831C221FB
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Nov 2020 17:27:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JmgfWd2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgKCR1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Nov 2020 12:27:43 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33476 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCR1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Nov 2020 12:27:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HNW9q112653;
        Tue, 3 Nov 2020 17:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=bKJkidqn7sFx9LJySv/e7ikASTpYfvo8gqBOjmlK5XM=;
 b=JmgfWd2j0ks0UkXNd7PSpoyz2uIUQLWwRDGjpZWjB+d7Q6dvVot61J2PCDun1IArRYIB
 KOw9ZuGwAevftt2LStvJ40cUeJWphnMiojdNyTvdPSy3PrqWhVR0uJyL7ebTZuoO9t96
 a3JpcAiwoZSRWi1Bcpqg66NaxrvN5p0JaRHHvB69rGhgN31LQnJ+qfYDy60/AY2DTEQt
 syRf/OCDBowH95ll5p1wpCtrCCTz/1rQhvRYETle55dd2eGBZWTYrE9+1x02dBUZQI9K
 z1stSffL2gw2I123PxMV19MukNhjrAJj/4DNUEdOcxka6cWoXtYmGprOMq9d8kriJ0a5 Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34hhb22jt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 03 Nov 2020 17:27:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A3HPifA192475;
        Tue, 3 Nov 2020 17:27:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34hvrw6k43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Nov 2020 17:27:36 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0A3HRXq0003843;
        Tue, 3 Nov 2020 17:27:33 GMT
Received: from localhost (/10.159.234.173)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Nov 2020 09:27:33 -0800
Date:   Tue, 3 Nov 2020 09:27:32 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix missing CoW blocks writeback conversion retry
Message-ID: <20201103172732.GD7123@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=1 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030117
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9794 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=1
 clxscore=1015 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011030117
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 7588cbeec6df, we tried to fix a race stemming from the lack of
coordination between higher level code that wants to allocate and remap
CoW fork extents into the data fork.  Christoph cites as examples the
always_cow mode, and a directio write completion racing with writeback.

According to the comments before the goto retry, we want to restart the
lookup to catch the extent in the data fork, but we don't actually reset
whichfork or cow_fsb, which means the second try executes using stale
information.  Up until now I think we've gotten lucky that either
there's something left in the CoW fork to cause cow_fsb to be reset, or
either data/cow fork sequence numbers have advanced enough to force a
fresh lookup from the data fork.  However, if we reach the retry with an
empty stable CoW fork and a stable data fork, neither of those things
happens.  The retry foolishly re-calls xfs_convert_blocks on the CoW
fork which fails again.  This time, we toss the write.

I've recently been working on extending reflink to the realtime device.
When the realtime extent size is larger than a single block, we have to
force the page cache to CoW the entire rt extent if a write (or
fallocate) are not aligned with the rt extent size.  The strategy I've
chosen to deal with this is derived from Dave's blocksize > pagesize
series: dirtying around the write range, and ensuring that writeback
always starts mapping on an rt extent boundary.  This has brought this
race front and center, since generic/522 blows up immediately.

However, I'm pretty sure this is a bug outright, independent of that.

Fixes: 7588cbeec6df ("xfs: retry COW fork delalloc conversion when no extent was found")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 5bf37afae5e9..4304c6416fbb 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -346,8 +346,8 @@ xfs_map_blocks(
 	ssize_t			count = i_blocksize(inode);
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
-	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
-	int			whichfork = XFS_DATA_FORK;
+	xfs_fileoff_t		cow_fsb;
+	int			whichfork;
 	struct xfs_bmbt_irec	imap;
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
@@ -381,6 +381,8 @@ xfs_map_blocks(
 	 * landed in a hole and we skip the block.
 	 */
 retry:
+	cow_fsb = NULLFILEOFF;
+	whichfork = XFS_DATA_FORK;
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
