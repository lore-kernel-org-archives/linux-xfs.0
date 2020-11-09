Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B75C388F7
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01B94206C0
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Nov 2020 18:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qUAzjv2P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbgKISRp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Nov 2020 13:17:45 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:59338 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729243AbgKISRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Nov 2020 13:17:45 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9I9F9x112604;
        Mon, 9 Nov 2020 18:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pAK++fCW/V9F2xBPH7KypFjCkD8KpqYomVdGAEowOM8=;
 b=qUAzjv2PcsDWv/VRAb/siJ3fcIxF7FnN62YBNXGhPqwi1w/lr0r7CAPzZQyGe8tEAMH/
 HDSrIaPPMfL79CV8VjG5bffi9DbYpl0B4RYc2pdMAbJqyzDAMmvM13/GUL3+ej2Owe2w
 PW6eqL7WyFysJTQJmIAQ/ZAW9JPHhglqaXiasOZAIQH1UsBuVCRBGHvbDoWmmOK8XiE8
 rhmqXiuSlV6NDHT+nNFNkUxKpsGHM/3LJZk3t8xDubexbmqlhqwcDYRljFVwY8vof4Wk
 jChe6HXFm4c1x3BTQ/0wfqfXtXo/9o4+4mdokai+CBQ6ZzqGrrxeqQySyEuWQ92mzl2s Gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72edmx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 09 Nov 2020 18:17:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0A9IB1ih136684;
        Mon, 9 Nov 2020 18:17:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34p5bqv1ps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Nov 2020 18:17:41 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0A9IHejQ010339;
        Mon, 9 Nov 2020 18:17:40 GMT
Received: from localhost (/10.159.239.129)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 10:17:40 -0800
Subject: [PATCH 1/4] xfs: fix brainos in the refcount scrubber's rmap fragment
 processor
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Mon, 09 Nov 2020 10:17:39 -0800
Message-ID: <160494585913.772802.17231950418756379430.stgit@magnolia>
In-Reply-To: <160494585293.772802.13326482733013279072.stgit@magnolia>
References: <160494585293.772802.13326482733013279072.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011090126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011090126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix some serious WTF in the reference count scrubber's rmap fragment
processing.  The code comment says that this loop is supposed to move
all fragment records starting at or before bno onto the worklist, but
there's no obvious reason why nr (the number of items added) should
increment starting from 1, and breaking the loop when we've added the
target number seems dubious since we could have more rmap fragments that
should have been added to the worklist.

This seems to manifest in xfs/411 when adding one to the refcount field.

Fixes: dbde19da9637 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/refcount.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index beaeb6fa3119..dd672e6bbc75 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -170,7 +170,6 @@ xchk_refcountbt_process_rmap_fragments(
 	 */
 	INIT_LIST_HEAD(&worklist);
 	rbno = NULLAGBLOCK;
-	nr = 1;
 
 	/* Make sure the fragments actually /are/ in agbno order. */
 	bno = 0;
@@ -184,15 +183,14 @@ xchk_refcountbt_process_rmap_fragments(
 	 * Find all the rmaps that start at or before the refc extent,
 	 * and put them on the worklist.
 	 */
+	nr = 0;
 	list_for_each_entry_safe(frag, n, &refchk->fragments, list) {
-		if (frag->rm.rm_startblock > refchk->bno)
-			goto done;
+		if (frag->rm.rm_startblock > refchk->bno || nr > target_nr)
+			break;
 		bno = frag->rm.rm_startblock + frag->rm.rm_blockcount;
 		if (bno < rbno)
 			rbno = bno;
 		list_move_tail(&frag->list, &worklist);
-		if (nr == target_nr)
-			break;
 		nr++;
 	}
 

