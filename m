Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6932AC4708C
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 05:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F5CC613DA
	for <linux-xfs@archiver.kernel.org>; Fri, 28 May 2021 05:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhE1F5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 May 2021 01:57:15 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2444 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhE1F5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 May 2021 01:57:15 -0400
Received: from dggeml718-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Frv3d3xqvz66ql;
        Fri, 28 May 2021 13:52:45 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggeml718-chm.china.huawei.com (10.3.17.129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 28 May 2021 13:55:38 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 28 May 2021 13:55:38 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: sort variable alphabetically to avoid repeated declaration
Date:   Fri, 28 May 2021 13:55:28 +0800
Message-ID: <1622181328-9852-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Variable 'xfs_agf_buf_ops', 'xfs_agi_buf_ops', 'xfs_dquot_buf_ops' and
'xfs_symlink_buf_ops' are declared twice, so sort these variables
alphabetically and remove the repeated declaration.

Cc: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 fs/xfs/libxfs/xfs_shared.h | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 782fdd08f759..25c4cab58851 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -22,30 +22,26 @@ struct xfs_inode;
  * Buffer verifier operations are widely used, including userspace tools
  */
 extern const struct xfs_buf_ops xfs_agf_buf_ops;
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
-extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
-extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
-extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
-extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
+extern const struct xfs_buf_ops xfs_agi_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
+extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
+extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
 extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
 extern const struct xfs_buf_ops xfs_dquot_buf_ops;
-extern const struct xfs_buf_ops xfs_symlink_buf_ops;
-extern const struct xfs_buf_ops xfs_agi_buf_ops;
-extern const struct xfs_buf_ops xfs_inobt_buf_ops;
+extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_finobt_buf_ops;
+extern const struct xfs_buf_ops xfs_inobt_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
-extern const struct xfs_buf_ops xfs_dquot_buf_ops;
-extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
+extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
-extern const struct xfs_buf_ops xfs_rtbuf_ops;
 
 /* log size calculation functions */
 int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
-- 
2.7.4

