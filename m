Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:20649 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753789AbdCHTnb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Mar 2017 14:43:31 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v28IKiud015891
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 8 Mar 2017 18:20:45 GMT
Date: Wed, 8 Mar 2017 10:19:37 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: try any AG when allocating the first btree block
 when reflinking
Message-ID: <20170308181937.GP5280@birch.djwong.org>
References: <20170308161315.11444-1-hch@lst.de>
 <20170308170701.GM5280@birch.djwong.org>
 <20170308171859.GA27174@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170308171859.GA27174@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2017 at 06:18:59PM +0100, Christoph Hellwig wrote:
> On Wed, Mar 08, 2017 at 09:07:01AM -0800, Darrick J. Wong wrote:
> > > +	if (WARN_ON_ONCE(args.fsbno == NULLFSBLOCK)) {
> > > +		xfs_iroot_realloc(ip, -1, whichfork);
> > > +		xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
> > > +		return -ENOMEM;
> > 
> > ENOSPC?
> 
> Yeah.
> 
> > > +	}
> > >  	/*
> > >  	 * Allocation can't fail, the space was reserved.
> > >  	 */
> > 
> > Can we get rid of the ASSERT(args.fsbno != NULLFSBLOCK); just below here
> > now that we jump out above?
> 
> Sure.
> 
> > 
> > Conceptually I guess it's ok for now until we separate out the uses of
> > *firstblock to stay ahead of locking rules vs. *firstblock to remap
> > things.  Hmm, I'll try to make a first stab at that today.
> 
> I've been working on that for a while - the problem is that it goes
> up a few layers, including xfs_bmapi_write and the da_args structures.
> 
> Give me a little more time and I should have a series for you.

Ok.

--D

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
