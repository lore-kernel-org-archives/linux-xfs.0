Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCVTtI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Mar 2018 15:49:08 -0400
Date: Thu, 22 Mar 2018 12:49:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1.5/4] xfs_repair: use custom ifork verifier in
 mv_orphanage
Message-ID: <20180322194902.GB4818@magnolia>
References: <152151529988.18312.2660325658864402943.stgit@magnolia>
 <152151530602.18312.5227395146899805650.stgit@magnolia>
 <9cf10ff8-878a-b4dc-1e32-c657c0d2354a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cf10ff8-878a-b4dc-1e32-c657c0d2354a@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: sandeen@redhat.com, linux-xfs@vger.kernel.org

On Thu, Mar 22, 2018 at 02:35:34PM -0500, Eric Sandeen wrote:
> Now that we have a custom verifier which can ignore parent
> inode numbers, use it in mv_orphanage() as well; orphan inodes
> may have invalid parents, and we're about to reconnect
> them anyway, so override that test when we get them off disk.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/repair/phase6.c b/repair/phase6.c
> index ed005e8..498a3b5 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c
> @@ -1138,7 +1138,8 @@ mv_orphanage(
>  		xname.len = snprintf((char *)fname, sizeof(fname), "%llu.%d",
>  					(unsigned long long)ino, ++incr);
>  
> -	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &xfs_default_ifork_ops);
> +	/* Orphans may not have a proper parent, so use custom ops here */
> +	err = -libxfs_iget(mp, NULL, ino, 0, &ino_p, &phase6_ifork_ops);
>  	if (err)
>  		do_error(_("%d - couldn't iget disconnected inode\n"), err);
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
