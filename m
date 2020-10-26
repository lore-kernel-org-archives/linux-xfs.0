Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699F9C2D0A3
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24CC020872
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:39:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GWNKZ5g1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407297AbgJZXjI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:39:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46314 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407284AbgJZXjI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:39:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPv0N177201;
        Mon, 26 Oct 2020 23:39:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=TA1Wtay+FnYL9ZduM2bNquYcG39FZhYFYWhgjPydm+U=;
 b=GWNKZ5g1gTEw2lyuMPIg6TzQBh4wy603WeVV7CouqLilAYNi2st+a6qSRh4C2T9hd2G+
 LgRnb6D/J8x7DDlzEvobFAOsH8kmQ5xHpOBjeBuwd1yTpOLiboS8lb8DRcVKE+W+wD76
 9NjFxMN7aeZxD2rqeADxQ/Dd5TTv1XEz6Z32Q3Ucq7LFLsag2iquBms6Fjyn3XQXrY9Y
 QfW7GuXSJtt84/opqKcIR/mojBEJ3/vsLqrZ+V1H6i/rbZgzgCyrRCBvsVKMMQ26P74B
 cOY1YeL0KlGfCqZSxymVqQ52oWxH3WMEMxTnI1s+SVbDvuRYykBypQUhoKvULNTIOtOH Mw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 34c9saqdct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:39:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPxcE110561;
        Mon, 26 Oct 2020 23:39:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34cx5wfu5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:39:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09QNd45r007457;
        Mon, 26 Oct 2020 23:39:04 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:39:04 -0700
Subject: [PATCH 20/21] xfs: fix high key handling in the rt allocator's
 query_range function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:39:03 -0700
Message-ID: <160375554340.882906.9426040207344861485.stgit@magnolia>
In-Reply-To: <160375541713.882906.11902959014062334120.stgit@magnolia>
References: <160375541713.882906.11902959014062334120.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: d88850bd5516a77c6f727e8b6cefb64e0cc929c7

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
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rtbitmap.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 1bb5c75f888a..dcb94f2059b1 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1016,7 +1016,6 @@ xfs_rtalloc_query_range(
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			rtstart;
 	xfs_rtblock_t			rtend;
-	xfs_rtblock_t			rem;
 	int				is_free;
 	int				error = 0;
 
@@ -1025,13 +1024,12 @@ xfs_rtalloc_query_range(
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
@@ -1040,7 +1038,7 @@ xfs_rtalloc_query_range(
 
 		/* How long does the extent go for? */
 		error = xfs_rtfind_forw(mp, tp, rtstart,
-				high_rec->ar_startext - 1, &rtend);
+				high_rec->ar_startext, &rtend);
 		if (error)
 			break;
 
@@ -1053,7 +1051,6 @@ xfs_rtalloc_query_range(
 				break;
 		}
 
-		rem -= rtend - rtstart + 1;
 		rtstart = rtend + 1;
 	}
 

