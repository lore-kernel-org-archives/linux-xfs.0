Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49666 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727059AbeI1Gwm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 02:52:42 -0400
Date: Thu, 27 Sep 2018 17:31:04 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 6/6] xfs: don't crash the vfs on a garbage inline symlink
Message-ID: <20180928003104.GE20086@magnolia>
References: <153400169747.27471.4044680761841034489.stgit@magnolia>
 <153400173428.27471.504421086760762828.stgit@magnolia>
 <20180813072313.GA26027@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180813072313.GA26027@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, wen.xu@gatech.edu

On Mon, Aug 13, 2018 at 12:23:13AM -0700, Christoph Hellwig wrote:
> >  	struct delayed_call	*done)
> >  {
> > +	char			*ptr;
> > +
> >  	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> > -	return XFS_I(inode)->i_df.if_u1.if_data;
> > +
> > +	/*
> > +	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
> > +	 * if_data is junk.
> > +	 */
> > +	ptr = XFS_I(inode)->i_df.if_u1.if_data;
> > +	return ptr ? ptr : ERR_PTR(-EFSCORRUPTED);
> >  }
> >  
> >  STATIC int
> 
> Please simplify this to:
> 
> >  	struct delayed_call	*done)
> >  {
> 	char			*link = XFS_I(inode)->i_df.if_u1.if_data;
> 
>   	ASSERT(XFS_I(inode)->i_df.if_flags & XFS_IFINLINE);
> > +	ptr = XFS_I(inode)->i_df.if_u1.if_data;
> 
> 	if (!link)
> 		return ERR_PTR(-EFSCORRUPTED);
> 	return link;
> 
> But be honest I'd much rather fix this in the caller than every fs.
> Can you send a patch to Al to do that instead?

Ok, I'll do that.

--D
