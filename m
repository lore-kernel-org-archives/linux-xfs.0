Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46018 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933276AbdCaRlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 31 Mar 2017 13:41:49 -0400
Date: Fri, 31 Mar 2017 10:41:18 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 8/8] statx: Include a mask for stx_attributes in struct
 statx
Message-ID: <20170331174118.GH4864@birch.djwong.org>
References: <149098148523.28108.1441135633380173665.stgit@warthog.procyon.org.uk>
 <149098153785.28108.1114055429564367803.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149098153785.28108.1114055429564367803.stgit@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Mar 31, 2017 at 06:32:17PM +0100, David Howells wrote:
> Include a mask in struct stat to indicate which bits of stx_attributes the
> filesystem actually supports.
> 
> This would also be useful if we add another system call that allows you to
> do a 'bulk attribute set' and pass in a statx struct with the masks
> appropriately set to say what you want to set.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/ext4/inode.c            |    6 ++++++
>  fs/stat.c                  |    1 +
>  include/linux/stat.h       |    1 +
>  include/uapi/linux/stat.h  |    4 ++--
>  samples/statx/test-statx.c |   12 ++++++++----
>  5 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 5d02b922afa3..349f97ae3c87 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5413,6 +5413,12 @@ int ext4_getattr(const struct path *path, struct kstat *stat,
>  	if (flags & EXT4_NODUMP_FL)
>  		stat->attributes |= STATX_ATTR_NODUMP;
>  
> +	stat->attributes_mask |= (STATX_ATTR_APPEND |
> +				  STATX_ATTR_COMPRESSED |

ext4 doesn't actually support compressed files.

(I know, the feature/inode flags exist, but there's no code and afaik
probably never will be...)

--D

> +				  STATX_ATTR_ENCRYPTED |
> +				  STATX_ATTR_IMMUTABLE |
> +				  STATX_ATTR_NODUMP);
> +	
>  	generic_fillattr(inode, stat);
>  	return 0;
>  }
> diff --git a/fs/stat.c b/fs/stat.c
> index 0c7e6cdc435c..c6c963b2546b 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -527,6 +527,7 @@ cp_statx(const struct kstat *stat, struct statx __user *buffer)
>  	tmp.stx_ino = stat->ino;
>  	tmp.stx_size = stat->size;
>  	tmp.stx_blocks = stat->blocks;
> +	tmp.stx_attributes_mask = stat->attributes_mask;
>  	tmp.stx_atime.tv_sec = stat->atime.tv_sec;
>  	tmp.stx_atime.tv_nsec = stat->atime.tv_nsec;
>  	tmp.stx_btime.tv_sec = stat->btime.tv_sec;
> diff --git a/include/linux/stat.h b/include/linux/stat.h
> index c76e524fb34b..64b6b3aece21 100644
> --- a/include/linux/stat.h
> +++ b/include/linux/stat.h
> @@ -26,6 +26,7 @@ struct kstat {
>  	unsigned int	nlink;
>  	uint32_t	blksize;	/* Preferred I/O size */
>  	u64		attributes;
> +	u64		attributes_mask;
>  #define KSTAT_ATTR_FS_IOC_FLAGS				\
>  	(STATX_ATTR_COMPRESSED |			\
>  	 STATX_ATTR_IMMUTABLE |				\
> diff --git a/include/uapi/linux/stat.h b/include/uapi/linux/stat.h
> index 0869b9eaa8ce..d538897b8e08 100644
> --- a/include/uapi/linux/stat.h
> +++ b/include/uapi/linux/stat.h
> @@ -114,7 +114,7 @@ struct statx {
>  	__u64	stx_ino;	/* Inode number */
>  	__u64	stx_size;	/* File size */
>  	__u64	stx_blocks;	/* Number of 512-byte blocks allocated */
> -	__u64	__spare1[1];
> +	__u64	stx_attributes_mask; /* Mask to show what's supported in stx_attributes */
>  	/* 0x40 */
>  	struct statx_timestamp	stx_atime;	/* Last access time */
>  	struct statx_timestamp	stx_btime;	/* File creation time */
> @@ -155,7 +155,7 @@ struct statx {
>  #define STATX__RESERVED		0x80000000U	/* Reserved for future struct statx expansion */
>  
>  /*
> - * Attributes to be found in stx_attributes
> + * Attributes to be found in stx_attributes and masked in stx_attributes_mask.
>   *
>   * These give information about the features or the state of a file that might
>   * be of use to ordinary userspace programs such as GUIs or ls rather than
> diff --git a/samples/statx/test-statx.c b/samples/statx/test-statx.c
> index 8571d766331d..d4d77b09412c 100644
> --- a/samples/statx/test-statx.c
> +++ b/samples/statx/test-statx.c
> @@ -141,8 +141,8 @@ static void dump_statx(struct statx *stx)
>  	if (stx->stx_mask & STATX_BTIME)
>  		print_time(" Birth: ", &stx->stx_btime);
>  
> -	if (stx->stx_attributes) {
> -		unsigned char bits;
> +	if (stx->stx_attributes_mask) {
> +		unsigned char bits, mbits;
>  		int loop, byte;
>  
>  		static char attr_representation[64 + 1] =
> @@ -160,14 +160,18 @@ static void dump_statx(struct statx *stx)
>  		printf("Attributes: %016llx (", stx->stx_attributes);
>  		for (byte = 64 - 8; byte >= 0; byte -= 8) {
>  			bits = stx->stx_attributes >> byte;
> +			mbits = stx->stx_attributes_mask >> byte;
>  			for (loop = 7; loop >= 0; loop--) {
>  				int bit = byte + loop;
>  
> -				if (bits & 0x80)
> +				if (!(mbits & 0x80))
> +					putchar('.');	/* Not supported */
> +				else if (bits & 0x80)
>  					putchar(attr_representation[63 - bit]);
>  				else
> -					putchar('-');
> +					putchar('-');	/* Not set */
>  				bits <<= 1;
> +				mbits <<= 1;
>  			}
>  			if (byte)
>  				putchar(' ');
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
