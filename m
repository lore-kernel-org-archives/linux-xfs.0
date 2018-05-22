Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:46997 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbeEVHvB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 03:51:01 -0400
Date: Tue, 22 May 2018 09:56:14 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 05/34] fs: use ->is_partially_uptodate in
        page_cache_seek_hole_data
Message-ID: <20180522075614.GA9430@lst.de>
References: <20180518164830.1552-1-hch@lst.de> <20180518164830.1552-6-hch@lst.de> <20180521195304.GA14384@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180521195304.GA14384@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org

> > diff --git a/fs/iomap.c b/fs/iomap.c
> > index bef5e91d40bf..0fecd5789d7b 100644
> > --- a/fs/iomap.c
> > +++ b/fs/iomap.c
> > @@ -594,31 +594,54 @@ EXPORT_SYMBOL_GPL(iomap_fiemap);
> >   *
> >   * Returns the offset within the file on success, and -ENOENT otherwise.
> 
> This comment is now wrong, since we return the offset via *lastoff and I
> think the return value is whether or not we found what we were looking
> for...?

Yes.  I'll just drop the comment as it doesn't add much value to start
with.

> > +	if (bsize == PAGE_SIZE || !ops->is_partially_uptodate) {
> > +		if (PageUptodate(page) == seek_data)
> > +			return true;
> > +		return false;
> 
> return PageUptodate(page) == seek_data; ?

Sure, I'll uptodate the patch.
