Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pADBxh63110004 for <xfs@oss.sgi.com>; Sun, 13 Nov 2011 05:59:43 -0600
Date: Sun, 13 Nov 2011 06:59:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfsprogs: unconditionally drop used buffer reference
Message-ID: <20111113115940.GB19435@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<f4640a738a62150c745c843b92c5d143ad1cb155.1320955675.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f4640a738a62150c745c843b92c5d143ad1cb155.1320955675.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:12PM -0600, Alex Elder wrote:
> In libxfs_mount(), after reading the last block in the log device,
> the buffer is released by a call to libxfs_putbuf().  But it's done
> only if bp is non-null.  It always will be non-null at this point,
> so just make the call unconditionally.
> 
> Also touch up a misleading indent.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>
> ---
>  libxfs/init.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/libxfs/init.c b/libxfs/init.c
> index 08fc584..ba44c9b 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -743,15 +743,14 @@ libxfs_mount(
>  			if (!(flags & LIBXFS_MOUNT_DEBUGGER))
>  				return NULL;
>  		}
> -		if (bp)
> -			libxfs_putbuf(bp);
> +		libxfs_putbuf(bp);
>  	}

This one isn't correct.  If LIBXFS_MOUNT_DEBUGGER is set we still
get through to here.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
