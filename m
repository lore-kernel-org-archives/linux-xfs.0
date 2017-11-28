Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50480 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752252AbdK1Qjy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Nov 2017 11:39:54 -0500
Date: Tue, 28 Nov 2017 08:39:19 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: handle register_shrinker error
Message-ID: <20171128163919.GH21412@magnolia>
References: <20171123120828.31881-1-mhocko@kernel.org>
 <20171123132633.GB21798@infradead.org>
 <20171123134128.mzxv6234hypokg4k@dhcp22.suse.cz>
 <201711240101.CJF18223.FJtHOLOSQFOMVF@I-love.SAKURA.ne.jp>
 <20171123161137.ncjqskbvdm6dgb3z@dhcp22.suse.cz>
 <20171123220045.GV5858@dastard>
 <20171124073957.3z4hjwg5exqw277h@dhcp22.suse.cz>
 <20171127174453.GC19379@magnolia>
 <20171128093551.mjwao7afv75me6ht@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171128093551.mjwao7afv75me6ht@dhcp22.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michal Hocko <mhocko@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, hch@infradead.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 28, 2017 at 10:35:51AM +0100, Michal Hocko wrote:
> On Mon 27-11-17 09:44:53, Darrick J. Wong wrote:
> [...]
> > > From 1009db61988c48c9a9e327a9d076945b29b02eee Mon Sep 17 00:00:00 2001
> > > From: Michal Hocko <mhocko@suse.com>
> > > Date: Thu, 23 Nov 2017 17:13:40 +0100
> > > Subject: [PATCH] xfs: fortify xfs_alloc_buftarg error handling
> > > 
> > > percpu_counter_init failure path doesn't clean up &btp->bt_lru list.
> > > Call list_lru_destroy in that error path. Similarly register_shrinker
> > > error path is not handled.
> > > 
> > > While it is unlikely to trigger these error path, it is not impossible
> > > especially the later might fail with large NUMAs.  Let's handle the
> > > failure to make the code more robust.
> > > 
> > > Acked-by: Dave Chinner <dchinner@redhat.com>
> > > Noticed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > > ---
> > >  fs/xfs/xfs_buf.c | 15 ++++++++++-----
> > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 4db6e8d780f6..4c6e86d861fd 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1815,22 +1815,27 @@ xfs_alloc_buftarg(
> > >  	btp->bt_daxdev = dax_dev;
> > >  
> > >  	if (xfs_setsize_buftarg_early(btp, bdev))
> > > -		goto error;
> > > +		goto error_free;
> > >  
> > >  	if (list_lru_init(&btp->bt_lru))
> > > -		goto error;
> > > +		goto error_free;
> > >  
> > >  	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
> > > -		goto error;
> > > +		goto error_lru;
> > >  
> > >  	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
> > >  	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
> > >  	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
> > >  	btp->bt_shrinker.flags = SHRINKER_NUMA_AWARE;
> > > -	register_shrinker(&btp->bt_shrinker);
> > > +	if (register_shrinker(&btp->bt_shrinker))
> > > +		goto error_pcpu;
> > >  	return btp;
> > >  
> > > -error:
> > > +error_pcpu:
> > > +	percpu_counter_destroy(&btp->bt_io_count);
> > > +error_lru:
> > > +	list_lru_destroy(&btp->bt_lru);
> > > +error_free:
> > >  	kmem_free(btp);
> > >  	return NULL;
> > 
> > This part looks ok,
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Are you going to apply the patch or should I re-send it with
> acks/reviewed-by?

I injected all of those when I added the patch to my tree:

Noticed-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> -- 
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
