Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfAURm7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 21 Jan 2019 12:42:59 -0500
Date: Mon, 21 Jan 2019 12:42:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 5/5] xfs: revalidate imap properly before writeback
 delalloc conversion
Message-ID: <20190121174256.GB14281@bfoster>
References: <20190117192004.49346-1-bfoster@redhat.com>
 <20190117192004.49346-6-bfoster@redhat.com>
 <20190118115937.GD7807@infradead.org>
 <20190118163132.GA6318@infradead.org>
 <20190118183915.GB53532@bfoster>
 <20190121154833.GA31678@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190121154833.GA31678@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Mon, Jan 21, 2019 at 07:48:33AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 18, 2019 at 01:39:15PM -0500, Brian Foster wrote:
> > This doesn't really seem all that different to me. Rather than firm up
> > the range in the caller, we turn XFS_BMAPI_DELALLOC into something that
> > seemingly behaves a bit more like CONVERT_ONLY.
> 
> The differences are:
> 
>  (a) we save one lookup in the extent tree
>  (b) we have a less fragile API
> 
> > A few notes/thoughts:
> > 
> > 1. What's the purpose of the nimaps == 0 check in
> > xfs_iomap_write_allocate()? If we got to this point with the page lock
> > held, shouldn't we always expect to find something backing the current
> > page?
> 
> It protects against the case where we migrate a COW fork mapping to the
> data fork, which is not protected by the page lock.  But I guess the
> check warrants a comment and an assert.
> 

Yeah, probably. It's not really clear to me what that means.

> > 2. If so, then it also seems that the whole "eof:" thing in
> > xfs_map_blocks() should never happen for data forks. If that's the case,
> > the use of the eof label there seems gratuitous.
> 
> Let me try with asserts enabled.
> 

Ok, thanks.

> > 
> > 3. If the starting bno param to xfs_bmapi_write() lands in a hole (due
> > to racing with a hole punch for example) and it finds some subsequent
> > delalloc extent to convert in the requested range, the arithmetic in
> > xfs_bmapi_trim_map() actually fabricates physical blocks for the hole
> > portion of the range relative to the startblock of the converted
> > delalloc extent. I don't think that causes a problem with the writeback
> > code because the fabricated blocks are before the page offset, but those
> > semantics are insane. I think you need to do something like fix up
> > xfs_bmapi_write() to return the actual converted mapping and make sure
> > xfs_iomap_write_allocate() handles that it might start beyond
> > map_start_fsb.
> 
> Sounds good.  To be honest I think the whole idea of converting the
> mapping before the requested offset is a rather bad idea to start
> with, just increasin our window that exposes stale data.  But to fix
> this properly we need to create everything as unwritten first, and
> I didn't have time to get back to that series.

Eh, I think that's a separate problem that re: your other series, we
already know how to fix properly. I don't think we should mess around
with something as fairly fundamental as delayed block allocation
behavior for an approach that doesn't address the underlying problem.

Brian
