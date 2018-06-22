Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754260AbeFVVWj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Jun 2018 17:22:39 -0400
Date: Fri, 22 Jun 2018 14:22:22 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 6/8] xfs: fix uninitialized field in rtbitmap fsmap backend
Message-ID: <20180622212222.GU4838@magnolia>
References: <152960586416.26246.8634761888260524091.stgit@magnolia>
 <152960590105.26246.13020311829179912536.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152960590105.26246.13020311829179912536.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Allison Henderson <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

Initialize the extent count field of the high key so that when we use
the high key to synthesize an 'unknown owner' record (i.e. used space
record) at the end of the queried range we have a field with which to
compute rm_blockcount.  This is not strictly necessary because the
synthesizer never uses the rm_blockcount field, but we can shut up the
static code analysis anyway.

Coverity-id: 1437358
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
v2: init both structs to zero
---
 fs/xfs/xfs_fsmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index c34fa9c342f2..c7157bc48bd1 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -513,8 +513,8 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info)
 {
-	struct xfs_rtalloc_rec		alow;
-	struct xfs_rtalloc_rec		ahigh;
+	struct xfs_rtalloc_rec		alow = { 0 };
+	struct xfs_rtalloc_rec		ahigh = { 0 };
 	int				error;
 
 	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
