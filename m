Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2CBA47F5A
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 09:24:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B2BD8F8059
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 07:24:08 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id gYDP3qBUvkOiYaHB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 07:24:04 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH] block: free q->flush_rq in blk_init_allocated_queue error
	paths
Date: Fri, 10 Oct 2014 16:23:07 +0200
Message-Id: <1412951028-4085-3-git-send-email-jack@suse.cz>
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, tytso@mit.edu, Jeff Mahoney <jeffm@suse.de>, Jens Axboe <axboe@fb.com>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Dave Jones <davej@fedoraproject.org>, Joel Becker <jlbec@evilplan.org>, Dave Jones <davej@redhat.com>, linux-ext4@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

From: Dave Jones <davej@redhat.com>

Commit 7982e90c3a57 ("block: fix q->flush_rq NULL pointer crash on
dm-mpath flush") moved an allocation to blk_init_allocated_queue(), but
neglected to free that allocation on the error paths that follow.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 block/blk-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4cd5ffc18442..bfe16d5af9f9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -713,7 +713,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 		return NULL;
 
 	if (blk_init_rl(&q->root_rl, q, GFP_KERNEL))
-		return NULL;
+		goto fail;
 
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
@@ -737,12 +737,16 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	/* init elevator */
 	if (elevator_init(q, NULL)) {
 		mutex_unlock(&q->sysfs_lock);
-		return NULL;
+		goto fail;
 	}
 
 	mutex_unlock(&q->sysfs_lock);
 
 	return q;
+
+fail:
+	kfree(q->flush_rq);
+	return NULL;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
 
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
