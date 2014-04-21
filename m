Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 535BC7F3F
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 18:14:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2720E8F8066
	for <xfs@oss.sgi.com>; Mon, 21 Apr 2014 16:14:15 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ZTDWEy6vz0t6iou3 for <xfs@oss.sgi.com>;
	Mon, 21 Apr 2014 16:14:13 -0700 (PDT)
Date: Tue, 22 Apr 2014 09:14:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] db: verify buffer on type change
Message-ID: <20140421231402.GC18672@dastard>
References: <1397550301-31883-1-git-send-email-david@fromorbit.com>
	<1397550301-31883-3-git-send-email-david@fromorbit.com>
	<20140421070252.GD20384@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140421070252.GD20384@infradead.org>
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

On Mon, Apr 21, 2014 at 12:02:52AM -0700, Christoph Hellwig wrote:
> > +void
> > +set_iocur_type(
> > +	const typ_t	*t)
> > +{
> > +	const struct xfs_buf_ops *ops = t ? t->bops : NULL;
> > +	struct xfs_buf	*bp = iocur_top->bp;
> > +
> > +	iocur_top->typ = t;
> > +
> > +	/* verify the buffer if the type has one. */
> > +	if (!bp)
> > +		return;
> > +	if (!ops) {
> > +		bp->b_ops = NULL;
> > +		bp->b_flags |= LIBXFS_B_UNCHECKED;
> > +		return;
> > +	}
> 
> The only caller currently makes sure we never pass a NULL t argument,
> and I think keeping it that way is sensible.  If we want to allow
> clearing the type we should add a separate clear_iocur_type helper for
> it.

Ok, I'll clear the conditional initialisation of *ops.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
