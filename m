Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16978 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdBNGyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 01:54:38 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v1E6sbXp022878
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 06:54:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v1E6sa5O010011
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 06:54:37 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v1E6saJg003021
        for <linux-xfs@vger.kernel.org>; Tue, 14 Feb 2017 06:54:36 GMT
Date: Mon, 13 Feb 2017 22:54:35 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [bug report] xfs: mark speculative prealloc CoW fork extents
 unwritten
Message-ID: <20170214065435.GD6813@birch.djwong.org>
References: <20170213190343.GA11256@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170213190343.GA11256@mwanda>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 13, 2017 at 10:03:43PM +0300, Dan Carpenter wrote:
> Hello Darrick J. Wong,
> 
> The patch 5eda43000064: "xfs: mark speculative prealloc CoW fork
> extents unwritten" from Feb 2, 2017, leads to the following static
> checker warning:
> 
> 	fs/xfs/xfs_reflink.c:381 xfs_reflink_convert_cow()
> 	error: uninitialized symbol 'error'.
> 
> fs/xfs/xfs_reflink.c
>    350  /* Convert all of the unwritten CoW extents in a file's range to real ones. */
>    351  int
>    352  xfs_reflink_convert_cow(
>    353          struct xfs_inode        *ip,
>    354          xfs_off_t               offset,
>    355          xfs_off_t               count)
>    356  {
>    357          struct xfs_bmbt_irec    got;
>    358          struct xfs_defer_ops    dfops;
>    359          struct xfs_mount        *mp = ip->i_mount;
>    360          struct xfs_ifork        *ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
>    361          xfs_fileoff_t           offset_fsb = XFS_B_TO_FSBT(mp, offset);
>    362          xfs_fileoff_t           end_fsb = XFS_B_TO_FSB(mp, offset + count);
>    363          xfs_extnum_t            idx;
>    364          bool                    found;
>    365          int                     error;
>                                         ^^^^^
>    366  
>    367          xfs_ilock(ip, XFS_ILOCK_EXCL);
>    368  
>    369          /* Convert all the extents to real from unwritten. */
>    370          for (found = xfs_iext_lookup_extent(ip, ifp, offset_fsb, &idx, &got);
>                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> What if found fails on the first iteration through the loop?

Oops, that's a bug, will send patch.

--D

> 
>    371               found && got.br_startoff < end_fsb;
>    372               found = xfs_iext_get_extent(ifp, ++idx, &got)) {
>    373                  error = xfs_reflink_convert_cow_extent(ip, &got, offset_fsb,
>    374                                  end_fsb - offset_fsb, &dfops);
>    375                  if (error)
>    376                          break;
>    377          }
>    378  
>    379          /* Finish up. */
>    380          xfs_iunlock(ip, XFS_ILOCK_EXCL);
>    381          return error;
>                 ^^^^^^^^^^^^
>    382  }
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
