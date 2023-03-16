Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9775C7618E
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCPThG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCPThG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D25F4E486E;
        Thu, 16 Mar 2023 12:36:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A840C620DC;
        Thu, 16 Mar 2023 19:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B34EC433D2;
        Thu, 16 Mar 2023 19:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995410;
        bh=M69KQ3mJeI96VG3yYgHfDsh7IMxTmng/euvBJAy8iMk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aehREGzh2nN1zganc90yAqKKqXKziwSIhO8TDOfi7PCbjz76gDroR+C2fbUkWp2pH
         xpcr2u9SncfDiOvZlDBR+zUrAIbQvGIgoTpMjE6qNi/XgvULa/ih8XFSW12tZLsbGe
         UblZgO/x43QeBECFLE6qKhIJ9zpbBjXY2CurP2U0V8WJ+7GhQBMS/KD478dn2hpge2
         gt5lcu/CZtQdE18S+/jNK8dAZ8xCGcL2FpoOX2WBRGDeloBXalJxcEdeXG50BzY8Ze
         Cs03aZeb2w850bYqqmAanc1IlzbyQ2TJZj0Id2AKV+tfyhXyD5oI8O9ngyI8FpDzg6
         CbRjb41lwRCEA==
Date:   Thu, 16 Mar 2023 12:36:49 -0700
Subject: [PATCH 1/1] xfs/122: fix parent pointer ioctl structure sizes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167899418149.18288.9351677296100528285.stgit@frogsfrogsfrogs>
In-Reply-To: <167899418137.18288.9076901881477991507.stgit@frogsfrogsfrogs>
References: <167899418137.18288.9076901881477991507.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We've renamed (and resized) the structures for the GETPARENTS ioctl, so
adjust the golden output here to reflect that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 0877f14bf2..da2da2089c 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -100,6 +100,8 @@ sizeof(struct xfs_fsop_ag_resblks) = 64
 sizeof(struct xfs_fsop_geom) = 256
 sizeof(struct xfs_fsop_geom_v1) = 112
 sizeof(struct xfs_fsop_geom_v4) = 112
+sizeof(struct xfs_getparents) = 96
+sizeof(struct xfs_getparents_rec) = 24
 sizeof(struct xfs_icreate_log) = 28
 sizeof(struct xfs_inode_log_format) = 56
 sizeof(struct xfs_inode_log_format_32) = 52
@@ -110,9 +112,7 @@ sizeof(struct xfs_log_dinode) = 176
 sizeof(struct xfs_log_legacy_timestamp) = 8
 sizeof(struct xfs_map_extent) = 32
 sizeof(struct xfs_parent_name_rec) = 16
-sizeof(struct xfs_parent_ptr) = 280
 sizeof(struct xfs_phys_extent) = 16
-sizeof(struct xfs_pptr_info) = 104
 sizeof(struct xfs_refcount_key) = 4
 sizeof(struct xfs_refcount_rec) = 12
 sizeof(struct xfs_rmap_key) = 20

