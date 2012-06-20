Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K75mf0255218 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 02:05:48 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3cAJFPEqcHP4NJxB (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 00:05:47 -0700 (PDT)
Date: Wed, 20 Jun 2012 03:05:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/9] xfs: struct xfs_buf_log_format isn't variable sized.
Message-ID: <20120620070546.GA8099@infradead.org>
References: <1339133914-11148-1-git-send-email-david@fromorbit.com>
	<1339133914-11148-6-git-send-email-david@fromorbit.com>
	<20120620063612.GB5467@infradead.org>
	<20120620070147.GH30705@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120620070147.GH30705@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 05:01:47PM +1000, Dave Chinner wrote:
> On Wed, Jun 20, 2012 at 02:36:12AM -0400, Christoph Hellwig wrote:
> > I like this patch with two minor nitpicks below.  Given that it's a mostly
> > unrelated cleanup I'd also propagate it to the first patch in the
> > series.
> 
> it's not unrelated - it makes the multiple buffer support so much
> easier to implement it's not funny....

Well, not entirely unrelated, but defintively a separate cleanup that
helpers later on.  I usually try to have these first in the series.

> XFS_MAX_BLOCKSIZE is now needed xfs_buf_item.h, so rather than
> introduce a dependency on xfs_alloc_btree.h, I moved them to where
> the other limits are defined (i.e. xfs_types.h).

Ok.  Please add a short blurb on this to the commit message.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
