Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3EL0miM099403 for <xfs@oss.sgi.com>; Wed, 14 Apr 2010 16:00:48 -0500
Subject: Re: [PATCHv2 8/10] xfs: avoid repeated pointer dereferences
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100412065644.GJ2493@dastard>
References: <1270852242.7840.158.camel@doink> <20100412065644.GJ2493@dastard>
Date: Wed, 14 Apr 2010 16:02:41 -0500
Message-ID: <1271278961.3559.75.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: xfs@oss.sgi.com

On Mon, 2010-04-12 at 16:56 +1000, Dave Chinner wrote:
> On Fri, Apr 09, 2010 at 05:30:42PM -0500, Alex Elder wrote:
> > In xlog_find_cycle_start() use a local variable for some repeated
> > operations rather than constantly updating the memory location
> > whose address is passed in.
> 
> Won't the compiler optimise that out for us? i.e. does the dissassembly
> of the function look any better before and after this change?

I doubt it *can* optimize that.  Doing so would change
the way the function interacts semantically with the
pointed-to memory.  Still, I performed a quick check
to be sure (on an x86_64) and the compiled code really
does de-reference the pointer for both reads from and
writes to memory.

> > Signed-off-by: Alex Elder <aelder@sgi.com>
> > 
> > ---
> > fs/xfs/xfs_log_recover.c |   83 ++++++++++++++++++++++++-----------------------
> >  fs/xfs/xfs_log_recover.c |   26 ++++++++++++++------------
> >  1 file changed, 14 insertions(+), 12 deletions(-)
> > 
> > Index: b/fs/xfs/xfs_log_recover.c
> > ===================================================================
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -354,26 +354,28 @@ xlog_find_cycle_start(
> >  {
> >  	xfs_caddr_t	offset;
> >  	xfs_daddr_t	mid_blk;
> > +	xfs_daddr_t	end_blk;
> >  	uint		mid_cycle;
> >  	int		error;
> >  
> > -	mid_blk = BLK_AVG(first_blk, *last_blk);
> > -	while (mid_blk != first_blk && mid_blk != *last_blk) {
> > +	ASSERT(last_blk != NULL);
> > +	end_blk = *last_blk;
> 
> FWIW, there is no need for that ASSERT there - the machine will
> panic on the very next line, anyway....

Agreed.  I make a habit of stating assumptions about
passed-in arguments via assertions.  Not a big deal,
I'll take it out.

Still soliciting a reviewed-by on this one.

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
