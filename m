Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52936 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727519AbeJ3A1w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 29 Oct 2018 20:27:52 -0400
Subject: Re: [PATCH 5/5] xfs_metadump: Zap dev inodes
References: <20181026201943.24131-1-stefanrin@gmail.com>
 <20181026201943.24131-6-stefanrin@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <e9fb6661-858a-250a-ec2f-a9232e0309ae@sandeen.net>
Date: Mon, 29 Oct 2018 10:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <20181026201943.24131-6-stefanrin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Stefan Ring <stefanrin@gmail.com>, linux-xfs@vger.kernel.org



On 10/26/18 3:19 PM, Stefan Ring wrote:
> ---
>  db/metadump.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 39183fb7..bdc6f2f4 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -2269,6 +2269,24 @@ process_inode_data(
>  	return 1;
>  }
>  
> +static int
> +process_dev_inode(
> +	xfs_dinode_t		*dip)
> +{
> +	if (XFS_DFORK_NEXTENTS(dip, XFS_ATTR_FORK) ||
> +	    XFS_DFORK_NEXTENTS(dip, XFS_DATA_FORK)) {
> +		if (show_warnings)
> +			print_warning("inode %llu has unexpected extents",
> +				      (unsigned long long)cur_ino);
> +		return 0;
> +	} else {
> +		int used = XFS_DFORK_DPTR(dip) - (char*)dip;
> +
> +		memset(XFS_DFORK_DPTR(dip), 0, mp->m_sb.sb_inodesize - used);
> +		return 1;
> +	}
> +}
> +
>  /*
>   * when we process the inode, we may change the data in the data and/or
>   * attribute fork if they are in short form and we are obfuscating names.
> @@ -2321,7 +2339,9 @@ process_inode(
>  		case S_IFREG:
>  			success = process_inode_data(dip, TYP_DATA);
>  			break;
> -		default: ;
> +		default:
> +			success = process_dev_inode(dip);
> +			break;

Probably:
		case S_IFBLK:
		case S_IFCHR:
			success = process_dev_inode(dip);
			break;
		default:
			break;

no?

>  	}
>  	nametable_clear();
>  
> 
