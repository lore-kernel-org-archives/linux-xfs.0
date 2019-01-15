Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55768 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390500AbfAOVfC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Jan 2019 16:35:02 -0500
Date: Tue, 15 Jan 2019 13:34:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: use generic fillattr to reduce redundant code
Message-ID: <20190115213432.GA12609@infradead.org>
References: <20190115170849.GC12689@magnolia>
 <20190115211306.GA12570@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115211306.GA12570@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org

On Tue, Jan 15, 2019 at 01:13:06PM -0800, Christoph Hellwig wrote:
> On Tue, Jan 15, 2019 at 09:08:49AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Refactor xfs_vn_getattr to use generic_fillattr to fill out parts of the
> > kstat structure instead of open-coding the same pieces.  This eliminates
> > redundant code and fixes a bug where we fail to set the AUTOMOUNT
> > attribute.  Obviously, we retain all the xfs-specific parts.
> 
> I find the idea of writing the same values twice for something like
> stat that is pretty performane critical rather odd.
> 
> I'd much rather just fix the XFS version up to set the automount
> attribute, and clear STATX_ATIME for noatime inodes.

Actually, the proper fix is to move these checks to what actually
is common code, something like this:

--
>From 3f82b9fce150a8af6b98bae686bbd24cbe3388ab Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 15 Jan 2019 22:31:50 +0100
Subject: fs: move generic stat response attr handling to vfs_getattr_nosec

generic_fillattr is an optional helper that isn't used by all
filesystems, move handling purely based on inode flags to
vfs_getattr_nosec, which is common code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/stat.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index adbfcd86c81b..9600ff1ea8df 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -45,11 +45,6 @@ void generic_fillattr(struct inode *inode, struct kstat *stat)
 	stat->ctime = inode->i_ctime;
 	stat->blksize = i_blocksize(inode);
 	stat->blocks = inode->i_blocks;
-
-	if (IS_NOATIME(inode))
-		stat->result_mask &= ~STATX_ATIME;
-	if (IS_AUTOMOUNT(inode))
-		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 }
 EXPORT_SYMBOL(generic_fillattr);
 
@@ -75,11 +70,19 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	stat->result_mask |= STATX_BASIC_STATS;
 	request_mask &= STATX_ALL;
 	query_flags &= KSTAT_QUERY_FLAGS;
-	if (inode->i_op->getattr)
-		return inode->i_op->getattr(path, stat, request_mask,
-					    query_flags);
+	if (inode->i_op->getattr) {
+		int ret = inode->i_op->getattr(path, stat, request_mask,
+				query_flags);
+		if (ret)
+			return ret;
+	} else {
+		generic_fillattr(inode, stat);
+	}
 
-	generic_fillattr(inode, stat);
+	if (IS_NOATIME(inode))
+		stat->result_mask &= ~STATX_ATIME;
+	if (IS_AUTOMOUNT(inode))
+		stat->attributes |= STATX_ATTR_AUTOMOUNT;
 	return 0;
 }
 EXPORT_SYMBOL(vfs_getattr_nosec);
-- 
2.20.1
