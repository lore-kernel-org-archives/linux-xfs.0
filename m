Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o46Npt8w137294 for <xfs@oss.sgi.com>; Thu, 6 May 2010 18:51:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C483136DE43
	for <xfs@oss.sgi.com>; Thu,  6 May 2010 16:54:04 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	oFMA5tk8poayg6jb for <xfs@oss.sgi.com>;
	Thu, 06 May 2010 16:54:04 -0700 (PDT)
Date: Fri, 7 May 2010 09:54:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/11] xfs: delayed logging
Message-ID: <20100506235401.GD19579@dastard>
References: <1273110351-2333-1-git-send-email-david@fromorbit.com>
	<20100506132641.GC19579@dastard>
	<20100506191218.GA18555@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100506191218.GA18555@infradead.org>
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

On Thu, May 06, 2010 at 03:12:18PM -0400, Christoph Hellwig wrote:
> > Secondly, for delayed logging only, matching by transaction
> > structure address triggers the failure because busy extents
> > have a much longer life than the transaction structure. It is clear
> > why the transaction ID matching didn't trip over - it would have
> > triggered a log force in this situation, and hence blocked until
> > the checkpoint that fs_mark-2742 had triggered was complete before
> > redoing the rbtree insert.
> 
> True, the busy extents get spliced over to the cil context, so they
> outlive the transaction structure.
> 
> > Right now I'm simply going to go back to using the transaction ID
> > for matching transactions, even though the above analysis points out
> > that even that is not as efficient as it could be for delayed
> > logging. That is, we don't even need to force the log or have a
> > synchronous transaction if the extent was first freed in the current
> > checkpoint seqeunce. Doing that, however, requires pinning the
> > checkpoint sequence (i.e. preventing a flush) until the current
> > transaction commits. While that is in the plan for delayed logging,
> > it is future functionality and hence I'm not going to attempt to
> > design and implement it this close to 2.6.35-rc cycle. [*]
> 
> Sounds fine to me.  I'm not a fan of exporting the tid, but it
> seems like there's no good way around it for now.  Please make the
> tid exporting a separate changeset so that it's easily revertable
> once this is sorted out.

Yeah, that's a good idea.

> And documenting all this in comments in the code so that it's archived
> would be very useful!

Will do. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
