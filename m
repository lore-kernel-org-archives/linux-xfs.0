Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:58698 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbcLUEYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 23:24:44 -0500
Subject: Re: [PATCH 3/3] xfs_io: fix the minimum arguments to the reflink
 command
References: <148182550558.24784.5628335536185073955.stgit@birch.djwong.org>
 <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <383e31f6-d851-c8b4-4aed-8fd21155ee59@sandeen.net>
Date: Tue, 20 Dec 2016 22:24:42 -0600
MIME-Version: 1.0
In-Reply-To: <148182551808.24784.14290922921211733530.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 12/15/16 12:11 PM, Darrick J. Wong wrote:
> The reflink command can reflink the entirety of two files if the
> offsets and lengths are not specified... but we forgot to permit
> that case.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

and thanks for the 4/3 patch.

> ---
>  io/reflink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> 
> diff --git a/io/reflink.c b/io/reflink.c
> index a09e82d..d26cbdd 100644
> --- a/io/reflink.c
> +++ b/io/reflink.c
> @@ -302,7 +302,7 @@ reflink_init(void)
>  	reflink_cmd.name = "reflink";
>  	reflink_cmd.altname = "rl";
>  	reflink_cmd.cfunc = reflink_f;
> -	reflink_cmd.argmin = 4;
> +	reflink_cmd.argmin = 1;
>  	reflink_cmd.argmax = -1;
>  	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
>  	reflink_cmd.args =
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
