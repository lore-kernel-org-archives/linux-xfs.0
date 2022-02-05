Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96705C433F5
	for <linux-xfs@archiver.kernel.org>; Sat,  5 Feb 2022 02:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbiBEC4z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Feb 2022 21:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238321AbiBEC4y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Feb 2022 21:56:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5E5C061346
        for <linux-xfs@vger.kernel.org>; Fri,  4 Feb 2022 18:56:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E548060C45
        for <linux-xfs@vger.kernel.org>; Sat,  5 Feb 2022 02:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B08AC004E1
        for <linux-xfs@vger.kernel.org>; Sat,  5 Feb 2022 02:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644029813;
        bh=7BuaQP9n9qrpRhlWfKQWYI9vdM0jhaz4tr0FWuRcmMc=;
        h=Date:From:To:Subject:From;
        b=ItxvDH91qNP+ukTuXmKBwVX4ZT2RoQj6MCaxvSmRVe/J8odc5QQbP03NQHM9cI/Hu
         cVf5epOLxeBxHaSLszaWaoyMB/gbW2GMHCcQMS01G/gVVLlP+mqqZ9wtH6iKOJezoN
         kd2rQd98ituj20MHcR718eFTIqpHOkVlA/WfJdbq5d8RCbdGJRrWXxgafAzHlvgdP+
         bDCP7GGCcCquHwgNmLdYiancwqAJmqXwgD+AvjYyIh3rfeFpihZ27o+9qSVHCiG7Bn
         g7XxOclWFrGsVOrMKb4AALp5JMabcCCFGvy7jOs9OOjMYxVL+qS5t+Nrkj1s9MukHN
         oHuHBPgxzJVBQ==
Date:   Fri, 4 Feb 2022 18:56:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: return error from sync_filesystem during remount
Message-ID: <20220205025652.GY8313@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

In xfs_fs_reconfigure, check the return value from sync_filesystem and
fail the remount if there was an internal error.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4c0dee78b2f8..5f3781879c63 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1831,7 +1831,9 @@ xfs_fs_reconfigure(
 	if (error)
 		return error;
 
-	sync_filesystem(mp->m_super);
+	error = sync_filesystem(mp->m_super);
+	if (error)
+		return error;
 
 	/* inode32 -> inode64 */
 	if (xfs_has_small_inums(mp) && !xfs_has_small_inums(new_mp)) {
