Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C51E27CB2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 18:26:52 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 82F83304039
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2016 16:26:52 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	DmsgHsScKV8ufGxW for <xfs@oss.sgi.com>;
	Wed, 10 Feb 2016 16:26:49 -0800 (PST)
Date: Thu, 11 Feb 2016 11:26:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/8] xfs: don't chain ioends during writepage submission
Message-ID: <20160211002647.GT14668@dastard>
References: <1455094043-9694-1-git-send-email-david@fromorbit.com>
	<1455094043-9694-7-git-send-email-david@fromorbit.com>
	<20160210113609.GC15221@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160210113609.GC15221@infradead.org>
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
Cc: xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 03:36:09AM -0800, Christoph Hellwig wrote:
> > -STATIC void
> > +STATIC int
> >  xfs_submit_ioend(
> >  	struct writeback_control *wbc,
> >  	xfs_ioend_t		*ioend,
> >  	int			fail)
> 
> No that almost all of the function is rewritten can you rename
> fail to error or status?  fail always suggests a boolean to me and
> is rather confusing.

*nod*

> > + * Return the ioend we finished off so that the caller can submit it
> > + * once it has finished processing the dirty page.
> >   */
> > -STATIC void
> > +STATIC struct xfs_ioend *
> >  xfs_add_to_ioend(
> >  	struct inode		*inode,
> >  	struct buffer_head	*bh,
> >  	xfs_off_t		offset,
> >  	struct xfs_writepage_ctx *wpc)
> >  {
> > +	struct xfs_ioend	*prev = NULL;
> > +
> >  	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
> >  	    bh->b_blocknr != wpc->last_block + 1) {
> >  		struct xfs_ioend	*new;
> >  
> > +		prev = wpc->ioend;
> 
> Looking at the new list_head based code it might be either to just
> pass in a pointer to the submit_list and just add the previous ioend
> here directly.

OK.

> >  	ret = xfs_do_writepage(page, wbc, &wpc);
> > -	return xfs_writepage_submit(&wpc, wbc, ret);
> > +	if (wpc.ioend)
> > +		xfs_submit_ioend(wbc, wpc.ioend, ret);
> > +	return ret;
> >  }
> >  
> >  STATIC int
> > @@ -1019,7 +1022,9 @@ xfs_vm_writepages(
> >  
> >  	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
> >  	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
> > -	return xfs_writepage_submit(&wpc, wbc, ret);
> > +	if (wpc.ioend)
> > +		xfs_submit_ioend(wbc, wpc.ioend, ret);
> > +	return ret;
> 
> And this is where ignoreing the xfs_setfilesize_trans_alloc errors
> reappears after a previous patch mostly fixed it up.

will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
