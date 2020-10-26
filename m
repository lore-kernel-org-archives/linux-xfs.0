Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B68AC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04D9020882
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 00:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758568;
	bh=G5u/P+M9cxw0aGemHQX2PaHhw/C9NPpD6hKT9YDESVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qq63nIRXHM836dcyYOoNKkbW8uOFPf6C/fnOsAJDhZyJx2yYdwWeDDfQtzdTSKzXH
	 OZwQAzsTuoHAmRzKYIXlszyjkzu0ovAWPzwa3unwitj6/gBscdGz6epXkUZhFsMz5T
	 sxs1yPJd3c8SnIjqPEGSpuR2PPROrsyBuQnuMOBM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409793AbgJZXwh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:55288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409784AbgJZXwh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:52:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEB3821BE5;
        Mon, 26 Oct 2020 23:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756356;
        bh=G5u/P+M9cxw0aGemHQX2PaHhw/C9NPpD6hKT9YDESVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnkXOkq8joN6xKtav+M56YWrSkvW53UMl9TK2H09tbZfNyTH0BeBDDZjsmCx9wpAq
         teHlRWtnxll2edcnTjGXhfzRDcyOZsKSsPX5N95TbKZ7VkZp4EOrP21cAzDsPhsxY/
         ewqcHiHp1v4iGdS9u0ERM8dtw3XZWr7j6h0/ooi0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 026/132] xfs: fix realtime bitmap/summary file truncation when growing rt volume
Date:   Mon, 26 Oct 2020 19:50:18 -0400
Message-Id: <20201026235205.1023962-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
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
index 48be55b18c494..3ecbf859d3522 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1016,10 +1016,13 @@ xfs_growfs_rt(
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
@@ -1027,9 +1030,12 @@ xfs_growfs_rt(
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

