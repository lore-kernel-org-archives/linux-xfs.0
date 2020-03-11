Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDCCC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EFDF215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pHbKIK1O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCKAri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33706 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgCKArh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0fbjc112367
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=HM8b4vz/VPTJ1phfavsAEEt/MMDBVEDF0QziwNVt0+U=;
 b=pHbKIK1O0vL39sTWk1BBp7FhPcXbWEO8Zzuxv1q/uOUO0aWemquTzC1S/6iCHe7akLC2
 vXbSf+6RRMEvXscVJ/vV9at99kuohYZRfcOt+tJoPIOVTwzT694hSEsKNwqxQO5wVb+X
 1KfD1U1cuGy5rJ7lu+FURqPb6EdcKnxCCY6zJ5bAsWQnbsgWCZOSA+gON79Y/3g7lTPQ
 LCwDfHGcN1chrU1JcUrX/TzmTwSqYg0dJfcn0SsfJlwSieXYHIT1fnwU2mndvlWlfO0W
 MsF9jant5Vgv7zovkweZVSGhXGLzjDhnpTqnxEZ7h/uVGEl6MVUogBeqWARjNRt0GIrE /g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31ugq56-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0bued013769
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yp8rnnbnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:35 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0lZHC019979
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:35 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:35 -0700
Subject: [PATCH 3/7] xfs: fix buffer corruption reporting when
 xfs_dir3_free_header_check fails
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:33 -0700
Message-ID: <158388765361.939165.18143580183240823438.stgit@magnolia>
In-Reply-To: <158388763282.939165.6485358230553665775.stgit@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=3
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_verifier_error is supposed to be called on a corrupt metadata buffer
from within a buffer verifier function, whereas xfs_buf_corruption_error
is the function to be called when a piece of code has read a buffer and
catches something that a read verifier cannot.  The first function sets
b_error anticipating that the low level buffer handling code will see
the nonzero b_error and clear XBF_DONE on the buffer, whereas the second
function does not.

Since xfs_dir3_free_header_check examines fields in the dir free block
header that require more context than can be provided to read verifiers,
we must call xfs_buf_corruption_error when it finds a problem.

Switching the calls has a secondary effect that we no longer corrupt the
buffer state by setting b_error and leaving XBF_DONE set.  When /that/
happens, we'll trip over various state assertions (most commonly the
b_error check in xfs_buf_reverify) on a subsequent attempt to read the
buffer.

Fixes: bc1a09b8e334bf5f ("xfs: refactor verifier callers to print address of failing check")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index dbd1e901da92..af4f22dc3891 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -226,7 +226,7 @@ __xfs_dir3_free_read(
 	/* Check things that we can't do in the verifier. */
 	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
 	if (fa) {
-		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);
+		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
 		return -EFSCORRUPTED;
 	}

