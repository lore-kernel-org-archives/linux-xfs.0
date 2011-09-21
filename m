Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LET6uq149276 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 09:29:06 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBAE613FDB94
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:34:29 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id H1lAV6DgCrXEJmTm for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:34:29 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8LD8H6j002452
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 09:08:17 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p8LET1Cb106754 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 10:29:03 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p8LAShxL020392 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 07:28:44 -0300
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110921005612.GL15688@dastard>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
	<20110921005612.GL15688@dastard>
Date: Wed, 21 Sep 2011 09:28:50 -0500
Message-ID: <1316615330.9298.117.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: Alex Elder <aelder@sgi.com>, XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-09-21 at 10:56 +1000, Dave Chinner wrote:
> On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> > Ran the xfstests (auto) overnight and didn't see any new issues.
>
> Sure, but xfstests won't be triggering the new failure paths.

I meant to convey that I did not introduce any regressions.

> 
> It looks to me like any failure to get a buffer will now result in a
> cancelled transaction and a filesystem shutdown - the new failure
> paths really need to be tested to ensure that failures are handled
> gracefully and don't result in filesystem corruption.
> 
> As it is, I'm not sure we want to do this. The only reason we can
> fail to get a buffer is allocation failures in extremely low memory
> conditions. However, the last thing we want is for filesystem
> shutdowns to be triggered by transient low memory conditions.
> 
> The current state of the code is that the xfs_buf_get() code tries
> really, really hard to allocate memory, and we don't have any
> evidence to point to the fact that is it failing to allocate memory.
> We'd be seeing asserts firing and/or NULL pointer deref panics if
> xfs_buf_get() was failing, and neither of these are happening.

I am really confused. Are you saying we should rather let the kernel
reference a null pointer and panic than making the file system shutdown
gracefully ?!

I do agree that we may not be seeing any buffer allocation failures (I
was very surprised to see allocations not being checked in such a mature
code). Under the very same token, we will not exercise the failure paths
these patches introduce) and hence will not get into file system
shutdown state. No ?

Just in case when the buffer allocation do fail, the changes in these
patches would prevent a kernel panic and lead to a graceful file system
shutdown. Isn't that a better option ?
 
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
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
