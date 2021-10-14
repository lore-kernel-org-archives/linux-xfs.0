Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB3A4C43217
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C753961108
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbhJNUTG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233695AbhJNUTG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C38E6611C1;
        Thu, 14 Oct 2021 20:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242620;
        bh=Lk64fhAT6t5oUCU3DAgg6U9HhNwa5dG2QKQaB78d990=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ceCl1cUWW/Pd/LllPk7V4d+8W8FkEesmaB6EG7aPLkGDkpJNrXBIbsUxFjvR0r74K
         R+elgFEHaAptXiYnv4w0tNZ55HbOxJtyvrAsFT9ZdxSDfNTGIjOjj4SfmOYBAnUSYb
         +fuYo9tqxjX/jwrJPu5tJlz0sX2O46U7hi3eK4G9N7bZvfKg2QppWxCgavNBT1NPo5
         dv70SjY2htDf2ph0rsvdeAmgAHsBXLNv1cYuJimuDEQ5FB2tnmbxwyGQBH+ITp3X+9
         gCUQOROVn5WRKFutV+JDWVj2lQe/IyeDF2TTPXHuHpOwMasEhDxguamlLziWnwFURd
         wspTPr5kVZ2eQ==
Subject: [PATCH 01/17] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:00 -0700
Message-ID: <163424262046.756780.2366797746965376855.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

During review of subsequent patches, Dave and I noticed that this
function doesn't work quite right -- accessing cur->bc_ino depends on
the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
because block 0 of an AG is never part of a btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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
 

