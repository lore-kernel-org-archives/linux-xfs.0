Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LMhR4i182410 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 17:43:27 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A26914083EF
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:48:51 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	IqYrVI2QCvbAIFat for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 15:48:51 -0700 (PDT)
Date: Thu, 22 Sep 2011 08:43:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
Message-ID: <20110921224322.GR15688@dastard>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110921005612.GL15688@dastard> <1316637518.5872.39.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316637518.5872.39.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS Mailing List <xfs@oss.sgi.com>

On Wed, Sep 21, 2011 at 03:38:38PM -0500, Alex Elder wrote:
> On Wed, 2011-09-21 at 10:56 +1000, Dave Chinner wrote:
> > On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> > > Ran the xfstests (auto) overnight and didn't see any new issues.
> > 
> > Sure, but xfstests won't be triggering the new failure paths.
> > 
> > It looks to me like any failure to get a buffer will now result in a
> > cancelled transaction and a filesystem shutdown - the new failure
> > paths really need to be tested to ensure that failures are handled
> > gracefully and don't result in filesystem corruption.
> 
> This is true.
> 
> > As it is, I'm not sure we want to do this. The only reason we can
> > fail to get a buffer is allocation failures in extremely low memory
> > conditions. However, the last thing we want is for filesystem
> > shutdowns to be triggered by transient low memory conditions.
> 
> But a failure to get a buffer, not checked, can't be good
> can it?  In other words, the patch now adds handling for
> a xfs_buf_get() failure, which avoids a kernel-mode null
> pointer dereference in the off chance that would happen.
> That's worse than a filesystem shutdown.

See my previous post about how the behaviour of the FS after an oops
is very different to a shutdown.

> Now I grant you your earlier statement, namely that it's
> conceivable that the new error return could lead to a
> previously un-exercised path that leads to file system
> corruption.
> 
> But I do believe that all these places handle *an* error
> (not the specific ENOMEM error), so those spots already
> are generally prepared for something to go wrong.

Yes, but that's making the assumption that those error handling
routines handle the new failure cases correctly. The inode
allocation case is one I'm particularly concerned about...

> I didn't anticipate this, and the patch has already been
> committed.  I need to know whether people think this is
> critical enough for me to revert the patch.

In the long run, it doesn't matter. All I'm concerned about is that
everyone is aware of the potential downsides of this change, and why
not handling the error might be preferrable in the short term until
we get transaction rollbacks sorted out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
