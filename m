Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36638 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbeJaCPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Oct 2018 22:15:08 -0400
Date: Tue, 30 Oct 2018 10:20:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/7] Revert "xfs_repair: treat zero da btree pointers as
 corruption"
Message-ID: <20181030172039.GG4135@magnolia>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030112043.6034-2-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:20:37PM +1100, Dave Chinner wrote:
> This reverts commit 67a79e2cc9320aaf269cd00e9c8d16892931886d.
> 
> A root LEAFN block can exist in a directory. When we convert from
> leaf format (LEAF1 - internal free list) to node format (LEAFN -
> external free list) the only change to the single root leaf block is
> that it's magic number is changed from LEAF1 to LEAFN.
> 
> We don't actually end up with DA nodes in the tree until the LEAFN
> node is split, and that requires a couple more dirents to be added
> to the directory to fill the LEAFN block up completely. Then it will
> split and create a DA node root block pointing to multiple LEAFN
> leaf blocks.
> 
> Hence restore the old behaviour where we skip the DA node tree
> rebuild if there is a LEAFN root block found as there is no tree to
> rebuild.

The trouble with reverting the patch is that xfs_repair goes back to
tripping over an assertion in release_da_cursor_int if the reason why
we got bno == 0 is that the directory has a da btree block with
nbtree[0].before pointing to zero.

Will post a better fix + regression tests for both issues shortly.

--D

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  repair/dir2.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 3374ae722bf9..ba5763ed3d26 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1242,11 +1242,11 @@ process_node_dir2(
>  		return 1;
>  
>  	/*
> -	 * Directories with a root marked XFS_DIR2_LEAFN_MAGIC are corrupt
> +	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
>  	 */
>  	if (bno == 0) {
> -		err_release_da_cursor(mp, &da_cursor, 0);
> -		return 1;
> +		release_da_cursor(mp, &da_cursor, 0);
> +		return 0;
>  	} else {
>  		/*
>  		 * Now pass cursor and bno into leaf-block processing routine.
> -- 
> 2.19.1
> 
