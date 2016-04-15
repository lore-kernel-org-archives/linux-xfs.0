Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 466CA7D48
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 05:41:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BD8B3AC003
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:41:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id jdRioIUHuBuRdxfR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:41:22 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 33/42] block: convert rq_data_dir helper to use REQ_OPs
Date: Fri, 15 Apr 2016 05:39:53 -0500
Message-Id: <1460716802-2294-34-git-send-email-mchristi@redhat.com>
In-Reply-To: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
References: <1460716802-2294-1-git-send-email-mchristi@redhat.com>
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
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

The request->op field is now always setup up with a REQ_OP.
This patch has the rq_data_dir helper convert the operation
to a WRITE or READ direction based on that.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 42711ef..5694894 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -598,7 +598,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		((int)((rq)->cmd_flags & 1))
+#define rq_data_dir(rq)		(op_is_write(rq->op) ? WRITE : READ)
 
 /*
  * Driver can handle struct request, if it either has an old style
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
