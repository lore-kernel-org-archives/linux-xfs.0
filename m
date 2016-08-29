Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AD4EF7CAF
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 13:17:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3F662AC002
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ttFbGW47p5cp965H (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 11:17:54 -0700 (PDT)
Date: Mon, 29 Aug 2016 14:17:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/5] xfs: update metadata LSN in buffers during log
	recovery
Message-ID: <20160829181751.GC54904@bfoster.bfoster>
References: <1470935467-52772-1-git-send-email-bfoster@redhat.com>
	<1470935467-52772-5-git-send-email-bfoster@redhat.com>
	<20160829012923.GM19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829012923.GM19025@dastard>
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

On Mon, Aug 29, 2016 at 11:29:23AM +1000, Dave Chinner wrote:
> On Thu, Aug 11, 2016 at 01:11:06PM -0400, Brian Foster wrote:
> > @@ -2552,6 +2562,27 @@ xlog_recover_validate_buf_type(
> >  		xfs_warn(mp, warnmsg);
> >  		ASSERT(0);
> >  	}
> > +
> > +	/*
> > +	 * We must update the metadata LSN of the buffer as it is written out to
> > +	 * ensure that older transactions never replay over this one and corrupt
> > +	 * the buffer. This can occur if log recovery is interrupted at some
> > +	 * point after the current transaction completes, at which point a
> > +	 * subsequent mount starts recovery from the beginning.
> > +	 *
> > +	 * Write verifiers update the metadata LSN from log items attached to
> > +	 * the buffer. Therefore, initialize a bli purely to carry the LSN to
> > +	 * the verifier. We'll clean it up in our ->iodone() callback.
> > +	 */
> > +	if (bp->b_ops && current_lsn != NULLCOMMITLSN) {
> > +		struct xfs_buf_log_item	*bip;
> > +
> > +		ASSERT(!bp->b_iodone || bp->b_iodone == xlog_recover_iodone);
> > +		bp->b_iodone = xlog_recover_iodone;
> > +		xfs_buf_item_init(bp, mp);
> > +		bip = bp->b_fspriv;
> > +		bip->bli_item.li_lsn = current_lsn;
> > +	}
> >  }
> 
> Of, so now we have two things we do when current_lsn !=
> NULLCOMMITLSN. I'd change this to something like:
> 
> 
> 	ASSERT(bp->b_fspriv == NULL);
> 	if (current_lsn == NULLCOMMITLSN)
> 		return;
> 
> 	if (warn) {
> 		....
> 	}
> 
> 	if (!bp->b_ops)
> 		return
> 
> 	/* add buf_item */

Ok, I may still invert the bp->b_ops check as that seems more clear to
me for whatever reason, but otherwise that looks like a nice cleanup.
Thanks.

Brian

> 
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
