Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QKTPrX254588 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 15:29:25 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	KNKAqP4Dm35K8XQH for <xfs@oss.sgi.com>;
	Fri, 26 Oct 2012 13:31:11 -0700 (PDT)
Date: Sat, 27 Oct 2012 07:31:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 25/25] xfs: add write verifiers to log recovery
Message-ID: <20121026203107.GJ29378@dastard>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-26-git-send-email-david@fromorbit.com>
	<20121026085448.GD3035@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121026085448.GD3035@infradead.org>
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

On Fri, Oct 26, 2012 at 04:54:48AM -0400, Christoph Hellwig wrote:
> > +	 * during log recovery, we don't have a quotainfo structure to
> > +	 * pull the number of dquots per buffer out of, so we have to calculate
> > +	 * it directly.
> > +	 */
> > +	if (mp->m_log->l_flags & XLOG_ACTIVE_RECOVERY) {
> > +		dquots_per_buf = BBTOB(bp->b_length);
> > +		do_div(dquots_per_buf, sizeof(xfs_dqblk_t));
> 
> No need for do_div when dividing a 32-bit value by a constant.
> 
> I'd be almost tempted to do the calculation unconditionally to make the
> code cleaner, too.

Ok.

> > + * There is no easy way to do this except for trying a bunch of magic
> > + * number matches....
> 
> How do we make sure buffers used for the symlink or attr payload don't
> match this?

Remote attr buffers aren't logged - they are written sycnhronously
during the transaction - so won't get found by this. As for remote
symlink buffers, yeah, that might be a problem. Ultimately, both of
these buffer types are going to grow headers for CRCs, so this
problem will go away. I'm not sure how to address this problem
in the mean time short of putting the buffer content type into all
the buf_log_format headers. Do you have any better ideas?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
