Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 12:43:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m71Jhdh8026218
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 12:43:39 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D7BEEECE8D
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 12:44:51 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id kn13qPxLKWg7KvlN for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 12:44:51 -0700 (PDT)
Date: Fri, 1 Aug 2008 21:44:52 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/21] implement generic xfs_btree_updkey
Message-ID: <20080801194452.GF1263@lst.de>
References: <20080729193110.GM19104@lst.de> <20080730050936.GM13395@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730050936.GM13395@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Wed, Jul 30, 2008 at 03:09:36PM +1000, Dave Chinner wrote:
> > +	int			ptr;
> > +#ifdef DEBUG
> > +	int			error;
> > +#endif
> 
> This can be scoped inside the for loop.

Done.

> And even then I think we might not need an error variable - it can
> only return EFSCORRUPTED, so:
> 
> #ifdef DEBUG
> 		if (xfs_btree_check_block(cur, block, level, bp)) {
> 			XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
> 			return EFSCORRUPTED;
> 		}
> #endif
> 
> Would remove the need for the error variable.

I'm not a big fan of losing detailed error information.  Depending
on how the bigger btree blocks work out we might return other errors
here in the near future.
