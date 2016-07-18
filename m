Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1155D7CAF
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 08:34:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D8225304048
	for <xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nDTj8CmPfrOeJEMC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jul 2016 06:34:30 -0700 (PDT)
Date: Mon, 18 Jul 2016 09:34:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 047/119] xfs: disable XFS_IOC_SWAPEXT when rmap btree is
	enabled
Message-ID: <20160718133428.GF27380@bfoster.bfoster>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612657322.12839.9067889093004523073.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612657322.12839.9067889093004523073.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Thu, Jun 16, 2016 at 06:22:53PM -0700, Darrick J. Wong wrote:
> Swapping extents between two inodes requires the owner to be updated
> in the rmap tree for all the extents that are swapped. This code
> does not yet exist, so switch off the XFS_IOC_SWAPEXT ioctl until
> support has been implemented. This will need to be done before the
> rmap btree code can have the experimental tag removed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> [darrick.wong@oracle.com: fix extent swapping when rmap enabled]
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_bmap_util.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 450fd49..8666873 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1618,6 +1618,10 @@ xfs_swap_extents(
>  	__uint64_t	tmp;
>  	int		lock_flags;
>  
> +	/* XXX: we can't do this with rmap, will fix later */
> +	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
> +		return -EOPNOTSUPP;
> +
>  	tempifp = kmem_alloc(sizeof(xfs_ifork_t), KM_MAYFAIL);
>  	if (!tempifp) {
>  		error = -ENOMEM;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
