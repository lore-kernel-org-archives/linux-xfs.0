Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59838 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbeJKE7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Oct 2018 00:59:20 -0400
Date: Wed, 10 Oct 2018 14:34:45 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 17/18] xfs_metadump: remove shadow variable
Message-ID: <20181010213445.GX28243@magnolia>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
 <1539201682-22198-18-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1539201682-22198-18-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 10, 2018 at 03:01:21PM -0500, Eric Sandeen wrote:
> "length" is used in 2 nested inner scopes, which is fairly unclear and
> generates a sparse warning.  Rename the inner scope variable for clarity.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  db/metadump.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index cc2ae9a..8b8e472 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1515,9 +1515,10 @@ process_dir_data_block(
>  		dup = (xfs_dir2_data_unused_t *)ptr;
>  
>  		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
> -			int	length = be16_to_cpu(dup->length);
> -			if (dir_offset + length > end_of_data ||
> -			    !length || (length & (XFS_DIR2_DATA_ALIGN - 1))) {
> +			int	free_length = be16_to_cpu(dup->length);

I know you're just changing names, but there ought to be a blank line
betweeen the variable declaration and the first line of code.

Looks fine otherwise.

--D

> +			if (dir_offset + free_length > end_of_data ||
> +			    !free_length ||
> +			    (free_length & (XFS_DIR2_DATA_ALIGN - 1))) {
>  				if (show_warnings)
>  					print_warning(
>  			"invalid length for dir free space in inode %llu",
> @@ -1527,15 +1528,15 @@ process_dir_data_block(
>  			if (be16_to_cpu(*xfs_dir2_data_unused_tag_p(dup)) !=
>  					dir_offset)
>  				return;
> -			dir_offset += length;
> -			ptr += length;
> +			dir_offset += free_length;
> +			ptr += free_length;
>  			/*
>  			 * Zero the unused space up to the tag - the tag is
>  			 * actually at a variable offset, so zeroing &dup->tag
>  			 * is zeroing the free space in between
>  			 */
>  			if (zero_stale_data) {
> -				int zlen = length -
> +				int zlen = free_length -
>  						sizeof(xfs_dir2_data_unused_t);
>  
>  				if (zlen > 0) {
> -- 
> 1.8.3.1
> 
