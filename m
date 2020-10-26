Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F8AC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B831207F7
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:35:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="vvXf55/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406891AbgJZXfT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:35:19 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:43654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406870AbgJZXfT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:35:19 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPA6j177080;
        Mon, 26 Oct 2020 23:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WfJHmdhMLOv4RZsjQZdgI83NGHF84pPhBHn0I6Idbtc=;
 b=vvXf55/9Js7wCeIdX62qbefFApJQyFHOFdlC35Pm3OaKSd5h9T0XTrz6DhA9XF5G9UnZ
 2BpB7N+8GT1jtVZCvG8dfqj+sUY9Iz7+LWOuEsUdxRyzPXmuDo2nKARY/fxTIGKidGPf
 sGWCgIzyUP4QkNku8/mpSf5EPthM+w7ozCR0wuohtzINxdI1C4xvDNG0ChO2qvvi+h19
 MILd+ZMWVWrkXkZAjLR60gtCEYYJdROcamvQ9HNY2l5j4M8cFhWlNhniZqx0VmG5tbEq
 7hhxmPlDZRjRdX01o14mZpmVJkFePFMtj9Lb/Cm09CNTvg/vcCimoFqBMZ0weYeBIpTh rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 34c9saqd4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:35:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNPGLW121087;
        Mon, 26 Oct 2020 23:35:13 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 34cx6va63r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:35:13 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNZCjf007776;
        Mon, 26 Oct 2020 23:35:12 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:35:12 -0700
Subject: [PATCH 10/26] xfs: refactor quota expiration timer modification
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 26 Oct 2020 16:35:09 -0700
Message-ID: <160375530933.881414.2110709777506459447.stgit@magnolia>
In-Reply-To: <160375524618.881414.16347303401529121282.stgit@magnolia>
References: <160375524618.881414.16347303401529121282.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260153
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260153
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Source kernel commit: 11d8a9190275855f79d62093d789e962cc7228fb

Define explicit limits on the range of quota grace period expiration
timeouts and refactor the code that modifies the timeouts into helpers
that clamp the values appropriately.  Note that we'll refactor the
default grace period timer separately.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_format.h |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 4a106b6713ad..afc068944be9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1199,6 +1199,30 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 #define XFS_DQTYPE_ANY		(XFS_DQTYPE_REC_MASK)
 
+/*
+ * XFS Quota Timers
+ * ================
+ *
+ * Traditional quota grace period expiration timers are an unsigned 32-bit
+ * seconds counter; time zero is the Unix epoch, Jan  1 00:00:01 UTC 1970.
+ * Note that an expiration value of zero means that the quota limit has not
+ * been reached, and therefore no expiration has been set.  Therefore, the
+ * ondisk min and max defined here can be used directly to constrain the incore
+ * quota expiration timestamps on a Unix system.
+ */
+
+/*
+ * Smallest possible ondisk quota expiration value with traditional timestamps.
+ * This corresponds exactly with the incore expiration Jan  1 00:00:01 UTC 1970.
+ */
+#define XFS_DQ_LEGACY_EXPIRY_MIN	((int64_t)1)
+
+/*
+ * Largest possible ondisk quota expiration value with traditional timestamps.
+ * This corresponds exactly with the incore expiration Feb  7 06:28:15 UTC 2106.
+ */
+#define XFS_DQ_LEGACY_EXPIRY_MAX	((int64_t)U32_MAX)
+
 /*
  * This is the main portion of the on-disk representation of quota information
  * for a user.  We pad this with some more expansion room to construct the on

