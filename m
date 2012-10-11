Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9B63xAg045684 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 01:03:59 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zn07EWpsu3ZuTSzO for
	<xfs@oss.sgi.com>; Wed, 10 Oct 2012 23:05:31 -0700 (PDT)
Date: Thu, 11 Oct 2012 08:05:25 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
In-Reply-To: <20121010232241.GZ23644@dastard>
Message-ID: <alpine.LFD.2.00.1210110759000.27001@localhost>
References: <1349784945-28399-1-git-send-email-lczerner@redhat.com>
	<20121009193908.GI23644@dastard>
	<alpine.LFD.2.00.1210100924180.2326@(none)>
	<20121010232241.GZ23644@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="571107329-1014084701-1349935528=:27001"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--571107329-1014084701-1349935528=:27001
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 11 Oct 2012, Dave Chinner wrote:

> Date: Thu, 11 Oct 2012 10:22:41 +1100
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: xfs@oss.sgi.com
> Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
> 
> On Wed, Oct 10, 2012 at 09:50:38AM +0200, Lukáš Czerner wrote:
> > On Wed, 10 Oct 2012, Dave Chinner wrote:
> > 
> > > Date: Wed, 10 Oct 2012 06:39:08 +1100
> > > From: Dave Chinner <david@fromorbit.com>
> > > To: Lukas Czerner <lczerner@redhat.com>
> > > Cc: xfs@oss.sgi.com
> > > Subject: Re: [PATCH] xfs: avoid underflow in xfs_ioc_trim()
> > > 
> > > On Tue, Oct 09, 2012 at 02:15:45PM +0200, Lukas Czerner wrote:
> > > > Currently if len argument in xfs_ioc_trim() is smaller than one BB
> > > > (basic block) the 'end' variable underflow. Avoid that by bailing out if
> > > > len is smaller than BB.
> > > > 
> > > > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_discard.c |    7 ++++++-
> > > >  1 files changed, 6 insertions(+), 1 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> > > > index 69cf4fc..54dc58a 100644
> > > > --- a/fs/xfs/xfs_discard.c
> > > > +++ b/fs/xfs/xfs_discard.c
> > > > @@ -183,8 +183,12 @@ xfs_ioc_trim(
> > > >  	    range.minlen > XFS_FSB_TO_B(mp, XFS_ALLOC_AG_MAX_USABLE(mp)))
> > > >  		return -XFS_ERROR(EINVAL);
> > > >  
> > > > +	end = BTOBBT(range.len);
> > > > +	if (0 == end)
> > > > +		goto out;
> > > 
> > > Uggh. "if (end == 0)", please.
> > 
> > Not a Star Wars fan then ? ;). Ok, I'll change that.
> 
> I might be, but I don't get the reference - something to do with the
> second moon of Endor, or just letting the wookie win so you don't
> come to an armless end? :)

I know it under the name "yoda notation", or "yoda condition",
probably based on the Yoda's strange sentence composition which is
usually kind of backwards :).

> 
> As it is, I don't like reverse logic notation because it makes code
> strange and unreadable. It doesn't provide any real benefit because
> the compiler will warn about typos that result in assignments in
> such statements (i.e.  if (end = 0)). Hence writing code so that the
> compilation will fail if you make a typo isn't necessary - Clear,
> consistent and easily readable code is much more important....

Good point.

> 
> > > > +
> > > >  	start = BTOBB(range.start);
> > > > -	end = start + BTOBBT(range.len) - 1;
> > > > +	end += start - 1;
> > > 
> > > Better would be to check if end <= start. That way it also catches
> > > start+len overflows.
> > 
> > That's not possible. Even if range.start and range.len would be
> > 2^64-1 (which is not possible for range.start) we always do the
> > BTOBB conversion and ((2^64-1) / 512) * 2 always fits the _s64
> > type.
> 
> Regardless, checking that the end of the range is after the start is a
> much more robust check than individual underflow/overflow tests. We
> do that all over the place in XFS when converting byte ranges to
> block based start/end pairs.

Fair enough.

> 
> > > >  	minlen = BTOBB(max_t(u64, granularity, range.minlen));
> > > >  
> > > >  	if (end > XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks) - 1)
> > > > @@ -203,6 +207,7 @@ xfs_ioc_trim(
> > > >  	if (last_error)
> > > >  		return last_error;
> > > >  
> > > > +out:
> > > >  	range.len = XFS_FSB_TO_B(mp, blocks_trimmed);
> > > >  	if (copy_to_user(urange, &range, sizeof(range)))
> > > >  		return -XFS_ERROR(EFAULT);
> > > 
> > > I think it should return EINVAL, not silently do nothing. If the
> > > user application uses a loop that increments start/len based on the
> > > returned amount of blocks trimmed, returning zero could send it into
> > > an endless loop.
> > 
> > That's not what the application would do. At least it would not set
> > len to what's returned as number of blocs discarded, it does not
> > make sense.
> 
> Oh, right, my mistake.
> 
> > However if user specify length smaller than what we're able to
> > discard (in xfs it is BBSIZE if I am not mistaken?), then it
> > probably make sense to return -EINVAL. It is similar situation of
> > minlen, where we return -EINVAL if it is bigger than AG. However
> > this will make it to fail at different threshold on different file
> > system / block sizes so I am on the fence about it. What do you
> > think, is it worth it ?
> 
> Actually, the minimum length that can be discarded is the filesystem
> block size, and applications can get that easily enough from
> stat(2).  IOWs, we probably should be rejecting minlen < 1 FSB,
> range < 1 FSB with EINVAL....

Agreed, we should return EINVAL when range < 1 FSB. However 'minlen'
is a different case, when minlen < 1 FSB. Minlen says that we should
not discard ranges smaller than certain value which is perfectly
feasible with minlen < 1 FSB.

I'll resend the patch, thanks!
-Lukas

> 
> Cheers,
> 
> Dave.
> 
--571107329-1014084701-1349935528=:27001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--571107329-1014084701-1349935528=:27001--
