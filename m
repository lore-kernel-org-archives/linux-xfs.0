Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A56AB7F59
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 18:03:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D430AC014
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2014 16:03:46 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fpx1C09lJGv0X3l7 for <xfs@oss.sgi.com>;
	Wed, 23 Apr 2014 16:03:44 -0700 (PDT)
Date: Thu, 24 Apr 2014 08:58:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 17/20] xfsprogs/repair: helpers for finding in-core
	inode records w/ free inodes
Message-ID: <20140423225832.GT15995@dastard>
References: <1397146270-42993-1-git-send-email-bfoster@redhat.com>
	<1397146270-42993-18-git-send-email-bfoster@redhat.com>
	<20140423062443.GP15995@dastard>
	<20140423200216.GF5225@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140423200216.GF5225@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 23, 2014 at 04:02:16PM -0400, Brian Foster wrote:
> On Wed, Apr 23, 2014 at 04:24:43PM +1000, Dave Chinner wrote:
> > On Thu, Apr 10, 2014 at 12:11:07PM -0400, Brian Foster wrote:
> > > Add the findfirst_free_inode_rec() and next_free_ino_rec() helpers
> > > to assist scanning the in-core inode records for records with at
> > > least one free inode. These will be used to determine what records
> > > are included in the free inode btree.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  repair/incore.h | 27 +++++++++++++++++++++++++++
> > >  1 file changed, 27 insertions(+)
> > > 
> > > diff --git a/repair/incore.h b/repair/incore.h
> > > index 5419884..5f8c188 100644
> > > --- a/repair/incore.h
> > > +++ b/repair/incore.h
> > > @@ -381,6 +381,33 @@ void			clear_uncertain_ino_cache(xfs_agnumber_t agno);
> > >  		((ino_tree_node_t *) ((ino_node_ptr)->avl_node.avl_forw))
> > >  
> > >  /*
> > > + * finobt helpers
> > > + */
> > > +static inline ino_tree_node_t *
> > > +findfirst_free_inode_rec(xfs_agnumber_t agno)
> > > +{
> > > +	ino_tree_node_t *ino_rec;
> > > +
> > > +	ino_rec = findfirst_inode_rec(agno);
> > > +
> > > +	while (ino_rec && !ino_rec->ir_free)
> > > +		ino_rec = next_ino_rec(ino_rec);
> > > +
> > > +	return ino_rec;
> > > +}
> > > +
> > > +static inline ino_tree_node_t *
> > > +next_free_ino_rec(ino_tree_node_t *ino_rec)
> > > +{
> > > +	ino_rec = next_ino_rec(ino_rec);
> > > +
> > > +	while (ino_rec && !ino_rec->ir_free)
> > > +		ino_rec = next_ino_rec(ino_rec);
> > > +
> > > +	return ino_rec;
> > > +}
> > 
> > That looks a bit inefficient - walking the list of inode records to
> > find the next one with free inodes. Perhaps we woul dbe better
> > served by adding a new list for inode records with free entries and
> > walking that instead?
> > 
> > Iknow, it's a memory vs speed tradeoff, but if we've got millions of
> > inodes and very few free, the difference could be very significant.
> > 
> 
> Hmm, perhaps. The ino_tree_node_t structure is 104 bytes according to
> pahole. With 64 inodes per node, 1 billion inodes would turn into around
> 15 million of these structures. If I write a dumb little program to
> allocate, initialize and iterate 15 million ~100 byte structures
> (accessing the structure beginning and end), it uses ~1.8GB RAM and runs
> in under 5 seconds. If I increase that to 30 million, it allocates
> ~3.5GB RAM, triggers kswapd (4GB RAM VM) and seems to run anywhere from
> 30s to 1m30s.
>
> All of that probably doesn't mean that much in the context of repair, I
> guess. ;)

*nod*

Repair does more than this between searches (so TLB pressure will be
different), some CPUs have prefetchers that detect pointer chasing
like this, some systems have remote (hence slower) memory. Hence
testing in isolation doesn't necessarily give an accurate picture...

> I'll have to experiment a bit more with this and, at minimum,
> I'll include some data in my next rev. FWIW, if it is a problem I'd
> probably approach this as an additional optimization patch rather than
> rework this one. I also note that we already do multiple scans of the
> inode record list (e.g., cursor initialization), so we might be able to
> buy back some of whatever the finobt degradation is by condensing the
> cursor initialization scans.

Yup, doing it as an additional patch if it is necessary sounds like
a good plan to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
