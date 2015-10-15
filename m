Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E16457F37
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 13:48:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C0E12304062
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 11:48:20 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uomSKOHH5WBF47r8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Oct 2015 11:48:19 -0700 (PDT)
Date: Thu, 15 Oct 2015 13:48:15 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [patch] xfs: fix an error code in xfs_fs_fill_super()
Message-ID: <20151015184815.GA18333@redhat.com>
References: <20151015181951.GD3163@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151015181951.GD3163@mwanda>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 15, 2015 at 09:19:51PM +0300, Dan Carpenter wrote:
> If alloc_percpu() fails, we accidentally return PTR_ERR(NULL), which
> means success, but we intended to return -ENOMEM.
> 
> Fixes: 225e4635580c ('xfs: per-filesystem stats in sysfs')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 368c55a..b2c252c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1477,7 +1477,7 @@ xfs_fs_fill_super(
>  	/* Allocate stats memory before we do operations that might use it */
>  	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
>  	if (!mp->m_stats.xs_stats) {
> -		error = PTR_ERR(mp->m_stats.xs_stats);
> +		error = -ENOMEM;
>  		goto out_destroy_counters;
>  	}
>  

Agreed. Thanks for the patch.

Reviewed-by: Bill O'Donnell <billodo@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
