Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37506 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbeJATSg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Oct 2018 15:18:36 -0400
Date: Mon, 1 Oct 2018 14:40:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/10] xfs: use a separate iomap_ops for delalloc writes
Message-ID: <20181001124057.GB3452@lst.de>
References: <20180917205354.15401-1-hch@lst.de> <20180917205354.15401-11-hch@lst.de> <20180926151805.GC899@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180926151805.GC899@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 26, 2018 at 11:18:06AM -0400, Brian Foster wrote:
> >  static int
> > -xfs_file_iomap_begin_delay(
> > +xfs_delalloc_iomap_begin(
> 
> Ok, but wouldn't something like xfs_buffered_iomap_begin/end() be a
> better name? Technically a real extent may already exist in this
> codepath, so I find the delalloc name kind of confusing.

The point is that it does a delalloc allocation.  I'd always rather
document what it does than the (current) use case.

Either way I've dropped the patch for now, as it seems a bit pointless
as long as we still don't use delayed allocations for files with
extent size hints.

> > +	xfs_fileoff_t		start_fsb;
> > +	xfs_fileoff_t		end_fsb;
> > +	int			error = 0;
> > +
> > +	if (iomap->type != IOMAP_DELALLOC)
> > +		return 0;
> 
> Any reason we don't continue to filter out !IOMAP_WRITE as well?

We are only using it for writes (or zeroing, but the same logic should
apply there)
