Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A674F7CA0
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 10:38:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 693BF8F8039
	for <xfs@oss.sgi.com>; Wed, 21 Sep 2016 08:38:46 -0700 (PDT)
Received: from mga05.intel.com ([192.55.52.43]) by cuda.sgi.com with ESMTP id
	2BY4oHIAJSrfyuoQ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 21 Sep 2016 08:38:45 -0700 (PDT)
Date: Wed, 21 Sep 2016 09:38:44 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: kernel BUG at fs/xfs/xfs_message.c:113!
Message-ID: <20160921153844.GA24413@linux.intel.com>
References: <20160920163304.GA8999@linux.intel.com>
	<20160920201453.GH340@dastard> <20160920230613.GL340@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160920230613.GL340@dastard>
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
Cc: linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com

On Wed, Sep 21, 2016 at 09:06:13AM +1000, Dave Chinner wrote:
> On Wed, Sep 21, 2016 at 06:14:53AM +1000, Dave Chinner wrote:
> > On Tue, Sep 20, 2016 at 10:33:04AM -0600, Ross Zwisler wrote:
> > > I'm consistently able to generate this kernel BUG with both v4.7 and v4.8-rc7.
> > > This bug reproduces both with and without DAX.
> > > Here is the BUG with v4.8-rc7, passed through kasan_symbolize.py:
> > > 
> > >   run fstests generic/026 at 2016-09-20 10:22:58
> > >   XFS (pmem0p2): Unmounting Filesystem
> > >   XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309
> > 
> > It overran the block allocation reservation for the transaction.
> 
> Can you try the patch I've attached below, Ross? it solves the
> problem for me....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: remote attribute blocks aren't really userdata
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When adding a new remote attribute, we write the attribute to the
> new extent before the allocation transaction is committed. This
> means we cannot reuse busy extents as that violates crash
> consistency semantics. Hence we currently treat remote attribute
> extent allocation like userdata because it has the same overwrite
> ordering constraints as userdata.
> 
> Unfortunately, this also allows the allocator to incorrectly apply
> extent size hints to the remote attribute extent allocation. This
> results in interesting failures, such as transaction block
> reservation overruns and in-memory inode attribute fork corruption.
> 
> To fix this, we need to separate the busy extent reuse configuration
> from the userdata configuration. This changes the definition of
> XFS_BMAPI_METADATA slightly - it now means that allocation is
> metadata and reuse of busy extents is acceptible due to the metadata
> ordering semantics of the journal. If this flag is not set, it
> means the allocation is that has unordered data writeback, and hence
> busy extent reuse is not allowed. It no longer implies the
> allocation is for user data, just that the data write will not be
> strictly ordered. This matches the semantics for both user data
> and remote attribute block allocation.
> 
> As such, This patch changes the "userdata" field to a "datatype"
> field, and adds a "no busy reuse" flag to the field.
> When we detect an unordered data extent allocation, we immediately set
> the no reuse flag. We then set the "user data" flags based on the
> inode fork we are allocating the extent to. Hence we only set
> userdata flags on data fork allocations now and consider attribute
> fork remote extents to be an unordered metadata extent.
> 
> The result is that remote attribute extents now have the expected
> allocation semantics, and the data fork allocation behaviour is
> completely unchanged.
> 
> It should be noted that there may be other ways to fix this (e.g.
> use ordered metadata buffers for the remote attribute extent data
> write) but they are more invasive and difficult to validate both
> from a design and implementation POV. Hence this patch takes the
> simple, obvious route to fixing the problem...
> 
> Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Yep, this solves it for me as well.

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
