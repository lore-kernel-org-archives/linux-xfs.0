Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 556FF7CB1
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 07:52:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1A7798F8050
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 05:52:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qDc5o9dgtiyMWECv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Apr 2016 05:52:03 -0700 (PDT)
Date: Wed, 6 Apr 2016 08:52:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/5] xfs: xfs_iflush_cluster has range issues
Message-ID: <20160406125201.GC4188@bfoster.bfoster>
References: <1459934574-25543-1-git-send-email-david@fromorbit.com>
	<1459934574-25543-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1459934574-25543-4-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2016 at 07:22:52PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_iflush_cluster() does a gang lookup on the radix tree, meaning
> it can find inode beyond the current cluster if there is sparse

	      inodes

> cache population. gang lookups return results in ascending index
> order, so stop trying to cluster iodes once the first inode outside

				   inodes

> the cluster mask is detected.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 6598104..b984be4 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3194,11 +3194,20 @@ xfs_iflush_cluster(
>  		 */
>  		spin_lock(&cip->i_flags_lock);
>  		if (!cip->i_ino ||
> -		    __xfs_iflags_test(ip, XFS_ISTALE) ||
> -		    (XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> +		    __xfs_iflags_test(ip, XFS_ISTALE)) {
>  			spin_unlock(&cip->i_flags_lock);
>  			continue;
>  		}
> +
> +		/*
> +		 * Once we fall off the end of the cluster, no point checking
> +		 * any more inodes in the list because they will also all be
> +		 * outside the cluster.
> +		 */
> +		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> +			spin_unlock(&cip->i_flags_lock);
> +			break;
> +		}
>  		spin_unlock(&cip->i_flags_lock);
>  
>  		/*
> -- 
> 2.7.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
