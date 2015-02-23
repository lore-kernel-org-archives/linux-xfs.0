Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD62F7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 04:26:43 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8F4D9304032
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 02:26:40 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id hDeMVyWgS0HM96jo (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 02:26:35 -0800 (PST)
Date: Mon, 23 Feb 2015 11:26:33 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150223102633.GC24272@dhcp22.suse.cz>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard> <20150221032000.GC7922@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150221032000.GC7922@thunk.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, hannes@cmpxchg.org, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

On Fri 20-02-15 22:20:00, Theodore Ts'o wrote:
[...]
> So based on akpm's sage advise and wisdom, I added back GFP_NOFAIL to
> ext4/jbd2.

I am currently going through opencoded GFP_NOFAIL allocations and have
this in my local branch currently. I assume you did the same so I will
drop mine if you have pushed yours already.
---
>From dc49cef75dbd677d5542c9e5bd27bbfab9a7bc3a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Fri, 20 Feb 2015 11:32:58 +0100
Subject: [PATCH] jbd2: revert must-not-fail allocation loops back to
 GFP_NOFAIL

This basically reverts 47def82672b3 (jbd2: Remove __GFP_NOFAIL from jbd2
layer). The deprecation of __GFP_NOFAIL was a bad choice because it led
to open coding the endless loop around the allocator rather than
removing the dependency on the non failing allocation. So the
deprecation was a clear failure and the reality tells us that
__GFP_NOFAIL is not even close to go away.

It is still true that __GFP_NOFAIL allocations are generally discouraged
and new uses should be evaluated and an alternative (pre-allocations or
reservations) should be considered but it doesn't make any sense to lie
the allocator about the requirements. Allocator can take steps to help
making a progress if it knows the requirements.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 fs/jbd2/journal.c     | 11 +----------
 fs/jbd2/transaction.c | 20 +++++++-------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 1df94fabe4eb..878ed3e761f0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -371,16 +371,7 @@ int jbd2_journal_write_metadata_buffer(transaction_t *transaction,
 	 */
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
-retry_alloc:
-	new_bh = alloc_buffer_head(GFP_NOFS);
-	if (!new_bh) {
-		/*
-		 * Failure is not an option, but __GFP_NOFAIL is going
-		 * away; so we retry ourselves here.
-		 */
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-		goto retry_alloc;
-	}
+	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
 
 	/* keep subsequent assertions sane */
 	atomic_set(&new_bh->b_count, 1);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 5f09370c90a8..dac4523fa142 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -278,22 +278,16 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
+		/*
+		 * If __GFP_FS is not present, then we may be being called from
+		 * inside the fs writeback layer, so we MUST NOT fail.
+		 */
+		if ((gfp_mask & __GFP_FS) == 0)
+			gfp_mask |= __GFP_NOFAIL;
 		new_transaction = kmem_cache_zalloc(transaction_cache,
 						    gfp_mask);
-		if (!new_transaction) {
-			/*
-			 * If __GFP_FS is not present, then we may be
-			 * being called from inside the fs writeback
-			 * layer, so we MUST NOT fail.  Since
-			 * __GFP_NOFAIL is going away, we will arrange
-			 * to retry the allocation ourselves.
-			 */
-			if ((gfp_mask & __GFP_FS) == 0) {
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
-				goto alloc_transaction;
-			}
+		if (!new_transaction)
 			return -ENOMEM;
-		}
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
-- 
2.1.4

-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
