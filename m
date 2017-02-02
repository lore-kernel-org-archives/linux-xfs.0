Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:50429 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdBBH5B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:57:01 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/19] xfs: don't wrap ID in xfs_dq_get_next_id
Date: Thu,  2 Feb 2017 08:56:04 +0100
Message-Id: <1486022171-8076-13-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Eric Sandeen <sandeen@redhat.com>

commit 657bdfb7f5e68ca5e2ed009ab473c429b0d6af85 upstream.

The GETNEXTQOTA ioctl takes whatever ID is sent in,
and looks for the next active quota for an user
equal or higher to that ID.

But if we are at the maximum ID and then ask for the "next"
one, we may wrap back to zero.  In this case, userspace
may loop forever, because it will start querying again
at zero.

We'll fix this in userspace as well, but for the kernel,
return -ENOENT if we ask for the next quota ID
past UINT_MAX so the caller knows to stop.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7a30b8f..9d06cc3 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -710,6 +710,10 @@ xfs_dq_get_next_id(
 	/* Simple advance */
 	next_id = *id + 1;
 
+	/* If we'd wrap past the max ID, stop */
+	if (next_id < *id)
+		return -ENOENT;
+
 	/* If new ID is within the current chunk, advancing it sufficed */
 	if (next_id % mp->m_quotainfo->qi_dqperchunk) {
 		*id = next_id;
-- 
2.1.4

