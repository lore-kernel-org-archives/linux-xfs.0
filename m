Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:35659 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751479AbdIALkW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Sep 2017 07:40:22 -0400
Received: by mail-wr0-f172.google.com with SMTP id y15so5850493wrc.2
        for <linux-xfs@vger.kernel.org>; Fri, 01 Sep 2017 04:40:21 -0700 (PDT)
Date: Fri, 1 Sep 2017 13:40:18 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs_repair: take the ag_lock before recording rmap for a
 bmbt record
Message-ID: <20170901114018.q2dyxvn77c4ua4b6@hades.localdomain>
References: <20170831201255.GP3775@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831201255.GP3775@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@redhat.com>, matorola@gmail.com, xfs <linux-xfs@vger.kernel.org>

On Thu, Aug 31, 2017 at 01:12:55PM -0700, Darrick J. Wong wrote:
> When the (threaded) inode scanner iterates the blocks of a bmbt tree and
> wants to record the bmbt blocks in the in-core rmap database, we have to
> take the ag_lock for the AG that the bmbt block is in, or else we can
> accidentally corrupt the rmap slab by calling slab_add from two threads.
> 
> Reported-by: matorola@gmail.com
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  repair/scan.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/repair/scan.c b/repair/scan.c
> index 6c9f5e7..ccf60a6 100644
> --- a/repair/scan.c
> +++ b/repair/scan.c
> @@ -386,7 +386,10 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
>  
>  	/* Record BMBT blocks in the reverse-mapping data. */
>  	if (check_dups && collect_rmaps) {
> +		agno = XFS_FSB_TO_AGNO(mp, bno);
> +		pthread_mutex_lock(&ag_locks[agno].lock);
>  		error = rmap_add_bmbt_rec(mp, ino, whichfork, bno);
> +		pthread_mutex_unlock(&ag_locks[agno].lock);
>  		if (error)
>  			do_error(
>  _("couldn't add inode %"PRIu64" bmbt block %"PRIu64" reverse-mapping data."),
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
