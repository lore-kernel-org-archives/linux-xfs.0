Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EC2C433E0
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973F764E23
	for <linux-xfs@archiver.kernel.org>; Sat, 13 Feb 2021 05:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhBMFe5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 13 Feb 2021 00:34:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230458AbhBMFe4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 13 Feb 2021 00:34:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C329364E9D;
        Sat, 13 Feb 2021 05:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613194441;
        bh=/IORSqdy+Ox8dFWvtPo45m+ddaFqcKeIwkSWZfD/B8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pVWBgjIYogRRxZjKThRfUFTHEoiHm0XqWQP3YU4sMXAeudVpKMUggw71LJj4oWDDj
         pgmFM+eQN/g/Do7ZbQSPkQO9kTzvxqA+caG3X16uRfGLJCkt0iua9q5BsiiRUDxvcT
         BgYnJU+SX9IBeMyb6EH5ggjcjcPBjsZVS+Znd6DZK68waGDzkYoITNqn88kBNUnqic
         gJKNAX4DV/kb6W0RK5GuQg5+W2qpQ9Ngw2Z4SOkfwljs5NEV/nf2T7tTQZhu8n6Y9S
         X/n4fe4xjH1X/S87ezIzTYIn534GcJpWKDddLDarvKEmjVk7zKhh52c/Sic9JkL3Yn
         c68FTosnUBlWQ==
Subject: [PATCH 2/4] xfs/122: add legacy timestamps to ondisk checker
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-xfs@vger.kernel.org
Date:   Fri, 12 Feb 2021 21:34:01 -0800
Message-ID: <161319444151.403615.11040645637561952151.stgit@magnolia>
In-Reply-To: <161319443045.403615.18346950431837086632.stgit@magnolia>
References: <161319443045.403615.18346950431837086632.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add these new ondisk structures.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/xfs/122     |    1 +
 tests/xfs/122.out |    1 +
 2 files changed, 2 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index 322e1d81..c8593315 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -181,6 +181,7 @@ struct xfs_iext_cursor
 struct xfs_ino_geometry
 struct xfs_attrlist
 struct xfs_attrlist_ent
+struct xfs_legacy_ictimestamp
 EOF
 
 echo 'int main(int argc, char *argv[]) {' >>$cprog
diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index b0773756..f229465a 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -97,6 +97,7 @@ sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
 sizeof(struct xfs_inumbers) = 24
 sizeof(struct xfs_inumbers_req) = 64
+sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_phys_extent) = 16

