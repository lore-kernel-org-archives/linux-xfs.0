Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6JNhSLQ199198 for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 18:43:28 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DDD29150D1F7
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2011 16:43:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	JN0vvs1tu920bdjU for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2011 16:43:27 -0700 (PDT)
Date: Wed, 20 Jul 2011 09:43:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: convert AIL cursors to use struct list_head
Message-ID: <20110719234324.GC9359@dastard>
References: <1310960419-9875-1-git-send-email-david@fromorbit.com>
	<1310960419-9875-4-git-send-email-david@fromorbit.com>
	<1311116636.1964.40.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311116636.1964.40.camel@doink>
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
Cc: xfs@oss.sgi.com

On Tue, Jul 19, 2011 at 06:03:56PM -0500, Alex Elder wrote:
> On Mon, 2011-07-18 at 13:40 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The list of active AIL cursors uses a roll-your-own linked list with
> > special casing for the AIL push cursor. Simplify this code by
> > replacing the list with standard struct list_head lists, and use a
> > separate list_head to track the active cursors. This allows us to
> > treat the AIL push cursor as a generic cursor rather than as a
> > special case, further simplifying the code.
> > 
> > Further, fix the duplicate push cursor initialisation that the
> > special case handling was hiding, and clean up all the comments
> > around the active cursor list handling.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> You didn't fix one thing I mentioned before in a comment.
> I can fix that for you if you like.  Other than that, this
> looks good.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> > ---
> >  fs/xfs/xfs_trans_ail.c  |   77 ++++++++++++++++-------------------------------
> >  fs/xfs/xfs_trans_priv.h |    4 +-
> >  2 files changed, 28 insertions(+), 53 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
> > index 7908c79..8cd329b 100644
> > --- a/fs/xfs/xfs_trans_ail.c
> > +++ b/fs/xfs/xfs_trans_ail.c
> 
> . . .
> 
> > @@ -181,17 +177,12 @@ xfs_trans_ail_cursor_init(
> 
> . . .
> 
> > - * Get the next item in the traversal and advance the cursor.
> > - * If the cursor was invalidated (inidicated by a lip of 1),
> > - * restart the traversal.
> > + * Get the next item in the traversal and advance the cursor.  If the cursor
> > + * was invalidated (indicated by a lip of 1), restart the traversal.
>  * was invalidated (indicated by its item pointer's low bit being set),
>  * restart the traversal.

I thought I fixed that. Hmmmm, I did fix a comment that said the
same thing - just it wasn't the one you noticed. :/ I'll fix it up
when I redo the splice code again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
