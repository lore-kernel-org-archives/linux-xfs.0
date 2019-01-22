Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37310 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729282AbfAVROq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Jan 2019 12:14:46 -0500
Date: Tue, 22 Jan 2019 09:14:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190122171445.GA6717@infradead.org>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190121154833.GA31678@infradead.org>
 <20190121174256.GB14281@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121174256.GB14281@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 12:42:56PM -0500, Brian Foster wrote:
> > It protects against the case where we migrate a COW fork mapping to the
> > data fork, which is not protected by the page lock.  But I guess the
> > check warrants a comment and an assert.
> > 
> 
> Yeah, probably. It's not really clear to me what that means.
> 
> > > 2. If so, then it also seems that the whole "eof:" thing in
> > > xfs_map_blocks() should never happen for data forks. If that's the case,
> > > the use of the eof label there seems gratuitous.
> > 
> > Let me try with asserts enabled.
> > 
> 
> Ok, thanks.

So, the nimaps == 0 case hits even for the data fork when running
xfs/442 on a 1k block size file system.  That test has generally been
a fun source of bugs in the always_cow series.
