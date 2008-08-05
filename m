Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Aug 2008 17:25:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m750Owv0018801
	for <xfs@oss.sgi.com>; Mon, 4 Aug 2008 17:24:59 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 307B5F027BF
	for <xfs@oss.sgi.com>; Mon,  4 Aug 2008 17:26:12 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id TijMNu21BMH2UwXg for <xfs@oss.sgi.com>; Mon, 04 Aug 2008 17:26:12 -0700 (PDT)
Date: Tue, 5 Aug 2008 10:26:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/26] generic btree implementation, version 3
Message-ID: <20080805002607.GJ6119@disturbed>
References: <20080804013158.GA8819@lst.de> <20080804015425.GE6119@disturbed> <20080804142131.GA9892@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804142131.GA9892@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Mon, Aug 04, 2008 at 04:21:32PM +0200, Christoph Hellwig wrote:
> On Mon, Aug 04, 2008 at 11:54:25AM +1000, Dave Chinner wrote:
> > > I'm not sure
> > > what to do with move_* - these are the most ugly helpers, so maybe
> > > we should just make them memmove wrappers in the style of copy_
> > > and leave all addressing to the callers.
> > 
> > Yes, it would be nice to have them use the same interface. If
> > we do that, then there's no real point for having a copy vs move
> > distinction - we could just make everything use the
> > memmove version and drop one of the interfaces altogether....
> 
> I've actually come up with another variant.  Since what we do in the
> memmove case is to move a number of entries in a single block up or down
> one position I've added the following helper:
> 
> STATIC void
> xfs_btree_shift_keys(
> 	struct xfs_btree_cur    *cur,
> 	union xfs_btree_key     *key
> 	int                     dir,
> 	int                     numkeys)
> {
> 	char			*dst_key;
> 
> 	ASSERT(numkeys >= 0);
> 	ASSERT(dir == 1 || dir == -1);
> 
> 	dst_key = (char *)key + (dir * cur->bc_ops->key_len);
> 	memmove(dst_key, key, numkeys * cur->bc_ops->key_len);
> }
> 
> and the same for ptrs and recs.  This follows the original code in
> spirit and is quite readable.

Nice. That fits nicely into the 'make a hole' or 'fill a hole' parts
of various functions which will remove a lot of magic from them.
The only thing I'd do is add an enum for the direction so the
callers are self-documenting as to the direction of the shift....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
