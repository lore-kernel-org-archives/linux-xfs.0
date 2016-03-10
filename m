Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2F7ED7CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 07:28:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 88A64AC007
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 05:28:24 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4xcdZLIwd3vR24y8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 05:28:22 -0800 (PST)
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id u2ADSMYu014729
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 13:28:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
	by aserv0022.oracle.com (8.13.8/8.13.8) with ESMTP id u2ADSMZU027253
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 13:28:22 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
	by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id u2ADSLqq014606
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 13:28:22 GMT
Date: Thu, 10 Mar 2016 16:28:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [report] potential uninitialized variable in xfs_dir2_node_to_leaf()
Message-ID: <20160310132816.GA16611@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello XFS devs,

I get the following static checker warning:

	fs/xfs/libxfs/xfs_dir2_leaf.c:1726 xfs_dir2_node_to_leaf()
	error: potentially using uninitialized 'rval'.

fs/xfs/libxfs/xfs_dir2_leaf.c
  1691          int                     rval;           /* successful free trim? */
                                        ^^^^

  1692          xfs_trans_t             *tp;            /* transaction pointer */
  1693          struct xfs_dir3_icleaf_hdr leafhdr;
  1694          struct xfs_dir3_icfree_hdr freehdr;
  1695  
  1696          /*
  1697           * There's more than a leaf level in the btree, so there must
  1698           * be multiple leafn blocks.  Give up.
  1699           */
  1700          if (state->path.active > 1)
  1701                  return 0;
  1702          args = state->args;
  1703  
  1704          trace_xfs_dir2_node_to_leaf(args);
  1705  
  1706          mp = state->mp;
  1707          dp = args->dp;
  1708          tp = args->trans;
  1709          /*
  1710           * Get the last offset in the file.
  1711           */
  1712          if ((error = xfs_bmap_last_offset(dp, &fo, XFS_DATA_FORK))) {
  1713                  return error;
  1714          }
  1715          fo -= args->geo->fsbcount;
  1716          /*
  1717           * If there are freespace blocks other than the first one,
  1718           * take this opportunity to remove trailing empty freespace blocks
  1719           * that may have been left behind during no-space-reservation
  1720           * operations.
  1721           */
  1722          while (fo > args->geo->freeblk) {
  1723                  if ((error = xfs_dir2_node_trim_free(args, fo, &rval))) {
                                                                        ^^^^
The first "return 0" happens before "rval" is initialized.

  1724                          return error;
  1725                  }
  1726                  if (rval)
                            ^^^^
  1727                          fo -= args->geo->fsbcount;
  1728                  else
  1729                          return 0;
  1730          }

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
