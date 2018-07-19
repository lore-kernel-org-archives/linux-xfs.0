Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:48470 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbeGSIys (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jul 2018 04:54:48 -0400
Date: Thu, 19 Jul 2018 11:12:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] xfs: remove dfops param from internal bmap extent
 helpers
Message-ID: <20180719081232.tejkl6yc5jm5eybt@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: bfoster@redhat.com
Cc: linux-xfs@vger.kernel.org

Hello Brian Foster,

The patch 81ba8f3e947c: "xfs: remove dfops param from internal bmap
extent helpers" from Jul 11, 2018, leads to the following static
checker warning:

	fs/xfs/libxfs/xfs_bmap.c:2465 xfs_bmap_add_extent_unwritten_real()
	error: we previously assumed 'tp' could be null (see line 2037)

fs/xfs/libxfs/xfs_bmap.c
  2017  xfs_bmap_add_extent_unwritten_real(
  2018          struct xfs_trans        *tp,
  2019          xfs_inode_t             *ip,    /* incore inode pointer */
  2020          int                     whichfork,
  2021          struct xfs_iext_cursor  *icur,
  2022          xfs_btree_cur_t         **curp, /* if *curp is null, not a btree */
  2023          xfs_bmbt_irec_t         *new,   /* new data to add to file extents */
  2024          int                     *logflagsp) /* inode logging flags */
  2025  {
  2026          xfs_btree_cur_t         *cur;   /* btree cursor */
  2027          int                     error;  /* error return value */
  2028          int                     i;      /* temp state */
  2029          xfs_ifork_t             *ifp;   /* inode fork pointer */
  2030          xfs_fileoff_t           new_endoff;     /* end offset of new entry */
  2031          xfs_bmbt_irec_t         r[3];   /* neighbor extent entries */
  2032                                          /* left is 0, right is 1, prev is 2 */
  2033          int                     rval=0; /* return value (logging flags) */
  2034          int                     state = xfs_bmap_fork_to_state(whichfork);
  2035          struct xfs_mount        *mp = ip->i_mount;
  2036          struct xfs_bmbt_irec    old;
  2037          struct xfs_defer_ops    *dfops = tp ? tp->t_dfops : NULL;
                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The patch adds a check for NULL.

  2038  
  2039          *logflagsp = 0;
  2040  

[ snip ]

  2454  
  2455          /* update reverse mappings */
  2456          error = xfs_rmap_convert_extent(mp, dfops, ip, whichfork, new);
  2457          if (error)
  2458                  goto done;
  2459  
  2460          /* convert to a btree if necessary */
  2461          if (xfs_bmap_needs_btree(ip, whichfork)) {
  2462                  int     tmp_logflags;   /* partial log flag return val */
  2463  
  2464                  ASSERT(cur == NULL);
  2465                  error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0,
                                                          ^^
Existing code dereferences "tp" without checking for NULL.

  2466                                  &tmp_logflags, whichfork);
  2467                  *logflagsp |= tmp_logflags;
  2468                  if (error)
  2469                          goto done;
  2470          }
  2471  

See also:

fs/xfs/libxfs/xfs_bmap.c:4376 xfs_bmapi_write() error: we previously assumed 'tp' could be null (see line 4272)
fs/xfs/libxfs/xfs_bmap.c:4890 xfs_bmap_del_extent_real() error: we previously assumed 'tp' could be null (see line 4866)

regards,
dan carpenter
