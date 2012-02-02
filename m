Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q12G7YGg061171 for <xfs@oss.sgi.com>; Thu, 2 Feb 2012 10:07:36 -0600
Date: Thu, 2 Feb 2012 11:07:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] xfs: cleanup quota check on disk blocks and inodes
	reservations
Message-ID: <20120202160726.GA10568@infradead.org>
References: <20120123034513.3339.97432.stgit@ltc219.sdl.hitachi.co.jp>
	<20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120123034543.3339.56848.stgit@ltc219.sdl.hitachi.co.jp>
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
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Alex Elder <elder@kernel.org>, yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>

On Mon, Jan 23, 2012 at 12:45:43PM +0900, Mitsuo Hayasaka wrote:
> This patch is a cleanup of quota check on disk blocks and inodes
> reservations.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Ben Myers <bpm@sgi.com>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
> 
>  fs/xfs/xfs_trans_dquot.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index c4ba366..5e6cd1c 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -605,7 +605,7 @@ xfs_trans_dqresv(
>  	time_t		timer;
>  	xfs_qwarncnt_t	warns;
>  	xfs_qwarncnt_t	warnlimit;
> -	xfs_qcnt_t	count;
> +	xfs_qcnt_t	tcount;

Can you call this variable total_count to make it a bit more obvious?

> +			tcount = *resbcountp + nblks;
> +			if (hardlimit > 0ULL && tcount > hardlimit) {

Given that xfs_qcnt_t is unsigned what about transforming this into the
more readable:

			if (hardlimit && total_count > hardlimit)

and similar for the others?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
