Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2G1naRP108410 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 20:49:36 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D4A6D19D159E
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 18:51:10 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	aGe7AaI8BrfpBUBh for <xfs@oss.sgi.com>;
	Mon, 15 Mar 2010 18:51:10 -0700 (PDT)
Date: Tue, 16 Mar 2010 12:51:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 9/9] xfs: log ticket reservation underestimates the
	number of iclogs
Message-ID: <20100316015107.GE12369@dastard>
References: <1268620506-10799-1-git-send-email-david@fromorbit.com>
	<1268620506-10799-10-git-send-email-david@fromorbit.com>
	<20100315154154.GA20155@infradead.org>
	<20100315154435.GA29024@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100315154435.GA29024@infradead.org>
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

On Mon, Mar 15, 2010 at 11:44:35AM -0400, Christoph Hellwig wrote:
> > > +	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > > +	num_headers = (unit_bytes + iclog_space - 1) / iclog_space;
> > > +
> > > +	/* for split-recs - ophdrs added when data split over LRs */
> > > +	unit_bytes += sizeof(xlog_op_header_t) * num_headers;
> > > +
> > > +	/* add extra header reservations if we overrun */
> > > +	while (!num_headers ||
> > > +	       ((unit_bytes + iclog_space - 1) / iclog_space) > num_headers) {
> > > +		unit_bytes += sizeof(xlog_op_header_t);
> > > +		num_headers++;
> > > +	}
> > 
> > Looks good, but why do you check for a zero num_headers here?  The only way
> > this could happen after the roundup above is if unit_bytes is zero, which
> > can't ever happen - one caller has it hardcoded to 1, and the the other
> > has a conditional for it beeing bigger than 0 around the call.

Mainly because I want to be able to pass a length of zero in for the
checkpoint transaction and have it do the right thing. That is,
reserve space for the first header which, in this case, will
definitely be used. Indeed, once I made this change, i forgot to
change the CIL ticket allocation back to zero - it is still:

	tic = xlog_ticket_alloc(log, 1 /* to get a LR header */,
				1, XFS_TRANSACTION, 0);

Other than that I can't find any caller that uses unit_bytes = 1.
Maybe I missed something - can you point it out to me?

FWIW, there's more missing from the transaction reservations
themselves - none of them take into account the space used by the
log item format descriptor that describe the changed regions of an
object written to the log. They take into account the regions
themselves, but not the descriptor. Some of the hard coded
transaction reservations do - see all the single sector transactions
that reserve "<something> + 128" e.g:

	error = xfs_trans_reserve(tp, 0, mp->m_sb.sb_sectsize + 128, 0, 0,
				XFS_DEFAULT_LOG_COUNT);

That 128 bytes is for the log item format descriptor, and in some
cases I'm not sure that 128 bytes is enough. Anyway, that's a
problem for a rainy day...

> BTW: use of the howmany macro might make some of the above easier
> to read.

Good point. I'll look into using that.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
