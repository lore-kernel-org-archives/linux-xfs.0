Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A0KLw5133900 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 19:20:21 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 019B2145B0BF
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 17:27:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	gj3TOszPHwid5CUH for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 17:27:27 -0700 (PDT)
Date: Mon, 10 Oct 2011 11:20:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] repair: fix some valgrind reported errors on i686
Message-ID: <20111010002017.GQ3159@dastard>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-3-git-send-email-david@fromorbit.com>
	<20111009234529.GA13527@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111009234529.GA13527@infradead.org>
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

On Sun, Oct 09, 2011 at 07:45:29PM -0400, Christoph Hellwig wrote:
> On Mon, Oct 10, 2011 at 10:11:47AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Fix a potential prefetch read problem due to the first loop
> > execution of pf_batch_read potentially not initialising the fsbno
> > varaible:
> 
> variable.
> 
> > 
> > ==10177== Thread 6:
> > ==10177== Conditional jump or move depends on uninitialised value(s)
> > ==10177==    at 0x8079CAB: pf_batch_read (prefetch.c:408)
> > ==10177==    by 0x6A2996D: clone (clone.S:130)
> > ==10177==
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  repair/prefetch.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/repair/prefetch.c b/repair/prefetch.c
> > index d2fdf90..da074a8 100644
> > --- a/repair/prefetch.c
> > +++ b/repair/prefetch.c
> > @@ -397,7 +397,7 @@ pf_batch_read(
> >  	int			len, size;
> >  	int			i;
> >  	int			inode_bufs;
> > -	unsigned long		fsbno;
> > +	unsigned long		fsbno = 0;
> 
> Call me stupid, but I can't see how this could actually be a real
> life issue.  The first thing we do in the loop is to to write
> to fsbno in btree_find.  I'm fine adding this to shut up warnins,
> but I can't see a real issue.

If btree_find() fails to find the key being looked up, it returns
without having initialised fsbno.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
