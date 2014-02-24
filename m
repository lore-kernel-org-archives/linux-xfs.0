Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 139DB7F55
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 07:35:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1D63304048
	for <xfs@oss.sgi.com>; Mon, 24 Feb 2014 05:35:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HuUAAKVANcG5ZSEN for
	<xfs@oss.sgi.com>; Mon, 24 Feb 2014 05:35:34 -0800 (PST)
Date: Mon, 24 Feb 2014 08:35:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/3] xfs: always do log forces via the workqueue
Message-ID: <20140224133459.GA54199@bfoster.bfoster>
References: <1392783402-4726-1-git-send-email-david@fromorbit.com>
	<1392783402-4726-2-git-send-email-david@fromorbit.com>
	<5304F6F6.3070007@redhat.com> <20140220002358.GH4916@dastard>
	<53076B05.8010806@redhat.com> <20140221222106.GQ13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140221222106.GQ13647@dastard>
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

On Sat, Feb 22, 2014 at 09:21:06AM +1100, Dave Chinner wrote:
> On Fri, Feb 21, 2014 at 10:04:37AM -0500, Brian Foster wrote:
> > On 02/19/2014 07:23 PM, Dave Chinner wrote:
> > > On Wed, Feb 19, 2014 at 01:24:54PM -0500, Brian Foster wrote:
> > >> On 02/18/2014 11:16 PM, Dave Chinner wrote:
> > >>> From: Dave Chinner <dchinner@redhat.com>
> > >>>
> > ...
...
> > 
> > General follow up question - what makes not taking xc_ctx_lock anywhere
> > in here safe in the first place? In the current implementation, if the
> > push has already been queued (note that we flush before we take the
> > spinlock and check the push sequence) and we get into the ctx wait
> > sequence, isn't it possible to see xc_committing before the ctx we're
> > pushing is even added?
> 
> The waiting is serialised on the push lock, not the context lock.
> 
> The context lock is used to serialise addition to a CIL context with
> the against the pushing of that sequence. Triggering a push of a CIL
> context does not need to be serialised addition to the CIL, nor
> directly against the push of the CIL. A blocking push needs to be
> serialised against the checkpoint of a CIL context to the iclog,
> which is a different thing altogether.
> 
> Hence we don't want to use the xc_ctx_lock for this - it is already
> a contended lock and we don't want to hold off commits into a new
> sequence while we wait for a previous sequence to finish pushing.
> 
> Yes, there are potential races in the exist code. They are fixed by
> this patch.
> 

Ok, thanks.

> > With this patch, what prevents us from seeing the updated
> > xc_current_sequence and thus skipping the restart (xc_current_sequence
> > isn't updated under the spinlock) before the pushed ctx has been added
> > to xc_committing?
> 
> The fact that the patch moves the xc_current_sequence update under
> the the push_lock avoids this. i.e. it is now only updated atomically
> with adding the context to the committing list. Both are now
> explicitly updated at the same time, so you can't see a sequence
> number greater than what you might find on the list...
> 

Ah, right. I was reading through your patch and the original code to
understand it better and lost the fact that you moved
xc_current_sequence under spinlock (e.g., my assumption above about it
not updated under lock is incorrect). That clears that up. Thanks for the
explanations.

Reviewed-by: Brian Foster <bfoster@redhat.com>

Brian

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
