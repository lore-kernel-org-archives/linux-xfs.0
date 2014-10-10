Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DF3707F5D
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C550E304070
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id zjZgILgKkuXVRpb7 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] scsi: Keep interrupts disabled while submitting requests
Date: Fri, 10 Oct 2014 16:23:33 +0200
Message-Id: <1412951028-4085-29-git-send-email-jack@suse.cz>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

scsi_request_fn() can be called from softirq context during IO
completion. If it enables interrupts there, HW interrupts can interrupt
softirq processing and queue more IO completion work which can
eventually lead to softlockup reports because IO completion softirq runs
for too long. Keep interrupts disabled in scsi_request_fn().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/scsi_lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e316368c99..44b867e9adc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1481,7 +1481,8 @@ static void scsi_softirq_done(struct request *rq)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: IO request lock assumed to be held when called, interrupts
+ * must be disabled.
  */
 static void scsi_request_fn(struct request_queue *q)
 	__releases(q->queue_lock)
@@ -1563,7 +1564,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
 		 *		take the lock again.
 		 */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock(shost->host_lock);
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1575,7 +1576,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Dispatch the command to the low-level driver.
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
-		spin_lock_irq(q->queue_lock);
+		spin_lock(q->queue_lock);
 		if (rtn)
 			goto out_delay;
 	}
@@ -1583,7 +1584,7 @@ static void scsi_request_fn(struct request_queue *q)
 	return;
 
  not_ready:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock(shost->host_lock);
 
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
@@ -1593,7 +1594,7 @@ static void scsi_request_fn(struct request_queue *q)
 	 * cases (host limits or settings) should run the queue at some
 	 * later time.
 	 */
-	spin_lock_irq(q->queue_lock);
+	spin_lock(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 out_delay:
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
