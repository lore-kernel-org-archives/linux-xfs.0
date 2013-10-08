Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 002967FAC
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 18:03:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C3F2D8F8089
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:03:45 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jGvNkB0ZRUrnYGoV for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 16:03:44 -0700 (PDT)
Message-ID: <52548F4F.5000800@sandeen.net>
Date: Tue, 08 Oct 2013 18:03:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 04/32] xfs: check magic numbers in dir3 leaf verifier first
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-5-git-send-email-david@fromorbit.com>
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

On 9/29/13 10:15 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Calling xfs_dir3_leaf_hdr_from_disk() in a verifier before
> validating the magic numbers in the buffer results in ASSERT
> failures due to mismatching magic numbers when a corruption occurs.
> Seeing as the verifier is supposed to catch the corruption and pass
> it back to the caller, having the verifier assert fail on error
> defeats the purpose of detecting the errors in the first place.
> 
> Check the magic numbers direct from the buffer before decoding the
> header.

Looks good; have you sent this for the kernel yet?

(I thought we wanted changes to hit kernelspace first) :)

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_dir2_leaf.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c
> index 7ec2f19..c035c4d 100644
> --- a/libxfs/xfs_dir2_leaf.c
> +++ b/libxfs/xfs_dir2_leaf.c
> @@ -161,6 +161,11 @@ xfs_dir3_leaf_check_int(
>  	return true;
>  }
>  
> +/*
> + * We verify the magic numbers before decoding the leaf header so that on debug
> + * kernels we don't get assertion failures in xfs_dir3_leaf_hdr_from_disk() due
> + * to incorrect magic numbers.
> + */
>  static bool
>  xfs_dir3_leaf_verify(
>  	struct xfs_buf		*bp,
> @@ -172,24 +177,25 @@ xfs_dir3_leaf_verify(
>  
>  	ASSERT(magic == XFS_DIR2_LEAF1_MAGIC || magic == XFS_DIR2_LEAFN_MAGIC);
>  
> -	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
>  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
>  		struct xfs_dir3_leaf_hdr *leaf3 = bp->b_addr;
> +		__uint16_t		magic3;
>  
> -		if ((magic == XFS_DIR2_LEAF1_MAGIC &&
> -		     leafhdr.magic != XFS_DIR3_LEAF1_MAGIC) ||
> -		    (magic == XFS_DIR2_LEAFN_MAGIC &&
> -		     leafhdr.magic != XFS_DIR3_LEAFN_MAGIC))
> -			return false;
> +		magic3 = (magic == XFS_DIR2_LEAF1_MAGIC) ? XFS_DIR3_LEAF1_MAGIC
> +							 : XFS_DIR3_LEAFN_MAGIC;
>  
> +		if (leaf3->info.hdr.magic != cpu_to_be16(magic3))
> +			return false;
>  		if (!uuid_equal(&leaf3->info.uuid, &mp->m_sb.sb_uuid))
>  			return false;
>  		if (be64_to_cpu(leaf3->info.blkno) != bp->b_bn)
>  			return false;
>  	} else {
> -		if (leafhdr.magic != magic)
> +		if (leaf->hdr.info.magic != cpu_to_be16(magic))
>  			return false;
>  	}
> +
> +	xfs_dir3_leaf_hdr_from_disk(&leafhdr, leaf);
>  	return xfs_dir3_leaf_check_int(mp, &leafhdr, leaf);
>  }
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
