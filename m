Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5207A7CA0
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C9202AC003
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 67A5tv3z6fw8qbog (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:47 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 06/45] dm: use op_is_write instead of checking for REQ_WRITE
Date: Sun,  5 Jun 2016 14:31:46 -0500
Message-Id: <1465155145-10812-7-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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

We currently set REQ_WRITE/WRITE for all non READ IOs
like discard, flush, writesame, etc. In the next patches where we
no longer set up the op as a bitmap, we will not be able to
detect a operation direction like writesame by testing if REQ_WRITE is
set.

This has dm use the op_is_write helper which will do the right
thing.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/md/dm-io.c     | 4 ++--
 drivers/md/dm-kcopyd.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 50f17e3..26e9a85 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -409,7 +409,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	struct io *io;
 	struct sync_io sio;
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && !op_is_write(rw)) {
 		WARN_ON(1);
 		return -EIO;
 	}
@@ -442,7 +442,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 {
 	struct io *io;
 
-	if (num_regions > 1 && (rw & RW_MASK) != WRITE) {
+	if (num_regions > 1 && !op_is_write(rw)) {
 		WARN_ON(1);
 		fn(1, context);
 		return -EIO;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 1452ed9..9f390e4 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -465,7 +465,7 @@ static void complete_io(unsigned long error, void *context)
 	io_job_finish(kc->throttle);
 
 	if (error) {
-		if (job->rw & WRITE)
+		if (op_is_write(job->rw))
 			job->write_err |= error;
 		else
 			job->read_err = 1;
@@ -477,7 +477,7 @@ static void complete_io(unsigned long error, void *context)
 		}
 	}
 
-	if (job->rw & WRITE)
+	if (op_is_write(job->rw))
 		push(&kc->complete_jobs, job);
 
 	else {
@@ -550,7 +550,7 @@ static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
 
 		if (r < 0) {
 			/* error this rogue job */
-			if (job->rw & WRITE)
+			if (op_is_write(job->rw))
 				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
