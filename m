Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52472 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726672AbeIMDMM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Sep 2018 23:12:12 -0400
Subject: Re: [PATCH] xfs_repair: warn properly about reflink flag with and
 without -n
References: <700e2326-fd4c-224e-bf9c-cb77756e4a55@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ca3a9129-bda6-51ff-51cf-2dbe3506444f@sandeen.net>
Date: Wed, 12 Sep 2018 17:05:40 -0500
MIME-Version: 1.0
In-Reply-To: <700e2326-fd4c-224e-bf9c-cb77756e4a55@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 9/12/18 2:26 PM, Eric Sandeen wrote:
> The decision to emit a warning in fix_inode_reflink_flag seems broken; in
> no-modify mode we'll do_warn that we're setting it (even though we don't),
> and we'll be silent if it needs to be cleared.
> 
> Fix this so it's the standard "would" in no-modify, and "will" in regular
> mode.  This also ensures that we return the proper status if flags are
> found to be incorrect in -n or -e mode.

Oh, oops - I guess this might have been intentional, if "clear reflink flag
on non-reflinked file" is more of a preening operation?  So in -n mode
nothing happens, but we preen/clear it in full mode?

(but in that case do_warn in the full run still triggers a non-zero
exit code with -e ... bleah)

(also: this makes refusing to map & boot from "reflinked" files that may
not even /be/ reflinked at all even /more/ awesomely random, doesn't it!)

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/repair/rmap.c b/repair/rmap.c
> index bffb5b61..7ef2d0fd 100644
> --- a/repair/rmap.c
> +++ b/repair/rmap.c
> @@ -1142,16 +1142,27 @@ fix_inode_reflink_flag(
>  	struct xfs_dinode	*dino;
>  	struct xfs_buf		*buf;
>  
> +	if (no_modify) {
> +		if (set)
> +			do_warn(
> +_("would set reflink flag on inode %"PRIu64"\n"),
> +				XFS_AGINO_TO_INO(mp, agno, agino));
> +		else
> +			do_warn(
> +_("would clear reflink flag on inode %"PRIu64"\n"),
> +				XFS_AGINO_TO_INO(mp, agno, agino));
> +		return 0;
> +	}
> +
> +	/* Modify mode */
>  	if (set)
>  		do_warn(
>  _("setting reflink flag on inode %"PRIu64"\n"),
>  			XFS_AGINO_TO_INO(mp, agno, agino));
> -	else if (!no_modify) /* && !set */
> +	else
>  		do_warn(
>  _("clearing reflink flag on inode %"PRIu64"\n"),
>  			XFS_AGINO_TO_INO(mp, agno, agino));
> -	if (no_modify)
> -		return 0;
>  
>  	buf = get_agino_buf(mp, agno, agino, &dino);
>  	if (!buf)
> 
