Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44132 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753165AbeF1TYf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:24:35 -0400
Subject: Re: [PATCH 11/10] xfs_repair: clear extent size hints when clearing
 inode core
References: <153006766483.20121.9285982017465570544.stgit@magnolia>
 <20180628172937.GI5711@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <07330d87-0cd4-0d37-9c77-0e2b1f66f67d@sandeen.net>
Date: Thu, 28 Jun 2018 14:24:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180628172937.GI5711@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 6/28/18 12:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In kernel 4.18 we become more strict about what can be in the extent
> size hint fields, even for freed inodes.  Therefore, if repair decides
> to clear out an inode core, zero the hint fields and clear the flags so
> that the kernel won't trip over the cleared inode if and when it tries
> to read the chunk.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good, I'll merge this before the libxfs sync.  Thanks!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  repair/dinode.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index f9b2bac0..4118db7c 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -194,6 +194,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  		dinoc->di_anextents = 0;
>  	}
>  
> +	if (be32_to_cpu(dinoc->di_extsize) != 0)  {
> +		__dirty_no_modify_ret(dirty);
> +		dinoc->di_extsize = 0;
> +	}
> +
>  	if (dinoc->di_version > 1 &&
>  			be32_to_cpu(dinoc->di_nlink) != 0)  {
>  		__dirty_no_modify_ret(dirty);
> @@ -237,6 +242,11 @@ clear_dinode_core(struct xfs_mount *mp, xfs_dinode_t *dinoc, xfs_ino_t ino_num)
>  		dinoc->di_changecount = 0;
>  	}
>  
> +	if (be32_to_cpu(dinoc->di_cowextsize) != 0)  {
> +		__dirty_no_modify_ret(dirty);
> +		dinoc->di_cowextsize = 0;
> +	}
> +
>  	return dirty;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
