Return-Path: <SRS0=b91c=A3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98479C433E1
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F1CB206F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Jul 2020 06:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qcW8UHhf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgGPGsI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 02:48:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56766 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgGPGsH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Jul 2020 02:48:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6lxWo164895
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=SK9m8OL60YPUkBsj9BoddtrstOHn0HS/dyLi2Ofmads=;
 b=qcW8UHhf3XS0CvAPx+Rv4toake9ZtaMsN11GgaymVPuKrdvOkW2leQo+hPxdDKdudB9M
 DGbpMLa0WL/LJQScC9N8Ucb2YZ2B+6l4xnsXFM0HFppX9T/yZF79JjKh5wVraP0PJ4sT
 OMI/qaz2kdTjyOGNwv5Bvn4qrYGuZJVDj8ExQ79Spj6pJp4ZYM2F1xmZemxY6uZnCiUG
 UxBawqRBChiuxWXNZKcG7s9fC93q2cI2If+658Qg5h18m/ukufWH1lYW6NA792dQqnuB
 Impgf3FLVH1tSQUb962XAhYSQWJGpAUtoTw0cnNcnbtazjsVbYbUdF0EwWx8w2+VRWDk HA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 327s65nrru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:48:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06G6hfW2061368
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:06 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0srg8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:06 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06G6k5RT007341
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2020 06:46:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 23:46:05 -0700
Subject: [PATCH 07/11] xfs: remove unnecessary quota type masking
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Jul 2020 23:46:03 -0700
Message-ID: <159488196391.3813063.17612590871057481605.stgit@magnolia>
In-Reply-To: <159488191927.3813063.6443979621452250872.stgit@magnolia>
References: <159488191927.3813063.6443979621452250872.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160050
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007160051
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

When XFS' quota functions take a parameter for the quota type, they only
care about the three quota record types (user, group, project).
Internal state flags and whatnot should never be passed by callers and
are an error.  Now that we've moved responsibility for filtering out
internal state to the callers, we can drop the masking everywhere else.

In other words, if you call a quota function, you must only pass in
XFS_DQTYPE_*.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.h |    4 ++--
 fs/xfs/xfs_qm.h    |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 07e18ce33560..81ba614439bd 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -136,7 +136,7 @@ xfs_dquot_type(const struct xfs_dquot *dqp)
 
 static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 {
-	switch (type & XFS_DQTYPE_REC_MASK) {
+	switch (type) {
 	case XFS_DQTYPE_USER:
 		return XFS_IS_UQUOTA_ON(mp);
 	case XFS_DQTYPE_GROUP:
@@ -150,7 +150,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 
 static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
-	switch (type & XFS_DQTYPE_REC_MASK) {
+	switch (type) {
 	case XFS_DQTYPE_USER:
 		return ip->i_udquot;
 	case XFS_DQTYPE_GROUP:
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index f04af35349d7..fac6fa81f1fa 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -88,7 +88,7 @@ xfs_dquot_tree(
 static inline struct xfs_inode *
 xfs_quota_inode(xfs_mount_t *mp, uint dq_flags)
 {
-	switch (dq_flags & XFS_DQTYPE_REC_MASK) {
+	switch (dq_flags) {
 	case XFS_DQTYPE_USER:
 		return mp->m_quotainfo->qi_uquotaip;
 	case XFS_DQTYPE_GROUP:

