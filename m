Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43676 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfEUTTH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 May 2019 15:19:07 -0400
Subject: Re: [PATCH 10/12] mkfs: allow setting dax flag on root directory
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
 <155839426866.68606.8424427245250373556.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b95c9911-5f36-0b35-1508-b00e041f58ba@sandeen.net>
Date: Tue, 21 May 2019 14:19:05 -0500
MIME-Version: 1.0
In-Reply-To: <155839426866.68606.8424427245250373556.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 5/20/19 6:17 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Teach mkfs to set the DAX flag on the root directory so that all new
> files can be created in dax mode.  This is a complement to removing the
> mount option.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man8/mkfs.xfs.8 |   11 +++++++++++
>  mkfs/xfs_mkfs.c     |   11 +++++++++++
>  2 files changed, 22 insertions(+)

I'll tuck this away for 2024 when we decide what to do about dax.

-Eric

> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 4b8c78c3..0137f164 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -391,6 +391,17 @@ All inodes created by
>  will have this extent size hint applied.
>  The value must be provided in units of filesystem blocks.
>  Directories will pass on this hint to newly created children.
> +.TP
> +.BI dax= value
> +All inodes created by
> +.B mkfs.xfs
> +will have the DAX flag set.
> +This means that directories will pass the flag on to newly created files
> +and files will use the DAX IO paths when possible.
> +This value is either 1 to enable the use or 0 to disable.
> +By default,
> +.B mkfs.xfs
> +will not enable DAX mode.
>  .RE
>  .TP
>  .B \-f
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 09106648..5b66074d 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -59,6 +59,7 @@ enum {
>  	D_PROJINHERIT,
>  	D_EXTSZINHERIT,
>  	D_COWEXTSIZE,
> +	D_DAX,
>  	D_MAX_OPTS,
>  };
>  
> @@ -253,6 +254,7 @@ static struct opt_params dopts = {
>  		[D_PROJINHERIT] = "projinherit",
>  		[D_EXTSZINHERIT] = "extszinherit",
>  		[D_COWEXTSIZE] = "cowextsize",
> +		[D_DAX] = "dax",
>  	},
>  	.subopt_params = {
>  		{ .index = D_AGCOUNT,
> @@ -368,6 +370,12 @@ static struct opt_params dopts = {
>  		  .maxval = UINT_MAX,
>  		  .defaultval = SUBOPT_NEEDS_VAL,
>  		},
> +		{ .index = D_DAX,
> +		  .conflicts = { { NULL, LAST_CONFLICT } },
> +		  .minval = 0,
> +		  .maxval = 1,
> +		  .defaultval = 1,
> +		},
>  	},
>  };
>  
> @@ -1465,6 +1473,9 @@ data_opts_parser(
>  		cli->fsx.fsx_cowextsize = getnum(value, opts, subopt);
>  		cli->fsx.fsx_xflags |= FS_XFLAG_COWEXTSIZE;
>  		break;
> +	case D_DAX:
> +		cli->fsx.fsx_xflags |= FS_XFLAG_DAX;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> 
