Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49638 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdBBSkj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 13:40:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 33/51] xfs: bump up reserved blocks in xfs_alloc_set_aside
Date: Thu,  2 Feb 2017 19:37:52 +0100
Message-Id: <20170202183346.841381169@linuxfoundation.org>
In-Reply-To: <20170202183345.067336143@linuxfoundation.org>
References: <20170202183345.067336143@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 5149fd327f16e393c1d04fa5325ab072c32472bf upstream.

Setting aside 4 blocks globally for bmbt splits isn't all that useful,
as different threads can allocate space in parallel.  Bump it to 4
blocks per AG to allow each thread that is currently doing an
allocation to dip into it separately.  Without that we may no have
enough reserved blocks if there are enough parallel transactions
in an almost out space file system that all run into bmap btree
splits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -95,10 +95,7 @@ unsigned int
 xfs_alloc_set_aside(
 	struct xfs_mount	*mp)
 {
-	unsigned int		blocks;
-
-	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
-	return blocks;
+	return mp->m_sb.sb_agcount * (XFS_ALLOC_AGFL_RESERVE + 4);
 }
 
 /*


