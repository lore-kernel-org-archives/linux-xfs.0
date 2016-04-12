Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DDB237CA2
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 21:50:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A1931304066
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 19:50:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	jEgZFKXYK9VKNJ2K for <xfs@oss.sgi.com>;
	Mon, 11 Apr 2016 19:50:14 -0700 (PDT)
Date: Tue, 12 Apr 2016 12:41:35 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: bmap btree changes should update rmap btree
Message-ID: <20160412024135.GF9088@dastard>
References: <1459201425-31773-1-git-send-email-david@fromorbit.com>
	<20160411233407.GA7967@birch.djwong.org>
	<20160412000901.GI567@dastard>
	<20160412011626.GA11156@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412011626.GA11156@birch.djwong.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <xfs@oss.sgi.com>

On Mon, Apr 11, 2016 at 06:16:26PM -0700, Darrick J. Wong wrote:
> [should have kicked this onto the lists...]
> > > This needs to be list_add_tail so that the rmap operations happen in order.
> > 
> > Ah, no, it doesn't. The list_sort() before we process it destroys
> > any order we create here.
> 
> I think list_sort() is supposed to maintain list order if the compare fn
> returns zero.  From lib/list_sort.c:
> 
> /*
> <snip>
>  * The comparison function @cmp must return a negative value if @a
>  * should sort before @b, and a positive value if @a should sort after
>  * @b. If @a and @b are equivalent, and their original relative
>  * ordering is to be preserved, @cmp must return 0.
>  */
> 
> From my (admittedly flimsy) testing of list_sort() it looks like it does
> preserve the order of rmap_intents that have the same agno.  I looked at
> the source code and I think that assertion should hold.

If what I did is maintaining order, then it's simply by chance, not
intent.  :/

> > > we do a collapse range of 2 blocks at offset 32, say, then we end up with
> > > unmap($pblk, $ino, 32, 16) and map($pblk-2, $ino, 30, 16) in the deferred list.
> > > We don't want the map to happen before the unmap because that results in two
> > > rmaps covering the same range of logical offset, which causes problems in
> > > generic/145.
> 
> I forgot to mention this, but the ordering requirement only applies within a
> single rmapbt -- if the map/unmap operations apply to different AGs, no
> confusion will result from out-of-order execution.

*nod*

> > I'd suggest that the list_sort compare function could take this into
> > account, and order overlapping operations appropriately (e.g. unmap
> > before map). You could even put a sequence number in the rmap list
> > entry so that when sorting we know what order they were added to the
> > rmap list and then overlaps could be resolved in the sort function
> > easily...
> 
> I /think/ we're fine with just the list_add_tail...

Yeah, it seems that way, but it'll need "here be dragons" comment
around it...

> ...if not, /me wonders if we could skip the list_sort and just roll the
> transaction every time we have to go from a higher AG to a lower AG.  I think
> the rmap update intent log items will help us to redo the metadata operations
> if we crash.

I think that would work, but we want to keep the number of
transactions to a minimum. Trying to keep everything grouped by AG
definitely helps wiht that. What would be nice to know is how many
operations we are expecting to see here will actually have extents
from multiple AGs in them, and hence how many transactions are the
likely common case...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
