Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:49476 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726495AbfECPzG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 May 2019 11:55:06 -0400
Subject: Re: [PATCH] mkfs: enable reflink and rmap by default
References: <20190503005717.GO5207@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b406bac9-1899-1714-a14f-472fb4bbaffd@sandeen.net>
Date: Fri, 3 May 2019 10:55:05 -0500
MIME-Version: 1.0
In-Reply-To: <20190503005717.GO5207@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On 5/2/19 7:57 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Enable reflink and reverse mapping by default.

Soooo until now, I thought I had understood that rmap was unlikely
to be default ever, due to performance impacts.  Is this no longer the case?
Of course I can't find any emails or IRC logs to indicate I didn't
just dream this up...

Also, at this point, remind me again what uses rmap and why it should
be enabled now?

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  mkfs/xfs_mkfs.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 0862621a..3874f7dd 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2021,14 +2021,14 @@ _("sparse inodes not supported without CRC support\n"));
>  		}
>  		cli->sb_feat.spinodes = false;
>  
> -		if (cli->sb_feat.rmapbt) {
> +		if (cli->sb_feat.rmapbt && cli_opt_set(&mopts, M_RMAPBT)) {
>  			fprintf(stderr,
>  _("rmapbt not supported without CRC support\n"));
>  			usage();
>  		}
>  		cli->sb_feat.rmapbt = false;
>  
> -		if (cli->sb_feat.reflink) {
> +		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
>  			fprintf(stderr,
>  _("reflink not supported without CRC support\n"));
>  			usage();
> @@ -3934,8 +3934,8 @@ main(
>  			.dirftype = true,
>  			.finobt = true,
>  			.spinodes = true,
> -			.rmapbt = false,
> -			.reflink = false,
> +			.rmapbt = true,
> +			.reflink = true,
>  			.parent_pointers = false,
>  			.nodalign = false,
>  			.nortalign = false,
> 
