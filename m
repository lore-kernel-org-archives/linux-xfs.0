Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 096E88063
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 16:50:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 89D7CAC005
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:50:32 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6SMfYdFZ670LF6ZG for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 14:50:30 -0800 (PST)
Date: Wed, 6 Mar 2013 09:49:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 07/16] xfs: add CRC checks for quota blocks
Message-ID: <20130305224936.GQ26081@dastard>
References: <1361755901-12453-1-git-send-email-david@fromorbit.com>
	<1361755901-12453-8-git-send-email-david@fromorbit.com>
	<20130305203615.GK22182@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130305203615.GK22182@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Mar 05, 2013 at 02:36:15PM -0600, Ben Myers wrote:
> Hi Dave,
> 
> On Mon, Feb 25, 2013 at 12:31:32PM +1100, Dave Chinner wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > 
> > Use the reserved space in struct xfs_dqblk to store a UUID and a crc
> > for the quota blocks.
> > 
> > [dchinner@redhat.com] Add a LSN field and update for current verifier
> > infrastructure.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Been over this and it looks fine.
> 
> > @@ -897,6 +910,10 @@ xfs_qm_dqiter_bufs(
> >  		if (error)
> >  			break;
> >  
> > +		/*
> > +		 * XXX(hch): need to figure out if it makes sense to validate
> > +		 *	     the CRC here.
> > +		 */
> 
> What's you're opinion on this?

I did actually change the code to validate the CRC here via
the call to xfs_trans_read_buf(.... &xfs_dquot_buf_ops) above. i.e.
the read verifier will do CRC validation of the buffer.

The comment is still relevant, however, because it's not exactly
clear what the best approach to do here if we get a CRC failure.
That would indicate some kind of corruption that we weren't
expecting, and quite possibly a corruption that rewriting the dquot
can't fix. So without knowing what kind of corruption is typical
here, I don't know what the best approach to take here is.

So effectively what I've done is add CRC validation so that we'll
get people telling us about problems (because the quotacheck will
abort and there will be a stack trace in the log). If it turns out
that corrupted quota files is a common problem that quotacheck
encounters we can gather the corpses, do post-mortem analysis of the
failures and then revisit the code appropriately with that knowledge
in hand.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
