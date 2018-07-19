Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:58322 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731887AbeGSSYp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 14:24:45 -0400
Date: Thu, 19 Jul 2018 10:40:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: refactor unmount record write
Message-ID: <20180719174017.GJ4813@magnolia>
References: <153195715716.16758.18150859087945516040.stgit@magnolia>
 <153195716953.16758.3719225666646928225.stgit@magnolia>
 <20180719163947.GB10151@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180719163947.GB10151@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 19, 2018 at 09:39:47AM -0700, Christoph Hellwig wrote:
> Looks generally fine, but some tiny nitpicks:
> 
> > +	/* the data section must be 32 bit size aligned */
> > +	struct {
> > +		uint16_t magic;
> > +		uint16_t pad1;
> > +		uint32_t pad2; /* may as well make it 64 bits */
> > +	} magic = {
> > +		.magic = XLOG_UNMOUNT_TYPE,
> > +	};
> 
> Can we please give this structure type a name and move it to
> xfs_log_format.h?  They way this had been done always irked me.

Ok.  It gets written to disk, so that makes sense.

> > +	/*
> > +	 * At this point, we're umounting anyway,
> > +	 * so there's no point in transitioning log state
> > +	 * to IOERROR. Just continue...
> > +	 */
> 
> Use up all 80 lines, please.
> 
> > +	if (!(iclog->ic_state == XLOG_STATE_ACTIVE ||
> > +	      iclog->ic_state == XLOG_STATE_DIRTY) &&
> > +	    !XLOG_FORCED_SHUTDOWN(log))
> > +		xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> > +	else
> > +		spin_unlock(&log->l_icloglock);
> 
> 	switch (iclog->ic_state) {
> 	default:
> 		if (!XLOG_FORCED_SHUTDOWN(log)) {
> 			xlog_wait(&iclog->ic_force_wait, &log->l_icloglock);
> 			break;
> 		}
> 		/*FALLHRU*/
> 	case XLOG_STATE_ACTIVE:
> 	case XLOG_STATE_DIRTY:
> 		spin_unlock(&log->l_icloglock);
> 		break;

<nod>

--D

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
