Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BB38C7F47
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 06:00:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A759D304062
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 04:00:25 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id ix7uyPeMZD5E5Dkg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Feb 2015 04:00:23 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard> <20150221032000.GC7922@thunk.org>
In-Reply-To: <20150221032000.GC7922@thunk.org>
Message-Id: <201502212100.IBG78151.QLHSOMJFVOtFFO@I-love.SAKURA.ne.jp>
Date: Sat, 21 Feb 2015 21:00:05 +0900
Mime-Version: 1.0
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
To: tytso@mit.edu
Cc: hannes@cmpxchg.org, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org

Theodore Ts'o wrote:
> So at this point, it seems we have two choices.  We can either revert
> 9879de7373fc, or I can add a whole lot more GFP_FAIL flags to ext4's
> memory allocations and submit them as stable bug fixes.

Can you absorb this side effect by simply adding GFP_NOFAIL to only
ext4's memory allocations? Don't you also depend on lower layers which
use GFP_NOIO?

BTW, while you are using open-coded GFP_NOFAIL retry loop for GFP_NOFS
allocation in jbd2, you are already using GFP_NOFAIL for GFP_NOFS
allocation in jbd. Failure check being there for GFP_NOFAIL seems
redundant.

---------- linux-3.19/fs/jbd2/transaction.c ----------
257 static int start_this_handle(journal_t *journal, handle_t *handle,
258                              gfp_t gfp_mask)
259 {
260         transaction_t   *transaction, *new_transaction = NULL;
261         int             blocks = handle->h_buffer_credits;
262         int             rsv_blocks = 0;
263         unsigned long ts = jiffies;
264 
265         /*
266          * 1/2 of transaction can be reserved so we can practically handle
267          * only 1/2 of maximum transaction size per operation
268          */
269         if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
270                 printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
271                        current->comm, blocks,
272                        journal->j_max_transaction_buffers / 2);
273                 return -ENOSPC;
274         }
275 
276         if (handle->h_rsv_handle)
277                 rsv_blocks = handle->h_rsv_handle->h_buffer_credits;
278 
279 alloc_transaction:
280         if (!journal->j_running_transaction) {
281                 new_transaction = kmem_cache_zalloc(transaction_cache,
282                                                     gfp_mask);
283                 if (!new_transaction) {
284                         /*
285                          * If __GFP_FS is not present, then we may be
286                          * being called from inside the fs writeback
287                          * layer, so we MUST NOT fail.  Since
288                          * __GFP_NOFAIL is going away, we will arrange
289                          * to retry the allocation ourselves.
290                          */
291                         if ((gfp_mask & __GFP_FS) == 0) {
292                                 congestion_wait(BLK_RW_ASYNC, HZ/50);
293                                 goto alloc_transaction;
294                         }
295                         return -ENOMEM;
296                 }
297         }
298 
299         jbd_debug(3, "New handle %p going live.\n", handle);
---------- linux-3.19/fs/jbd2/transaction.c ----------

---------- linux-3.19/fs/jbd/transaction.c ----------
 84 static int start_this_handle(journal_t *journal, handle_t *handle)
 85 {
 86         transaction_t *transaction;
 87         int needed;
 88         int nblocks = handle->h_buffer_credits;
 89         transaction_t *new_transaction = NULL;
 90         int ret = 0;
 91 
 92         if (nblocks > journal->j_max_transaction_buffers) {
 93                 printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
 94                        current->comm, nblocks,
 95                        journal->j_max_transaction_buffers);
 96                 ret = -ENOSPC;
 97                 goto out;
 98         }
 99 
100 alloc_transaction:
101         if (!journal->j_running_transaction) {
102                 new_transaction = kzalloc(sizeof(*new_transaction),
103                                                 GFP_NOFS|__GFP_NOFAIL);
104                 if (!new_transaction) {
105                         ret = -ENOMEM;
106                         goto out;
107                 }
108         }
109 
110         jbd_debug(3, "New handle %p going live.\n", handle);
---------- linux-3.19/fs/jbd/transaction.c ----------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
