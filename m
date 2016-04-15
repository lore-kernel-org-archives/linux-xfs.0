Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3523E7CA0
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 05:40:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE3F2304059
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:40:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id De7SnsZdhpxqj7OS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2016 03:40:45 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 17/42] ocfs2: set bi_op to REQ_OP
Date: Fri, 15 Apr 2016 05:39:37 -0500
Message-Id: <1460716802-2294-18-git-send-email-mchristi@redhat.com>
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

This patch has ocfs2 use bio->bi_op for REQ_OPs and rq_flag_bits
to bio->bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/ocfs2/cluster/heartbeat.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index e37373d..0619a20 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -530,7 +530,8 @@ static void o2hb_bio_end_io(struct bio *bio)
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
 				      unsigned int *current_slot,
-				      unsigned int max_slots, int rw)
+				      unsigned int max_slots, int op,
+				      int op_flags)
 {
 	int len, current_page;
 	unsigned int vec_len, vec_start;
@@ -556,7 +557,8 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
-	bio->bi_rw = rw;
+	bio->bi_op = op;
+	bio->bi_rw = op_flags;
 
 	vec_start = (cs << bits) % PAGE_SIZE;
 	while(cs < max_slots) {
@@ -593,7 +595,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 
 	while(current_slot < max_slots) {
 		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
-					 READ);
+					 REQ_OP_READ, 0);
 		if (IS_ERR(bio)) {
 			status = PTR_ERR(bio);
 			mlog_errno(status);
@@ -625,7 +627,8 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, WRITE_SYNC);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, REQ_OP_WRITE,
+				 WRITE_SYNC);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
