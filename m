Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3PMXq6K250149 for <xfs@oss.sgi.com>; Wed, 25 Apr 2012 17:33:52 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	o8SdA7GwLPVxwq41 for <xfs@oss.sgi.com>;
	Wed, 25 Apr 2012 15:33:50 -0700 (PDT)
Date: Thu, 26 Apr 2012 08:33:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 37/37] xfs: make XBF_MAPPED the default behaviour
Message-ID: <20120425223346.GW9541@dastard>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-38-git-send-email-david@fromorbit.com>
	<4F9859E1.6010601@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F9859E1.6010601@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Apr 25, 2012 at 03:09:05PM -0500, Mark Tinguely wrote:
> PS.
> On 04/23/12 00:59, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Rather than specifying XBF_MAPPED for almost all buffers, introduce
> >XBF_UNMAPPED for the couple of users that use unmapped buffers.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> >  fs/xfs/xfs_buf.c         |   28 +++++++++++++---------------
> >  fs/xfs/xfs_buf.h         |    4 ++--
> >  fs/xfs/xfs_fsops.c       |   10 +++++-----
> >  fs/xfs/xfs_inode.c       |    1 +
> >  fs/xfs/xfs_log_recover.c |    4 ++--
> >  fs/xfs/xfs_trans_buf.c   |    6 ------
> >  fs/xfs/xfs_vnodeops.c    |    3 +--
> >  7 files changed, 24 insertions(+), 32 deletions(-)
> >
> >diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> >@@ -707,7 +707,6 @@ xfs_buf_set_empty(
> >  	bp->b_length = numblks;
> >  	bp->b_io_length = numblks;
> >  	bp->b_bn = XFS_BUF_DADDR_NULL;
> >-	bp->b_flags&= ~XBF_MAPPED;
> >  }
> >
> 
> I know that bp->baddr is set to NULL and denotes that this is not
> mapped, but why not set the XBF_UNMAPPED?

Because mapped/unmapped is essentially meaningless for buffers that
use associated memory. These buffers have external memory attached
to them, so the buffer cache is not responsible for allocating or
freeing the memory. Further, the memory being attached to the buffer
is assumed to be contiguous - this interface does not work with
unmapped memory buffers. Hence setting XBF_UNMAPPED would actually be
the wrong thing to do.

> >  static inline struct page *
> >@@ -759,7 +758,6 @@ xfs_buf_associate_memory(
> >
> >  	bp->b_io_length = BTOBB(len);
> >  	bp->b_length = BTOBB(buflen);
> >-	bp->b_flags |= XBF_MAPPED;
> >
> >  	return 0;
> >  }
> 
> I think the answer is no, but can XBF_UNMAPPED be set and leaked here?

No, because xfs_buf_associate_memory() is only ever called on
buffers that are set up to be mapped in the first place.

FWIW, xfs_buf_associate_memory() is really considered deprecated. It
is only called in 3 places - two are doing an offset read in log
recovery (2 of 3 callers of the function that does it are handling
log I osplit over the physical end of the log) and the third direct
caller is for setting up the extra log buffer for a split log IO
when it wraps around the end of the physical log. IOWs, this is
interface only remains in the code to support one specific quirk of
the log, and at some point either Christoph or I will get around to
fixing that, too. Then we can completely drop this interface....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
