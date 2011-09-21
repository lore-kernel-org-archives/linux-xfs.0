Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8L0uI4r098211 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 19:56:18 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D97AD1607DB2
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 18:01:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	xjJ0EN3NeFbvY8Qk for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 18:01:36 -0700 (PDT)
Date: Wed, 21 Sep 2011 10:56:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
Message-ID: <20110921005612.GL15688@dastard>
References: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
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

On Tue, Sep 20, 2011 at 08:56:55AM -0500, Chandra Seetharaman wrote:
> Ran the xfstests (auto) overnight and didn't see any new issues.

Sure, but xfstests won't be triggering the new failure paths.

It looks to me like any failure to get a buffer will now result in a
cancelled transaction and a filesystem shutdown - the new failure
paths really need to be tested to ensure that failures are handled
gracefully and don't result in filesystem corruption.

As it is, I'm not sure we want to do this. The only reason we can
fail to get a buffer is allocation failures in extremely low memory
conditions. However, the last thing we want is for filesystem
shutdowns to be triggered by transient low memory conditions.

The current state of the code is that the xfs_buf_get() code tries
really, really hard to allocate memory, and we don't have any
evidence to point to the fact that is it failing to allocate memory.
We'd be seeing asserts firing and/or NULL pointer deref panics if
xfs_buf_get() was failing, and neither of these are happening.

As it is, before we can gracefully handle memory allocation failures
in the xfs_buf layer, we need to be able to roll back dirty
transactions so that memory allocation failure does not result
filesystem shutdowns. That's actually possible to do now with the
delayed logging infrastructure (because the CIL keeps a copy of the
previous in memory modifications prior to the bad transaction), so
we should look towards implementing transaction rollback first
before allowing memory allocation to fail inside transaction
contexts....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
