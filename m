Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38824 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753619AbeGHPOz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 8 Jul 2018 11:14:55 -0400
Date: Sun, 8 Jul 2018 17:16:15 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 21/22] xfs: add support for sub-pagesize writeback
        without buffer_heads
Message-ID: <20180708151615.GC14418@lst.de>
References: <20180702145813.22496-1-hch@lst.de> <20180702145813.22496-22-hch@lst.de> <20180703123603.GB22789@bfoster> <20180703220501.GX32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703220501.GX32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Jul 03, 2018 at 03:05:01PM -0700, Darrick J. Wong wrote:
> > So the buffer completion code clears the uptodate status of the buffer
> > on error. I assume that means the next read would replace the data we
> > failed to write with whatever was previously on disk.
> 
> I've always found it a little weird that we basically throw away the
> newer page contents on error, but we shouldn't be changing the behavior
> in quite so subtle a way.
> 
> Also, since we clear uptodate the next (buffered) write will reread the
> page contents.
> 
> > I guess it's debatable whether that is the right thing to do in
> > general, but that seems like a higher level issue nonetheless (i.e., I
> > don't think we'd ever retry the writepage either?).
> 
> AFAIK we don't retry failed writes unless userspace dirties the page.
> 
> > So is there any reason not to do the analogous in the iomap completion
> > code?
> 
> Will let Christoph answer that one.

As far as I can tell the write path should never even touch the
uptodate bit, and the buffer head path is only doing so for very
old legacy reasons.  I'd rather keep the iomap write path out of
the update bit manipulation business from the very beginning instead
of carry junk like this over.
