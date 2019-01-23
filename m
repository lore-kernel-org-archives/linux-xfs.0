Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45500 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbfAWSkh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 23 Jan 2019 13:40:37 -0500
Date: Wed, 23 Jan 2019 13:40:34 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190123184034.GB27886@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190121154833.GA31678@infradead.org>
 <20190121174256.GB14281@bfoster>
 <20190122171445.GA6717@infradead.org>
 <20190122181327.GA23651@bfoster>
 <20190123181412.GA23710@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123181412.GA23710@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Wed, Jan 23, 2019 at 10:14:12AM -0800, Christoph Hellwig wrote:
> On Tue, Jan 22, 2019 at 01:13:28PM -0500, Brian Foster wrote:
> > > So, the nimaps == 0 case hits even for the data fork when running
> > > xfs/442 on a 1k block size file system.  That test has generally been
> > > a fun source of bugs in the always_cow series.
> > 
> > Hmm, Ok.. any idea how/why that is? I'm curious if this is an artifact
> > of this code being racy (i.e., nimaps == 0 occurs somehow on a range
> > external to the page) or there is some legitimate means to lose a
> > delalloc block under the locked page. If the latter, we should at least
> > document it in the code..
> 
> I haven't managed to pinpint it mostly because xfs_bmapi_write is
> such an unreadable mess.  Based on that I decided to implement the idea
> of a separate xfs_bmapi_delalloc_convert helper again, mostly to try
> to understand what actuall is going on.  This seems to work pretty
> reasonable after initial testing, except that it seems to unhide an
> issue in xfs/109 which doesn't look directly related.  The current
> status is here:
> 
> http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.2
> 

I have a v3 of this series that does something similar, but doesn't
quite take the refactoring as far. I just created an
xfs_bmapi_delalloc() wrapper over xfs_bmapi_write(). The changes to the
latter are minimal based on a tweak of XFS_BMAPI_DELALLOC behavior. The
change to xfs_iomap_write_allocate() is basically just to use the new
helper instead of xfs_bmapi_write().

The refactoring you have looks like the right direction to me, but I'm
wondering why we need to change so much all at once, particularly since
it's not clear that some of this -EAGAIN stuff is really necessary.
Pulling bits out of xfs_bmapi_write() is also inherently more difficult
to review than reusing it, IMO.

Hmm, I'm wondering if we could rebase your refactoring onto the simple
wrapper in my patch. You'd basically just reimplement the helper, kill
off the XFS_BMAPI_DELALLOC stuff as you already have, and the changes to
xfs_iomap_write_allocate() (notwithstanding moving/renaming the
function, which should really be split up into separate patches) would
probably be minimal (i.e., do the extent lookup).

I was still running some tests but I've got through a decent amount
already and have everything formatted to send out so I'll just post
it...

Brian
