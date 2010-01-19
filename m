Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0J9PmwX180554 for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 03:25:48 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 838ED1C5DF57
	for <xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:26:48 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Oy0H7GsdoIQdTXoG for
	<xfs@oss.sgi.com>; Tue, 19 Jan 2010 01:26:48 -0800 (PST)
Date: Tue, 19 Jan 2010 04:26:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] xfs: make xfs_dir_cilookup_result use unsigned char
Message-ID: <20100119092648.GD7168@infradead.org>
References: <1263861026-13448-1-git-send-email-david@fromorbit.com>
	<1263861026-13448-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1263861026-13448-5-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jan 19, 2010 at 11:30:22AM +1100, Dave Chinner wrote:
> For consistency with the result of the code.
> 
> Signed-off-by: Dave Chinner <david@fromorbit.com>
> ---
>  fs/xfs/xfs_dir2.c |    2 +-
>  fs/xfs/xfs_dir2.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dir2.c b/fs/xfs/xfs_dir2.c
> index c21c527..3a8c6ba 100644
> --- a/fs/xfs/xfs_dir2.c
> +++ b/fs/xfs/xfs_dir2.c
> @@ -247,7 +247,7 @@ xfs_dir_createname(
>  int
>  xfs_dir_cilookup_result(
>  	struct xfs_da_args *args,
> -	const char	*name,
> +	const unsigned char *name,
>  	int		len)
>  {

Given that the value we copy things into is unsigned anyway this looks
correct,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
