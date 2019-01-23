Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37652 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfAWSON (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Jan 2019 13:14:13 -0500
Date: Wed, 23 Jan 2019 10:14:12 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190123181412.GA23710@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190121154833.GA31678@infradead.org>
 <20190121174256.GB14281@bfoster>
 <20190122171445.GA6717@infradead.org>
 <20190122181327.GA23651@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190122181327.GA23651@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Tue, Jan 22, 2019 at 01:13:28PM -0500, Brian Foster wrote:
> > So, the nimaps == 0 case hits even for the data fork when running
> > xfs/442 on a 1k block size file system.  That test has generally been
> > a fun source of bugs in the always_cow series.
> 
> Hmm, Ok.. any idea how/why that is? I'm curious if this is an artifact
> of this code being racy (i.e., nimaps == 0 occurs somehow on a range
> external to the page) or there is some legitimate means to lose a
> delalloc block under the locked page. If the latter, we should at least
> document it in the code..

I haven't managed to pinpint it mostly because xfs_bmapi_write is
such an unreadable mess.  Based on that I decided to implement the idea
of a separate xfs_bmapi_delalloc_convert helper again, mostly to try
to understand what actuall is going on.  This seems to work pretty
reasonable after initial testing, except that it seems to unhide an
issue in xfs/109 which doesn't look directly related.  The current
status is here:

http://git.infradead.org/users/hch/xfs.git/shortlog/refs/heads/xfs-mapping-validation.2
