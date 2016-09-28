Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16411 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756372AbcI1Cxt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:53:49 -0400
Subject: [PATCH 02/63] xfs: return an error when an inline directory is too
 small
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:53:43 -0700
Message-ID: <147503122305.30303.17555276635568155992.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>

If the size of an inline directory is so small that it doesn't
even cover the required header size, return an error to userspace
instead of ASSERTing and returning 0 like everything's ok.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reported-by: Jan Kara <jack@suse.cz>
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

