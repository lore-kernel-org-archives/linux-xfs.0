Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69CnouN113971 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 07:49:50 -0500
Subject: Re: [PATCH] xfs: remove a dmapi leftover
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100703092116.GA27669@infradead.org>
References: <20100703092116.GA27669@infradead.org>
Date: Fri, 09 Jul 2010 07:52:39 -0500
Message-ID: <1278679959.5154.0.camel@doink>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Sat, 2010-07-03 at 05:21 -0400, Christoph Hellwig wrote:
> The open_exec file operation is only added by the external dmapi patch.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-07-03 10:54:07.323263955 +0200
> +++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-07-03 10:54:11.636128320 +0200
> @@ -921,9 +921,6 @@ const struct file_operations xfs_file_op
>  	.open		= xfs_file_open,
>  	.release	= xfs_file_release,
>  	.fsync		= xfs_file_fsync,
> -#ifdef HAVE_FOP_OPEN_EXEC
> -	.open_exec	= xfs_file_open_exec,
> -#endif
>  };
>  
>  const struct file_operations xfs_dir_file_operations = {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
