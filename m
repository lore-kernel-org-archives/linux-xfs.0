Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49101 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753247AbdKXHkB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 24 Nov 2017 02:40:01 -0500
Date: Fri, 24 Nov 2017 08:39:57 +0100
From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
References: <20171123120828.31881-1-mhocko@kernel.org>
 <20171123132633.GB21798@infradead.org>
 <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171123220045.GV5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, hch@infradead.org, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 24-11-17 09:00:46, Dave Chinner wrote:
> On Thu, Nov 23, 2017 at 05:11:37PM +0100, Michal Hocko wrote:
> > On Fri 24-11-17 01:01:10, Tetsuo Handa wrote:
> > > Michal Hocko wrote:
> > > > On Thu 23-11-17 05:26:33, Christoph Hellwig wrote:
> > > > > Looks good,
> > > > > 
> > > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > 
> > > > Thanks!
> > > > 
> > > > > I can take a stab at the quota one.
> > > > 
> > > > That would be really great!
> > > > 
> > > Again, it does not look good. Since kmem_free() does only kvfree(),
> > > nothing will release memory allocated by list_lru_init().
> > 
> > Hmm, you are right. I have (blindly) followed the current code flow
> > which is wrong as well. The following should do the trick. Should I
> > split that into two patches?
> 
> One is fine by me - if we're need to backport one fix, then we need
> to backport both :/

OK

> > ---
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index dd0e18af990c..4c6e86d861fd 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1815,25 +1815,27 @@ xfs_alloc_buftarg(
> >  	btp->bt_daxdev = dax_dev;
> >  
> >  	if (xfs_setsize_buftarg_early(btp, bdev))
> > -		goto error;
> > +		goto error_free;
> >  
> >  	if (list_lru_init(&btp->bt_lru))
> > -		goto error;
> > +		goto error_free;
> >  
> >  	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
> > -		goto error;
> > +		goto error_lru;
> >  
> >  	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
> >  	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
> >  	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
> >  	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
> > -	if (register_shrinker(&btp->bt_shrinker)) {
> > -		percpu_counter_destroy(&btp->bt_io_count);
> > -		goto error;
> > -	}
> > +	if (register_shrinker(&btp->bt_shrinker))
> > +		goto error_pcpu;
> >  	return btp;
> >  
> > -error:
> > +error_pcpu:
> > +	percpu_counter_destroy(&btp->bt_io_count);
> > +error_lru:
> > +	list_lru_destroy(&btp->bt_lru);
> > +error_free:
> >  	kmem_free(btp);
> >  	return NULL;
> 
> That should do the trick.
> 
> Acked-by: Dave Chinner <dchinner@redhat.com>

Thanks. Updated patch below
---
>From 1009db61988c48c9a9e327a9d076945b29b02eee Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Thu, 23 Nov 2017 17:13:40 +0100
Subject: [PATCH] xfs: fortify xfs_alloc_buftarg error handling

percpu_counter_init failure path doesn't clean up &btp->bt_lru list.
Call list_lru_destroy in that error path. Similarly register_shrinker
error path is not handled.

While it is unlikely to trigger these error path, it is not impossible
especially the later might fail with large NUMAs.  Let's handle the
failure to make the code more robust.

Acked-by: Dave Chinner <dchinner@redhat.com>
Noticed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/xfs_buf.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4db6e8d780f6..4c6e86d861fd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1815,22 +1815,27 @@ xfs_alloc_buftarg(
 	btp->bt_daxdev = dax_dev;
 
 	if (xfs_setsize_buftarg_early(btp, bdev))
-		goto error;
+		goto error_free;
 
 	if (list_lru_init(&btp->bt_lru))
-		goto error;
+		goto error_free;
 
 	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
-		goto error;
+		goto error_lru;
 
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
 	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
-	register_shrinker(&btp->bt_shrinker);
+	if (register_shrinker(&btp->bt_shrinker))
+		goto error_pcpu;
 	return btp;
 
-error:
+error_pcpu:
+	percpu_counter_destroy(&btp->bt_io_count);
+error_lru:
+	list_lru_destroy(&btp->bt_lru);
+error_free:
 	kmem_free(btp);
 	return NULL;
 }
-- 
2.15.0

-- 
Michal Hocko
SUSE Labs
