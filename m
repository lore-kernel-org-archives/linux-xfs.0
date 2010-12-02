Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB229okA245896 for <xfs@oss.sgi.com>; Wed, 1 Dec 2010 20:09:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4566B1C8525D
	for <xfs@oss.sgi.com>; Wed,  1 Dec 2010 18:11:33 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	PXiEW8XjQEDNhbnk for <xfs@oss.sgi.com>;
	Wed, 01 Dec 2010 18:11:33 -0800 (PST)
Date: Thu, 2 Dec 2010 13:11:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/14] xfs: convert grant head manipulations to
	lockless algorithm
Message-ID: <20101202021130.GU16922@dastard>
References: <1290994712-21376-1-git-send-email-david@fromorbit.com>
	<1290994712-21376-11-git-send-email-david@fromorbit.com>
	<20101201131513.GB22455@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101201131513.GB22455@infradead.org>
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

On Wed, Dec 01, 2010 at 08:15:13AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 29, 2010 at 12:38:28PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The only thing that the grant lock remains to protect is the grant head
> > manipulations when adding or removing space from the log. These calculations
> > are already based on atomic variables, so we can already update them safely
> > without locks. However, the grant head manpulations require atomic multi-step
> > calculations to be executed, which the algorithms currently don't allow.
> > 
> > To make these multi-step calculations atomic, convert the algorithms to
> > compare-and-exchange loops on the atomic variables. That is, we sample the old
> > value, perform the calculation and use atomic64_cmpxchg() to attempt to update
> > the head with the new value. If the head has not changed since we sampled it,
> > it will succeed and we are done. Otherwise, we rerun the calculation again from
> > a new sample of the head.
> > 
> > This allows us to remove the grant lock from around all the grant head space
> > manipulations, and that effectively removes the grant lock from the log
> > completely.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -3478,11 +3485,18 @@ xlog_verify_dest_ptr(
> >  		xlog_panic("xlog_verify_dest_ptr: invalid ptr");
> >  }
> >  
> > +/*
> > + * XXX: because we cannot atomically sample both the reserve and write heads,
> > + * we cannot verify them reliably as they may be sampled in the middle of
> > + * racing modifications. Hence just taking snapshots of the heads can give an
> > + * incorrect view of the state of log. Hence just disable this check for now.
> > + */
> >  STATIC void
> >  xlog_verify_grant_head(
> 
> I can't see any way to keep this check with the atomic reserve/write
> heads, so we might as well remove it entirely.

Ok, will do.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
