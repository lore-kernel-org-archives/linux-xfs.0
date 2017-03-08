Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56352 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751975AbdCHR2W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 12:28:22 -0500
Date: Wed, 8 Mar 2017 18:18:59 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: try any AG when allocating the first btree block
        when reflinking
Message-ID: <20170308171859.GA27174@lst.de>
References: <20170308161315.11444-1-hch@lst.de> <20170308170701.GM5280@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308170701.GM5280@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Mar 08, 2017 at 09:07:01AM -0800, Darrick J. Wong wrote:
> > +	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
> > +		xfs_iroot_realloc(ip, -1, whichfork);
> > +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > +		return -ENOMEM;
> 
> ENOSPC?

Yeah.

> > +	}
> >  	/*
> >  	 * Allocation can't fail, the space was reserved.
> >  	 */
> 
> Can we get rid of the ASSERT(args.fsbno != NULLFSBLOCK); just below here
> now that we jump out above?

Sure.

> 
> Conceptually I guess it's ok for now until we separate out the uses of
> *firstblock to stay ahead of locking rules vs. *firstblock to remap
> things.  Hmm, I'll try to make a first stab at that today.

I've been working on that for a while - the problem is that it goes
up a few layers, including xfs_bmapi_write and the da_args structures.

Give me a little more time and I should have a series for you.
