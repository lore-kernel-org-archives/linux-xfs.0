Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5837C433E2
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:04:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F1B820738
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 18:04:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ob8W1qv6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbgIGSEB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 14:04:01 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729492AbgIGSDx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 14:03:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087HxAdM012023
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=FuXl3zraW/egma2vZGGohTRJ9M9TeKUJoXDjw4V4ATw=;
 b=ob8W1qv6C7y3aZB289lATpqjKn42jO+im8+9ZOkqIO7nhYHxs1KpGTakg7tN9Y1WAlwR
 qNLZQpzCwEvlHkr3AuRtowmDKEhu5PkVO5oOIQ2RuRcsea4zOtwfj5pauDj5v7Rwtg/W
 uM/pyCz8Vgv553H/h4lm3bhoMhU+dceYEOoTdWq1EyKcsO98AEocsfBBhkw1+K/WbUoX
 Nucee5QIti/Fb7JxReZqYOOgXxSLdkY4BOEPywDyXGf2MGMcSf9HP67QUq23bp7P/tI3
 qvJRyp1o7RlDwtdBLHvZgeuhJzHGOzQRons4UrbOWR+IhfGGT7z4SFrlF2vKwNDLggZQ GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 33c23qqp8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:03:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 087I0veD049451
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:01:50 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33cmk163d3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 07 Sep 2020 18:01:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 087I1nWv024947
        for <linux-xfs@vger.kernel.org>; Mon, 7 Sep 2020 18:01:49 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 07 Sep 2020 11:01:21 -0700
Subject: [PATCH 3/3] xfs: ensure that fpunch, fcollapse,
 and finsert operations are aligned to rt extent size
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 07 Sep 2020 11:01:20 -0700
Message-ID: <159950168085.582172.4254559621934598919.stgit@magnolia>
In-Reply-To: <159950166214.582172.6124562615225976168.stgit@magnolia>
References: <159950166214.582172.6124562615225976168.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9737 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 mlxscore=0 bulkscore=0 suspectscore=3 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009070172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that any fallocate operation that requires the range to be
block-aligned also checks that the range is aligned to the realtime
extent size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 5123f82f2477..f2a8a0e75e1f 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -946,6 +946,14 @@ xfs_free_file_space(
 	startoffset_fsb = XFS_B_TO_FSB(mp, offset);
 	endoffset_fsb = XFS_B_TO_FSBT(mp, offset + len);
 
+	/* We can only free complete realtime extents. */
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
+
+		if ((startoffset_fsb | endoffset_fsb) & (extsz - 1))
+			return -EINVAL;
+	}
+
 	/*
 	 * Need to zero the stuff we're not freeing, on disk.
 	 */
@@ -1139,6 +1147,14 @@ xfs_insert_file_space(
 
 	trace_xfs_insert_file_space(ip);
 
+	/* We can only insert complete realtime extents. */
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		xfs_extlen_t	extsz = xfs_get_extsz_hint(ip);
+
+		if ((stop_fsb | shift_fsb) & (extsz - 1))
+			return -EINVAL;
+	}
+
 	error = xfs_bmap_can_insert_extents(ip, stop_fsb, shift_fsb);
 	if (error)
 		return error;

