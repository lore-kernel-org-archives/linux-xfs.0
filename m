Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD9FC7CBF
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 13:55:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 981378F804C
	for <xfs@oss.sgi.com>; Mon,  3 Jun 2013 11:55:31 -0700 (PDT)
Message-ID: <51ACE78B.6040308@redhat.com>
Date: Mon, 03 Jun 2013 14:59:23 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/6] xfs: fix remote attribute invalidation for a leaf
References: <1370237332-24757-1-git-send-email-david@fromorbit.com>
	<1370237332-24757-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1370237332-24757-5-git-send-email-david@fromorbit.com>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On 06/03/2013 01:28 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When invalidating an attribute leaf block block, there might be
> remote attributes that it points to. With the recent rework of the
> remote attribute format, we have to make sure we calculate the
> length of the attribute correctly. We aren't doing that in
> xfs_attr3_leaf_inactive(), so fix it.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Brian Foster <bfoster@redhat.com>

> ---
>  fs/xfs/xfs_attr_leaf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
> index d788302..31d3cd1 100644
> --- a/fs/xfs/xfs_attr_leaf.c
> +++ b/fs/xfs/xfs_attr_leaf.c
> @@ -3258,7 +3258,7 @@ xfs_attr3_leaf_inactive(
>  			name_rmt = xfs_attr3_leaf_name_remote(leaf, i);
>  			if (name_rmt->valueblk) {
>  				lp->valueblk = be32_to_cpu(name_rmt->valueblk);
> -				lp->valuelen = XFS_B_TO_FSB(dp->i_mount,
> +				lp->valuelen = xfs_attr3_rmt_blocks(dp->i_mount,
>  						    be32_to_cpu(name_rmt->valuelen));
>  				lp++;
>  			}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
