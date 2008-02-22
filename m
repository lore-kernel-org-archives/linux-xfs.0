Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:10:19 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M4AB7P002129
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:13 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CB538E8EC3B
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:38 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 2w1uv73efHxIKeb9 for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:38 -0800 (PST)
Date: Thu, 21 Feb 2008 23:10:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Documentation: correct XFS defaults for
	ikeep/noikeep mount options
Message-ID: <20080222041036.GA24091@infradead.org>
References: <1203316358-31840-1-git-send-email-jeffpc@josefsipek.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203316358-31840-1-git-send-email-jeffpc@josefsipek.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
Cc: xfs@oss.sgi.com, hch@infradead.org

Looks good to me.

On Mon, Feb 18, 2008 at 01:32:38AM -0500, Josef 'Jeff' Sipek wrote:
> Signed-off-by: Josef 'Jeff' Sipek <jeffpc@josefsipek.net>
> ---
>  Documentation/filesystems/xfs.txt |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs.txt b/Documentation/filesystems/xfs.txt
> index 74aeb14..655bdfe 100644
> --- a/Documentation/filesystems/xfs.txt
> +++ b/Documentation/filesystems/xfs.txt
> @@ -59,9 +59,10 @@ When mounting an XFS filesystem, the following options are accepted.
>  
>    ikeep/noikeep
>  	When inode clusters are emptied of inodes, keep them around
> -	on the disk (ikeep) - this is the traditional XFS behaviour
> -	and is still the default for now.  Using the noikeep option,
> -	inode clusters are returned to the free space pool.
> +	on the disk (ikeep) - this is the traditional XFS behaviour.
> +	Using the noikeep option, inode clusters are returned to the
> +	free space pool. noikeep is the default for non-DMAPI mounts,
> +	while ikeep is the default when DMAPI is in use.
>  
>    inode64
>  	Indicates that XFS is allowed to create inodes at any location
> -- 
> 1.5.4.rc2.85.g9de45-dirty
> 
> 
---end quoted text---
