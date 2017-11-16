Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdKPTpp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Nov 2017 14:45:45 -0500
Subject: Re: [PATCH] xfs: fix type usage
References: <20171116194344.GJ5119@magnolia>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d9ff8ef7-aadd-2668-680f-62ba0532cae1@redhat.com>
Date: Thu, 16 Nov 2017 13:45:43 -0600
MIME-Version: 1.0
In-Reply-To: <20171116194344.GJ5119@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>

On 11/16/17 1:43 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Be consistent about using uint32_t/uint8_t instead of u32/u8.  This is
> more so that we don't have to maintain /those/ types in xfsprogs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks Darrick.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_iext_tree.c  |    2 +-
>  fs/xfs/libxfs/xfs_log_format.h |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_iext_tree.c b/fs/xfs/libxfs/xfs_iext_tree.c
> index 343a942..19e546a 100644
> --- a/fs/xfs/libxfs/xfs_iext_tree.c
> +++ b/fs/xfs/libxfs/xfs_iext_tree.c
> @@ -302,7 +302,7 @@ xfs_iext_rec_cmp(
>  	xfs_fileoff_t		offset)
>  {
>  	uint64_t		rec_offset = rec->lo & XFS_IEXT_STARTOFF_MASK;
> -	u32			rec_len = rec->hi & XFS_IEXT_LENGTH_MASK;
> +	uint32_t		rec_len = rec->hi & XFS_IEXT_LENGTH_MASK;
>  
>  	if (rec_offset > offset)
>  		return 1;
> diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> index 996f035..349d9f8 100644
> --- a/fs/xfs/libxfs/xfs_log_format.h
> +++ b/fs/xfs/libxfs/xfs_log_format.h
> @@ -274,7 +274,7 @@ struct xfs_inode_log_format {
>  	uint64_t		ilf_ino;	/* inode number */
>  	union {
>  		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
> -		u8		__pad[16];	/* unused */
> +		uint8_t		__pad[16];	/* unused */
>  	} ilf_u;
>  	int64_t			ilf_blkno;	/* blkno of inode buffer */
>  	int32_t			ilf_len;	/* len of inode buffer */
> @@ -295,7 +295,7 @@ struct xfs_inode_log_format_32 {
>  	uint64_t		ilf_ino;	/* inode number */
>  	union {
>  		uint32_t	ilfu_rdev;	/* rdev value for dev inode*/
> -		u8		__pad[16];	/* unused */
> +		uint8_t		__pad[16];	/* unused */
>  	} ilf_u;
>  	int64_t			ilf_blkno;	/* blkno of inode buffer */
>  	int32_t			ilf_len;	/* len of inode buffer */
> 

