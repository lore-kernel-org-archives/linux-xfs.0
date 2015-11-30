Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 762EC7F50
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 07:22:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23655AC003
	for <xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:22:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Oo7YzPUWnwIu44wA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Nov 2015 05:22:25 -0800 (PST)
Date: Mon, 30 Nov 2015 08:22:24 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs/xfs_buf: make xfs_buf_ioend_async() static
Message-ID: <20151130132223.GB24765@bfoster.bfoster>
References: <1448646749-18978-1-git-send-email-kuleshovmail@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1448646749-18978-1-git-send-email-kuleshovmail@gmail.com>
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
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Nov 27, 2015 at 11:52:29PM +0600, Alexander Kuleshov wrote:
> There are no callers of the xfs_buf_ioend_async() function outside
> of the fs/xfs/xfs_buf.c. So, let's make it static.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 3243cdf..45a8ea7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1045,7 +1045,7 @@ xfs_buf_ioend_work(
>  	xfs_buf_ioend(bp);
>  }
>  
> -void
> +static void
>  xfs_buf_ioend_async(
>  	struct xfs_buf	*bp)
>  {
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
