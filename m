Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF049C2D0DE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C48F8206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:05:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RPh9SbUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbgAABFR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:05:17 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:46582 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727131AbgAABFR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:05:17 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115GhC089304
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=7qJWFs/m/4R2x60tjDQiH7zmPpuo98xJqLVhixsHCjg=;
 b=RPh9SbUiQVewb3cFMTlymxyoYrjBHk9YFh3dK7gEyNTWGion6XFM0MW7UpULTOrjzNbT
 p4lSPQGKEcty0AWJKY0tgI+diaCo5HpghFRqOW1srhJ+2EvicBACNHsoyBMLPO/aJ8Yo
 WeLRGD+mvj8DGVr51OYOdzmuzOnaacRf+1J8LgKRDzM1EGuNVL2crD6GnzUE52AYHxfn
 VWJ/S4TmYn7KCMT8Y9/IRnpUUFD7P2SNDxgMf0K4TvUxNhwlypvYEq6lYjpVv0uvfrwM
 BxJcw2CBDgYNXjLpdIof+386fIk3laatki1cgJBI0QNwJSZk47F2b5RRVvzt31R3fH9Z NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqjw7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:15 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00115Fud165849
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:05:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2x8gj912s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:05:14 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 001146VO024284
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:04:06 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:04:06 -0800
Subject: [PATCH 3/6] xfs: remove unnecessary inode-transaction roll
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:04:04 -0800
Message-ID: <157784064395.1358958.15190927920240007676.stgit@magnolia>
In-Reply-To: <157784062523.1358958.17318700801044648140.stgit@magnolia>
References: <157784062523.1358958.17318700801044648140.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010008
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010008
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Remove the transaction roll at the end of the loop in
xfs_itruncate_extents_flags.  xfs_defer_finish takes care of rolling the
transaction as needed and reattaching the inode, which means we already
start each loop with a clean transaction.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |    4 ----
 1 file changed, 4 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 12eeeea4df16..c6986517074e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1565,10 +1565,6 @@ xfs_itruncate_extents_flags(
 		error = xfs_defer_finish(&tp);
 		if (error)
 			goto out;
-
-		error = xfs_trans_roll_inode(&tp, ip);
-		if (error)
-			goto out;
 	}
 
 	if (whichfork == XFS_DATA_FORK) {

