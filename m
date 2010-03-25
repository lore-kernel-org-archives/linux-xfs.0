Return-Path: <xfs-bounces@oss.sgi.com>
Subject: Re: [PATCH 11/16] XFS xfs_trace.c: duplicated include
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
References: <1269537767-7553-1-git-send-email-andrea.gelmini@gelma.net>
	<1269537767-7553-11-git-send-email-andrea.gelmini@gelma.net>
Date: Thu, 25 Mar 2010 13:37:39 -0500
Message-ID: <1269542259.2523.25.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Christoph Hellwig <hch@lst.de>

On Thu, 2010-03-25 at 18:22 +0100, Andrea Gelmini wrote:
> fs/xfs/linux-2.6/xfs_trace.c: xfs_attr_sf.h is included more than once.
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>

Looks good.	-Alex

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_trace.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_trace.c b/fs/xfs/linux-2.6/xfs_trace.c
> index 5a10760..cb840e0 100644
> --- a/fs/xfs/linux-2.6/xfs_trace.c
> +++ b/fs/xfs/linux-2.6/xfs_trace.c
> @@ -41,7 +41,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_attr.h"
> -#include "xfs_attr_sf.h"
>  #include "xfs_attr_leaf.h"
>  #include "xfs_log_priv.h"
>  #include "xfs_buf_item.h"



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
