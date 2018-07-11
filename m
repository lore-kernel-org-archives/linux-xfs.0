Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726641AbeGKLCE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jul 2018 07:02:04 -0400
Date: Wed, 11 Jul 2018 06:58:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 21/22] xfs: add support for sub-pagesize writeback
 without buffer_heads
Message-ID: <20180711105817.GA3805@killians.ges.redhat.com>
References: <20180702145813.22496-1-hch@lst.de>
 <20180702145813.22496-22-hch@lst.de>
 <20180703123603.GB22789@bfoster>
 <20180703220501.GX32415@magnolia>
 <20180708151615.GC14418@lst.de>
 <20180710010202.GA5835@killians.ges.redhat.com>
 <20180710121530.GA765@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710121530.GA765@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jul 10, 2018 at 02:15:30PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 09, 2018 at 09:02:02PM -0400, Brian Foster wrote:
> > It looks to me that if the page itself isn't uptodate, we
> > overwrite a block of that page and then the writepage fails, clearing
> > the buffer uptodate status means that the next read would return what is
> > on disk (not what was just written to the page).
> 
> With iomap we never clear the uptodate bit, and we only set it when
> the part of the page contains valid data.  With buffer heads we might
> indeed clear the uptodate bit after a write error.  Now if the whole
> page is set uptodate we won't re-read it, but if the whole page wasn't
> uptodate it seems like the buffer head code will lose data in that
> case, which looks wrong to me.
> 

My understanding is that we could lose data regardless because the page
is not redirtied and thus can be reclaimed. Based on that, I thought
that perhaps the buffer state was cleared to perform that invalidation
explicitly rather than unpredictably based on cache behavior, but it
seems the whole page uptodate thing is completely inconsistent with
that.

> > I'm not sure that's
> > what happens if the page was already uptodate before the
> > overwrite/writepage, however, I didn't notice anything that cleared page
> > uptodate status on a writepage I/O error..?
> 
> Yes, the buffer head code seems inconsistent in how it treats the buffer
> vs page uptodate bits.

Ok. Given the page behavior is what it is, I think it's reasonable to
treat the block state consistently. I mainly wanted to be sure that I
wasn't missing something with regard to the impact of write errors on
PageUptodate() and if there was some explicit write error invalidation
going on, we don't lose sight of it and provide inconsistent behavior.
It sounds like that is not the case:

Reviewed-by: Brian Foster <bfoster@redhat.com>
