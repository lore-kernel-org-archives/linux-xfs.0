Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA710C77B78
	for <linux-xfs@archiver.kernel.org>; Wed,  3 May 2023 15:15:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjECPPT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 May 2023 11:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjECPPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 May 2023 11:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A35449B
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 08:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3B6F6116D
        for <linux-xfs@vger.kernel.org>; Wed,  3 May 2023 15:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DA5C433D2;
        Wed,  3 May 2023 15:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683126916;
        bh=mB9DF3PNjwR538dbIZMTYN0XMKgwB4OuTtHkODHc/30=;
        h=Date:From:To:Cc:Subject:From;
        b=HQU2q27InKzS4alGjdesfqfqMG+ElFkAZAHF3y1G4VfQ7vASoxZ+qIbs5JzEy2+97
         ljCf/4cpai27BWNWJf6L4TeDiNbAxNpG/94ak0ju2yXyWFIYDPW6fygf4xktJY4F96
         eeCCtixDxpjjrf244FORh+UoASjva4GkCJoU1eOFmfi49b69GvTIUqGGyVQBI9UwRx
         yMb/3Yi/gjt89SYtrk8kUdasS0g2SFIuy67gzT1s4KaH6JUkorZ2tOKAXaXtx7Qz+E
         ej1eadBNKY29CiNkBY8FATXjEOk3VnzqBaJWHEfyIgK5qoYE7oh9ImZX0X8rArMnD1
         jYLWPuCY6gWjQ==
Date:   Wed, 3 May 2023 08:15:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs_repair: dont leak buffer when discarding directories
Message-ID: <20230503151515.GD15394@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Commit 1f7c7553489c tried to reduce the memory requirements of phase 6
of repair by redesigning longform_dir2_entry_check without the bplist
array.  Unfortunately, none of us noticed that the code that rejects a
dir block with a bad header now leaks the xfs_buf object because we no
longer have a bplist to drop the buffer references.  Any time we hold a
buffer and decide to move on in the dabno loop, we must release the
buffer.

The immediate result of this error is that dir_binval complains about
the recursive lock count of the buffer when we blow out the directory.
However, if the block is reallocated by another thread, repair will
deadlock when it tries to get the buffer and cannot take the buffer
lock.

Found via xfs/113 fuzzing data format directory blocks.  For whatever
reason this happens much more frequently when su=128k,sw=4, but this
applies to everyone equally.

While we're at it, make the relse at the bottom of the function run for
any remaining buffer reference, even if this isn't a block format
directory to avoid leaving a landmine in case we ever add a "goto
fix" inside the loop for a non-block directory.

Fixes: 1f7c7553489 ("repair: don't duplicate names in phase 6")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index 0be2c9c9705..48bf57359c5 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -2332,6 +2332,9 @@ longform_dir2_entry_check(
 				fixit++;
 				if (isblock)
 					goto out_fix;
+
+				libxfs_buf_relse(bp);
+				bp = NULL;
 				continue;
 			}
 		}
@@ -2343,6 +2346,7 @@ longform_dir2_entry_check(
 			break;
 
 		libxfs_buf_relse(bp);
+		bp = NULL;
 	}
 	fixit |= (*num_illegal != 0) || dir2_is_badino(ino) || *need_dot;
 
@@ -2370,7 +2374,7 @@ longform_dir2_entry_check(
 		}
 	}
 out_fix:
-	if (isblock && bp)
+	if (bp)
 		libxfs_buf_relse(bp);
 
 	if (!no_modify && (fixit || dotdot_update)) {
