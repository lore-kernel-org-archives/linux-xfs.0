Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5E897F98
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 16:18:20 -0500 (CDT)
Date: Thu, 14 Mar 2013 16:18:17 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 02/21] xfs: increase hexdump output in xfs_corruption_error
Message-ID: <20130314211817.GX22182@sgi.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
	<1363091454-8852-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1363091454-8852-3-git-send-email-david@fromorbit.com>
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

On Tue, Mar 12, 2013 at 11:30:35PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Currently xfs_corruption_error() dumps the first 16 bytes of the
> buffer that is passed to it when a corruption occurs. This is not
> large enough to see the entire state of the header of the block that
> was determined to be corrupt.  increase the output to 64 bytes to
> capture the majority of all headers in all types of metadata blocks.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_error.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 07bf3b9..35d3f5b 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -178,7 +178,7 @@ xfs_corruption_error(
>  	inst_t			*ra)
>  {
>  	if (level <= xfs_error_level)
> -		xfs_hex_dump(p, 16);
> +		xfs_hex_dump(p, 64);

Are you sure we don't have any structures which are shorter than that?  I guess
we'll have to take a look.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
