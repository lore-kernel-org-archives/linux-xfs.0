Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8211BC10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43B1C215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cbl/Nrgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgCKArw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:52 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47106 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgCKArw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:52 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0dw0C086320
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=0cZIAgTvXgcxfQVG7LtcfUwggltOtpG7aValmS0utvw=;
 b=cbl/Nrgun6UpZp/5KBYDPCyav+eIhLctHCk3qUf6mcq360KttsJjRvI9Zmam0WLUZm/B
 kX1XgtFwZ/yGp7NSft2K4A15A5P7ifblJ0Kdt9Uo0bLp3LGe46FnfEEKMKgOxdOWxeHS
 fHKsVVwj0U8aDrUue15LyRENO22R//UF5qCo3s+9b1a8PXJ9Dvj9fDUTi9giR1XsUEVI
 2+IUqj6CcGgxYuYFQO/aETv3bLVNGEj6igu0ClX0ix2BmiR6MbUN0eqC1Dj9QLT+LNfa
 SlPfw7artQ8m5CjCqjxjKyPrsV9zDlCmMwe0600LA8DQd42s2YU5+Sbcymbq2xTaMWUD 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2yp9v63scm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0lo5p029400
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2yp8rnnbus-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:49 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02B0lfre010010
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:41 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:41 -0700
Subject: [PATCH 4/7] xfs: don't ever return a stale pointer from
 __xfs_dir3_free_read
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:40 -0700
Message-ID: <158388766026.939165.7051247687487788235.stgit@magnolia>
In-Reply-To: <158388763282.939165.6485358230553665775.stgit@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=885 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 mlxlogscore=949
 phishscore=0 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If we decide that a directory free block is corrupt, we must take care
not to leak a buffer pointer to the caller.  After xfs_trans_brelse
returns, the buffer can be freed or reused, which means that we have to
set *bpp back to NULL.

Callers are supposed to notice the nonzero return value and not use the
buffer pointer, but we should code more defensively, even if all current
callers handle this situation correctly.

Fixes: de14c5f541e7 ("xfs: verify free block header fields")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index af4f22dc3891..bbd478ec75c9 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -228,6 +228,7 @@ __xfs_dir3_free_read(
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
 		return -EFSCORRUPTED;
 	}
 

