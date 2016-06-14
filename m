Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7964D7CA0
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 18:06:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4B8A7304039
	for <xfs@oss.sgi.com>; Tue, 14 Jun 2016 16:06:35 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	y1ktwrMwP6v0vY57 for <xfs@oss.sgi.com>;
	Tue, 14 Jun 2016 16:06:29 -0700 (PDT)
Date: Wed, 15 Jun 2016 09:06:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH-tip 6/6] xfs: Enable reader optimistic spinning for
	DAX inodes
Message-ID: <20160614230613.GB26977@dastard>
References: <1465927959-39719-1-git-send-email-Waiman.Long@hpe.com>
	<1465927959-39719-7-git-send-email-Waiman.Long@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1465927959-39719-7-git-send-email-Waiman.Long@hpe.com>
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
To: Waiman Long <Waiman.Long@hpe.com>
Cc: linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>, linux-ia64@vger.kernel.org, Scott J Norton <scott.norton@hpe.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, linux-alpha@vger.kernel.org, Douglas Hatch <doug.hatch@hpe.com>, Jason Low <jason.low2@hp.com>

On Tue, Jun 14, 2016 at 02:12:39PM -0400, Waiman Long wrote:
> This patch enables reader optimistic spinning for inodes that are
> under a DAX-based mount point.
> 
> On a 4-socket Haswell machine running on a 4.7-rc1 tip-based kernel,
> the fio test with multithreaded randrw and randwrite tests on the
> same file on a XFS partition on top of a NVDIMM with DAX were run,
> the aggregated bandwidths before and after the patch were as follows:
> 
>   Test      BW before patch     BW after patch  % change
>   ----      ---------------     --------------  --------
>   randrw        1352 MB/s          2164 MB/s      +60%
>   randwrite     1710 MB/s          2550 MB/s      +49%
> 
> Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
> ---
>  fs/xfs/xfs_icache.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 99ee6ee..09f284f 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -71,6 +71,15 @@ xfs_inode_alloc(
>  
>  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
>  
> +	/*
> +	 * Enable reader spinning for DAX nount point
> +	 */
> +	if (mp->m_flags & XFS_MOUNT_DAX) {
> +		rwsem_set_rspin_threshold(&ip->i_iolock.mr_lock);
> +		rwsem_set_rspin_threshold(&ip->i_mmaplock.mr_lock);
> +		rwsem_set_rspin_threshold(&ip->i_lock.mr_lock);
> +	}

That's wrong. DAX is a per-inode flag, not a mount wide flag. This
needs to be done once the inode has been fully initialised and
IS_DAX(inode) can be run.

Also, the benchmark doesn't show that all these locks are being
tested by this benchmark. e.g. the i_mmaplock isn't involved in
the benchmark's IO paths at all. It's only taken in page faults and
truncate paths....

I'd also like to see how much of the gain comes from the iolock vs
the ilock, as the ilock is nested inside the iolock and so
contention is much rarer....

As it is, I'm *extremely* paranoid when it comes to changes to core
locking like this. Performance is secondary to correctness, and we
need much more than just a few benchmarks to verify there aren't
locking bugs being introduced....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
