Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Dec 2007 14:19:39 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBQMJT9V014841
	for <xfs@oss.sgi.com>; Wed, 26 Dec 2007 14:19:32 -0800
Received: from mta11.adelphia.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 07AA4BB8B12
	for <xfs@oss.sgi.com>; Wed, 26 Dec 2007 14:19:41 -0800 (PST)
Received: from mta11.adelphia.net (mta11.adelphia.net [68.168.78.205]) by cuda.sgi.com with ESMTP id DR1CIf10Uu5EBXMH for <xfs@oss.sgi.com>; Wed, 26 Dec 2007 14:19:41 -0800 (PST)
Message-ID: <4772D373.6020906@alcatraz.fdf.net>
Date: Wed, 26 Dec 2007 16:19:31 -0600
From: Dustin Marquess <jailbird@alcatraz.fdf.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix unaligned access in readdir
References: <20071226154857.GA3472@lst.de>
In-Reply-To: <20071226154857.GA3472@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

This patch does indeed fix the problem.

Thanks!

-Dustin

Christoph Hellwig wrote:
> This patch should fix the issue seen on Alpha with unaligned accesses
> in the new readdir code.   By aligning each dirent to sizeof(u64) we'll
> avoid unaligned accesses.  To make doubly sure we're not hitting
> problems also rearrange struct hack_dirent to avoid holes.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-12-26 15:35:33.000000000 +0100
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-12-26 15:40:14.000000000 +0100
> @@ -262,9 +262,9 @@ xfs_file_readdir(
>  #else
>  
>  struct hack_dirent {
> -	int		namlen;
> -	loff_t		offset;
>  	u64		ino;
> +	loff_t		offset;
> +	int		namlen;
>  	unsigned int	d_type;
>  	char		name[];
>  };
> @@ -286,8 +286,10 @@ xfs_hack_filldir(
>  {
>  	struct hack_callback *buf = __buf;
>  	struct hack_dirent *de = (struct hack_dirent *)(buf->dirent + buf->used);
> +	unsigned int reclen;
>  
> -	if (buf->used + sizeof(struct hack_dirent) + namlen > buf->len)
> +	reclen = ALIGN(sizeof(struct hack_dirent) + namlen, sizeof(u64));
> +	if (buf->used + reclen > buf->len)
>  		return -EINVAL;
>  
>  	de->namlen = namlen;
> @@ -295,7 +297,7 @@ xfs_hack_filldir(
>  	de->ino = ino;
>  	de->d_type = d_type;
>  	memcpy(de->name, name, namlen);
> -	buf->used += sizeof(struct hack_dirent) + namlen;
> +	buf->used += reclen;
>  	return 0;
>  }
>  
> @@ -335,7 +337,8 @@ xfs_file_readdir(
>  		offset = filp->f_pos;
>  
>  	while (!eof) {
> -		int reclen;
> +		unsigned int reclen;
> +
>  		start_offset = offset;
>  
>  		buf.used = 0;
> @@ -356,7 +359,8 @@ xfs_file_readdir(
>  				goto done;
>  			}
>  
> -			reclen = sizeof(struct hack_dirent) + de->namlen;
> +			reclen = ALIGN(sizeof(struct hack_dirent) + de->namlen,
> +				       sizeof(u64));
>  			size -= reclen;
>  			de = (struct hack_dirent *)((char *)de + reclen);
>  			curr_offset = de->offset /* & 0x7fffffff */;
> 
