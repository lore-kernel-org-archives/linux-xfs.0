Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA3837F53
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 07:49:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 49167AC001
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:49:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Ng8ecohJnW1Hc3Zy (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2015 05:49:13 -0700 (PDT)
Date: Mon, 12 Oct 2015 08:49:10 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: constify sysfs_ops structures
Message-ID: <20151012124910.GB25023@bfoster.bfoster>
References: <1444560146-22737-1-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1444560146-22737-1-git-send-email-Julia.Lawall@lip6.fr>
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
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Sun, Oct 11, 2015 at 12:42:26PM +0200, Julia Lawall wrote:
> These sysfs_ops structures are never modified.  All other sysfs_ops
> structures in the kernel are declared as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 

The fix looks correct, but these data structures just happened to be
removed and condensed into a more generic xfs_sysfs_ops definition as
part of the recent per-mount stats series. See commit a27c2640 ("xfs:
consolidate sysfs ops") for reference.

Brian

> ---
>  fs/xfs/xfs_sysfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
> index aa03670..192c865 100644
> --- a/fs/xfs/xfs_sysfs.c
> +++ b/fs/xfs/xfs_sysfs.c
> @@ -112,7 +112,7 @@ xfs_dbg_store(
>  	return xfs_attr->store ? xfs_attr->store(buf, count, NULL) : 0;
>  }
>  
> -static struct sysfs_ops xfs_dbg_ops = {
> +static const struct sysfs_ops xfs_dbg_ops = {
>  	.show = xfs_dbg_show,
>  	.store = xfs_dbg_store,
>  };
> @@ -227,7 +227,7 @@ xfs_log_store(
>  	return xfs_attr->store ? xfs_attr->store(buf, count, log) : 0;
>  }
>  
> -static struct sysfs_ops xfs_log_ops = {
> +static const struct sysfs_ops xfs_log_ops = {
>  	.show = xfs_log_show,
>  	.store = xfs_log_store,
>  };
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
