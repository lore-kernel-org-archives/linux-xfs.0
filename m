Return-Path: <SRS0=8N9+=DU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB439C433E7
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 17:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6045F25308
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Oct 2020 17:01:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M1RHRWhd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgJMRA7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Oct 2020 13:00:59 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42842 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgJMRA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 13:00:59 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DGwesu138000;
        Tue, 13 Oct 2020 17:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=AEULCGoazW6p+wXUshZ4QF5+dVJIwsMPJOoGdDsckGE=;
 b=M1RHRWhd8KCsaRLncOy60eQSKq+p+cPIAjVY07h1ykeKOKzZ2vGlEjYNFYcyAGY7q+yO
 J3LwqPLpJkqpxiS7UO/f0YxcLaxdEEMd9RP80YdBm8u766laE06K700M3p2GPfazP0AT
 7nju6qpWg70/0EPIfrNlEfwwOlM1M6YNW9HqZE6xm9oOA+JRrKT+1dW9k85dLeewjI7g
 rGShYRtgn+4k2DzBe0mcqEoBkzrEOYJRy0W8zpOPUq9lfCJsAoS8PMSODWTIKBlEYAxG
 hcZtnQQXoZaoQlYth6iF6Fej3N/qYTjEcnzr5nPIrizvH6FDL/GWrBf1QkpRUhDLpnwb aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 343pajsxs2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 13 Oct 2020 17:00:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09DGnkgk188627;
        Tue, 13 Oct 2020 16:58:55 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 344by2fste-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Oct 2020 16:58:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09DGwsBQ018971;
        Tue, 13 Oct 2020 16:58:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 13 Oct 2020 09:58:54 -0700
Date:   Tue, 13 Oct 2020 09:58:53 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>,
        Allison Collins <allison.henderson@oracle.com>,
        "Bill O'Donnell" <billodo@redhat.com>
Subject: [PATCH] xfs: fix high key handling in the rt allocator's query_range
 function
Message-ID: <20201013165853.GC9832@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=5 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9773 signatures=668681
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=5
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010130124
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some off-by-one errors in xfs_rtalloc_query_range.  The highest key
in the realtime bitmap is always one less than the number of rt extents,
which means that the key clamp at the start of the function is wrong.
The 4th argument to xfs_rtfind_forw is the highest rt extent that we
want to probe, which means that passing 1 less than the high key is
wrong.  Finally, drop the rem variable that controls the loop because we
can compare the iteration point (rtstart) against the high key directly.

The sordid history of this function is that the original commit (fb3c3)
incorrectly passed (high_rec->ar_startblock - 1) as the 'limit' parameter
to xfs_rtfind_forw.  This was wrong because the "high key" is supposed
to be the largest key for which the caller wants result rows, not the
key for the first row that could possibly be outside the range that the
caller wants to see.

A subsequent attempt (8ad56) to strengthen the parameter checking added
incorrect clamping of the parameters to the number of rt blocks in the
system (despite the bitmap functions all taking units of rt extents) to
avoid querying ranges past the end of rt bitmap file but failed to fix
the incorrect _rtfind_forw parameter.  The original _rtfind_forw
parameter error then survived the conversion of the startblock and
blockcount fields to rt extents (a0e5c), and the most recent off-by-one
fix (a3a37) thought it was patching a problem when the end of the rt
volume is not in use, but none of these fixes actually solved the
original problem that the author was confused about the "limit" argument
to xfs_rtfind_forw.

Sadly, all four of these patches were written by this author and even
his own usage of this function and rt testing were inadequate to get
this fixed quickly.

Original-problem: fb3c3de2f65c ("xfs: add a couple of queries to iterate free extents in the rtbitmap")
Not-fixed-by: 8ad560d2565e ("xfs: strengthen rtalloc query range checks")
Not-fixed-by: a0e5c435babd ("xfs: fix xfs_rtalloc_rec units")
Fixes: a3a374bf1889 ("xfs: fix off-by-one error in xfs_rtalloc_query_range")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 1d9fa8a300f1..6c1aba16113c 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1018,7 +1018,6 @@ xfs_rtalloc_query_range(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
-	xfs_rtblock_t			rem;
 	int				is_free;
 	int				error = 0;
 
@@ -1027,13 +1026,12 @@ xfs_rtalloc_query_range(
 	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
 	    low_rec->ar_startext == high_rec->ar_startext)
 		return 0;
-	if (high_rec->ar_startext > mp->m_sb.sb_rextents)
-		high_rec->ar_startext = mp->m_sb.sb_rextents;
+	high_rec->ar_startext = min(high_rec->ar_startext,
+			mp->m_sb.sb_rextents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = low_rec->ar_startext;
-	rem = high_rec->ar_startext - rtstart;
-	while (rem) {
+	while (rtstart <= high_rec->ar_startext) {
 		/* Is the first block free? */
 		error = xfs_rtcheck_range(mp, tp, rtstart, 1, 1, &rtend,
 				&is_free);
@@ -1042,7 +1040,7 @@ xfs_rtalloc_query_range(
 
 		/* How long does the extent go for? */
 		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startext - 1, &rtend);
+				high_rec->ar_startext, &rtend);
 		if (error)
 			break;
 
@@ -1055,7 +1053,6 @@ xfs_rtalloc_query_range(
 				break;
 		}
 
-		rem -= rtend - rtstart + 1;
 		rtstart = rtend + 1;
 	}
 
