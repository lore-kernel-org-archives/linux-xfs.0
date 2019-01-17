Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbfAQUEO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jan 2019 15:04:14 -0500
Date: Thu, 17 Jan 2019 12:04:07 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/22] xfs: refactor special inode roll out of
 xfs_dir_ialloc
Message-ID: <20190117200407.GA8077@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
 <154630921076.18437.14193766050551378677.stgit@magnolia>
 <20190117142427.GF16270@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117142427.GF16270@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 06:24:27AM -0800, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
> > index 5a1d98d1546d..ee274d74b8d4 100644
> > --- a/fs/xfs/libxfs/xfs_inode_util.h
> > +++ b/fs/xfs/libxfs/xfs_inode_util.h
> > @@ -82,6 +82,12 @@ struct xfs_ialloc_ops {
> >  
> >  	/* Do any final setup needed before we return the inode. */
> >  	void (*setup)(struct xfs_inode *ip);
> > +
> > +	/*
> > +	 * Roll the transaction between allocating a new ichunk and
> > +	 * initializing a new inode core.
> > +	 */
> > +	int (*ichunk_roll)(struct xfs_trans **tpp);
> 
> Sorry, but this whole idea to add gracious indirect calls is just
> backwards.  They do have a non-trivial cost, and we should rather
> get rid of pointless indirect calls instead of adding more.

I built all this indirect call stuff so that mkfs protofile code would
be able to set parameters ... but seeing as Eric said he'll deprecate
all that, I think it's no longer necessary.

--D
