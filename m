Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D9C717F53
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 21:32:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CED718F8033
	for <xfs@oss.sgi.com>; Thu, 15 May 2014 19:32:58 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	2JNnfGDMajwohltX for <xfs@oss.sgi.com>;
	Thu, 15 May 2014 19:32:52 -0700 (PDT)
Date: Fri, 16 May 2014 12:32:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: don't let bplist index go negative in prefetch
Message-ID: <20140516023238.GD26353@dastard>
References: <53750E9F.3010301@redhat.com>
 <53757670.5060609@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53757670.5060609@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 15, 2014 at 09:22:40PM -0500, Eric Sandeen wrote:
> On 5/15/14, 1:59 PM, Eric Sandeen wrote:
> > After:
> > 
> > bbd3275 repair: don't unlock prefetch tree to read discontig buffers
> > 
> > Coverity spotted that it's possible for us to arrive at the loop
> > below with num == 1, and then we decrement it to 0, and try to
> > index bplist[num-1].
> > 
> > I think this was possible before the change, i.e. it's probably
> > not a regression.
> > 
> > Fix this by not trying to shrink the window unless we have
> > more than one buffer in the array.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > ---
> 
> FWIW, I'm not sure this can actually be hit; see below.
> 
> > 
> > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > index 4595310..b6d4755 100644
> > --- a/repair/prefetch.c
> > +++ b/repair/prefetch.c
> > @@ -505,7 +505,7 @@ pf_batch_read(
> >  		first_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[0]));
> >  		last_off = LIBXFS_BBTOOFF64(XFS_BUF_ADDR(bplist[num-1])) +
> >  			XFS_BUF_SIZE(bplist[num-1]);
> 
> Indexing bplist[num-1] after we do num-- is only a problem if num==1.
> 
> If num==1, then last_off - first_off == XFS_BUF_SIZE(bplist[0]) above.
> 
> > -		while (last_off - first_off > pf_max_bytes) {
> 
> so we can only go here if XFS_BUF_SIZE(bplist[0] > pf_max_bytes, and
> 
>         pf_max_bytes = sysconf(_SC_PAGE_SIZE) << 7;
> 
> for a 4k page that's 512k.
> 
> So unless XFS_BUF_SIZE(bplist[0]) > 512k, we won't run into trouble.

For prefetch, it can't be more than 64k (the maximum size of a
metadata block), so I think we're safe right at the moment.

> And I don't ... think that can happen, right?  So it's probably impossible
> to hit; worth being defensive, but not critical.

Agreed, it doesn't appear like a critical fix. I'll queue it up for
after the 3.2.0 release.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
