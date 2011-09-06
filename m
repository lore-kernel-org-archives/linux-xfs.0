Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p86BqVuR076019 for <xfs@oss.sgi.com>; Tue, 6 Sep 2011 06:52:31 -0500
Date: Tue, 6 Sep 2011 07:52:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/25] xfs: remove the first extent special case in
	xfs_bmap_add_extent
Message-ID: <20110906115226.GA12931@infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060640.399504409@bombadil.infradead.org>
	<1315002176.2069.81.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1315002176.2069.81.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Sep 02, 2011 at 05:22:56PM -0500, Alex Elder wrote:
> On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> > Both xfs_bmap_add_extent_hole_delay and xfs_bmap_add_extent_hole_real
> > already contain code to handle the case where there is no extent to
> > merge with, which is effectively the same as the code duplicated here.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> It looks like an attribute fork will never get a delayed
> allocation extent assigned to it.  At least I assume so,
> because xfs_bmap_add_extent_hole_delay() only ever works
> on the data fork.  (I didn't know that.)

Yes, we only use delayed allocation for file data.  The same is
also true for unwritten extents.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
