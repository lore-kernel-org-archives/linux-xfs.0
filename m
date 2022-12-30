Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B25C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiLaAwJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiLaAv6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:51:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86737164AF;
        Fri, 30 Dec 2022 16:51:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43C0AB81DF5;
        Sat, 31 Dec 2022 00:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BB9C433EF;
        Sat, 31 Dec 2022 00:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447915;
        bh=2XUqCDN5obPTVw6gdUTST5T79HLXXgbtO6UGKb5NSBo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OXa4LTVZPzHjFpNbS0jNBMMUdSQpFOsPioWlDYZE1+UFeBS+a2SCcfuZCd6KpLt4t
         AYQQridvj8/l4VzNQhYkiXvY9f0WlcAsuJF8kIZiOkPc2i1FOfEi4RiEgX2C258KMV
         dhc0fp0AhwbyjG46H1f0hYKZgZD7h3ZdiVHJRioJGxQO9im0E91vWv1AgnUU/W8XEy
         3mf8GMqsPUYy4BZbAXPkr6eUP8rjQEyB7xc/3t4cG4blI4QwAXNHko/m7DeeWM8sHa
         ljPxf0JBKE5QcoNZAsREnh4v9whBh94j35pUdKQ9bkO707bn7SlMKws5Y1+ZxaS3Mp
         ftSDgwWd9xl2Q==
Subject: [PATCH 1/7] xfs/122: fix for swapext log items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:48 -0800
Message-ID: <167243878834.732172.4501257239247928885.stgit@magnolia>
In-Reply-To: <167243878818.732172.6392253687008406885.stgit@magnolia>
References: <167243878818.732172.6392253687008406885.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add entries for the extent swapping log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 95e53c5081..21549db7fd 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -117,6 +117,9 @@ sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_swap_extent) = 64
+sizeof(struct xfs_sxd_log_format) = 16
+sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36

