Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771FFC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 539EF206C3
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 04:27:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0g8SvGYx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgFBE1e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 00:27:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgFBE1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 00:27:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524Hx20106701;
        Tue, 2 Jun 2020 04:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/nEsDqDYvYENSn3sz7xvuLZEtUCONJrtI+ab408CbgI=;
 b=0g8SvGYxmef3Zdx2BKierTtB+oTrvo4zVAXO6QKwQdedry3OKGhn9P6i1cz/xp5+UFSo
 59zTfFc8MTuqEfSUuTYVpqNJQqpll0C7DuXhIQj+elUdm/KJ/Kq0LymC4xTuRkzwKOyS
 rROVrms4vyuiV6R560EUE6kgk/K6Bcm+pu7WFcCyttmVEEWK9RJPwq1QELYvuwy4ZGij
 6x5Ps6G3N9zx4AFyGrq7+1dLwhjO93E+WZxtdvHQeTnLiX4JM0MsXMWqpd8yDMTr6hXB
 H/0LnFKJcKXcWpxhRgoubuoBzvtCgrs83kVSYkjV/htoMzQhYHUdyNZPf8JVj3XaXtzE UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31bewqswkq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 02 Jun 2020 04:27:28 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0524HuWd126564;
        Tue, 2 Jun 2020 04:27:27 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31c25mnka5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Jun 2020 04:27:27 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0524RQua021649;
        Tue, 2 Jun 2020 04:27:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 21:27:26 -0700
Subject: [PATCH 05/12] xfs_repair: inject lost blocks back into the fs no
 matter the owner
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 01 Jun 2020 21:27:24 -0700
Message-ID: <159107204483.315004.966896847007086323.stgit@magnolia>
In-Reply-To: <159107201290.315004.4447998785149331259.stgit@magnolia>
References: <159107201290.315004.4447998785149331259.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=2 spamscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006020024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=2 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006020024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In repair phase 5, inject_lost_blocks takes the blocks that we allocated
but didn't use for constructing the new AG btrees and puts them back in
the filesystem by adding them to the free space.  The only btree that
can overestimate like that are the free space btrees, but in principle,
any of the btrees can do that.  If the others did, the rmap record owner
for those blocks won't necessarily be OWNER_AG, and if it isn't, repair
will fail.

Get rid of this logic bomb so that we can use it for /any/ block count
overestimation, and then we can use it to clean up after all
reconstruction of any btree type.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/phase5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/repair/phase5.c b/repair/phase5.c
index 44a6bda8..75c480fd 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2516,8 +2516,8 @@ inject_lost_blocks(
 		if (error)
 			goto out_cancel;
 
-		error = -libxfs_free_extent(tp, *fsb, 1, &XFS_RMAP_OINFO_AG,
-					    XFS_AG_RESV_NONE);
+		error = -libxfs_free_extent(tp, *fsb, 1,
+				&XFS_RMAP_OINFO_ANY_OWNER, XFS_AG_RESV_NONE);
 		if (error)
 			goto out_cancel;
 

