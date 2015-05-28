Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F3447F4E
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 18:46:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F7048F8066
	for <xfs@oss.sgi.com>; Thu, 28 May 2015 16:46:12 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	776bNFlKCFemAajF for <xfs@oss.sgi.com>;
	Thu, 28 May 2015 16:46:10 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Yy7Uy-0006ct-Aw
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Yy7Uy-00024f-A2
	for xfs@oss.sgi.com; Fri, 29 May 2015 09:46:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfs: add DAX truncate support
Date: Fri, 29 May 2015 09:45:53 +1000
Message-Id: <1432856755-7859-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1432856755-7859-1-git-send-email-david@fromorbit.com>
References: <1432856755-7859-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

When we truncate a DAX file, we need to call through the DAX page
truncation path rather than through block_truncate_page() so that
mappings and block zeroing are all handled correctly. Otherwise,
truncate does not need to change.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iops.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f4cd720..0994f95 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -851,7 +851,11 @@ xfs_setattr_size(
 	 * to hope that the caller sees ENOMEM and retries the truncate
 	 * operation.
 	 */
-	error = block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
+	if (IS_DAX(inode))
+		error = dax_truncate_page(inode, newsize, xfs_get_blocks_direct);
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
