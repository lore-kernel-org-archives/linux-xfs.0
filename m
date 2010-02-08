Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18JaG59155680 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 13:36:16 -0600
Date: Mon, 8 Feb 2010 14:37:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/11] fs/xfs: Correct NULL test
Message-ID: <20100208193726.GB9527@infradead.org>
References: <Pine.LNX.4.64.1002060944580.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1002060944580.8092@ask.diku.dk>
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
To: Julia Lawall <julia@diku.dk>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>

On Sat, Feb 06, 2010 at 09:45:15AM +0100, Julia Lawall wrote:
> diff --git a/fs/xfs/quota/xfs_qm.c b/fs/xfs/quota/xfs_qm.c
> index 11cfd82..4318cd5 100644
> --- a/fs/xfs/quota/xfs_qm.c
> +++ b/fs/xfs/quota/xfs_qm.c
> @@ -123,7 +123,7 @@ xfs_Gqm_init(void)
>  		goto out;
>  
>  	gdqhash = kmem_zalloc_large(hsize);
> -	if (!udqhash)
> +	if (!gdqhash)
>  		goto out_free_udqhash;

Thanks, this looks correct,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
