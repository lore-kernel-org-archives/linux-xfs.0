Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45503 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751559AbdKDHzF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 4 Nov 2017 03:55:05 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id vA47t46f013025
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 07:55:04 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vA47t42v028524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 07:55:04 GMT
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vA47t4OQ027707
        for <linux-xfs@vger.kernel.org>; Sat, 4 Nov 2017 07:55:04 GMT
Date: Sat, 4 Nov 2017 10:54:57 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] xfs: scrub directory freespace
Message-ID: <20171104075457.izv6ylypgjwhf6uy@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hello Darrick J. Wong,

The patch df481968f33b: "xfs: scrub directory freespace" from Oct 17,
2017, leads to the following static checker warning:

	fs/xfs/scrub/dir.c:446 xfs_scrub_directory_check_freesp()
	info: ignoring unreachable code.

fs/xfs/scrub/dir.c
   431  STATIC void
   432  xfs_scrub_directory_check_freesp(
   433          struct xfs_scrub_context        *sc,
   434          xfs_dablk_t                     lblk,
   435          struct xfs_buf                  *dbp,
   436          unsigned int                    len)
   437  {
   438          struct xfs_dir2_data_free       *bf;
   439          struct xfs_dir2_data_free       *dfp;
   440          int                             offset;
   441  
   442          if (len == 0)
   443                  return;
   444  
   445          bf = sc->ip->d_ops->data_bestfree_p(dbp->b_addr);
   446          for (dfp = &bf[0]; dfp < &bf[XFS_DIR2_DATA_FD_COUNT]; dfp++) {
                                                                      ^^^^^
This looks like a loop

   447                  offset = be16_to_cpu(dfp->offset);
   448                  if (offset == 0)
   449                          break;
   450                  if (len == be16_to_cpu(dfp->length))
   451                          return;
   452                  /* Didn't find the best length in the bestfree data */
   453                  break;
                        ^^^^^^
but we always either break or return on the first iteration.  What's
going on?

   454          }
   455  
   456          xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
   457  }

regards,
dan carpenter
