Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n05HVH9U005624 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 11:31:24 -0600
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB8DC61000
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 09:31:15 -0800 (PST)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13]) by cuda.sgi.com with ESMTP id
	HAX8fUbyEUQL3lBN for <xfs@oss.sgi.com>;
	Mon, 05 Jan 2009 09:31:15 -0800 (PST)
Date: Mon, 5 Jan 2009 09:30:55 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
	soft lockup - is this XFS problem?)
In-Reply-To: <20090105164135.GC32675@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org>
	<20081230042333.GC27679@wotan.suse.de>
	<20090103214443.GA6612@infradead.org>
	<20090105014821.GA367@wotan.suse.de>
	<20090105041959.GC367@wotan.suse.de>
	<20090105064838.GA5209@wotan.suse.de>
	<49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Roman Kononov <kernel@kononov.ftml.net>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Klotz <peter.klotz@aon.at>, stable@kernel.org



On Mon, 5 Jan 2009, Nick Piggin wrote:
> 
> This patch should be applied to 2.6.29 and 27/28 stable kernels, please.

No. I think this patch is utter crap. But please feel free to educate me 
on why that is not the case.

Here's my explanation:

Not only is it ugly (which is already sufficient ground to suspect it is 
wrong or could at least be done better), but reading the comment, it makes 
no sense at all. You only put the barrier in the "goto repeat" case, but 
the thing is, if you worry about radix tree slot not being reloaded in the 
repeat case, then you damn well should worry about it not being reloaded 
in the non-repeat case too!

The code is immediately followed by a test to see that the page is still 
the same in the slot, ie this:

                /*
                 * Has the page moved?
                 * This is part of the lockless pagecache protocol. See
                 * include/linux/pagemap.h for details.
                 */
                if (unlikely(page != *pagep)) {

and if you need a barrier for the repeat case, you need one for this case 
too.

In other words, it looks like you fixed the symptom, but not the real 
cause! That's now how we work in the kernel.

The real cause, btw, appears to be that radix_tree_deref_slot() is a piece 
of slimy sh*t, and has not been correctly updated to RCU. The proper fix 
doesn't require any barriers that I can see - I think the proper fix is 
this simple one-liner.

If you use RCU to protect a data structure, then any data loaded from that 
data structure that can change due to RCU should be loaded with 
"rcu_dereference()". 

Now, I can't test this, because it makes absolutely no difference for me 
(the diff isn't empty, but the asm changes seem to be all due to just gcc 
variable numbering changing). I can't seem to see the buggy code. Maybe it 
needs a specific compiler version, or some specific config option to 
trigger?

So because I can't see the issue, I also obviously can't verify that it's 
the only possible case. Maybe there is some other memory access that 
should also be done with the proper rcu accessors?

Of course, it's also possible that we should just put a barrier in 
page_cache_get_speculative(). That doesn't seem to make a whole lot of 
conceptual sense, though (the same way that your barrier() didn't make any 
sense - I don't see that the barrier has absolutely _anything_ to do with 
whether the speculative getting of the page fails or not!)

In general, I'd like fewer "band-aid" patches, and more "deep thinking" 
patches. I'm not saying mine is very deep either, but I think it's at 
least scrathing the surface of the real problem rather than just trying to 
cover it up.

		Linus

---
 include/linux/radix-tree.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index a916c66..355f6e8 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -136,7 +136,7 @@ do {									\
  */
 static inline void *radix_tree_deref_slot(void **pslot)
 {
-	void *ret = *pslot;
+	void *ret = rcu_dereference(*pslot);
 	if (unlikely(radix_tree_is_indirect_ptr(ret)))
 		ret = RADIX_TREE_RETRY;
 	return ret;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
