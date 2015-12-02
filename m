Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 867447F69
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 15:39:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F10F8F8054
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 13:39:35 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id c4UPXZQ0MbVp42V0 for
	<xfs@oss.sgi.com>; Wed, 02 Dec 2015 13:39:33 -0800 (PST)
Date: Wed, 2 Dec 2015 14:39:32 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151202213932.GA7652@linux.intel.com>
References: <20151202183438.GA1319@linux.intel.com>
	<20151202202910.GH19199@dastard> <20151202204502.GI19199@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151202204502.GI19199@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Thu, Dec 03, 2015 at 07:45:02AM +1100, Dave Chinner wrote:
> On Thu, Dec 03, 2015 at 07:29:10AM +1100, Dave Chinner wrote:
> > On Wed, Dec 02, 2015 at 11:34:38AM -0700, Ross Zwisler wrote:
> > > I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> > > and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> > > machine.  Here are the failures:
> > 
> > Which are caused by commit 1ca1915 ("xfs: Don't use unwritten extents
> > for DAX") because of this code for unwritten extent conversion in
> > get_blocks:
> > 
> > 	tp->t_flags |= XFS_TRANS_RESERVE;
> > 
> > It's a minor problem compared to all the other issues DAX has right
> > now, so I ignored it to get the bigger problem solved first.
> 
> Patch to fix the problem below.
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: Don't use reserved blocks for data blocks with DAX
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 1ca1915 ("xfs: Don't use unwritten extents for DAX") enabled
> the DAX allocation call to dip into the reserve pool in case it was
> converting unwritten extents rather than allocating blocks. This was
> a direct copy of the unwritten extent conversion code, but had an
> unintended side effect of allowing normal data block allocation to
> use the reserve pool. Hence normal block allocation could deplete
> the reserve pool and prevent unwritten extent conversion at ENOSPC,
> hence violating fallocate guarantees on preallocated space.
> 
> Fix it by checking whether the incoming map from __xfs_get_blocks()
> spans an unwritten extent and only use the reserve pool if the
> allocation covers an unwritten extent.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>

I've verified that this fixes all three failing xfstests reported in this mail.
Thanks!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
