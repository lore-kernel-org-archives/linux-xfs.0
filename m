Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C20BC38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjARA5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbjARA4U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:56:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12BA23866;
        Tue, 17 Jan 2023 16:43:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 354BF61598;
        Wed, 18 Jan 2023 00:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906CEC433EF;
        Wed, 18 Jan 2023 00:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002627;
        bh=9vBhundcjxebuDTFUoqhwePYoyxQpEzlbOMHy1gxztk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=krnjwUQQ8nVS9nMU+6FiLkMc3uqnzD8KsrF9nKjObSGc/ssFgse+c84U4pnGq0TGN
         YAoTjln0UgjZEK+nPxotQJH4nmJLy1xKHSpIzhW80HGVaOGoswC8NBMwtokYalAqEs
         bAI3jo16LyCc64OuXj3tuwx575c6qwgYJ93+t8d4867fWmniOZeASya6WJ0BA54cMi
         ZDHgVVyQMkCGnIkKgj+rk55zpxlRR+PrkAVHLPJjGCRvLMebtQAUqrCNfUUeLw7b8W
         O1nHcdAfQJdQKHogyr0gAq1nGWqa2Q2Fl0OQqXunyoEjyZC9KHJFvNh4AT36qqW7nP
         fkGcEKAozB/qQ==
Date:   Tue, 17 Jan 2023 16:43:47 -0800
Subject: [PATCH 1/4] populate: ensure btree directories are created reliably
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, david@fromorbit.com
Message-ID: <167400103057.1915094.778206076529720127.stgit@magnolia>
In-Reply-To: <167400103044.1915094.5935980986164675922.stgit@magnolia>
References: <167400103044.1915094.5935980986164675922.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The population function creates an XFS btree format directory by
polling the extent count of the inode and creating new dirents until
the extent count goes over the limit that pushes it into btree
format.

It then removes every second dirent to create empty space in the
directory data to ensure that operations like metadump with
obfuscation can check that they don't leak stale data from deleted
dirents.

Whilst this does not result in directory data blocks being freed, it
does not take into account the fact that the dabtree index has half
the entries removed from it and that can result in btree nodes
merging and extents being freed. This causes the extent count to go
down, and the inode is converted back into extent form. The
population checks then fail because it should be in btree form.

Fix this by counting the number of directory data extents rather than
the total number of extents in the data fork. We can do this simply
by using xfs_bmap and counting the number of extents returned as it
does not report extents beyond EOF (which is where the dabtree is
located). As the number of data blocks does not change with the
dirent removal algorithm used, this will ensure that the inode data
fork remains in btree format.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: make this patch first in line]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/common/populate b/common/populate
index 44b4af1667..84f4b8e374 100644
--- a/common/populate
+++ b/common/populate
@@ -89,9 +89,12 @@ __populate_xfs_create_btree_dir() {
 		local creat=mkdir
 		test "$((nr % 20))" -eq 0 && creat=touch
 		$creat "${name}/$(printf "%.08d" "$nr")"
+		# Extent count checks use data blocks only to avoid the removal
+		# step from removing dabtree index blocks and reducing the
+		# number of extents below the required threshold.
 		if [ "$((nr % 40))" -eq 0 ]; then
-			local nextents="$(_xfs_get_fsxattr nextents $name)"
-			[ $nextents -gt $max_nextents ] && break
+			local nextents="$(xfs_bmap ${name} | grep -v hole | wc -l)"
+			[ "$((nextents - 1))" -gt $max_nextents ] && break
 		fi
 		nr=$((nr+1))
 	done

