Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:00:12 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M405ba031232
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:00:06 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3204E8EE03
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:00:27 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id GmcXIl6nbaocEYVI for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:00:27 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M3n6F3005472
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 04:49:06 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M3n5UT005462
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 04:49:05 +0100
Date: Fri, 22 Feb 2008 04:49:05 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] don't encode parent in nfs filehandles unless nessecary
Message-ID: <20080222034905.GB5354@lst.de>
References: <20080103183311.GA23209@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103183311.GA23209@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Thu, Jan 03, 2008 at 07:33:11PM +0100, Christoph Hellwig wrote:
> As Dave pointed out after the export ops changes we now always encode
> the parent into the filehandle for regular files, but it's not actually
> needed when the filesystem is export with no_subtree_check.  This
> one-liner fixes xfs_fs_encode_fh to skip encoding the parent unless
> nessecary.

ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2008-01-02 17:02:48.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2008-01-03 19:30:51.000000000 +0100
> @@ -66,7 +66,7 @@ xfs_fs_encode_fh(
>  	int			len;
>  
>  	/* Directories don't need their parent encoded, they have ".." */
> -	if (S_ISDIR(inode->i_mode))
> +	if (S_ISDIR(inode->i_mode) || !connectable)
>  		fileid_type = FILEID_INO32_GEN;
>  	else
>  		fileid_type = FILEID_INO32_GEN_PARENT;
---end quoted text---
