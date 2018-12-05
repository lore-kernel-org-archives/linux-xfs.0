Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39128 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbeLEDsL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Dec 2018 22:48:11 -0500
Subject: Re: [PATCH v2 2/6] xfs_repair: don't error out on dirs with a single
 leafn block
References: <154181071499.3727.3910572718199592407.stgit@magnolia>
 <154181072709.3727.17020900125846885320.stgit@magnolia>
 <20181122181346.GW6792@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <f3770fe4-1f20-42a0-4d13-6c2e19329f54@sandeen.net>
Date: Tue, 4 Dec 2018 21:48:10 -0600
MIME-Version: 1.0
In-Reply-To: <20181122181346.GW6792@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/22/18 12:13 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In process_node_dir2, we need to distinguish between a directory with a
> single leafn block (yes, they exist) having no interior da nodes, and a
> directory with a da tree that incorrectly points to dablk 0.  If we
> happened to fill out any part of the da cursor then we have a da btree
> with garbage in it; otherwise, we have a single leafn block.
> 
> This was found by repair repeatedly rebuilding a directory containing a
> single leafn block (xfs/495).
> 
> Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

I'm finding the commit log hard to parse/understand.

Let's reference

71a6af8 Revert "xfs_repair: treat zero da btree pointers as corruption"

for starters, but can we do something like this....?

===

As explained in

71a6af8 Revert "xfs_repair: treat zero da btree pointers as corruption"

a single root LEAFN block can exist in a directory until it grows further.

This is why, normally, we skip directories with a root marked
XFS_DIR2_LEAFN_MAGIC, as detected by the left-most leaf block being 
found at file block 0.

However, if we traversed any level of a btree to get here (as
indicated by da_cursor.active > 0), then a leaf block claiming block
0 indicates corruption, and we should handle it as such, and rebuild
the directory.

This was found by repair repeatedly rebuilding a directory containing a
single leafn block (xfs/495).

Fixes: 67a79e2cc932 ("xfs_repair: treat zero da btree pointers as corruption")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

===

I'm not hung up on rewriting the commit log, but if you like it give me
thumbs up.  I needed to think it through that way to grok the change.
Anyway, for the change now that I do grok it,

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> v2: now that the regression test has landed, mention that in the
> changelog
> ---
>  repair/dir2.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index ba5763ed..e67ec590 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1243,10 +1243,21 @@ process_node_dir2(
>  
>  	/*
>  	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
> +	 *
> +	 * Be careful here: If any level of the da cursor was filled out then
> +	 * the directory has a da btree containing an invalid before pointer to
> +	 * dblock 0, and we should move on to rebuilding the directory.  If no
> +	 * levels in the da cursor got filled out, then we just have a single
> +	 * leafn block and we're done.
>  	 */
>  	if (bno == 0) {
> -		release_da_cursor(mp, &da_cursor, 0);
> -		return 0;
> +		if (da_cursor.active > 0) {
> +			err_release_da_cursor(mp, &da_cursor, 0);
> +			return 1;
> +		} else {
> +			release_da_cursor(mp, &da_cursor, 0);
> +			return 0;
> +		}
>  	} else {
>  		/*
>  		 * Now pass cursor and bno into leaf-block processing routine.
> 
