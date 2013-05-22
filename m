Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0462929DF8
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 18:54:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C728B304032
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 16:54:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zLC8B9EdTTqcLH3N for <xfs@oss.sgi.com>;
	Wed, 22 May 2013 16:54:52 -0700 (PDT)
Date: Thu, 23 May 2013 09:54:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 06/11] xfs: fully initialise temp leaf in
	xfs_attr3_leaf_unbalance
Message-ID: <20130522235450.GO29466@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-7-git-send-email-david@fromorbit.com>
	<20130522205059.GP20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522205059.GP20028@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, May 22, 2013 at 03:50:59PM -0500, Ben Myers wrote:
> On Tue, May 21, 2013 at 06:02:05PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_attr3_leaf_unbalance() uses a temporary buffer for recombining
> > the entries in two leaves when the destination leaf requires
> > compaction. The temporary buffer ends up being copied back over the
> > original destination buffer, so the header in the temporary buffer
> > needs to contain all the information that is in the destination
> > buffer.
> > 
> > To make sure the temporary buffer is fully initialised, once we've
> > set up the temporary incore header appropriately, write is back to
> > the temporary buffer before starting to move entries around.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >
> > ---
> >  fs/xfs/xfs_attr_leaf.c |   16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> > index 0bce1b3..79ece72 100644
> > --- a/fs/xfs/xfs_attr_leaf.c
> > +++ b/fs/xfs/xfs_attr_leaf.c
> > @@ -2181,14 +2181,24 @@ xfs_attr3_leaf_unbalance(
> >  		struct xfs_attr_leafblock *tmp_leaf;
> >  		struct xfs_attr3_icleaf_hdr tmphdr;
> >  
> > -		tmp_leaf = kmem_alloc(state->blocksize, KM_SLEEP);
> > -		memset(tmp_leaf, 0, state->blocksize);
> > -		memset(&tmphdr, 0, sizeof(tmphdr));
> > +		tmp_leaf = kmem_zalloc(state->blocksize, KM_SLEEP);
> > +
> > +		/*
> > +		 * Copy the header into the temp leaf so that all the stuff
> > +		 * not in the incore header is present and gets copied back in
> > +		 * once we've moved all the entries.
> > +		 */
> > +		memcpy(tmp_leaf, save_leaf, xfs_attr3_leaf_hdr_size(save_leaf));
> >  
> > +		memset(&tmphdr, 0, sizeof(tmphdr));
> >  		tmphdr.magic = savehdr.magic;
> >  		tmphdr.forw = savehdr.forw;
> >  		tmphdr.back = savehdr.back;
> >  		tmphdr.firstused = state->blocksize;
> > +
> > +		/* write the header to the temp buffer to initialise it */
> > +		xfs_attr3_leaf_hdr_to_disk(tmp_leaf, &tmphdr);
> > +
> 
> Hrm.  It seemed like the memset 0 for the incore temp header should have been
> enough for the purposes of moveents.  Why did you have to add this additional
> hdr_to_disk?

Because we've modified the tmphdr so it is different to what is in
the tmp_leaf, and I'm being paranoid and not making any assumptions
that a callee doesn't reread the tmphdr from the tmp_leaf.

i.e. I'm initialising both the on-disk and the incore headers to
be identical before we do anything else. Once bitten, twice shy.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
