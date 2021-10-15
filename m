Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEAFC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0786108B
	for <linux-xfs@archiver.kernel.org>; Fri, 15 Oct 2021 00:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhJOAoJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 20:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233814AbhJOAoJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:44:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D33C610A0;
        Fri, 15 Oct 2021 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634258523;
        bh=SwmHLtiWBsInS37q9Eii4jsAcx9X4JoZKegxlVpE/h8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L/2aCfgAjgB6vX1olUbUbF5nYgsqDH6McpOeC1n5WZW9X8tuCyQRJGwnfyyK5m61w
         YgXurIu/oSbxvBJAOfDVTvCZ9uXGAdKiwFzobLwrDyyTeehS88n35czeJa98iEpZT/
         7ASd82gBfb7uR7opZzPMl/AGO7mc011Xb0xOW38Bcbq3lrzsQ2Sg6uDIh5BScIlZCG
         A2QS5aWvTQb3O1U0mJsHUCl9bhPjT8glx9qpIj4ug3Vto/wIxK481ys18ezLwO8no9
         eVfy1dPxX+FId4OhT31yuX3GAzcHj7S0L+LuYgSC5mt0bB6bK9mbDJJf5QwpYh7k2v
         ykaXWCnPNRSkA==
Date:   Thu, 14 Oct 2021 17:42:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: [PATCH v4.1 01/17] xfs: fix incorrect decoding in
 xchk_btree_cur_fsbno
Message-ID: <20211015004203.GO24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424262046.756780.2366797746965376855.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424262046.756780.2366797746965376855.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During review of subsequent patches, Dave and I noticed that this
function doesn't work quite right -- accessing cur->bc_ino depends on
the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
because block 0 of an AG is never part of a btree.

Note: This changes the btree scrubber tracepoints behavior -- if the
cursor has no buffer for a certain level, it will always report
NULLFSBLOCK.  It is assumed that anyone tracing the online fsck code
will also be tracing xchk_start/xchk_done or otherwise be aware of what
exactly is being scrubbed.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v4.1: note the new behavior in the commit message
---
 fs/xfs/scrub/trace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index c0ef53fe6611..93c13763c15e 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
 	if (level < cur->bc_nlevels && cur->bc_bufs[level])
 		return XFS_DADDR_TO_FSB(cur->bc_mp,
 				xfs_buf_daddr(cur->bc_bufs[level]));
-	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
+
+	if (level == cur->bc_nlevels - 1 &&
+	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
 		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
-	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
-		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
+
 	return NULLFSBLOCK;
 }
 
