Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:54194 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbfDDQip (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 4 Apr 2019 12:38:45 -0400
Subject: Re: [PATCH 48/36] mkfs: don't use DIFLAG values for fsx_xflags
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <20190326171819.GW1183@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <29e227cb-b5b0-880e-6402-95c0e8f4935e@sandeen.net>
Date: Thu, 4 Apr 2019 11:38:44 -0500
MIME-Version: 1.0
In-Reply-To: <20190326171819.GW1183@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/26/19 12:18 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> mkfs shouldn't be using DIFLAG values where FS_XFLAG values are
> required.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Yay!

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index e87c692c..19ad1c90 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1451,15 +1451,15 @@ data_opts_parser(
>  		break;
>  	case D_RTINHERIT:
>  		if (getnum(value, opts, subopt))
> -			cli->fsx.fsx_xflags |= XFS_DIFLAG_RTINHERIT;
> +			cli->fsx.fsx_xflags |= FS_XFLAG_RTINHERIT;
>  		break;
>  	case D_PROJINHERIT:
>  		cli->fsx.fsx_projid = getnum(value, opts, subopt);
> -		cli->fsx.fsx_xflags |= XFS_DIFLAG_PROJINHERIT;
> +		cli->fsx.fsx_xflags |= FS_XFLAG_PROJINHERIT;
>  		break;
>  	case D_EXTSZINHERIT:
>  		cli->fsx.fsx_extsize = getnum(value, opts, subopt);
> -		cli->fsx.fsx_xflags |= XFS_DIFLAG_EXTSZINHERIT;
> +		cli->fsx.fsx_xflags |= FS_XFLAG_EXTSZINHERIT;
>  		break;
>  	case D_COWEXTSIZE:
>  		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
> @@ -2212,9 +2212,9 @@ validate_extsize_hint(
>  	bool			rt;
>  	uint16_t		flags = 0;
>  
> -	rt = (cli->fsx.fsx_xflags & XFS_DIFLAG_RTINHERIT);
> +	rt = (cli->fsx.fsx_xflags & FS_XFLAG_RTINHERIT);
>  
> -	if (cli->fsx.fsx_xflags & XFS_DIFLAG_EXTSZINHERIT)
> +	if (cli->fsx.fsx_xflags & FS_XFLAG_EXTSZINHERIT)
>  		flags |= XFS_DIFLAG_EXTSIZE;
>  
>  	fa = libxfs_inode_validate_extsize(mp, cli->fsx.fsx_extsize, S_IFREG,
> 
