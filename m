Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51680 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbeJZUi2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Oct 2018 16:38:28 -0400
Date: Fri, 26 Oct 2018 05:01:37 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs: factor data block addition from
 xfs_dir2_node_addname_int()
Message-ID: <20181026120137.GB8116@infradead.org>
References: <20181024225716.19459-1-david@fromorbit.com>
 <20181024225716.19459-3-david@fromorbit.com>
 <20181026094529.GA29302@infradead.org>
 <20181026105245.GF19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026105245.GF19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 09:52:45PM +1100, Dave Chinner wrote:
> Which causes build warnings because gcc can't work out the code flow
> if I leave it alone. And seeing as I use -Werror on the fs/xfs/
> directories, that breaks the build.
> 
> So I'd prefer to leave it like this without a transient build
> warning....

With this incremental patch I don't see any warning, and I really
can't see how it could cause any warnings:

(it is basically a revert of a tiny part of your patch).

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index df109763db39..4ab2447cd343 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1916,7 +1916,6 @@ xfs_dir2_node_addname_int(
 
 		/* setup current free block buffer */
 		free = fbp->b_addr;
-		bests = dp->d_ops->free_bests_p(free);
 
 		/* we're going to have to log the free block index later */
 		logfree = 1;
@@ -1932,9 +1931,6 @@ xfs_dir2_node_addname_int(
 					   -1, &dbp);
 		if (error)
 			return error;
-
-		/* suppress gcc maybe-used-initialised warning */
-		bests = dp->d_ops->free_bests_p(free);
 	}
 
 	/* setup for data block up now */
@@ -1972,6 +1968,7 @@ xfs_dir2_node_addname_int(
 		xfs_dir2_data_log_header(args, dbp);
 
 	/* If the freespace block entry is now wrong, update it. */
+	bests = dp->d_ops->free_bests_p(free); /* gcc is so stupid */
 	if (bests[findex] != bf[0].length) {
 		bests[findex] = bf[0].length;
 		logfree = 1;
