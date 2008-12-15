Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBFLieno009454
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 15:44:41 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8B6B622A95
	for <linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 13:44:39 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FlQ74EzPCYwID2lD for
	<linux-xfs@oss.sgi.com>; Mon, 15 Dec 2008 13:44:39 -0800 (PST)
Date: Mon, 15 Dec 2008 16:44:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Include ctype.h for tolower(3).
Message-ID: <20081215214438.GA5392@infradead.org>
References: <1229371140-105409-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1229371140-105409-1-git-send-email-arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-xfs@oss.sgi.com

On Mon, Dec 15, 2008 at 08:59:00PM +0100, Arkadiusz Miskiewicz wrote:
> ---
>  xfsprogs/libxfs/xfs_dir2.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/xfsprogs/libxfs/xfs_dir2.c b/xfsprogs/libxfs/xfs_dir2.c
> index 71134f8..eab4718 100644
> --- a/xfsprogs/libxfs/xfs_dir2.c
> +++ b/xfsprogs/libxfs/xfs_dir2.c
> @@ -17,6 +17,7 @@
>   */
>  
>  #include <xfs.h>
> +#include <ctype.h>

This file is shared with the kernel, so adding the include here is not
a good idea.  Can you resubmit it with the include added in
include/platform_defs.h.in?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
