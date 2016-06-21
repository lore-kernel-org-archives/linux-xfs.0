Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DB8D7CA7
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 19:57:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 301A2304032
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 17:57:17 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	I935urc9xf6yP5jy for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 17:57:14 -0700 (PDT)
Date: Tue, 21 Jun 2016 10:57:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 009/119] xfs: convert list of extents to free into a
	regular list
Message-ID: <20160621005712.GN26977@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612632997.12839.18026491074892368053.stgit@birch.djwong.org>
	<20160617115930.GH19042@infradead.org>
	<20160618201509.GA5042@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618201509.GA5042@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, vishal.l.verma@intel.com

On Sat, Jun 18, 2016 at 01:15:10PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 17, 2016 at 04:59:30AM -0700, Christoph Hellwig wrote:
> > >  {
> > > +	struct xfs_bmap_free_item	*new;		/* new element */
> > >  #ifdef DEBUG
> > >  	xfs_agnumber_t		agno;
> > >  	xfs_agblock_t		agbno;
> > > @@ -597,17 +595,7 @@ xfs_bmap_add_free(
> > >  	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
> > >  	new->xbfi_startblock = bno;
> > >  	new->xbfi_blockcount = (xfs_extlen_t)len;
> > > +	list_add(&new->xbfi_list, &flist->xbf_flist);
> > >  	flist->xbf_count++;
> > 
> > Please kill xbf_count while you're at it, it's entirely superflous.
> 
> The deferred ops conversion patch kills this off by moving the whole
> "defer an op to the next transaction by logging redo items" logic
> into a separate file and mechanism.
> 
> This patch is just a cleanup to reduce some of the open coded list ugliness
> before starting on the rmap stuff.  Once the deferred ops code lands, all
> three of these functions go away.

Ok, so because all these functions go away, I'll take this patch now
without the suggested cleanups so that you don't have to rework it.

....

> > > +	list_sort((*tp)->t_mountp, &flist->xbf_flist, xfs_bmap_free_list_cmp);
> > 
> > Can you add a comment on why we are sorting the list?
> 
> We sort the list so that we process the freed extents in AG order to
> avoid deadlocking.
> 
> I'll add a comment to the deferred ops code if there isn't one already.

This seems best - add the clean up to the later patches rather than
have to rework lots of patches because of minor mods to early
patches...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
