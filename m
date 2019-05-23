Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53680 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387693AbfEWXZQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 19:25:16 -0400
Date: Fri, 24 May 2019 09:25:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/20] xfs: factor out iclog size calculation from
 xlog_sync
Message-ID: <20190523232511.GV29573@dread.disaster.area>
References: <20190523173742.15551-1-hch@lst.de>
 <20190523173742.15551-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523173742.15551-10-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, May 23, 2019 at 07:37:31PM +0200, Christoph Hellwig wrote:
> Split out another self-contained bit of code from xlog_sync.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_log.c | 64 ++++++++++++++++++++++++++++--------------------
>  1 file changed, 38 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 885470f08554..e2c9f74f86f3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1830,6 +1830,36 @@ xlog_split_iclog(
>  	return split_offset;
>  }
>  
> +static int
> +xlog_calc_iclog_size(
> +	struct xlog		*log,
> +	struct xlog_in_core	*iclog,
> +	uint32_t		*roundoff)
> +{
> +	bool			v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
> +	uint32_t		count_init, count;
> +
> +	/* Add for LR header */
> +	count_init = log->l_iclog_hsize + iclog->ic_offset;
> +
> +	/* Round out the log write size */
> +	if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {

Hmmm, seeing as this is a now a standalone function, perhaps it
would make more sense to precalculate this whole check like so:

	bool			use_lsunit;

	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
			log->l_mp->m_sb.sb_logsunit > 1;

	if (use_lsunit) {
> +		/* we have a v2 stripe unit to use */
> +		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
> +	} else {
> +		count = BBTOB(BTOBB(count_init));
> +	}

Otherwise the patch looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
