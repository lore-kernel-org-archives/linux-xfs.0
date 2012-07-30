Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ULnphG094398 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 16:49:51 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	N68lPpnFHlKY237C for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 14:49:49 -0700 (PDT)
Date: Tue, 31 Jul 2012 07:49:46 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] xfs: check for possible overflow in xfs_ioc_trim
Message-ID: <20120730214946.GG2877@dastard>
References: <1343636024-20123-1-git-send-email-tracek@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1343636024-20123-1-git-send-email-tracek@redhat.com>
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
To: Tomas Racek <tracek@redhat.com>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, "supporter:XFS FILESYSTEM" <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, Ben Myers <bpm@sgi.com>, lczerner@redhat.com

On Mon, Jul 30, 2012 at 10:13:44AM +0200, Tomas Racek wrote:
> If range.start argument was between ULLONG_MAX - BBSIZE and ULLONG_MAX,
> BTOBB macro resulted in overflow which caused start to be set to 0.
> Now, invalid argument error is returned instead.
> 
> Signed-off-by: Tomas Racek <tracek@redhat.com>
> ---
>  fs/xfs/xfs_discard.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
> index f9c3fe3..0ef7dd4 100644
> --- a/fs/xfs/xfs_discard.c
> +++ b/fs/xfs/xfs_discard.c
> @@ -179,6 +179,10 @@ xfs_ioc_trim(
>  	 * used by the fstrim application.  In the end it really doesn't
>  	 * matter as trimming blocks is an advisory interface.
>  	 */
> +
> +	if (range.start > ULLONG_MAX - BBSIZE)
> +		return -XFS_ERROR(EINVAL);
> +

There's no point checking for overflow on the range start - what we
need to check is whether it is larger than the size of the
filesystem. We do that after the conversion of range.start to basic
blocks, so that check needs to be promoted to before this. i.e.

	if (range.start >= XFS_FSB_TO_B(mp, mp->m_sb.sb_dblocks))
		return -XFS_ERROR(EINVAL);

>  	start = BTOBB(range.start);
>  	end = start + BTOBBT(range.len) - 1;
>  	minlen = BTOBB(max_t(u64, granularity, range.minlen));

And that will prevent the overflow in BTOBB() just as effectively...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
