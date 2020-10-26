Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2462FC2D0A3
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:23:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8555207DE
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758181;
	bh=ACYIHEfNgVHqI+C07BuMcJ2NoOu80l8jDu2L0GJUl8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RZHd5TFZq1i5bYA5uX/GcfENoNtAWR/VqLyw8FwMRthQlsWaFR3/d4iHMJKz2nDtL
	 BzlA4iGn+PzegBFzKY+MjMnNz4uEfANstE+wXfCbUlxC/4tako653JbCGRAqenHVJf
	 KxkbDjApm+h7sLxtXfLjH/DqKwOlwN/bYwFxrOrI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391327AbgJ0AXA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:23:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410920AbgJZXzg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:55:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7CE720B1F;
        Mon, 26 Oct 2020 23:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756535;
        bh=ACYIHEfNgVHqI+C07BuMcJ2NoOu80l8jDu2L0GJUl8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vP9bmmzaIXQVFae2r+ZqnN3htfRm0m15CkTgB+spwd0GxPq6eKwGjAgDR8Ym6+RAL
         ORIvyPH2iMe6go+MsUdV//7fTpbdYUFJmU/hJ+wBgzeQxcmT8InSUSIztDMlWGiUY0
         Zj3RWwxGR2d52vVKksG/mVcBEXeGY6Bvv+4F78Cc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/80] xfs: fix realtime bitmap/summary file truncation when growing rt volume
Date:   Mon, 26 Oct 2020 19:54:11 -0400
Message-Id: <20201026235516.1025100-15-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

[ Upstream commit f4c32e87de7d66074d5612567c5eac7325024428 ]

The realtime bitmap and summary files are regular files that are hidden
away from the directory tree.  Since they're regular files, inode
inactivation will try to purge what it thinks are speculative
preallocations beyond the incore size of the file.  Unfortunately,
xfs_growfs_rt forgets to update the incore size when it resizes the
inodes, with the result that inactivating the rt inodes at unmount time
will cause their contents to be truncated.

Fix this by updating the incore size when we change the ondisk size as
part of updating the superblock.  Note that we don't do this when we're
allocating blocks to the rt inodes because we actually want those blocks
to get purged if the growfs fails.

This fixes corruption complaints from the online rtsummary checker when
running xfs/233.  Since that test requires rmap, one can also trigger
this by growing an rt volume, cycling the mount, and creating rt files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4a48a8c75b4f7..23ada3b3ea96c 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1010,10 +1010,13 @@ xfs_growfs_rt(
 		xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, mp->m_rbmip, XFS_ILOCK_EXCL);
 		/*
-		 * Update the bitmap inode's size.
+		 * Update the bitmap inode's size ondisk and incore.  We need
+		 * to update the incore size so that inode inactivation won't
+		 * punch what it thinks are "posteof" blocks.
 		 */
 		mp->m_rbmip->i_d.di_size =
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
+		i_size_write(VFS_I(mp->m_rbmip), mp->m_rbmip->i_d.di_size);
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 		/*
 		 * Get the summary inode into the transaction.
@@ -1021,9 +1024,12 @@ xfs_growfs_rt(
 		xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, mp->m_rsumip, XFS_ILOCK_EXCL);
 		/*
-		 * Update the summary inode's size.
+		 * Update the summary inode's size.  We need to update the
+		 * incore size so that inode inactivation won't punch what it
+		 * thinks are "posteof" blocks.
 		 */
 		mp->m_rsumip->i_d.di_size = nmp->m_rsumsize;
+		i_size_write(VFS_I(mp->m_rsumip), mp->m_rsumip->i_d.di_size);
 		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
 		/*
 		 * Copy summary data from old to new sizes.
-- 
2.25.1

