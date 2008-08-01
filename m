Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:39:06 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71Jd4IY025126
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:39:04 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 564701969148
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:40:17 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id ZfNPWglSUvzbnPnl for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:40:17 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:40:19 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/21] implement generic xfs_btree_decrement
Message-ID: <20080801194019.GD1263@lst.de>
References: <20080729193058.GK19104@lst.de> <20080730020919.GK13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730020919.GK13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 12:09:19PM +1000, Dave Chinner wrote:
> On Tue, Jul 29, 2008 at 09:30:58PM +0200, Christoph Hellwig wrote:
> > From: Dave Chinner <dgc@sgi.com>
> > 
> > [hch: split out from bigger patch and minor adaptions]
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> ....
> > +	/*
> > +	 * If we went off the root then we are seriously confused.
> > +	 * or the root of the tree is in an inode.
> > +	 */
> > +	if (lev == cur->bc_nlevels) {
> > +		ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
> > +		goto out0;
> > +	}
> 
> Same question as for the increment case.

Ok, changed.
