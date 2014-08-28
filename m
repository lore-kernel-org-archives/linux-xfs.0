Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35B8E7F3F
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 19:47:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E829E8F8071
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 17:47:24 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ptmX44xODoLk8SfP for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 17:47:22 -0700 (PDT)
Date: Thu, 28 Aug 2014 10:47:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] xfs: refactor xlog_recover_process_data()
Message-ID: <20140828004717.GP20518@dastard>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
	<1409016101-9511-2-git-send-email-david@fromorbit.com>
	<20140826124112.GB52815@bfoster.bfoster>
	<20140826223407.GM20518@dastard>
	<20140827111910.GB7431@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140827111910.GB7431@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Wed, Aug 27, 2014 at 07:19:10AM -0400, Brian Foster wrote:
> On Wed, Aug 27, 2014 at 08:34:07AM +1000, Dave Chinner wrote:
> > > > +	switch (flags) {
> > > > +	/* expected flag values */
> > > > +	case 0:
> > > > +	case XLOG_CONTINUE_TRANS:
> > > > +		error = xlog_recover_add_to_trans(log, trans, dp, hlen);
> > > > +		break;
> > > > +	case XLOG_WAS_CONT_TRANS:
> > > > +		error = xlog_recover_add_to_cont_trans(log, trans, dp, hlen);
> > > > +		break;
> > > > +	case XLOG_COMMIT_TRANS:
> > > > +		error = xlog_recover_commit_trans(log, trans, pass);
> > > > +		break;
> > > > +
> > > > +	/* unexpected flag values */
> > > > +	case XLOG_UNMOUNT_TRANS:
> > > > +		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
> > > > +		error = 0;
> > > > +		break;
> > > > +	case XLOG_START_TRANS:
> > > > +		xfs_warn(log->l_mp, "%s: bad transaction 0x%x", __func__, tid);
> > > > +		ASSERT(0);
> > > > +		break;
> > > 
> > > 		xlog_recover_new_tid(&rhash[hash], tid, be64_to_cpu(rhead->h_lsn)
> > > 		error = 0;
> > > 		break;
> > > 
> > 
> > I like the idea, but I don't like the suggested implementation. I
> > was in two minds as to whether I should factor
> > xlog_recover_find_tid() further.  There's only one caller of it and
> > only one caller of xlog_recover_new_tid() and the happen within
> > three lines of each other. Hence I'm thinking that it makes more
> > sense to wrap the "find or allocate trans" code in a single helper
> > and lift all that logic clean out of this function. That helper can
> > handle all the XLOG_START_TRANS logic more cleanly, I think....
> > 
> 
> Fair enough, that sounds reasonable so long as it isn't pulling the core
> state management off into disparate functions. What I like about the
> above (combined with the result of the rest of this series) is that the
> lifecycle is obvious and contained in a single block of code.

Well, it's not "state" as in "state machine". What we are doing is
decoding ophdrs, not walking through a state machine, and so I think
that the "start" ophdrs need to be treated differently because all
the other types of ophdrs have a dependency on the trans structure
existing.

Indeed, I suspect the correct thing to do is check for the start
flag *first*, before we do the lookup to find the trans structure,
because the start flag implies that we should not find an existing
trans structure for that tid. And once we've done that, we're
completely finished processing that ophdr, and hence should
return and not run any of the other code we run for all the
remaining ophdrs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
