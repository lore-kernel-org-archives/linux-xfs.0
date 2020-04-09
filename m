Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208FDC2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 04:43:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E57C220787
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 04:43:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHukFndt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgDIEne (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 00:43:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36367 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgDIEne (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 00:43:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id n10so3562614pff.3
        for <linux-xfs@vger.kernel.org>; Wed, 08 Apr 2020 21:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LO+6bCtaEDNVoaJRR/6CaJYxukfhv/dRWIA8Km3QLNk=;
        b=FHukFndtC1ugTxuOvSm2iyY/4TQmJM9VtCmkxqHrB9IE2qKKBc3u6JmGr1qjhO8gOg
         fVEIKe8dNCjGKVRpbHYkZgDsHTnuPZHYYKxCAuZr5DN7M3COW9DkAMWIeGjEagFP0ZGq
         SE+jRNxK4MLCWmuyAQcf8mxbc4ODF38zpahawfE0u4IKKXXVh0dmOXd2uTHrl2lVE6Ir
         3qjepSLrD3scospz1iCUYTAsGt3k3i8bhM7nlq21AQOnOrUdW6htKmk476KTe2aaZb3K
         LWChe5aLp8zPPs0xtTRi08/TMZ2fQqKiyU+ArIaaA5kvY3z9Kw/bqQz5w2CvjNsV/D9X
         /x0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LO+6bCtaEDNVoaJRR/6CaJYxukfhv/dRWIA8Km3QLNk=;
        b=lvTMv6Drxc3YfRSZBVSInmCCqE8CIiyA7GKE4oOCd9+IN6XPNAQ6/xmhOtst2w6uuY
         XlNS7631vP1w0hK3yBD6GV6ibHwRWts7Jzk3+x9RD+se+h871fLmejTlkuSEImhkBmB5
         6AhApidx6OjUBeXQ2AKhdpsRXqsCUeN5JOKPYJPic1U00baH4TKmuChJtaqegZPq1rgZ
         dv5UNvxFHFFQoyBt1QPJoPZ7kuvA6cckOIS3N3noxqCsGTFHRZ/gc7KoP2UuWrK3mvSF
         i46Qs5lKJ0b6zgDr1Br0mKPma03yWjdhk67nbM6/PMWwD1zf5XL6NZCaKK47+TNASETj
         0W4g==
X-Gm-Message-State: AGi0PuZjgs5gEW+bB23CJHf0rmCt9QKQx3kUt75eqt+azIw+vJbQ+fFw
        sfbp3ub2DTq9S4UxCXp2zIKqs2g=
X-Google-Smtp-Source: APiQypKacuI/PJ+4CJs7RwvHXYIqTzL9IwziVONoV8zbK4k4PGC9triN4g/ll7//SsgHG2mclhmAlQ==
X-Received: by 2002:aa7:95ae:: with SMTP id a14mr10647419pfk.164.1586407412738;
        Wed, 08 Apr 2020 21:43:32 -0700 (PDT)
Received: from he-cluster.localdomain ([67.216.221.250])
        by smtp.gmail.com with ESMTPSA id h16sm4496700pfk.38.2020.04.08.21.43.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 21:43:32 -0700 (PDT)
From:   xiakaixu1987@gmail.com
X-Google-Original-From: kaixuxia@tencent.com
To:     linux-xfs@vger.kernel.org
Cc:     darrick.wong@oracle.com, Kaixu Xia <kaixuxia@tencent.com>
Subject: [PATCH] xfs: remove unnecessary variable udqp from xfs_ioctl_setattr
Date:   Thu,  9 Apr 2020 12:43:23 +0800
Message-Id: <1586407403-32567-1-git-send-email-kaixuxia@tencent.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

The initial value of variable udqp is NULL, and we only set the
flag XFS_QMOPT_PQUOTA in xfs_qm_vop_dqalloc() function, so only
the pdqp value is initialized and the udqp value is still NULL.
Since the udqp value is NULL in the rest part of xfs_ioctl_setattr()
function, it is meaningless and do nothing. So remove it from
xfs_ioctl_setattr().

Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
---
 fs/xfs/xfs_ioctl.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index cdfb3cd..8ff91ab2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1513,7 +1513,6 @@ struct dentry *
 	struct fsxattr		old_fa;
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
-	struct xfs_dquot	*udqp = NULL;
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
@@ -1536,7 +1535,7 @@ struct dentry *
 	if (XFS_IS_QUOTA_ON(mp)) {
 		code = xfs_qm_vop_dqalloc(ip, VFS_I(ip)->i_uid,
 				VFS_I(ip)->i_gid, fa->fsx_projid,
-				XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
+				XFS_QMOPT_PQUOTA, NULL, NULL, &pdqp);
 		if (code)
 			return code;
 	}
@@ -1560,7 +1559,7 @@ struct dentry *
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
 	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
+		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
 			goto error_trans_cancel;
@@ -1626,7 +1625,6 @@ struct dentry *
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
 	xfs_qm_dqrele(olddquot);
-	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(pdqp);
 
 	return code;
@@ -1634,7 +1632,6 @@ struct dentry *
 error_trans_cancel:
 	xfs_trans_cancel(tp);
 error_free_dquots:
-	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(pdqp);
 	return code;
 }
-- 
1.8.3.1

