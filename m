Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43173 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751597AbdKNGBe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Nov 2017 01:01:34 -0500
Date: Mon, 13 Nov 2017 22:01:29 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fs, dax: unify IOMAP_F_DIRTY read vs write handling
 policy in the dax core
Message-ID: <20171114060129.GB15810@infradead.org>
References: <151062258598.8554.8157038002895095232.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20171114041228.GA4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114041228.GA4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Tue, Nov 14, 2017 at 03:12:28PM +1100, Dave Chinner wrote:
> On Mon, Nov 13, 2017 at 05:27:54PM -0800, Dan Williams wrote:
> > diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> > index b43be199fbdf..888b60189983 100644
> > --- a/fs/xfs/xfs_iomap.c
> > +++ b/fs/xfs/xfs_iomap.c
> > @@ -1087,9 +1087,9 @@ xfs_file_iomap_begin(
> >  		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
> >  	}
> >  
> > -	if ((flags & IOMAP_WRITE) && xfs_ipincount(ip) &&
> > -	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > -		iomap->flags |= IOMAP_F_DIRTY;
> > +	if (xfs_ipincount(ip))
> > +		if (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP)
> > +			iomap->flags |= IOMAP_F_DIRTY;
> 
> Please make a helper for this, and use it in xfs_file_fsync() where
> the same dirty checks are done. e.g.

Let's keep that sort of cleanup separate.  I initially considered
it when doing the MAP_SYNC work, but fsync works a little different
in that it looks at ili_last_lsn, so your little helper below won't
work as-is.  You can send it as an incremental patch later and we
can see if we can come up with something workable.
