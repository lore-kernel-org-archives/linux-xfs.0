Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26331 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932384AbdKFTeu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 14:34:50 -0500
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA6JYm5m024336
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:34:49 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA6JYmH8009308
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:34:48 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vA6JYmGe013874
        for <linux-xfs@vger.kernel.org>; Mon, 6 Nov 2017 19:34:48 GMT
Date: Mon, 6 Nov 2017 11:34:47 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [bug report] xfs: scrub directory freespace
Message-ID: <20171106193447.GA6244@magnolia>
References: <20171104075457.izv6ylypgjwhf6uy@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171104075457.izv6ylypgjwhf6uy@mwanda>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Sat, Nov 04, 2017 at 10:54:57AM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch df481968f33b: "xfs: scrub directory freespace" from Oct 17,
> 2017, leads to the following static checker warning:
> 
> 	fs/xfs/scrub/dir.c:446 xfs_scrub_directory_check_freesp()
> 	info: ignoring unreachable code.
> 
> fs/xfs/scrub/dir.c
>    431  STATIC void
>    432  xfs_scrub_directory_check_freesp(
>    433          struct xfs_scrub_context        *sc,
>    434          xfs_dablk_t                     lblk,
>    435          struct xfs_buf                  *dbp,
>    436          unsigned int                    len)
>    437  {
>    438          struct xfs_dir2_data_free       *bf;
>    439          struct xfs_dir2_data_free       *dfp;
>    440          int                             offset;
>    441  
>    442          if (len == 0)
>    443                  return;
>    444  
>    445          bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
>    446          for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
>                                                                       ^^^^^
> This looks like a loop
> 
>    447                  offset = be16_to_cpu(dfp->offset);
>    448                  if (offset == 0)
>    449                          break;
>    450                  if (len == be16_to_cpu(dfp->length))
>    451                          return;
>    452                  /* Didn't find the best length in the bestfree data */
>    453                  break;
>                         ^^^^^^
> but we always either break or return on the first iteration.  What's
> going on?

I think this is a broken refactoring of the bestfree checker --
previously we'd examine every slot in a directory's bestfree data block,
read the corresponding directory data block, and check that the slot
matches any of the data block's bestfree entries.  Then Dave pointed out
that the slot must match the /first/ entry in the dir data block, so we
only need to examine bf[0], and this loop can be unrolled.

Thanks for catching this!

--D

>    454          }
>    455  
>    456          xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
>    457  }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
