Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LKchGS175172 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:38:43 -0500
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110921005612.GL15688@dastard>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110921005612.GL15688@dastard>
Date: Wed, 21 Sep 2011 15:38:38 -0500
Message-ID: <1316637518.5872.39.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Dave Chinner <david@fromorbit.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-09-21 at 10:56 +1000, Dave Chinner wrote:
> On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> > Ran the xfstests (auto) overnight and didn't see any new issues.
> 
> Sure, but xfstests won't be triggering the new failure paths.
> 
> It looks to me like any failure to get a buffer will now result in a
> cancelled transaction and a filesystem shutdown - the new failure
> paths really need to be tested to ensure that failures are handled
> gracefully and don't result in filesystem corruption.

This is true.

> As it is, I'm not sure we want to do this. The only reason we can
> fail to get a buffer is allocation failures in extremely low memory
> conditions. However, the last thing we want is for filesystem
> shutdowns to be triggered by transient low memory conditions.

But a failure to get a buffer, not checked, can't be good
can it?  In other words, the patch now adds handling for
a xfs_buf_get() failure, which avoids a kernel-mode null
pointer dereference in the off chance that would happen.
That's worse than a filesystem shutdown.

Now I grant you your earlier statement, namely that it's
conceivable that the new error return could lead to a
previously un-exercised path that leads to file system
corruption.

But I do believe that all these places handle *an* error
(not the specific ENOMEM error), so those spots already
are generally prepared for something to go wrong.

> The current state of the code is that the xfs_buf_get() code tries
> really, really hard to allocate memory, and we don't have any
> evidence to point to the fact that is it failing to allocate memory.
> We'd be seeing asserts firing and/or NULL pointer deref panics if
> xfs_buf_get() was failing, and neither of these are happening.
> 
> As it is, before we can gracefully handle memory allocation failures
> in the xfs_buf layer, we need to be able to roll back dirty
> transactions so that memory allocation failure does not result
> filesystem shutdowns. That's actually possible to do now with the
> delayed logging infrastructure (because the CIL keeps a copy of the
> previous in memory modifications prior to the bad transaction), so
> we should look towards implementing transaction rollback first
> before allowing memory allocation to fail inside transaction
> contexts....

Now that's a great thing to do--use the CIL to facilitate
rolling back dirty transactions.  Very cool.

But this patch doesn't "allow" memory allocation to fail,
it simply avoids a sudden panic if it ever did (which you
point out is only slightly less likely than impossible).

I didn't anticipate this, and the patch has already been
committed.  I need to know whether people think this is
critical enough for me to revert the patch.

					-Alex



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
