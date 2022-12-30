Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60445C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiLaDXi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbiLaDXQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:23:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6F612A91
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2DEB81E72
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444D7C433EF;
        Sat, 31 Dec 2022 03:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456993;
        bh=zCHdghJRa9K1y39/R6qkELcMJeb3gZRbO4QXFg8nNzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JbQJXyy5RRYbw/FsOJqePJnvrjitVQFJTWOJCvRiCvVm9wXE7p6rGXJb8I5QyrGvn
         BZ8ZosCkN5fTfx0V361aQ646VuSbBIVjTkFIHHZ3wqLMg3flNSZaBrTGkzbaLdU4ta
         M9qdGuP4eO5e7I/gm5Fu+WUuvRowgZ/Iq2FSPw1+XT1cAQofRIiwDbjmYqOs1dxtEm
         SOXXGtr69aBH9UuZ0qbaFZwwo0/orA6kO81ygiSQLOLl75Z1AyBfvkncdb5fMzhinJ
         +q+V0W5peObaByiJ81IIQ/rqpUNeFjSILp4F0zLycG/qxqOjrqhzq/kVRxdEJBjv7c
         RJ01yrj0zkm/g==
Subject: [PATCH 3/3] xfs: Don't free EOF blocks on close when extent size
 hints are set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:20 -0800
Message-ID: <167243876065.726374.4890051106492069344.stgit@magnolia>
In-Reply-To: <167243876021.726374.15071907725836376245.stgit@magnolia>
References: <167243876021.726374.15071907725836376245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

When we have a workload that does open/write/close on files with
extent size hints set in parallel with other allocation, the file
becomes rapidly fragmented. This is due to close() calling
xfs_release() and removing the preallocated extent beyond EOF.  This
occurs for both buffered and direct writes that append to files with
extent size hints.

The existing open/write/close hueristic in xfs_release() does not
catch this as writes to files using extent size hints do not use
delayed allocation and hence do not leave delayed allocation blocks
allocated on the inode that can be detected in xfs_release(). Hence
XFS_IDIRTY_RELEASE never gets set.

In xfs_file_release(), we can tell whether the inode has extent size
hints set and skip EOF block truncation. We add this check to
xfs_can_free_eofblocks() so that we treat the post-EOF preallocated
extent like intentional preallocation and so are persistent unless
directly removed by userspace.

Before:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 1002
/mnt/scratch/file.1: 1002
/mnt/scratch/file.2: 1002
/mnt/scratch/file.3: 1002
/mnt/scratch/file.4: 1002
/mnt/scratch/file.5: 1002
/mnt/scratch/file.6: 1002
/mnt/scratch/file.7: 1002

After:

Test 2: Extent size hint fragmentation counts

/mnt/scratch/file.0: 4
/mnt/scratch/file.1: 4
/mnt/scratch/file.2: 4
/mnt/scratch/file.3: 4
/mnt/scratch/file.4: 4
/mnt/scratch/file.5: 4
/mnt/scratch/file.6: 4
/mnt/scratch/file.7: 4

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index a54ed26e1cc0..558951710404 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -710,12 +710,15 @@ xfs_can_free_eofblocks(
 		return false;
 
 	/*
-	 * Do not free real preallocated or append-only files unless the file
-	 * has delalloc blocks and we are forced to remove them.
+	 * Do not free extent size hints, real preallocated or append-only files
+	 * unless the file has delalloc blocks and we are forced to remove
+	 * them.
 	 */
-	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (xfs_get_extsz_hint(ip) ||
+	    (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))) {
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
+	}
 
 	/*
 	 * Do not try to free post-EOF blocks if EOF is beyond the end of the

