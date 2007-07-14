Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:45:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EGj0bm000759
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:45:01 -0700
Message-ID: <4698FD90.10003@sandeen.net>
Date: Sat, 14 Jul 2007 11:45:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix constness warning in dmapi
References: <20070714160910.GE7768@lst.de>
In-Reply-To: <20070714160910.GE7768@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> File operations are const now so make sure the dmapi code propagates
> this properly.

ACK.  Surprised that was still there :)

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/dmapi/dmapi_kern.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/dmapi/dmapi_kern.h	2007-07-14 16:08:31.000000000 +0200
> +++ linux-2.6-xfs/fs/dmapi/dmapi_kern.h	2007-07-14 16:08:41.000000000 +0200
> @@ -79,7 +79,7 @@ struct filesystem_dmapi_operations {
>  	int (*get_fsys_vector)(struct super_block *sb, void *addr);
>  	int (*fh_to_inode)(struct super_block *sb, struct inode **ip,
>  			   dm_fid_t *fid);
> -	struct file_operations * (*get_invis_ops)(struct inode *ip);
> +	const struct file_operations * (*get_invis_ops)(struct inode *ip);
>  	int (*inode_to_fh)(struct inode *ip, dm_fid_t *fid,
>  			   dm_fsid_t *fsid );
>  	void (*get_fsid)(struct super_block *sb, dm_fsid_t *fsid);
> Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-07-14 16:07:47.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-07-14 16:07:55.000000000 +0200
> @@ -49,7 +49,7 @@
>  #include "xfs_dm.h"
>  
>  
> -STATIC struct file_operations *
> +STATIC const struct file_operations *
>  xfs_dm_get_invis_ops(
>  	struct inode *ip)
>  {
> 
> 
