Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40712 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfAVSNa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Jan 2019 13:13:30 -0500
Date: Tue, 22 Jan 2019 13:13:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190122181327.GA23651@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190121154833.GA31678@infradead.org>
 <20190121174256.GB14281@bfoster>
 <20190122171445.GA6717@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190122171445.GA6717@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Tue, Jan 22, 2019 at 09:14:45AM -0800, Christoph Hellwig wrote:
> On Mon, Jan 21, 2019 at 12:42:56PM -0500, Brian Foster wrote:
> > > It protects against the case where we migrate a COW fork mapping to the
> > > data fork, which is not protected by the page lock.  But I guess the
> > > check warrants a comment and an assert.
> > > 
> > 
> > Yeah, probably. It's not really clear to me what that means.
> > 
> > > > 2. If so, then it also seems that the whole "eof:" thing in
> > > > xfs_map_blocks() should never happen for data forks. If that's the case,
> > > > the use of the eof label there seems gratuitous.
> > > 
> > > Let me try with asserts enabled.
> > > 
> > 
> > Ok, thanks.
> 
> So, the nimaps == 0 case hits even for the data fork when running
> xfs/442 on a 1k block size file system.  That test has generally been
> a fun source of bugs in the always_cow series.

Hmm, Ok.. any idea how/why that is? I'm curious if this is an artifact
of this code being racy (i.e., nimaps == 0 occurs somehow on a range
external to the page) or there is some legitimate means to lose a
delalloc block under the locked page. If the latter, we should at least
document it in the code..

FWIW, I have some refactoring in place that basically turns nimaps == 0
into an error and I don't see an xfs/442 failure with 1k or 4k blocks,
though that's only from a couple quick runs and I'm still working
through some changes. The difference of course is that this code uses
the range of the delalloc extent in the data fork rather than the
(potentially already stale) range from wpc->imap. I'll let it spin for a
bit I suppose and see if it explodes..

Brian
