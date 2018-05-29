Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53398 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932949AbeE2L0d (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 29 May 2018 07:26:33 -0400
Date: Tue, 29 May 2018 07:26:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 22/34] xfs: make xfs_writepage_map extent map centric
Message-ID: <20180529112630.GA107328@bfoster.bfoster>
References: <20180523144357.18985-1-hch@lst.de>
 <20180523144357.18985-23-hch@lst.de>
 <20180524145935.GA84959@bfoster.bfoster>
 <20180524165350.GA22675@lst.de>
 <20180524181356.GA89391@bfoster.bfoster>
 <20180525061900.GA16409@lst.de>
 <20180525113532.GA92036@bfoster.bfoster>
 <20180528071543.GA5428@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180528071543.GA5428@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>

On Mon, May 28, 2018 at 09:15:43AM +0200, Christoph Hellwig wrote:
> On Fri, May 25, 2018 at 07:35:33AM -0400, Brian Foster wrote:
> > That comment is what I'm basing on...
> > 
> > > 	/*
> > > 	 * We can end up here with no error and nothing to write if we
> > > 	 * race with a partial page truncate on a sub-page block sized
> > > 	 * filesystem. In that case we need to mark the page clean.
> > > 	 */
> > > 
> > 
> > So we can correctly end up with nothing to write on a dirty page, but it
> > presumes a race with truncate. So suppose we end up with a dirty page,
> >
> > at least one uptodate block, count is zero (i.e., due to holes) and
> > i_size is beyond the page. Would that not be completely bogus? If bogus,
> > I think that would at least detect the dumb example I posted earlier.
> 
> The trivial file_offset >= i_size_read assert explodes pretty soon
> in generic/091, and already does so with the existing mainline code.
> 

What exactly is the trivial check? Can you show the code please?

Brian

> I'd rather not open another can of worms right now..
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
