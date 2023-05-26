Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66666C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234501AbjEZCCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjEZCCj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E89A3;
        Thu, 25 May 2023 19:02:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B8E64C4C;
        Fri, 26 May 2023 02:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE471C433EF;
        Fri, 26 May 2023 02:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066557;
        bh=M/6Dya24VqVWqWcNd/upkKp9opJZ4q0M0/xVZ8L7TwQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Fmmux+iBN2sKcTcDEYzHOxaGaWFAsO9cXFFiREL92mhVXpP/O2bxkMBmiT/lJdeDv
         1U/sIgBanROVJXrdlaX8XsKJd9LSKs4+BGKxntxLXSuCZezJ2hBEKQCbek93WukLdj
         oSa8odFOQe3GJSa48E/nSUzIgN9BtvW1e0nlGXPeSZmoNhCy0e3987S316Rn614FpG
         KyUuP4+BjDBUiVW68vqfci95dF47Munel4dVHU/CjcbUbzJWLB4MdTaSfSdZW74Qig
         HvoRiTFvjhhUyc/ZDeiIPtUp+URrDem2XL82GQHouK1qMagUB6Lk+v1JE4e5wj6MkG
         8NAJq4jT+4c4g==
Date:   Thu, 25 May 2023 19:02:37 -0700
Subject: [PATCH 02/11] xfs/122: update for parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        allison.henderson@oracle.com, catherine.hoang@oracle.com
Message-ID: <168506060875.3732476.5529675243629156281.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
References: <168506060845.3732476.15364197106064737675.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update test for parent pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 89f7b735b0..55138218dd 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -98,6 +98,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 96
+sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -107,6 +109,7 @@ sizeof(struct xfs_legacy_timestamp) = 8
 sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
+sizeof(struct xfs_parent_name_rec) = 16
 sizeof(struct xfs_phys_extent) = 16
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12

