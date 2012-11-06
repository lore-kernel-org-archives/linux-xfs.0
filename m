Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6L2plF089448 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 15:02:52 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	qhcwrYLLFqQpkkhK for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 13:04:47 -0800 (PST)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TVqKC-0008I7-CN
	for xfs@oss.sgi.com; Wed, 07 Nov 2012 08:04:44 +1100
Date: Wed, 7 Nov 2012 08:04:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/22 V4] xfs: metadata verifiers
Message-ID: <20121106210444.GE24575@dastard>
References: <1352178813-17216-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1352178813-17216-1-git-send-email-david@fromorbit.com>
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

On Tue, Nov 06, 2012 at 04:13:11PM +1100, Dave Chinner wrote:
> Hi folks,
> 
> Fourth version of the buffer verifier series. The read verifier
> infrastructure is described here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00146.html
> 
> The second version with write verifiers is described here:
> 
> http://oss.sgi.com/archives/xfs/2012-10/msg00280.html
> 
> This version add write verifiers to all buffers that aren't directly
> read (i.e. via xfs_buf_get*() interfaces), and drops the log
> recovery verifiers from the series as it really needs more buffer
> item format flags to do relaibly.
> 
> The seris is just about ready to go - it passes all of xfstests here
> except for 070. With the addition of the getbuf write verifiers,
> this series is now detecting a corrupt xfs_da_node buffer being
> written to disk.  It appears to be a new symptom of known problem,
> as tracing indicates that the test is triggering the same double
> split/join pattern as described here:
> 
> http://oss.sgi.com/archives/xfs/2012-03/msg00347.html

So, 070 isn't hitting this exact problem - I think i have a handle
on the cause of the problem in the link now (i.e. I have a fix that
passes all of xfstests without any other problems arising), but the
reproducer is also causing the same write verifier failures as 070
and 117. However, all three do a double leaf split operation, so
that's going to be the underlying cause of the verifier failure.

This tracepoint list is the first half of an attribute add
operation:

xfs_attr_node_addname
xfs_buf_init
xfs_attr_leaf_lookup
xfs_attr_node_replace
xfs_attr_leaf_add
xfs_da_split
xfs_attr_leaf_split
xfs_da_grow_inode
xfs_attr_leaf_create
xfs_attr_leaf_rebalance
xfs_trans_log_buf
xfs_da_link_after
xfs_trans_log_buf
xfs_attr_leaf_add_old
xfs_attr_leaf_add
xfs_attr_leaf_compact
xfs_trans_log_buf
xfs_attr_leaf_split_before
xfs_attr_leaf_split
xfs_da_grow_inode
xfs_attr_leaf_create
xfs_attr_leaf_rebalance
xfs_da_link_after
xfs_trans_log_buf
xfs_attr_leaf_add_new
xfs_attr_leaf_add
xfs_attr_leaf_add_work
xfs_da_fixhashpath
xfs_da_node_split
xfs_da_node_add
xfs_da_node_add
xfs_da_fixhashpath
xfs_attr_leaf_flipflags

(that double leaf split makes it nice and complex, doesn't it?)

One of these operations is resulting in the buffer at block number
0xc8 being corrupted in memory. The xfs_trans_log_buf() calls above
are the places where that buffer is logged. Prior to fixing the
corruption problem, the code would assert fail in
xfs_attr_leaf_flipflags() (part of the atomic rename sequence), then
a couple of seconds later dump a write verifier failure.

Now I've just got to work out where in this maze the buffer gets
corrupted, and then I might start to understand why it doesn't
appear to cause detectable on-disk corruption...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
