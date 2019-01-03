Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:52740 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfACR5N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jan 2019 12:57:13 -0500
Date: Thu, 3 Jan 2019 09:57:09 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs_metadump: Zap dev inodes
Message-ID: <20190103175709.GE20475@magnolia>
References: <20181105213145.7560-1-stefanrin@gmail.com>
 <20181105213145.7560-6-stefanrin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181105213145.7560-6-stefanrin@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Nov 05, 2018 at 10:31:45PM +0100, Stefan Ring wrote:
> Signed-off-by: Stefan Ring <stefanrin@gmail.com>
> ---
>  db/metadump.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 59765263..57d6bc09 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2269,6 +2269,25 @@ process_inode_data(
>  	return 1;
>  }
>  
> +static int
> +process_dev_inode(
> +	xfs_dinode_t		*dip)
> +{
> +	if (XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +		if (show_warnings)
> +			print_warning("inode %llu has unexpected extents",
> +				      (unsigned long long)cur_ino);
> +		return 0;
> +	} else {
> +		if (zero_stale_data) {
> +			unsigned int	size = sizeof(xfs_dev_t);
> +			memset(XFS_DFORK_DPTR(dip) + size, 0,

Blank line needed between the  variable definition and the first line of
code.  Otherwise looks fine to me...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +					XFS_DFORK_DSIZE(dip, mp) - size);
> +		}
> +		return 1;
> +	}
> +}
> +
>  /*
>   * when we process the inode, we may change the data in the data and/or
>   * attribute fork if they are in short form and we are obfuscating names.
> @@ -2321,7 +2340,15 @@ process_inode(
>  		case S_IFREG:
>  			success = process_inode_data(dip, TYP_DATA);
>  			break;
> -		default: ;
> +		case S_IFIFO:
> +		case S_IFCHR:
> +		case S_IFBLK:
> +		case S_IFSOCK:
> +			success = process_dev_inode(dip);
> +			need_new_crc = 1;
> +			break;
> +		default:
> +			break;
>  	}
>  	nametable_clear();
>  
> -- 
> 2.14.5
> 
