Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N0dKMq091778 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 19:39:21 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97B8B93E3A
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 17:40:14 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	CoLLYjxYLpS9PMU1 for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 17:40:14 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:40:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
Message-ID: <20100923004012.GK2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
	<20100922173306.GE5697@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922173306.GE5697@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Sep 22, 2010 at 01:33:06PM -0400, Christoph Hellwig wrote:
> > +	int			(*grab)(struct xfs_inode *ip),
> 
> I think we can do without this callback.  The inode verification that
> needs to be done is always the same.  The only difference is that the
> dqrele code skips the quota inodes - but this can easily be done in
> the execute callback, and given that it's a slow path the additional
> two igrab calls won't hurt either.

Seems fair - the grab callback is from the first version where the
reclaim walk was not split out so there was significant differences.
I'll clean that up.

> To be symmetic with that the IRELE call should also be moved from the
> execute callbacks into the caller.  All this is stuff enabled by
> splitting out the reclaim code earlier which was pretty different in
> this area.  In fact just moving the validation + igrab and IRELE into
> common code might just be done in a separate patch between the last one
> and this.

Yup, that makes it a lot cleaner. Will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
