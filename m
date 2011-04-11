Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3BJkaFv109019 for <xfs@oss.sgi.com>; Mon, 11 Apr 2011 14:46:36 -0500
Date: Mon, 11 Apr 2011 21:49:38 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [xfs-masters] [PATCH] xfs_destroy_workqueues() should not be
	tagged with __exit
Message-ID: <20110411194938.GA10683@lst.de>
References: <4da3512411659d3276@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4da3512411659d3276@agluck-desktop.sc.intel.com>
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, dchinner@redhat.com

On Mon, Apr 11, 2011 at 12:06:12PM -0700, Luck, Tony wrote:
> ia64 throws away .exit sections for the built-in CONFIG case, so routines
> that are used in other circumstances should not be tagged as __exit.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

> 
> ---
> 
> Should be applied after (or merged into) Dave Chinner's patch
> 	xfs: convert the xfsaild threads to a workqueue
> which appeared as commit 0bf6a5bd4b55b466964ead6fa566d8f346a828ee in
> next-20110411
> 
> diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> index 67d5b2c..b38e58d 100644
> --- a/fs/xfs/linux-2.6/xfs_super.c
> +++ b/fs/xfs/linux-2.6/xfs_super.c
> @@ -1741,7 +1741,7 @@ out:
>  	return -ENOMEM;
>  }
>  
> -STATIC void __exit
> +STATIC void
>  xfs_destroy_workqueues(void)
>  {
>  	destroy_workqueue(xfs_ail_wq);
> 
> _______________________________________________
> xfs-masters mailing list
> xfs-masters@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs-masters
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
