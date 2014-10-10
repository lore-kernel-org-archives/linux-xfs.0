Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3FCE47F47
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2ED5E304053
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:12 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id L4clYAO2OaW9yxuN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:11 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] block: Make rq_affinity = 1 work as expected
Date: Fri, 10 Oct 2014 16:23:09 +0200
Message-Id: <1412951028-4085-5-git-send-email-jack@suse.cz>
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
Cc: Roland Dreier <roland@purestorage.com>, Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Christoph Hellwig <hch@infradead.org>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Jens Axboe <jaxboe@fusionio.com>, Joel Becker <jlbec@evilplan.org>, Tao Ma <boyu.mt@taobao.com>, Dan Williams <dan.j.williams@intel.com>, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Tao Ma <boyu.mt@taobao.com>

Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
the request completed in the __make_request cpu. But it makes the
old rq_affinity = 1 not work any more. The root cause is that
if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
ccpu will be the same as group_cpu, so the completion will be
excuted in the 'cpu' not 'group_cpu'.

This patch fix problem by simpling removing group_cpu and the codes
are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
we raise_blk_irq to ccpu.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Reviewed-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-softirq.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 475fab809a80..487addc85bb5 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -103,7 +103,7 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu, group_cpu = NR_CPUS;
+	int ccpu, cpu;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
@@ -117,14 +117,12 @@ void __blk_complete_request(struct request *req)
 	 */
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
 			ccpu = blk_cpu_to_group(ccpu);
-			group_cpu = blk_cpu_to_group(cpu);
-		}
 	} else
 		ccpu = cpu;
 
-	if (ccpu == cpu || ccpu == group_cpu) {
+	if (ccpu == cpu) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
