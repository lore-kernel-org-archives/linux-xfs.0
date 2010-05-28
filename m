Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4S0s4nY180664 for <xfs@oss.sgi.com>; Thu, 27 May 2010 19:54:04 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A4140157D1AF
	for <xfs@oss.sgi.com>; Thu, 27 May 2010 17:58:20 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	rkcqM61ArgfyxfFh for <xfs@oss.sgi.com>;
	Thu, 27 May 2010 17:58:20 -0700 (PDT)
Date: Fri, 28 May 2010 10:56:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/6] writeback: pay attention to wbc->nr_to_write in
	write_cache_pages
Message-ID: <20100528005602.GW12087@dastard>
References: <1274784852-30502-1-git-send-email-david@fromorbit.com>
	<1274784852-30502-5-git-send-email-david@fromorbit.com>
	<20100527143251.5193842d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100527143251.5193842d.akpm@linux-foundation.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, May 27, 2010 at 02:32:51PM -0700, Andrew Morton wrote:
> On Tue, 25 May 2010 20:54:10 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > If a filesystem writes more than one page in ->writepage, write_cache_pages
> > fails to notice this and continues to attempt writeback when wbc->nr_to_write
> > has gone negative - this trace was captured from XFS:
> > 
> > 
> >     wbc_writeback_start: towrt=1024
> >     wbc_writepage: towrt=1024
> >     wbc_writepage: towrt=0
> >     wbc_writepage: towrt=-1
> >     wbc_writepage: towrt=-5
> >     wbc_writepage: towrt=-21
> >     wbc_writepage: towrt=-85
> > 
> > This has adverse effects on filesystem writeback behaviour. write_cache_pages()
> > needs to terminate after a certain number of pages are written, not after a
> > certain number of calls to ->writepage are made.  This is a regression
> > introduced by 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4, but cannot be reverted
> 
> It's conventional to identify commits by their title as well as their
> hash.  So 17bc6c30cf6bfffd816bdc53682dd46fc34a2cf4 ("vfs: Add
> no_nrwrite_index_update writeback control flag").  Because that commit
> might have different hashes in different trees, I think.  A Linus idea.
> 
> I do this ten times a day - It's a PITA.

Will fix.

> 
> > directly due to subsequent bug fixes that have gone in on top of it.
> > 
> > This commit adds a ->writepage tracepoint inside write_cache_pages() (how the
> > above trace was generated) and does the revert manually leaving the subsequent
> > bug fixes in tact. ext4 is not affected by this as a previous commit in the
> 
> "intact".

*nod*

> > series stops ext4 from using the generic function.
> > 
> > -			if (nr_to_write > 0) {
> > -				nr_to_write--;
> > -				if (nr_to_write == 0 &&
> > +			if (wbc->nr_to_write > 0) {
> > +				if (--wbc->nr_to_write == 0 &&
> >  				    wbc->sync_mode == WB_SYNC_NONE) {
> >  					/*
> >  					 * We stop writing back only if we are
> > @@ -974,11 +973,8 @@ continue_unlock:
> >  		end = writeback_index - 1;
> >  		goto retry;
> >  	}
> > -	if (!wbc->no_nrwrite_index_update) {
> > -		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
> > -			mapping->writeback_index = done_index;
> > -		wbc->nr_to_write = nr_to_write;
> > -	}
> > +	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
> > +		mapping->writeback_index = done_index;
> >  
> >  	return ret;
> 
> 'bout time we fixed that.  I wonder why it took so long to find.

IMO, because without tracing it's almost impossible to see what is
happening inside this code easily. I wasn't looking for this bug
when I added the tracing - I was trying to discover why sync was
locking up for minutes on end.

Also a significant problem is that writeback changes often come in
through a tree that no filesystem developer is actually testing
(e.g. the block git tree) or a single FS tree (e.g. the ext4 tree),
so problems in the generic code that manifest in only one or two
filesystems slip under the radar all too easily. Hence they are
often only discovered when some other, unrelated, obvious problem is
investigated...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
