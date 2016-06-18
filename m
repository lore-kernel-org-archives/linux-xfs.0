Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DD00F7CA0
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 15:15:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49451AC004
	for <xfs@oss.sgi.com>; Sat, 18 Jun 2016 13:15:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qP0wyjJEByWKjNOW (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 18 Jun 2016 13:15:43 -0700 (PDT)
Date: Sat, 18 Jun 2016 13:15:10 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 009/119] xfs: convert list of extents to free into a
	regular list
Message-ID: <20160618201509.GA5042@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
	<20160617115930.GH19042@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617115930.GH19042@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Fri, Jun 17, 2016 at 04:59:30AM -0700, Christoph Hellwig wrote:
> >  {
> > +	struct xfs_bmap_free_item	*new;		/* new element */
> >  #ifdef DEBUG
> >  	xfs_agnumber_t		agno;
> >  	xfs_agblock_t		agbno;
> > @@ -597,17 +595,7 @@ xfs_bmap_add_free(
> >  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
> >  	new->xbfi_startblock = bno;
> >  	new->xbfi_blockcount = (xfs_extlen_t)len;
> > +	list_add(&new->xbfi_list, &flist->xbf_flist);
> >  	flist->xbf_count++;
> 
> Please kill xbf_count while you're at it, it's entirely superflous.

The deferred ops conversion patch kills this off by moving the whole
"defer an op to the next transaction by logging redo items" logic
into a separate file and mechanism.

This patch is just a cleanup to reduce some of the open coded list ugliness
before starting on the rmap stuff.  Once the deferred ops code lands, all
three of these functions go away.

> > @@ -617,14 +605,10 @@ xfs_bmap_add_free(
> >   */
> >  void
> >  xfs_bmap_del_free(
> > -	xfs_bmap_free_t		*flist,	/* free item list header */
> > -	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
> > -	xfs_bmap_free_item_t	*free)	/* list item to be freed */
> > +	struct xfs_bmap_free		*flist,	/* free item list header */
> > +	struct xfs_bmap_free_item	*free)	/* list item to be freed */
> 
> Which then also gets rid of the flist argument here.
> 
> > @@ -634,17 +618,16 @@ xfs_bmap_del_free(
> >   */
> >  void
> >  xfs_bmap_cancel(
> > +	struct xfs_bmap_free		*flist)	/* list of bmap_free_items */
> >  {
> > +	struct xfs_bmap_free_item	*free;	/* free list item */
> >  
> >  	if (flist->xbf_count == 0)
> >  		return;
> > +	while (!list_empty(&flist->xbf_flist)) {
> > +		free = list_first_entry(&flist->xbf_flist,
> > +				struct xfs_bmap_free_item, xbfi_list);
> 
> 	while ((free = list_first_entry_or_null(...))
> 
> > +	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);
> 
> Can you add a comment on why we are sorting the list?

We sort the list so that we process the freed extents in AG order to
avoid deadlocking.

I'll add a comment to the deferred ops code if there isn't one already.

--D

> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
