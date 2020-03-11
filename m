Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0589C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF7B4215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="w+60YZVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgCKAtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:49:14 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35156 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAtO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:49:14 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0mcKe028338
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=46EEkUwsWDCriuw6JSnqIs2Dm2VRwQTf9gqzKtyLSuM=;
 b=w+60YZVSeyL4dYH2a5MMMYQtSjCYvWsVo1c5BLxfJf5v0WmbD1UPkGD9jZbO8lBuz0pk
 UxbBDnUbGXlkibmw/ovPxbn2DYS293/szm6ogMeQSsTRR3rRbE4KEq3svJ32EQZ3yTle
 /vdr2i5zWWpkSPGGVETrFvPyq51mevyzeiJ7EG1/noS2WelzrE9DpBNuURCOI8fIjaIF
 iPoS/PiEjfezZIAlLH191xbbe9i+rA1jYOMyKG6x8L6hce/HFTD0ZMwJ000CRPPS+72V
 bId8pZl5MVUGiV8Zkv5rd4t6NX3GPpK2XHOICZUDkXHfbqZsji1wrLZv4iid7mnCKtck 5g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2ym31ugq90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:49:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0bT4M039770
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:12 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2yp8qrrnxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:12 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0lBY1019856
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:11 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:11 -0700
Subject: [PATCH 2/2] xfs: fix xfs_rmap_has_other_keys usage of ECANCELED
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:10 -0700
Message-ID: <158388763048.939081.7269460615856522299.stgit@magnolia>
In-Reply-To: <158388761806.939081.5340701470247161779.stgit@magnolia>
References: <158388761806.939081.5340701470247161779.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=1 bulkscore=0 spamscore=0 mlxlogscore=948
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=996 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In e7ee96dfb8c26, we converted all ITER_ABORT users to use ECANCELED
instead, but we forgot to teach xfs_rmap_has_other_keys not to return
that magic value to callers.  Fix it now.

Fixes: e7ee96dfb8c26 ("xfs: remove all *_ITER_ABORT values")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ff9412f113c4..dae1a2bf28eb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2694,7 +2694,6 @@ struct xfs_rmap_key_state {
 	uint64_t			owner;
 	uint64_t			offset;
 	unsigned int			flags;
-	bool				has_rmap;
 };
 
 /* For each rmap given, figure out if it doesn't match the key we want. */
@@ -2709,7 +2708,6 @@ xfs_rmap_has_other_keys_helper(
 	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
 	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
 		return 0;
-	rks->has_rmap = true;
 	return -ECANCELED;
 }
 
@@ -2731,7 +2729,7 @@ xfs_rmap_has_other_keys(
 	int				error;
 
 	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
-	rks.has_rmap = false;
+	*has_rmap = false;
 
 	low.rm_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
@@ -2739,11 +2737,12 @@ xfs_rmap_has_other_keys(
 
 	error = xfs_rmap_query_range(cur, &low, &high,
 			xfs_rmap_has_other_keys_helper, &rks);
-	if (error < 0)
-		return error;
+	if (error == -ECANCELED) {
+		*has_rmap = true;
+		return 0;
+	}
 
-	*has_rmap = rks.has_rmap;
-	return 0;
+	return error;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {

