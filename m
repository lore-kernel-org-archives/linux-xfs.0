Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A8FF7FAD
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 18:09:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16EC98F807A
	for <xfs@oss.sgi.com>; Tue,  8 Oct 2013 16:09:47 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id wMZiapFFmU9Rfu2S for <xfs@oss.sgi.com>;
	Tue, 08 Oct 2013 16:09:46 -0700 (PDT)
Message-ID: <525490B5.7080907@sandeen.net>
Date: Tue, 08 Oct 2013 18:09:41 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 06/32] xfs: don't assert fail on bad inode numbers
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
	<1380510944-8571-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-7-git-send-email-david@fromorbit.com>
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
> Let the inode verifier do it's work by returning an error when we
> fail to find correct magic numbers in an inode buffer.

Makes sense & matches kernel 74ffa796e127906883cacedcf3871494192c9e42

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  libxfs/xfs_inode_buf.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
> index 6205318..b096f77 100644
> --- a/libxfs/xfs_inode_buf.c
> +++ b/libxfs/xfs_inode_buf.c
> @@ -39,9 +39,8 @@ xfs_inobp_check(
>  					i * mp->m_sb.sb_inodesize);
>  		if (!dip->di_next_unlinked)  {
>  			xfs_alert(mp,
> -	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
> -				bp);
> -			ASSERT(dip->di_next_unlinked);
> +	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
> +				i, (long long)bp->b_bn);
>  		}
>  	}
>  }
> @@ -74,11 +73,10 @@ xfs_inode_buf_verify(
>  			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
>  					     mp, dip);
>  #ifdef DEBUG
> -			xfs_emerg(mp,
> +			xfs_alert(mp,
>  				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
>  				(unsigned long long)bp->b_bn, i,
>  				be16_to_cpu(dip->di_magic));
> -			ASSERT(0);
>  #endif
>  		}
>  	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
