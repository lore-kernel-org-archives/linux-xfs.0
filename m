Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCFCD7F56
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 17:31:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 774BCAC002
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:31:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	U9vpAEnCizbH07Wh for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 15:31:15 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: add DAX truncate support
Date: Wed,  4 Mar 2015 10:30:25 +1100
Message-Id: <1425425427-16283-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1425425427-16283-1-git-send-email-david@fromorbit.com>
References: <1425425427-16283-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

From: Dave Chinner <dchinner@redhat.com>

When we truncate a DAX file, we need to call through the DAX page
truncation path rather than through block_truncate_page() so that
mappings and block zeroing are all handled correctly. Otherwise,
truncate does not need to change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 9f38142..3ff24c3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -851,7 +851,11 @@ xfs_setattr_size(
 	 * to hope that the caller sees ENOMEM and retries the truncate
 	 * operation.
 	 */
-	error = block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
+	if (IS_DAX(inode))
+		error = dax_truncate_page(inode, newsize, xfs_get_blocks_dax);
+	else
+		error = block_truncate_page(inode->i_mapping, newsize,
+					    xfs_get_blocks);
 	if (error)
 		return error;
 	truncate_setsize(inode, newsize);
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
