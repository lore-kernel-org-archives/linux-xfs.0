Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3148D7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 13:59:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0B4678F8033
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 11:59:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 96jxOR5F7ELdWwZG for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 11:59:38 -0700 (PDT)
Message-ID: <519A7395.9060806@redhat.com>
Date: Mon, 20 May 2013 15:03:49 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 08/14] xfs: remote attribute allocation may be contiguous
References: <1369007481-15185-1-git-send-email-david@fromorbit.com>
	<1369007481-15185-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1369007481-15185-9-git-send-email-david@fromorbit.com>
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

On 05/19/2013 07:51 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When CRCs are enabled, there may be multiple allocations made if the
> headers cause a length overflow. This, however, does not mean that
> the number of headers required increases, as the second and
> subsequent extents may be contiguous with the previous extent. Hence
> when we map the extents to write the attribute data, we may end up
> with less extents than allocations made. Hence the assertion that we
> consume th enumber of headers we calculated in the allocation loop
> is incorrect and needs to be removed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_attr_remote.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
> index dee8446..aad95b0 100644
> --- a/fs/xfs/xfs_attr_remote.c
> +++ b/fs/xfs/xfs_attr_remote.c
> @@ -359,6 +359,11 @@ xfs_attr_rmtval_set(
>  		 * into requiring more blocks. e.g. for 512 byte blocks, we'll
>  		 * spill for another block every 9 headers we require in this
>  		 * loop.
> +		 *
> +		 * Note that this can result in contiguous allocation of blocks,
> +		 * so we don't use all the space we allocate for headers as we
> +		 * have one less header for each contiguous allocation that
> +		 * occurs in the map/write loop below.
>  		 */
>  		if (crcs && blkcnt == 0) {
>  			int total_len;
> @@ -439,7 +444,6 @@ xfs_attr_rmtval_set(
>  		lblkno += map.br_blockcount;
>  	}
>  	ASSERT(valuelen == 0);
> -	ASSERT(hdrcnt == 0);

I can't say I grok the context enough atm to send a Reviewed-by, but if
we're removing this, why not just remove the hdrcnt-- a few lines up as
well? It doesn't appear to be used after the first loop at this point.

Brian

>  	return 0;
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
