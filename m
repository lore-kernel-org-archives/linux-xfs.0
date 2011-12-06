Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6LL8RX001020 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:21:08 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A1A4B162F5A5
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:21:06 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	YhXZzTrcWNqoI8R5 for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:21:06 -0800 (PST)
Date: Tue, 6 Dec 2011 16:21:05 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: validate acl count
Message-ID: <20111206212105.GA28459@infradead.org>
References: <20111206212056.GA24640@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111206212056.GA24640@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

commit fa8b18edd752a8b4e9d1ee2cd615b82c93cf8bba upstream.

This prevents in-memory corruption and possible panics if the on-disk
ACL is badly corrupted.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_acl.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_acl.c b/fs/xfs/linux-2.6/xfs_acl.c
index 39f4f80..4b9fb91 100644
--- a/fs/xfs/linux-2.6/xfs_acl.c
+++ b/fs/xfs/linux-2.6/xfs_acl.c
@@ -42,6 +42,8 @@ xfs_acl_from_disk(struct xfs_acl *aclp)
 	int count, i;
 
 	count = be32_to_cpu(aclp->acl_cnt);
+	if (count > XFS_ACL_MAX_ENTRIES)
+		return ERR_PTR(-EFSCORRUPTED);
 
 	acl = posix_acl_alloc(count, GFP_KERNEL);
 	if (!acl)
-- 
1.7.7.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
