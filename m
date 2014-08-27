Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 51A807F50
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 06:19:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5001AC002
	for <xfs@oss.sgi.com>; Wed, 27 Aug 2014 04:19:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gw5q6CKHAVyToM2V (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Aug 2014 04:19:14 -0700 (PDT)
Date: Wed, 27 Aug 2014 07:19:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: refactor xlog_recover_process_data()
Message-ID: <20140827111910.GB7431@bfoster.bfoster>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
	<1409016101-9511-2-git-send-email-david@fromorbit.com>
	<20140826124112.GB52815@bfoster.bfoster>
	<20140826223407.GM20518@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140826223407.GM20518@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Aug 27, 2014 at 08:34:07AM +1000, Dave Chinner wrote:
> On Tue, Aug 26, 2014 at 08:41:13AM -0400, Brian Foster wrote:
> > On Tue, Aug 26, 2014 at 11:21:38AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Clean up xlog_recover_process_data() structure in preparation for
> > > fixing the allocationa nd freeing context of the transaction being
> > > recovered.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log_recover.c | 151 ++++++++++++++++++++++++++---------------------
> > >  1 file changed, 84 insertions(+), 67 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 01becbb..1970732f 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -3531,12 +3531,78 @@ out:
> > >  }
> > >  
> > >  STATIC int
> > > -xlog_recover_unmount_trans(
> > > -	struct xlog		*log)
> > > +xlog_recovery_process_ophdr(
> > > +	struct xlog		*log,
> > > +	struct hlist_head	rhash[],
> > > +	struct xlog_rec_header	*rhead,
> > > +	struct xlog_op_header	*ohead,
> > > +	xfs_caddr_t		dp,
> > > +	xfs_caddr_t		lp,
> > > +	int			pass)
> > >  {
> > > -	/* Do nothing now */
> > > -	xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
> > > -	return 0;
> > > +	struct xlog_recover	*trans;
> > > +	xlog_tid_t		tid;
> > > +	int			error;
> > > +	unsigned long		hash;
> > > +	uint			flags;
> > > +	unsigned int		hlen;
> > > +
> > > +	hlen = be32_to_cpu(ohead->oh_len);
> > > +	tid = be32_to_cpu(ohead->oh_tid);
> > > +	hash = XLOG_RHASH(tid);
> > > +	trans = xlog_recover_find_tid(&rhash[hash], tid);
> > > +	if (!trans) {
> > > +		/* add new tid if this is a new transaction */
> > > +		if (ohead->oh_flags & XLOG_START_TRANS) {
> > > +			xlog_recover_new_tid(&rhash[hash], tid,
> > > +					     be64_to_cpu(rhead->h_lsn));
> > > +		}
> > > +		return 0;
> > > +	}
> > > +
> > 
> > Overall this looks pretty good to me. I wonder if we can clean this up
> > to separate state management from error detection while we're at it. I
> > don't see any reason this code to find trans has to be up here.
> > 
> > > +	error = -EIO;
> > > +	if (dp + hlen > lp) {
> > > +		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, hlen);
> > > +		WARN_ON(1);
> > > +		goto out_free;
> > > +	}
> > > +
> > > +	flags = ohead->oh_flags & ~XLOG_END_TRANS;
> > > +	if (flags & XLOG_WAS_CONT_TRANS)
> > > +		flags &= ~XLOG_CONTINUE_TRANS;
> > > +
> > 
> > 	/* we should find a trans for anything other than a start op */
> > 	trans = xlog_recover_find_tid(&rhash[hash], tid);
> > 	if (((ohead->oh_flags & XLOG_START_TRANS) && trans) ||
> > 	    (!(ohead->oh_flags & XLOG_START_TRANS) && !trans)) {
> > 		xfs_warn(log->l_mp, "%s: bad transaction 0x%x oh_flags 0x%x trans %p",
> > 			 __func__, tid, ohead->oh_flags, trans);
> > 		ASSERT(0);
> > 		return -EIO;
> > 	}
> > 
> > Maybe returning error here is not the right thing to do because we want
> > the recovery to proceed. We could still dump a warning and return 0
> > though.
> 
> Urk. Try understanding why that logic exists in a couple of years
> time when you've forgetten all the context. :/
> 

Heh, that's the problem I had with the current code. The error checking
and state machine management is split between here and below. The above
is just an error check, and fwiw, it adds an extra check that doesn't
exist in the current code. Hide the flag busy-ness and effectively the
logic is:

	/* verify a tx is in progress or we're starting a new one */
	if (trans && is_start_header(ohead) ||
	    !trans && !is_start_header(ohead))
		return -EIO;

... which seems straightforward to me, but I'm sure there are other ways
to refactor things as well.

> > > +	switch (flags) {
> > > +	/* expected flag values */
> > > +	case 0:
> > > +	case XLOG_CONTINUE_TRANS:
> > > +		error = xlog_recover_add_to_trans(log, trans, dp, hlen);
> > > +		break;
> > > +	case XLOG_WAS_CONT_TRANS:
> > > +		error = xlog_recover_add_to_cont_trans(log, trans, dp, hlen);
> > > +		break;
> > > +	case XLOG_COMMIT_TRANS:
> > > +		error = xlog_recover_commit_trans(log, trans, pass);
> > > +		break;
> > > +
> > > +	/* unexpected flag values */
> > > +	case XLOG_UNMOUNT_TRANS:
> > > +		xfs_warn(log->l_mp, "%s: Unmount LR", __func__);
> > > +		error = 0;
> > > +		break;
> > > +	case XLOG_START_TRANS:
> > > +		xfs_warn(log->l_mp, "%s: bad transaction 0x%x", __func__, tid);
> > > +		ASSERT(0);
> > > +		break;
> > 
> > 		xlog_recover_new_tid(&rhash[hash], tid, be64_to_cpu(rhead->h_lsn)
> > 		error = 0;
> > 		break;
> > 
> 
> I like the idea, but I don't like the suggested implementation. I
> was in two minds as to whether I should factor
> xlog_recover_find_tid() further.  There's only one caller of it and
> only one caller of xlog_recover_new_tid() and the happen within
> three lines of each other. Hence I'm thinking that it makes more
> sense to wrap the "find or allocate trans" code in a single helper
> and lift all that logic clean out of this function. That helper can
> handle all the XLOG_START_TRANS logic more cleanly, I think....
> 

Fair enough, that sounds reasonable so long as it isn't pulling the core
state management off into disparate functions. What I like about the
above (combined with the result of the rest of this series) is that the
lifecycle is obvious and contained in a single block of code.

Brian

> Actually, that makes the factoring I've already done a little
> inconsistent. Let me rework this a bit.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
