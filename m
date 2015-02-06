Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 809107F59
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 17:20:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E0C04AC007
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 15:20:28 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8EwibELDnb9LoC3h for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 15:20:26 -0800 (PST)
Date: Sat, 7 Feb 2015 10:19:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 07/18] xfs: handle sparse inode chunks in icreate log
	recovery
Message-ID: <20150206231946.GR12722@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423252385-3063-8-git-send-email-bfoster@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 06, 2015 at 02:52:54PM -0500, Brian Foster wrote:
> Recovery of icreate transactions assumes hardcoded values for the inode
> count and chunk length.
> 
> Sparse inode chunks are allocated in units of m_ialloc_min_blks. Update
> the icreate validity checks to allow for appropriately sized inode
> chunks and verify the inode count matches what is expected based on the
> extent length rather than assuming a hardcoded count.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index ecc73d5..5a5ee20 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3068,12 +3068,19 @@ xlog_recover_do_icreate_pass2(
>  		return -EINVAL;
>  	}
>  
> -	/* existing allocation is fixed value */
> -	ASSERT(count == mp->m_ialloc_inos);
> -	ASSERT(length == mp->m_ialloc_blks);
> -	if (count != mp->m_ialloc_inos ||
> -	     length != mp->m_ialloc_blks) {
> -		xfs_warn(log->l_mp, "xlog_recover_do_icreate_trans: bad count 2");
> +	/* inode chunk is either full or sparse */
> +	if (length != mp->m_ialloc_blks &&
> +	    length != mp->m_ialloc_min_blks) {
> +		xfs_warn(log->l_mp,
> +			 "%s: unsupported chunk length", __FUNCTION__);
> +		return -EINVAL;
> +	}

Hmmm - this would prevent recovery of sparse inode chunk allocation
in multiples of mp->m_ialloc_min_blks, right? Surely we can allow
any sub-chunk extent size to be allocated as long as alignment and
size restrictions are met?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
