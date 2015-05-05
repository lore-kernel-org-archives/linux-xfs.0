Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A4477F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 17:14:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14D85AC004
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:14:39 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	uzjUJA9EdImH9EeJ for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 15:14:36 -0700 (PDT)
Date: Wed, 6 May 2015 08:14:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: enforce imax_pct when we have per-cpu SB accounting
Message-ID: <20150505221434.GH21261@dastard>
References: <20150505220208.GC11601@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150505220208.GC11601@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <xfs@oss.sgi.com>

On Tue, May 05, 2015 at 03:02:08PM -0700, Darrick J. Wong wrote:
> When per-CPU superblock counters are enabled (i.e. SMP=y), we don't
> update the in-core superblock's sb_icount value prior to checking if
> we're already at maximum inodes.  Therefore, it's possible for a tight
> file creation loop (e.g. "for i in {0..100000}; do touch /mnt/$i;
> done") to allocate far more inodes than the administrator specified at
> mkfs time.  Fix this by synchronizing the counters every time we think
> we need to allocate another chunk of inodes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 116ef1d..a8aaab6 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -375,6 +375,8 @@ xfs_ialloc_ag_alloc(
>  	 * at one time.
>  	 */
>  	newlen = args.mp->m_ialloc_inos;
> +	if (args.mp->m_maxicount)
> +		xfs_icsb_sync_counters(args.mp, 0);
>  	if (args.mp->m_maxicount &&
>  	    args.mp->m_sb.sb_icount + newlen > args.mp->m_maxicount)
>  		return -ENOSPC;
> @@ -1339,6 +1341,8 @@ xfs_dialloc(
>  	 * okalloc so we scan all available agi structures for a free
>  	 * inode.
>  	 */
> +	if (mp->m_maxicount)
> +		xfs_icsb_sync_counters(mp, 0);
>  	if (mp->m_maxicount &&
>  	    mp->m_sb.sb_icount + mp->m_ialloc_inos > mp->m_maxicount) {
>  		noroom = 1;

As i mentioned on IRC, sb_icount is now using the generic percpu
counter infrastrcture, so shouldn't have this problem - overshoot
should be, at maximum, (Ncpus * 32).

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
