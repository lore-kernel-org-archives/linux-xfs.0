Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7F0CE7A97
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjIYV6b (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjIYV6a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBE2112
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE19C433C8;
        Mon, 25 Sep 2023 21:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679104;
        bh=Cc0k1s28W0D6gzx1W3/i3XwsUaArrMHHViYGtU5SL0Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KQ1PGI5+gb4UN3BbiPaQV5RjmkcvNDmMXh47B3EWVfg5MyzmeZ3cqNY/p70e9YSM+
         CihmiFkBLo1aVP7jGYXbv1xC6ClmQjCm7qRloNSvMRIhO9+Fc5LXqCPZyVAssKpLTx
         UKM0Y9PbDWwLqjgRAtkkGGVaaMJ2KGYdLEO7FaVHXahqPzt04KMj7UpQ1rdYAMBAD8
         PSd1Vb8H0awD/G7jyMbpMnPL+rQ+AcVirG00Wl5n3ITC9tdu3l8aTc5Z04dgZABK7Z
         3u/g8KNxqr4V+VnvvLOz9gp4bBEULomEqzWscySus8BAavC66iHqdGoWRu8j8ZDyq7
         2ciQnpRG78Fkw==
Subject: [PATCH 2/5] xfs: allow userspace to rebuild metadata structures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:23 -0700
Message-ID: <169567910377.2318286.9674599819125611592.stgit@frogsfrogsfrogs>
In-Reply-To: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
References: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 5c83df2e54b6af870e3e02ccd2a8ecd54e36668c

Add a new (superuser-only) flag to the online metadata repair ioctl to
force it to rebuild structures, even if they're not broken.  We will use
this to move metadata structures out of the way during a free space
defragmentation operation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_fs.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2cbf9ea39b8..6360073865d 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -743,7 +743,11 @@ struct xfs_scrub_metadata {
  */
 #define XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED (1u << 7)
 
-#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR)
+/* i: Rebuild the data structure. */
+#define XFS_SCRUB_IFLAG_FORCE_REBUILD	(1u << 8)
+
+#define XFS_SCRUB_FLAGS_IN	(XFS_SCRUB_IFLAG_REPAIR | \
+				 XFS_SCRUB_IFLAG_FORCE_REBUILD)
 #define XFS_SCRUB_FLAGS_OUT	(XFS_SCRUB_OFLAG_CORRUPT | \
 				 XFS_SCRUB_OFLAG_PREEN | \
 				 XFS_SCRUB_OFLAG_XFAIL | \

