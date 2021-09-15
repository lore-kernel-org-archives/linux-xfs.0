Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20A8BC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033E9610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhIOXLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232888AbhIOXLy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:11:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56C10610E8;
        Wed, 15 Sep 2021 23:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747435;
        bh=wI5NOQqDr/a9u2k8c1TlkHeGPTOlggG0kBb2PDGDXkw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EhHTaY1nt4xev7yA9PoUh5Cx75LErh4iaFazqQEQT8TAaYLFIPN79vbjhh345KqmV
         ZC0iYGbAlCPrgEVSMJJUJvMPEYl5w1ZWPpknbULJZQnWmsrmEhgI2nE/iRik6sNg9n
         8hdSMsCd/dgdC6UfSaQYRFl/35cgyE8Om4M6XCnbgDHXoSVk8+5Iba9DgnwBx22Ar7
         LlAHORRAGzDzDtBmJLXVB5Pp4oUN5A9s3pmOVKFpwkgJkQkMV1nA9lmYsgNrRLlIrt
         uZK0jex1AxbKzm3aaqkNCPlDg/46BweR6+PpHIffLqFVl/mm7JQgAYNHw7WG1EgJc9
         iqJ+Ch9dIavEg==
Subject: [PATCH 44/61] xfs: sort variable alphabetically to avoid repeated
 declaration
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:10:35 -0700
Message-ID: <163174743509.350433.11653570779896775901.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

Source kernel commit: 5f7fd75086203a8a4dd3e518976e52bcf24e8b22

Variable 'xfs_agf_buf_ops', 'xfs_agi_buf_ops', 'xfs_dquot_buf_ops' and
'xfs_symlink_buf_ops' are declared twice, so sort these variables
alphabetically and remove the repeated declaration.

Cc: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_shared.h |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 782fdd08..25c4cab5 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
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

