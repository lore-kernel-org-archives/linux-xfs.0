Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LMSxj9181760 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 17:28:59 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F4B41C30B13
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:28:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UGORFIWKQqMxiCKK for <xfs@oss.sgi.com>;
	Wed, 21 Sep 2011 15:28:56 -0700 (PDT)
Date: Thu, 22 Sep 2011 08:28:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
Message-ID: <20110921222852.GQ15688@dastard>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110921005612.GL15688@dastard>
	<1316615330.9298.117.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316615330.9298.117.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Wed, Sep 21, 2011 at 09:28:50AM -0500, Chandra Seetharaman wrote:
> On Wed, 2011-09-21 at 10:56 +1000, Dave Chinner wrote:
> > On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> > > Ran the xfstests (auto) overnight and didn't see any new issues.
> >
> > Sure, but xfstests won't be triggering the new failure paths.
> 
> I meant to convey that I did not introduce any regressions.

That's fine, but part of the review process is ensuring that
modifications were tested properly. i.e. answering the question "has
this code had adequate test coverage?"

> > It looks to me like any failure to get a buffer will now result in a
> > cancelled transaction and a filesystem shutdown - the new failure
> > paths really need to be tested to ensure that failures are handled
> > gracefully and don't result in filesystem corruption.
> > 
> > As it is, I'm not sure we want to do this. The only reason we can
> > fail to get a buffer is allocation failures in extremely low memory
> > conditions. However, the last thing we want is for filesystem
> > shutdowns to be triggered by transient low memory conditions.
> > 
> > The current state of the code is that the xfs_buf_get() code tries
> > really, really hard to allocate memory, and we don't have any
> > evidence to point to the fact that is it failing to allocate memory.
> > We'd be seeing asserts firing and/or NULL pointer deref panics if
> > xfs_buf_get() was failing, and neither of these are happening.
> 
> I am really confused. Are you saying we should rather let the kernel
> reference a null pointer and panic than making the file system shutdown
> gracefully ?!

What I'm saying is that adding the error handling may cause
worse problems that we currently already have. Shutdowns are only
supposed to happen when the filesystem has detected a condition that
means it cannot continue operation. i.e. a permanent failure
condition that requires administrator intervention to fix.

Memory allocation failures are usually transient failures, and in
general there is nothing an admin can do to prevent them. hence
triggering shutdowns on memory allocation failures is the wrong
direction to be headed. The correct direction to be going is to
handle memory allocation failures gracefully, and a filesystem
shutdown is anything but graceful.

> I do agree that we may not be seeing any buffer allocation failures (I
> was very surprised to see allocations not being checked in such a mature
> code).

The Irix kernel, where all this code and it's underlying assumptions
came from, guaranteed that kernel memory allocations would *never*
fail. The assumption that xfs_buf allocation (and that allocations
during transactions) will never fail come from this heritage.

IOWs, this change breaks an architectural assumption that XFS was
originally built around. Yes, we need to be able to handle memory
allocation errors but I don't think this is the right solution.

> Under the very same token, we will not exercise the failure paths
> these patches introduce) and hence will not get into file system
> shutdown state. No ?

Well, that's what I'm worried about. There may be people out there
that are seeing these failures, and just not reporting them (happens
all the time). In that case we better make sure that the shutdowns
occur appropriatey if we are adding error checking.

> Just in case when the buffer allocation do fail, the changes in these
> patches would prevent a kernel panic and lead to a graceful file system
> shutdown. Isn't that a better option ?

Only if the shutdown is done correctly. For example, we can now
about inode allocation half way through writing the new inode
templates - that's a brand new failure path that we've never had to
deal with before.

So, does the error handling path ensure that we don't get partial
inode clusters written to disk (e.g. allocation fails 3 buffers into
an 8 buffer-long initialisation loop)? inode allocation buffers are
handled specially by both transaction commit and log recovery, so
the blanket statement of "the higher level path has error handling"
doesn't really fill me with confidence that this has been fully
considered.

A panic will stop the transaction dead with all it's modified
objects locked and unable to be flushed to disk. If the error
handling is not cancelling everything properly and preventing the
partial state from getting to disk or out to userspace, then a panic
is far more preferable than trying to handle the allocation
error....

The other thing to consider is that an oops will only stop the
current transaction - if critical buffers are not used in the
transaction, then the filesystem can still continue to operate (e.g.
writeback will be able to clean pages and move out of the OOM
conditions). In this case, the users don't lose all the dirty data
that is cached in memory, whereas a shutdown will simply discard it
all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
