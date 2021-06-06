Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFDAC47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4963E6139A
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhFFR4C (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhFFR4B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1836139A;
        Sun,  6 Jun 2021 17:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002051;
        bh=hHkTLLNaaovZxIWWULcwhSDsdFDSwPKH5SluN+ZB5+c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nnrIIKjI1jDx9Fvk+2MHFthYs8NjgDgq9dgce7k39bO9U6Jp9R1CMlzmmmM2ff0YS
         G8ILRWDWf9cWXp3pLAJ/Hz6Lhr6Ja6/2MHlYByqELAKkIvSDNN9vKwkGUdQQRA5ru5
         6GjE+xp+GSUl/Y3XfVQb8cX3LZCmzf5hV05gvhZ6Ny5E9JaJC8f8kkZawG41p3XprE
         iQu0FRFd1gsJHnmInRZ0dMgan04Nu54vXZ3JFRW9B6AlmFq4uTdAUi0GHxh+9dACFT
         kb3j/ENAZG1xOeuMkE6fLBWxnjzvPai3+sXx8NwT1Y4smNGyTs1k0A2aeyxYMO/8jh
         rn+DlwpH7KVDQ==
Subject: [PATCH 1/3] xfs: only reset incore inode health state flags when
 reclaiming an inode
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 06 Jun 2021 10:54:11 -0700
Message-ID: <162300205146.1202529.12989228054689182888.stgit@locust>
In-Reply-To: <162300204472.1202529.17352653046483745148.stgit@locust>
References: <162300204472.1202529.17352653046483745148.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While running some fuzz tests on inode metadata, I noticed that the
filesystem health report (as provided by xfs_spaceman) failed to report
the file corruption even when spaceman was run immediately after running
xfs_scrub to detect the corruption.  That isn't the intended behavior;
one ought to be able to run scrub to detect errors in the ondisk
metadata and be able to access to those reports for some time after the
scrub.

After running the same sequence through an instrumented kernel, I
discovered the reason why -- scrub igets the file, scans it, marks it
sick, and ireleases the inode.  When the VFS lets go of the incore
inode, it moves to RECLAIMABLE state.  If spaceman igets the incore
inode before it moves to RECLAIM state, iget reinitializes the VFS
state, clears the sick and checked masks, and hands back the inode.  At
this point, the caller has the exact same incore inode, but with all the
health state erased.

In other words, we're erasing the incore inode's health state flags when
we've decided NOT to sever the link between the incore inode and the
ondisk inode.  This is wrong, so we need to remove the lines that zero
the fields from xfs_iget_cache_hit.

As a precaution, we add the same lines into xfs_reclaim_inode just after
we sever the link between incore and ondisk inode.  Strictly speaking
this isn't necessary because once an inode has gone through reclaim it
must go through xfs_inode_alloc (which also zeroes the state) and
xfs_iget is careful to check for mismatches between the inode it pulls
out of the radix tree and the one it wants.

Fixes: 6772c1f11206 ("xfs: track metadata health status")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 396cc54ca03f..c3f912a9231b 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -523,9 +523,6 @@ xfs_iget_cache_hit(
 				XFS_INO_TO_AGINO(pag->pag_mount, ino),
 				XFS_ICI_RECLAIM_TAG);
 		inode->i_state = I_NEW;
-		ip->i_sick = 0;
-		ip->i_checked = 0;
-
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
 	} else {
@@ -979,6 +976,8 @@ xfs_reclaim_inode(
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
 	ip->i_ino = 0;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);

