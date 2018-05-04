Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:44666 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751507AbeEDT7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 15:59:49 -0400
Subject: Re: [PATCH 05/11] xfs_repair: treat zero da btree pointers as
 corruption
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
 <152401962320.13319.5253154840968934837.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <91427563-15d7-10d9-e641-f03712d1858b@sandeen.net>
Date: Fri, 4 May 2018 14:59:48 -0500
MIME-Version: 1.0
In-Reply-To: <152401962320.13319.5253154840968934837.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org



On 4/17/18 9:47 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> If a da btree pointer is zero (i.e. the beginning of the fork) report
> this as a corrupt tree to the caller instead of telling it that
> everything is good.  Fixes assertion errors when fuzzing
> nbtree[0].before to zero in xfs/394.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  repair/dir2.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/repair/dir2.c b/repair/dir2.c
> index 73dff90..47ece00 100644
> --- a/repair/dir2.c
> +++ b/repair/dir2.c
> @@ -1238,8 +1238,8 @@ process_node_dir2(
>  	 * Skip directories with a root marked XFS_DIR2_LEAFN_MAGIC
>  	 */
>  	if (bno == 0) {
> -		release_da_cursor(mp, &da_cursor, 0);
> -		return 0;
> +		err_release_da_cursor(mp, &da_cursor, 0);
> +		return 1;

Trying to make sense of this w.r.t. the comment right above it ... oh,
ok the traverse function does:

                if (whichfork == XFS_DATA_FORK &&
                    (nodehdr.magic == XFS_DIR2_LEAFN_MAGIC ||
                    nodehdr.magic == XFS_DIR3_LEAFN_MAGIC)) {
                        if (i != -1) {
                                do_warn(
_("found non-root LEAFN node in inode %" PRIu64 " bno = %u\n"),
                                        da_cursor->ino, bno);
 
I guess the comment should say:

/* Directories with root marked XFS_DIR2_LEAFN_MAGIC are corrupt */

now, but I might fix that on the way in, so:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

>  	} else {
>  		/*
>  		 * Now pass cursor and bno into leaf-block processing routine.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
