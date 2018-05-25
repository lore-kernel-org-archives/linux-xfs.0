Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966235AbeEYLfe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 25 May 2018 07:35:34 -0400
Date: Fri, 25 May 2018 07:35:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 22/34] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180525113532.GA92036@bfoster.bfoster>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-23-hch@lst.de>
 <20180524145935.GA84959@bfoster.bfoster>
 <20180524165350.GA22675@lst.de>
 <20180524181356.GA89391@bfoster.bfoster>
 <20180525061900.GA16409@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180525061900.GA16409@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>

On Fri, May 25, 2018 at 08:19:00AM +0200, Christoph Hellwig wrote:
> On Thu, May 24, 2018 at 02:13:56PM -0400, Brian Foster wrote:
> > Ok, so I guess writeback can see uptodate blocks over a hole if some
> > other block in that page is dirty.
> 
> Yes.
> 
> > Perhaps we could make sure that a
> > dirty page has at least one block that maps to an actual extent or
> > otherwise the page has been truncated..?
> 
> We have the following comment near the end of xfs_writepage_map:
> 

That comment is what I'm basing on...

> 	/*
> 	 * We can end up here with no error and nothing to write if we
> 	 * race with a partial page truncate on a sub-page block sized
> 	 * filesystem. In that case we need to mark the page clean.
> 	 */
> 

So we can correctly end up with nothing to write on a dirty page, but it
presumes a race with truncate. So suppose we end up with a dirty page,
at least one uptodate block, count is zero (i.e., due to holes) and
i_size is beyond the page. Would that not be completely bogus? If bogus,
I think that would at least detect the dumb example I posted earlier.

Brian

> And I'm pretty sure I managed to hit that case easily in xfstests,
> as my initial handling of it was wrong.  So I don't think we can
> even check for that.
> 
> > I guess having another dirty block bitmap similar to
> > iomap_page->uptodate could be required to tell for sure whether a
> > particular block should definitely have a block on-disk or not. It may
> > not be worth doing that just for additional error checks, but I still
> > have to look into the last few patches to grok all the iomap_page stuff.
> 
> I don't think it's worth it.  The sub-page dirty tracking has been one
> of the issues with the buffer head code that caused a lot of problems,
> and that we want to get rid of.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
