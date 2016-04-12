Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 57F287CA7
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 00:29:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3B07AC001
	for <xfs@oss.sgi.com>; Mon, 11 Apr 2016 22:29:46 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id xuUivuRTlFZcrD4s (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Apr 2016 22:29:43 -0700 (PDT)
Date: Mon, 11 Apr 2016 22:29:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: bmap btree changes should update rmap btree
Message-ID: <20160412052938.GB11156@birch.djwong.org>
References: <1459201425-31773-1-git-send-email-david@fromorbit.com>
	<20160411233407.GA7967@birch.djwong.org>
	<20160412000901.GI567@dastard>
	<20160412011626.GA11156@birch.djwong.org>
	<20160412024135.GF9088@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160412024135.GF9088@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <xfs@oss.sgi.com>

On Tue, Apr 12, 2016 at 12:41:35PM +1000, Dave Chinner wrote:
> On Mon, Apr 11, 2016 at 06:16:26PM -0700, Darrick J. Wong wrote:
> > [should have kicked this onto the lists...]
> > > > This needs to be list_add_tail so that the rmap operations happen in order.
> > > 
> > > Ah, no, it doesn't. The list_sort() before we process it destroys
> > > any order we create here.
> > 
> > I think list_sort() is supposed to maintain list order if the compare fn
> > returns zero.  From lib/list_sort.c:
> > 
> > /*
> > <snip>
> >  * The comparison function @cmp must return a negative value if @a
> >  * should sort before @b, and a positive value if @a should sort after
> >  * @b. If @a and @b are equivalent, and their original relative
> >  * ordering is to be preserved, @cmp must return 0.
> >  */
> > 
> > From my (admittedly flimsy) testing of list_sort() it looks like it does
> > preserve the order of rmap_intents that have the same agno.  I looked at
> > the source code and I think that assertion should hold.
> 
> If what I did is maintaining order, then it's simply by chance, not
> intent.  :/

:)

I guess the scary part is what if list_sort ever fails to maintain order
amongst the cmp() == 0 items, but I'll put in a generous HBD note before
the list_add_tail and the list_sort.

> > > > we do a collapse range of 2 blocks at offset 32, say, then we end up with
> > > > unmap($pblk, $ino, 32, 16) and map($pblk-2, $ino, 30, 16) in the deferred list.
> > > > We don't want the map to happen before the unmap because that results in two
> > > > rmaps covering the same range of logical offset, which causes problems in
> > > > generic/145.
> > 
> > I forgot to mention this, but the ordering requirement only applies within a
> > single rmapbt -- if the map/unmap operations apply to different AGs, no
> > confusion will result from out-of-order execution.
> 
> *nod*
> 
> > > I'd suggest that the list_sort compare function could take this into
> > > account, and order overlapping operations appropriately (e.g. unmap
> > > before map). You could even put a sequence number in the rmap list
> > > entry so that when sorting we know what order they were added to the
> > > rmap list and then overlaps could be resolved in the sort function
> > > easily...
> > 
> > I /think/ we're fine with just the list_add_tail...
> 
> Yeah, it seems that way, but it'll need "here be dragons" comment
> around it...

Will do.

> > ...if not, /me wonders if we could skip the list_sort and just roll the
> > transaction every time we have to go from a higher AG to a lower AG.  I think
> > the rmap update intent log items will help us to redo the metadata operations
> > if we crash.
> 
> I think that would work, but we want to keep the number of
> transactions to a minimum. Trying to keep everything grouped by AG
> definitely helps wiht that. What would be nice to know is how many
> operations we are expecting to see here will actually have extents
> from multiple AGs in them, and hence how many transactions are the
> likely common case...

Ok, I'll add some instrumentation so I can keep tabs on the number of
intents per freelist and the number of AGs that get touched per freelist.
My current guess is that we usually only have one or two rmaps to update
per transaction.

(I'm not even sure doing a xfs_trans_roll per AG is necessary; so far in my
testing I've never come close to exceeding the log reservation for the rmap
step.  But that's before we start logging rmap intents. :))

Ok sleep now.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
