Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 266897CA4
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 19:47:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95821AC001
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 17:47:38 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2nBMjmLsVm8B1U7e for <xfs@oss.sgi.com>;
	Mon, 20 Jun 2016 17:47:34 -0700 (PDT)
Date: Tue, 21 Jun 2016 10:47:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 004/119] xfs: enable buffer deadlock postmortem diagnosis
	via ftrace
Message-ID: <20160621004731.GL26977@dastard>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612629822.12839.7938642541078923297.stgit@birch.djwong.org>
	<20160617113423.GC19042@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160617113423.GC19042@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Jun 17, 2016 at 04:34:23AM -0700, Christoph Hellwig wrote:
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index efa2a73..2333db7 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -947,7 +947,8 @@ xfs_buf_trylock(
> >  	if (locked)
> >  		XB_SET_OWNER(bp);
> >  
> > -	trace_xfs_buf_trylock(bp, _RET_IP_);
> > +	locked ? trace_xfs_buf_trylock(bp, _RET_IP_) :
> > +		 trace_xfs_buf_trylock_fail(bp, _RET_IP_);
> >  	return locked;
> 
> I think this should be something like:
> 
> 	if (locked) {
> 		XB_SET_OWNER(bp);
> 		trace_xfs_buf_trylock(bp, _RET_IP_);
> 	} else {
> 		trace_xfs_buf_trylock_fail(bp, _RET_IP_);
> 	}
> 
> otherwise this looks good and can go in without the rest of the series.

I'll fix that up on commit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
