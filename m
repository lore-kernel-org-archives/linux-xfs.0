Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38996 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbeCTVQU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 17:16:20 -0400
Subject: Re: [PATCH 4/4] mkfs: enable sparse inodes by default
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151532462.18312.14450864420601203976.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b8c51fd3-0620-7289-0d7c-a53ba49cce66@sandeen.net>
Date: Tue, 20 Mar 2018 16:16:19 -0500
MIME-Version: 1.0
In-Reply-To: <152151532462.18312.14450864420601203976.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 3/19/18 10:08 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable the sparse inode feature by default.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

OK - the cli_opt_set stuff feels clunky but I know it's just the pattern
right now...

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  mkfs/xfs_mkfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 1ca6a2d..78d0ce5 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -1996,7 +1996,7 @@ _("finobt not supported without CRC support\n"));
>  		}
>  		cli->sb_feat.finobt = false;
>  
> -		if (cli->sb_feat.spinodes) {
> +		if (cli->sb_feat.spinodes && cli_opt_set(&iopts, I_SPINODES)) {
>  			fprintf(stderr,
>  _("sparse inodes not supported without CRC support\n"));
>  			usage();
> @@ -3811,7 +3811,7 @@ main(
>  			.crcs_enabled = true,
>  			.dirftype = true,
>  			.finobt = true,
> -			.spinodes = false,
> +			.spinodes = true,
>  			.rmapbt = false,
>  			.reflink = false,
>  			.parent_pointers = false,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
