Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56614 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbfDCQbp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Apr 2019 12:31:45 -0400
Subject: Re: [PATCH 08/36] xfs_io: statx -r should print attributes_mask
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259747924.31886.11402658884761183760.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <1273e8ca-ab27-b6fa-96d4-7f2f8a49d4f8@sandeen.net>
Date: Wed, 3 Apr 2019 11:31:43 -0500
MIME-Version: 1.0
In-Reply-To: <155259747924.31886.11402658884761183760.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 3/14/19 4:04 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> We're dumping the raw structure, so we ought to dump everything,
> including the attributes_mask field.

Ok - this was added to the kernel struct later, which is why we
didn't have it in the original userspace implementation, I guess:

commit 3209f68b3ca4667069923a325c88b21131bfdf9f
Author: David Howells <dhowells@redhat.com>
Date:   Fri Mar 31 18:32:17 2017 +0100

    statx: Include a mask for stx_attributes in struct statx
    
    Include a mask in struct stat to indicate which bits of stx_attributes the
    filesystem actually supports.
    
    This would also be useful if we add another system call that allows you to
    do a 'bulk attribute set' and pass in a statx struct with the masks
    appropriately set to say what you want to set.
    
    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  io/stat.c  |    4 ++++
>  io/statx.h |    2 +-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/io/stat.c b/io/stat.c
> index 64662b43..517be66e 100644
> --- a/io/stat.c
> +++ b/io/stat.c
> @@ -6,6 +6,9 @@
>   * Portions of statx support written by David Howells (dhowells@redhat.com)
>   */
>  
> +/* Try to pick up statx definitions from the system headers. */
> +#include <linux/stat.h>
> +
>  #include "command.h"
>  #include "input.h"
>  #include "init.h"
> @@ -272,6 +275,7 @@ dump_raw_statx(struct statx *stx)
>  	printf("stat.ino = %llu\n", (unsigned long long)stx->stx_ino);
>  	printf("stat.size = %llu\n", (unsigned long long)stx->stx_size);
>  	printf("stat.blocks = %llu\n", (unsigned long long)stx->stx_blocks);
> +	printf("stat.attributes_mask = 0x%llx\n", (unsigned long long)stx->stx_attributes_mask);
>  	printf("stat.atime.tv_sec = %lld\n", (long long)stx->stx_atime.tv_sec);
>  	printf("stat.atime.tv_nsec = %d\n", stx->stx_atime.tv_nsec);
>  	printf("stat.btime.tv_sec = %lld\n", (long long)stx->stx_btime.tv_sec);
> diff --git a/io/statx.h b/io/statx.h
> index 4e4b31ee..4f40eaa1 100644
> --- a/io/statx.h
> +++ b/io/statx.h
> @@ -107,7 +107,7 @@ struct statx {
>  	__u64	stx_ino;	/* Inode number */
>  	__u64	stx_size;	/* File size */
>  	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
> -	__u64	__spare1[1];
> +	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
>  	/* 0x40 */
>  	struct statx_timestamp	stx_atime;	/* Last access time */
>  	struct statx_timestamp	stx_btime;	/* File creation time */
> 
