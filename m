Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39520 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750721AbdAXDDi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jan 2017 22:03:38 -0500
Subject: Re: [PATCH 5/5] xfs_repair: trash dirattr btrees that cycle to the
 root
References: <148494391629.5256.3328772079712970611.stgit@birch.djwong.org>
 <148494394775.5256.15878832693432189642.stgit@birch.djwong.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <d7b15061-e95b-c09c-234d-6ae22d50bac4@sandeen.net>
Date: Mon, 23 Jan 2017 21:03:34 -0600
MIME-Version: 1.0
In-Reply-To: <148494394775.5256.15878832693432189642.stgit@birch.djwong.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/20/17 2:25 PM, Darrick J. Wong wrote:
> If xfs_repair detects a dir/attr btree that cycles back to the root, the
> tree should be cleared and/or rebuilt instead of simply aborting the
> repair program.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

So, while this seems ok, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

you can take this or leave it:

It'd be a bit nicer to just test da_bno outside the loop, I think;
the whole loop is

	do {
....
        } while (da_bno != 0);

so the only way da_bno can be zero here is if we entered the loop this way
after:

        da_bno = da_cursor->level[0].bno;

prior to entering it the first time:

        ino = da_cursor->ino;
        prev_bno = 0;

        do {
 
-Eric

> ---
>  repair/attr_repair.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/repair/attr_repair.c b/repair/attr_repair.c
> index b855a10..37a821b 100644
> --- a/repair/attr_repair.c
> +++ b/repair/attr_repair.c
> @@ -763,7 +763,12 @@ process_leaf_attr_level(xfs_mount_t	*mp,
>  		 * 0 is the root block and no block
>  		 * pointer can point to the root block of the btree
>  		 */
> -		ASSERT(da_bno != 0);
> +		if (da_bno == 0) {
> +			do_warn(
> +	_("btree cycle detected in attribute fork for inode %" PRIu64 "\n"),
> +				ino);
> +			goto error_out;
> +		}
>  
>  		if (dev_bno == NULLFSBLOCK) {
>  			do_warn(
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
