Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HHcQ27099561 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 11:38:26 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	03sBXpWdjuCDIBMp (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 09:38:25 -0800 (PST)
Date: Fri, 17 Feb 2012 12:38:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfs: use per-filesystem radix trees for dquot lookup
Message-ID: <20120217173824.GC21796@infradead.org>
References: <20120215022926.577682146@bombadil.infradead.org>
	<20120215023147.038502020@bombadil.infradead.org>
	<20120215222111.GN14132@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120215222111.GN14132@dastard>
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

On Thu, Feb 16, 2012 at 09:21:11AM +1100, Dave Chinner wrote:
> qi->qi_tree_lock, as the local variable is already set up.

Indeed.

> > +	struct radix_tree_root *tree = XFS_DQUOT_TREE(mp, type);
> > +	struct xfs_dquot	*dqp;
> > +	int			error;
> 
> Add a quotainfo local variable and use it in the function?

Yes, that's a good idea.

> qi->qi_tree_lock as it is already there and used for all the other
> quotainfo references.

Indeed.

I've fixed all these up, and also changed the XFS_DQUOT_TREE macro
to take a quotainfo pointer instead of a mount pointer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
