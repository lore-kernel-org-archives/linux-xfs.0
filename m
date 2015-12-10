Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23CC27F3F
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 16:34:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 00E1F304032
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 14:34:17 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	i41LTRC2HeWSB7F7 for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 14:34:15 -0800 (PST)
Date: Fri, 11 Dec 2015 09:33:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151210223333.GH26718@dastard>
References: <20151202183438.GA1319@linux.intel.com>
	<20151202202910.GH19199@dastard> <20151202204502.GI19199@dastard>
	<20151202213932.GA7652@linux.intel.com>
	<20151210165458.GA13603@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151210165458.GA13603@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, xfs@oss.sgi.com, Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>

On Thu, Dec 10, 2015 at 09:54:58AM -0700, Ross Zwisler wrote:
> On Wed, Dec 02, 2015 at 02:39:32PM -0700, Ross Zwisler wrote:
> > On Thu, Dec 03, 2015 at 07:45:02AM +1100, Dave Chinner wrote:
> > > On Thu, Dec 03, 2015 at 07:29:10AM +1100, Dave Chinner wrote:
> > > > On Wed, Dec 02, 2015 at 11:34:38AM -0700, Ross Zwisler wrote:
> > > > > I'm hitting a few more test failures in my testing setup with v4.4-rc3, xfs
> > > > > and DAX.  My test setup is a pair of 4GiB PMEM partitions in a KVM virtual
> > > > > machine.  Here are the failures:
> > > > 
> > > > Which are caused by commit 1ca1915 ("xfs: Don't use unwritten extents
> > > > for DAX") because of this code for unwritten extent conversion in
> > > > get_blocks:
> > > > 
> > > > 	tp->t_flags |= XFS_TRANS_RESERVE;
> > > > 
> > > > It's a minor problem compared to all the other issues DAX has right
> > > > now, so I ignored it to get the bigger problem solved first.
> > > 
> > > Patch to fix the problem below.
> > > 
> > > -Dave.
> > > -- 
> > > Dave Chinner
> > > david@fromorbit.com
> > > 
> > > xfs: Don't use reserved blocks for data blocks with DAX
> > > 
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Commit 1ca1915 ("xfs: Don't use unwritten extents for DAX") enabled
> > > the DAX allocation call to dip into the reserve pool in case it was
> > > converting unwritten extents rather than allocating blocks. This was
> > > a direct copy of the unwritten extent conversion code, but had an
> > > unintended side effect of allowing normal data block allocation to
> > > use the reserve pool. Hence normal block allocation could deplete
> > > the reserve pool and prevent unwritten extent conversion at ENOSPC,
> > > hence violating fallocate guarantees on preallocated space.
> > > 
> > > Fix it by checking whether the incoming map from __xfs_get_blocks()
> > > spans an unwritten extent and only use the reserve pool if the
> > > allocation covers an unwritten extent.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > 
> > Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > 
> > I've verified that this fixes all three failing xfstests reported in this mail.
> > Thanks!
> 
> Hey Dave,
> 
> Are you planning on pushing this fix for v4.4?

No plans to right now - ENOSPC is a corner case that most users
won't be anywhere near, especially for experimental functionality on
hardware nobody actually has....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
