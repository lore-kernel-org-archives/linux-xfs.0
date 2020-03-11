Return-Path: <SRS0=qEB5=44=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D373C10DCE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41FA6215A4
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Mar 2020 00:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lYFx0oOO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCKAr4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Mar 2020 20:47:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33918 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgCKAr4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Mar 2020 20:47:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0fbQC112443
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iMaPewhGgTeHFWeK5pug2oXQZ0+dTthizSxtljoQDRo=;
 b=lYFx0oOOuXT1G90l6NShaP/k0k2FiqL21J6sK8JsLQ4VAK0txe2I2UaFjivIRl92SGU/
 z87sJBMReo00r4fQBnJPxS+2poMIPz4/MOpYI838NPeJ+kd9ngRV0/R8i8vWAF/QuSAr
 0xvLw7uDbjMiiUpSJWu6cf84iABiWcLThiRJygAWpvUEo8lsctiDa9TP/DckwVRnEKjk
 bt2aP6p1QrLmZ0omNacq+cI6NLDnXAkul7mrM9FHfx1XF6Q+aYtRJ/nzrG92o4af4SKI
 sVduo7gY2C1ZJJvtlVtWl3FjZ9yVRQU0oN/mEv5Yhz5Jt4e33aCaYi0+8b8g4hLXiRl2 iA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2ym31ugq5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02B0lp9F029446
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2yp8rnnc7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:54 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02B0lsKS014582
        for <linux-xfs@vger.kernel.org>; Wed, 11 Mar 2020 00:47:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 17:47:53 -0700
Subject: [PATCH 6/7] xfs: check owner of dir3 data blocks
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 10 Mar 2020 17:47:52 -0700
Message-ID: <158388767279.939165.8430173747192985972.stgit@magnolia>
In-Reply-To: <158388763282.939165.6485358230553665775.stgit@magnolia>
References: <158388763282.939165.6485358230553665775.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110001
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003110000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Check the owner field of dir3 data block headers.  If it's corrupt,
release the buffer and return EFSCORRUPTED.  All callers handle this
properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index b9eba8213180..8de9611387e5 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -394,6 +394,22 @@ static const struct xfs_buf_ops xfs_dir3_data_reada_buf_ops = {
 	.verify_write = xfs_dir3_data_write_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_data_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->hdr.owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
 
 int
 xfs_dir3_data_read(
@@ -403,11 +419,24 @@ xfs_dir3_data_read(
 	unsigned int		flags,
 	struct xfs_buf		**bpp)
 {
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, bno, flags, bpp, XFS_DATA_FORK,
 			&xfs_dir3_data_buf_ops);
-	if (!err && tp && *bpp)
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_data_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	if (tp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }

