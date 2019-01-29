Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4773 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727342AbfA2VxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Jan 2019 16:53:16 -0500
Date: Wed, 30 Jan 2019 08:53:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Bug 202441] Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Message-ID: <20190129215311.GB4205@dastard>
References: <bug-202441-201763@https.bugzilla.kernel.org/>
 <bug-202441-201763-jzvLSzrUxn@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-202441-201763-jzvLSzrUxn@https.bugzilla.kernel.org/>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bugzilla-daemon@bugzilla.kernel.org
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 29, 2019 at 09:41:21PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=202441
> --- Comment #14 from Dave Chinner (david@fromorbit.com) ---
> > --- Comment #12 from Roger (rogan6710@gmail.com) ---
> > Beginnig from rc5, might have been earlier also, cache get's released,
> > sometimes almost all of it, and begins to fill up slowly again,
> 
> Which I'd consider bad behaviour - trashing the entire working set
> because memory pressure is occurring is pathological behaviour.
> 
> Can you confirm which -rcX that behaviour starts in? e.g. between
> -rc4 and -rc5 there is this commit:
> 
> 172b06c32b94 mm: slowly shrink slabs with a relatively small number of objects
> 
> Which does change the way that the inode caches are reclaimed by
> forcably triggering reclaim for caches that would have previously
> been ignored. That's one of the "red flag" commits I noticed when
> first looking at the history between 4.18 and 4.19....

And now, added in 4.19.3:

 $ gl -n 1 5ebac3b957a9 -p
commit 5ebac3b957a91c921d2f1a7953caafca18aa6260
Author: Roman Gushchin <guro@fb.com>
Date:   Fri Nov 16 15:08:18 2018 -0800

    mm: don't reclaim inodes with many attached pages
    
    commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0 upstream.
    
    Spock reported that commit 172b06c32b94 ("mm: slowly shrink slabs with a
    relatively small number of objects") leads to a regression on his setup:
    periodically the majority of the pagecache is evicted without an obvious
    reason, while before the change the amount of free memory was balancing
    around the watermark.
    
    The reason behind is that the mentioned above change created some
    minimal background pressure on the inode cache.  The problem is that if
    an inode is considered to be reclaimed, all belonging pagecache page are
    stripped, no matter how many of them are there.  So, if a huge
    multi-gigabyte file is cached in the memory, and the goal is to reclaim
    only few slab objects (unused inodes), we still can eventually evict all
    gigabytes of the pagecache at once.
    
    The workload described by Spock has few large non-mapped files in the
    pagecache, so it's especially noticeable.
    
    To solve the problem let's postpone the reclaim of inodes, which have
    more than 1 attached page.  Let's wait until the pagecache pages will be
    evicted naturally by scanning the corresponding LRU lists, and only then
    reclaim the inode structure.
    
    Link: http://lkml.kernel.org/r/20181023164302.20436-1-guro@fb.com
    Signed-off-by: Roman Gushchin <guro@fb.com>
    Reported-by: Spock <dairinin@gmail.com>
    Tested-by: Spock <dairinin@gmail.com>
    Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
    Cc: Michal Hocko <mhocko@kernel.org>
    Cc: Rik van Riel <riel@surriel.com>
    Cc: Randy Dunlap <rdunlap@infradead.org>
    Cc: <stable@vger.kernel.org>    [4.19.x]
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

SO, basically, I was right - the slab shrinking change in 4.18-rc5
caused the page cache to saw tooth like you reported, and there is a
"fix" for it in 4.19.3.

What does that "fix" do? It stops inode reclaim from inodes with
cached pages attached.

diff --git a/fs/inode.c b/fs/inode.c
index 42f6d25f32a5..65ae154df760 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -730,8 +730,11 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
                return LRU_REMOVED;
        }
 
-       /* recently referenced inodes get one more pass */
-       if (inode->i_state & I_REFERENCED) {
+       /*
+        * Recently referenced inodes and inodes with many attached pages
+        * get one more pass.
+        */
+       if (inode->i_state & I_REFERENCED || inode->i_data.nrpages > 1) {
                inode->i_state &= ~I_REFERENCED;
                spin_unlock(&inode->i_lock);
                return LRU_ROTATE;

Basically, what happened before this patch was that when an inode
was aged out of the cache due to the shrinker cycling over it, it's
page cache was reclaimed and then the inode reclaimed.

Now, the inode does not get reclaimed and the page cache is not
reclaimed. When you have lots of large files in your workload, that
means the inode cache turning over can no longer reclaim those
inodes, and so the inode can only be reclaimed after memory reclaim
has reclaimed the entire page cache for an inode.

That's a /massive/ change in behaviour, and it means that clean
inodes with cached pages attached can no longer be reclaimed by the
inode cache shrinker. Which will drive the inode cache shrinker into
trying to reclaim dirty inodes.....

Can you revert the above patch and see if the problem goes away?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
