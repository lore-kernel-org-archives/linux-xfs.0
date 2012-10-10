Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9A7nCOr240617 for <xfs@oss.sgi.com>; Wed, 10 Oct 2012 02:49:13 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KwEYkIxqh65eBbw8 for
	<xfs@oss.sgi.com>; Wed, 10 Oct 2012 00:50:43 -0700 (PDT)
Date: Wed, 10 Oct 2012 09:50:38 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
In-Reply-To: <20121009193908.GI23644@dastard>
Message-ID: <alpine.LFD.2.00.1210100924180.2326@(none)>
References: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
	<20121009193908.GI23644@dastard>
MIME-Version: 1.0
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
Cc: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

On Wed, 10 Oct 2012, Dave Chinner wrote:

> Date: Wed, 10 Oct 2012 06:39:08 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
> 
> On Tue, Oct 09, 2012 at 02:15:45PM +0200, Lukas Czerner wrote:
> > Currently if len argument in xfs_ioc_trim() is smaller than one BB
> > (basic block) the 'end' variable underflow. Avoid that by bailing out if
> > len is smaller than BB.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> >  fs/xfs/xfs_discard.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > index 69cf4fc..54dc58a 100644
> > --- a/fs/xfs/xfs_discard.c
> > +++ b/fs/xfs/xfs_discard.c
> > @@ -183,8 +183,12 @@ xfs_ioc_trim(
> >  	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
> >  		return -XFS_ERROR(EINVAL);
> >  
> > +	end = BTOBBT(range.len);
> > +	if (0 == end)
> > +		goto out;
> 
> Uggh. "if (end == 0)", please.

Not a Star Wars fan then ? ;). Ok, I'll change that.

> > +
> >  	start = BTOBB(range.start);
> > -	end = start + BTOBBT(range.len) - 1;
> > +	end += start - 1;
> 
> Better would be to check if end <= start. That way it also catches
> start+len overflows.

That's not possible. Even if range.start and range.len would be
2^64-1 (which is not possible for range.start) we always do the
BTOBB conversion and ((2^64-1) / 512) * 2 always fits the _s64
type.

> 
> 
> >  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
> >  
> >  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> > @@ -203,6 +207,7 @@ xfs_ioc_trim(
> >  	if (last_error)
> >  		return last_error;
> >  
> > +out:
> >  	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
> >  	if (copy_to_user(urange, &range, sizeof(range)))
> >  		return -XFS_ERROR(EFAULT);
> 
> I think it should return EINVAL, not silently do nothing. If the
> user application uses a loop that increments start/len based on the
> returned amount of blocks trimmed, returning zero could send it into
> an endless loop.

That's not what the application would do. At least it would not set
len to what's returned as number of blocs discarded, it does not
make sense.

However if user specify length smaller than what we're able to
discard (in xfs it is BBSIZE if I am not mistaken?), then it
probably make sense to return -EINVAL. It is similar situation of
minlen, where we return -EINVAL if it is bigger than AG. However
this will make it to fail at different threshold on different file
system / block sizes so I am on the fence about it. What do you
think, is it worth it ?

Thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
