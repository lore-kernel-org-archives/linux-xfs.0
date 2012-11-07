Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA764XoQ125626 for <xfs@oss.sgi.com>; Wed, 7 Nov 2012 00:04:33 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zd6g4yc4FKTmdP3g for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 22:06:29 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TVyll-0000mV-4v
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 17:05:45 +1100
Date: Wed, 7 Nov 2012 17:05:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/22 V4] xfs: metadata verifiers
Message-ID: <20121107060545.GC6434@dastard>
References: <1352178813-17216-1-git-send-email-david@fromorbit.com>
	<20121106210444.GE24575@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121106210444.GE24575@dastard>
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
To: xfs@oss.sgi.com

On Wed, Nov 07, 2012 at 08:04:44AM +1100, Dave Chinner wrote:
> On Tue, Nov 06, 2012 at 04:13:11PM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > Fourth version of the buffer verifier series. The read verifier
> > infrastructure is described here:
> > 
> > http://oss.sgi.com/archives/xfs/2012-10/msg00146.html
> > 
> > The second version with write verifiers is described here:
> > 
> > http://oss.sgi.com/archives/xfs/2012-10/msg00280.html
> > 
> > This version add write verifiers to all buffers that aren't directly
> > read (i.e. via xfs_buf_get*() interfaces), and drops the log
> > recovery verifiers from the series as it really needs more buffer
> > item format flags to do relaibly.
> > 
> > The seris is just about ready to go - it passes all of xfstests here
> > except for 070. With the addition of the getbuf write verifiers,
> > this series is now detecting a corrupt xfs_da_node buffer being
> > written to disk.  It appears to be a new symptom of known problem,
> > as tracing indicates that the test is triggering the same double
> > split/join pattern as described here:
> > 
> > http://oss.sgi.com/archives/xfs/2012-03/msg00347.html
> 
> So, 070 isn't hitting this exact problem - I think i have a handle
> on the cause of the problem in the link now (i.e. I have a fix that
> passes all of xfstests without any other problems arising), but the
> reproducer is also causing the same write verifier failures as 070
> and 117. However, all three do a double leaf split operation, so
> that's going to be the underlying cause of the verifier failure.

They underlying cause is the fact that leaf format attribute tree
format is unreliable when there are remote attributes. The detection
is based on the being precisely one block at offset 0 in the
attribute fork bmap btree, and when you add remote attributes that
is no longer true, even though the root block of the attribute tree
is still a leaf.

Hence there is code in the node format detection that specifically
handles leaf format trees when doing node format operations. This is
how the xfs_da_node_buf_ops get attached to attribute leaf format
buffers being read from disk - they pass verification because the
da node format verifier sees the leaf magic number and calls the
appropriate verifier instead.

This issue was that the original code I wrote had the read verifier
set the write verifier, so this act of calling the correct read
verifier also set the write verifier correctly. Convert to an ops
structure meant that this implicit rewrite of the write verifier no
longer occurred, and boomy-boom-boom when the write verifier when
the above situation occurs.

I just posted a V2 patch for 22/22 that fixes this. Now all xfstests
pass with the patch set.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
