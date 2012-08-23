Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N53HNm135013 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:03:17 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UJesH3WSqVY5NSTx for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:02 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PaA-0003GC-OD
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PaA-0003dt-Jg
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 033/102] xfs: pass KM_SLEEP flag to kmem_realloc() in
Date: Thu, 23 Aug 2012 15:01:51 +1000
Message-Id: <1345698180-13612-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

Upstream commit: 4505360376637832f79f84f352588b0a045ad113
 xlog_recover_add_to_cnt_trans()

The kmem_realloc() in xfs is given KM_* memory allocation flags. And it
allocates memory using kmalloc() after they are converted to gfp_mask
flags. In xlog_recover_add_to_cont_trans(), 0u is passed to kmem_realloc(),
instead of them. I guess it is preferred to use them, and here memory must
be allocated but don't have to be done with GFP_ATOMIC. So, this patch
changes it to KM_SLEEP.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Ben Myers <bpm@sgi.com>
Cc: Alex Elder <elder@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/xfs_log_recover.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index dfd872a..eead6dd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1488,7 +1488,7 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = kmem_realloc(old_ptr, len+old_len, old_len, 0u);
+	ptr = kmem_realloc(old_ptr, len+old_len, old_len, KM_SLEEP);
 	memcpy(&ptr[old_len], dp, len); /* d, s, l */
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
