Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7KFVEG3239400 for <xfs@oss.sgi.com>; Mon, 20 Aug 2012 10:31:14 -0500
Message-ID: <5032583F.6050207@sgi.com>
Date: Mon, 20 Aug 2012 10:31:11 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 2/4] xfs: Introduce a helper routine to probe data
	or hole offset from page cache
References: <5028FC2E.2010802@oracle.com>
In-Reply-To: <5028FC2E.2010802@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com

On 08/13/12 08:07, Jeff Liu wrote:
> helper routine to lookup data or hole offset from page cache for unwritten extents.
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> ---
>   fs/xfs/xfs_file.c |  213 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 files changed, 213 insertions(+), 0 deletions(-)
> +STATIC bool
> +xfs_find_get_desired_pgoff(
> +	struct inode		*inode,
> +	struct xfs_bmbt_irec	*map,
> +	unsigned int		type,
> +	loff_t			*offset)
> +{

...

> +		for (i = 0; i<  nr_pages; i++) {
> +			struct page	*page = pvec.pages[i];
> +			loff_t		b_offset;
> +
> +			/*
> +			 * Page index is out of range, searching done.
> +			 * If the current offset is not reaches the end
> +			 * of the specified search range, there should
> +			 * be a hole between them.
> +			 */
> +			if (page->index>  end) {

Shouldn't this sample of the index also be locked?

> +				if (type == HOLE_OFF&&  lastoff<  endoff) {
> +					*offset = lastoff;
> +					found = true;
> +				}
> +				goto out;
> +			}
> +
> +			lock_page(page);

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
