Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:44816 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbfBVOWi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 09:22:38 -0500
Date: Fri, 22 Feb 2019 15:22:37 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/8] xfs: merge COW handling into
 xfs_file_iomap_begin_delay
Message-ID: <20190222142237.GC2484@lst.de>
References: <20190218091827.12619-1-hch@lst.de> <20190218091827.12619-6-hch@lst.de> <20190221175903.GB51494@bfoster> <20190221213052.GT32253@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221213052.GT32253@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Thu, Feb 21, 2019 at 01:30:52PM -0800, Darrick J. Wong wrote:
> > So does this need to account for the case of an overlapping cow block
> > over a hole in the data fork (with cached data, if that is possible)?
> > IIUC we introduce that possibility just below.
> 
> I think it makes sense to ignore overlapping cow blocks for zeroing a
> hole in the data fork -- the user told us to zero part of a file that
> didn't have nonzero contents in it, so we just leave the speculative cow
> allocation for that block alone.

For a speculative preallocation I agree.  But if we have valid data
in there due to a cowextsize preallocation being used for data we
should handle it properly.

> > >  	iomap->flags |= IOMAP_F_NEW;
> > 
> > This looks like it flags the mapping new if we reserve cow blocks, which
> > I don't think is quite right.
> 
> Hmmm.  I thought it was correct -- if the write fails, we punch out the
> pagecache and trim any delalloc blocks in the data fork.  If they user
> tries to reread the area of the failed write we'll just read them back
> in from disk...?

Yes, I don't think it is actively harmful, but we don't really need
it either.
