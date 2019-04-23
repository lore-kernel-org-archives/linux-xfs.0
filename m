Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:42910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfDWPtj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Apr 2019 11:49:39 -0400
Date: Tue, 23 Apr 2019 08:49:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: assert that we don't enter agfl freeing with a
 non-permanent transaction
Message-ID: <20190423154927.GI4676@magnolia>
References: <20190423150709.GG4676@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423150709.GG4676@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>

From: Brian Foster <bfoster@redhat.com>

Block allocation requires a permanent transaction for deferred AGFL
frees.  Add an assert in the block allocation path to make explicit and
obvious to future callers the requirement of a transaction with a
permanent reservation.

Reported-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: split this out from the previous patch per hch request]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 857a53e58b94..a9ff3cf82cce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2243,6 +2243,9 @@ xfs_alloc_fix_freelist(
 	xfs_extlen_t		need;	/* total blocks needed in freelist */
 	int			error = 0;
 
+	/* deferred ops (AGFL block frees) require permanent transactions */
+	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
+
 	if (!pag->pagf_init) {
 		error = xfs_alloc_read_agf(mp, tp, args->agno, flags, &agbp);
 		if (error)
