Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40584 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752723AbdHKRJW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Aug 2017 13:09:22 -0400
Date: Fri, 11 Aug 2017 19:09:21 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: open code end_buffer_async_write in
        xfs_finish_page_writeback
Message-ID: <20170811170921.GA1127@lst.de>
References: <20170811095905.11241-1-hch@lst.de> <20170811095905.11241-2-hch@lst.de> <20170811162037.GB24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170811162037.GB24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Fri, Aug 11, 2017 at 09:20:38AM -0700, Darrick J. Wong wrote:
> If we're going to open-code end_buffer_async_write, could we have a
> comment here explaining that we've done so, and why?

Sure.

> ASSERT(bh->b_end_io == end_buffer_async_write), just in case we ever get
> passed a buffer head with an endio function that isn't what we're
> open-coding?

Ok.

> > +	if (unlikely(error && !quiet)) {
> > +		xfs_err_ratelimited(XFS_I(inode)->i_mount,
> > +			"read error on sector %llu", start);
> 
> Read error?  Isn't this writeback?

Ooops, it is.

> I also wonder about the wisdom of the text deviating from "lost async
> page write", since scripts/admins have been trained to look for that as
> evidence of writeback problems for years.

We could keep the text, but I think it's rather confusing and doesn't
fit the other XFS warnings.  And I don't think admins should rely on
the sorts of warnings.  E.g. for btrfs they would not get these
warnings either.

> (That said, at least now it's a lot less spammy.)

Yes - but we could still print the warning once per bio instead of
once per bh if the message remains the same.
