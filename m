Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48112 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932259AbcI3DGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:06:08 -0400
Subject: [PATCH 03/63] xfs: return an error when an inline directory is too
 small
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:05:54 -0700
Message-ID: <147520475445.29434.16504877508037387435.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>

If the size of an inline directory is so small that it doesn't
even cover the required header size, return an error to userspace
instead of ASSERTing and returning 0 like everything's ok.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dir2_readdir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index f44f799..2981698 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -84,7 +84,8 @@ xfs_dir2_sf_getdents(
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
+	if (dp->i_d.di_size < xfs_dir2_sf_hdr_size(sfp->i8count))
+		return -EFSCORRUPTED;
 
 	/*
 	 * If the block number in the offset is out of range, we're done.

