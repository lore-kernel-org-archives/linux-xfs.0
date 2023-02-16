Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 795E0C6379F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBPUi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:38:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBPUi5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:38:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36422028
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:38:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB5E460C1E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F44EC433EF;
        Thu, 16 Feb 2023 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579935;
        bh=t1fiih6oG55Rxkca+9y7YyKSEIU7dqt4ykdlDhgH5zY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tL6jvHgJLpZjScdSsAMal4MIK0mhRYMowdB/vS7oxAHMrolOh7/SYLHzkpUe/RX59
         HUttSapg3IIIhpFcq8C804MyA9ZSpumbhNR1nUb3Rui6LVsTXTauwuITBg8CUBT1h9
         uG05+gjyZHffmWd5TIhktv7ubJHzZNtw7Y1hgPZSNVw7MA8HR1qN7rGV5eVMPthUSD
         3KXtLOU51r0W/ZP8Oq2rGwrJSKmg4syw2i3JY0SaRd5fuGdVltiQMiU/DJkZIUNSNi
         h8UMwOlVNcK8biTeXEjpWqRU1r7EbYdRk9Sv/zMK9C+VxZltTH3P2P2yE0pzU3rAXL
         gn0CfKHTUY4Uw==
Date:   Thu, 16 Feb 2023 12:38:54 -0800
Subject: [PATCH 24/28] xfs: Filter XFS_ATTR_PARENT for getfattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872730.3473407.10774924524532838927.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_xattr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 8bb5f53a31fe..ddc2db5d6f73 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -234,6 +234,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

