Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8AIqeH2123005 for <xfs@oss.sgi.com>; Sat, 10 Sep 2011 13:52:41 -0500
Date: Sat, 10 Sep 2011 14:52:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 15/25] xfs: pass bmalloca structure to xfs_bmap_isaeof
Message-ID: <20110910185238.GB4750@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060643.660514652@bombadil.infradead.org>
	<1315612556.1999.130.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315612556.1999.130.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Fri, Sep 09, 2011 at 06:55:56PM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> > All the variables xfs_bmap_isaeof() is passed are contained within
> > the xfs_bmalloca structure. Pass that instead.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> This looks good.
> 
> Now that the transaction pointer is available in
> xfs_bmap_isaeof(), it gets used in the call to
> xfs_bmap_last_extent().  It looks to me like
> this means btree block buffers will be added to
> and removed from the transaction's item list
> in xfs_bmap_read_extents(), and that list will
> be scanned for these buffers in xfs_trans_read_buf()
> (unlike before).
> 
> I don't question whether that's correct, but
> is that desirable?  Would we be just as well
> off *not* providing the transaction pointer?

We shouldn't do it, if just to avoid random changes in this patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
