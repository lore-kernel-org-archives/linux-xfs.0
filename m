Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 88F637F56
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 06:10:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6758A8F8040
	for <xfs@oss.sgi.com>; Thu, 18 Feb 2016 04:10:24 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0nbPPGaQgIGjCCIb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Feb 2016 04:10:23 -0800 (PST)
Date: Thu, 18 Feb 2016 07:10:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: better xfs_trans_alloc interface
Message-ID: <20160218121021.GB16962@bfoster.bfoster>
References: <1455699159-20906-1-git-send-email-hch@lst.de>
	<1455699159-20906-2-git-send-email-hch@lst.de>
	<20160217134006.GA4065@bfoster.bfoster>
	<20160217220436.GI19486@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160217220436.GI19486@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, Feb 18, 2016 at 09:04:36AM +1100, Dave Chinner wrote:
> On Wed, Feb 17, 2016 at 08:40:08AM -0500, Brian Foster wrote:
> > On Wed, Feb 17, 2016 at 09:52:38AM +0100, Christoph Hellwig wrote:
> > > Merge xfs_trans_reserve and xfs_trans_alloc into a single function call
> > > that returns a transaction with all the required log and block reservations,
> > > and which allows passing transaction flags directly to avoid the cumbersome
> > > _xfs_trans_alloc interface.
> > > 
> > > While we're at it we also get rid of the transaction type argument that has
> > > been superflous since we stopped supporting the non-CIL logging mode.  The
> > > guts of it will be removed in another patch.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > 
> > > @@ -165,7 +123,7 @@ xfs_trans_dup(
> > >   * This does not do quota reservations. That typically is done by the
> > >   * caller afterwards.
> > >   */
> > > -int
> > > +static int
> > >  xfs_trans_reserve(
> > >  	struct xfs_trans	*tp,
> > >  	struct xfs_trans_res	*resp,
> > > @@ -219,7 +177,7 @@ xfs_trans_reserve(
> > >  						resp->tr_logres,
> > >  						resp->tr_logcount,
> > >  						&tp->t_ticket, XFS_TRANSACTION,
> > > -						permanent, tp->t_type);
> > > +						permanent, 0);
> > 
> > So this looks like it effectively breaks xlog_print_tic_res()..? I see
> > that is all removed in the subsequent patch, but the type still seems
> > like useful information in the event that an associated problem occurs
> > with the transaction. In fact, we just had a transaction overrun report
> > over the weekend (on irc) where at least I thought this was useful
> > (unfortunately it looks like I lost the reference to the syslog output).
> 
> I've considered doing this removal myself in the past - doing
> somethign like embedding the return address of the
> xfs-trans_reserve() call in the ticket that is allocated tells us
> exactly where the call was made. This can be printed with %pS, and
> that gives us the function (and location in the function) the
> reservation was made. Hence we solve the problem of not
> knowing which call path triggered the problem.
> 
> Hence I don't think we actually need to the type in every function
> call.
> 

That sounds like a good idea to me.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
