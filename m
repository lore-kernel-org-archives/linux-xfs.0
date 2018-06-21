Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50610 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754177AbeFUSbt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Jun 2018 14:31:49 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5LITGX3083011
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:49 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2jmr2muayb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:48 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVmSo000883
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:48 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5LIVmbM018680
        for <linux-xfs@vger.kernel.org>; Thu, 21 Jun 2018 18:31:48 GMT
Subject: [PATCH 7/8] xfs: fix off-by-one error in xfs_rtalloc_query_range
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 21 Jun 2018 11:31:47 -0700
Message-ID: <152960590720.26246.9373633806502479237.stgit@magnolia>
In-Reply-To: <152960586416.26246.8634761888260524091.stgit@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In commit 8ad560d2565e6 ("xfs: strengthen rtalloc query range checks")
we strengthened the input parameter checks in the rtbitmap range query
function, but introduced an off-by-one error in the process.  The call
to xfs_rtfind_forw deals with the high key being rextents, but we clamp
the high key to rextents - 1.  This causes the returned results to stop
one block short of the end of the rtdev, which is incorrect.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rtbitmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 65fc4ed2e9a1..b228c821bae6 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1029,8 +1029,8 @@ xfs_rtalloc_query_range(
 	if (low_rec->ar_startext >= mp->m_sb.sb_rextents ||
 	    low_rec->ar_startext == high_rec->ar_startext)
 		return 0;
-	if (high_rec->ar_startext >= mp->m_sb.sb_rextents)
-		high_rec->ar_startext = mp->m_sb.sb_rextents - 1;
+	if (high_rec->ar_startext > mp->m_sb.sb_rextents)
+		high_rec->ar_startext = mp->m_sb.sb_rextents;
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	rtstart = low_rec->ar_startext;

