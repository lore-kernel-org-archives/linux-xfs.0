Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67D917F5D
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2AC118F8065
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:09 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FkmHruFLKUtr9D57 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] block: improve rq_affinity placement
Date: Fri, 10 Oct 2014 16:23:08 +0200
Message-Id: <1412951028-4085-4-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, Jens Axboe <jaxboe@fusionio.com>, Shaohua Li <shaohua.li@intel.com>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Shaohua Li <shaohua.li@intel.com>

This patch reverts commit 35ae66e0a09ab70ed(block: Make rq_affinity = 1
work as expected). The purpose is to avoid an unnecessary IPI.
Let's take an example. My test box has cpu 0-7, one socket. Say request is
added from CPU 1, blk_complete_request() occurs at CPU 7. Without the reverted
patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU
0, and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
CPU 7 have no difference from cache sharing point view and we can avoid an
ipi if doing it in CPU 7.
An immediate concern is this is just like QUEUE_FLAG_SAME_FORCE, but actually
not. blk_complete_request() is running in interrupt handler, and currently
I/O controller doesn't support multiple interrupts (I checked several LSI
cards and AHCI), so only one CPU can run blk_complete_request(). This is
still quite different as QUEUE_FLAG_SAME_FORCE.
Since only one CPU runs softirq, the only difference with below patch is
softirq not always runs at the first CPU of a group.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-softirq.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 487addc85bb5..58340d0cb23a 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -103,7 +103,7 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu;
+	int ccpu, cpu, group_cpu = NR_CPUS;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
@@ -117,12 +117,22 @@ void __blk_complete_request(struct request *req)
 	 */
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
 			ccpu = blk_cpu_to_group(ccpu);
+			group_cpu = blk_cpu_to_group(cpu);
+		}
 	} else
 		ccpu = cpu;
 
-	if (ccpu == cpu) {
+	/*
+	 * If current CPU and requested CPU are in the same group, running
+	 * softirq in current CPU. One might concern this is just like
+	 * QUEUE_FLAG_SAME_FORCE, but actually not. blk_complete_request() is
+	 * running in interrupt handler, and currently I/O controller doesn't
+	 * support multiple interrupts, so current CPU is unique actually. This
+	 * avoids IPI sending from current CPU to the first CPU of a group.
+	 */
+	if (ccpu == cpu || ccpu == group_cpu) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
