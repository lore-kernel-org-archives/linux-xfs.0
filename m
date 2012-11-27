Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAR6Y3PS015746 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 00:34:03 -0600
Received: from mga03.intel.com (mga03.intel.com [143.182.124.21]) by
	cuda.sgi.com with ESMTP id s82dAniCW9KOyu9S for
	<xfs@oss.sgi.com>; Mon, 26 Nov 2012 22:36:18 -0800 (PST)
Date: Tue, 27 Nov 2012 14:35:49 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [xfs:for-next 72/74] fs/xfs/xfs_log.c:1709:32: sparse: incorrect
	type in assignment (different base types)
Message-ID: <50b45f45.SLR36oqX9vHupAe2%fengguang.wu@intel.com>
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

tree:   git://oss.sgi.com/xfs/xfs for-next
head:   7c4cebe8e02dd0b0e655605442bbe9268db9ed4f
commit: 0e446be44806240c779666591bb9e8cb0e86a50d [72/74] xfs: add CRC checks to the log


sparse warnings:

+ fs/xfs/xfs_log.c:1709:32: sparse: incorrect type in assignment (different base types)
fs/xfs/xfs_log.c:1709:32:    expected restricted __le32 [usertype] h_crc
fs/xfs/xfs_log.c:1709:32:    got restricted __be32
+ fs/xfs/xfs_log.c:1568:29: sparse: incorrect type in return expression (different base types)
fs/xfs/xfs_log.c:1568:29:    expected restricted __be32
fs/xfs/xfs_log.c:1568:29:    got restricted __le32
fs/xfs/xfs_log.c:267:17: sparse: context imbalance in 'xlog_grant_head_wait' - unexpected unlock
--
+ fs/xfs/xfs_log_recover.c:3239:13: sparse: restricted __be32 degrades to integer
+ fs/xfs/xfs_log_recover.c:3239:25: sparse: restricted __le32 degrades to integer
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast to restricted __be32
+ fs/xfs/xfs_log_recover.c:3243:41: sparse: cast from restricted __le32

vim +1709 fs/xfs/xfs_log.c

0e446be4 Christoph Hellwig   2012-11-12  1562  		}
0e446be4 Christoph Hellwig   2012-11-12  1563  	}
0e446be4 Christoph Hellwig   2012-11-12  1564  
0e446be4 Christoph Hellwig   2012-11-12  1565  	/* ... and finally for the payload */
0e446be4 Christoph Hellwig   2012-11-12  1566  	crc = crc32c(crc, dp, size);
0e446be4 Christoph Hellwig   2012-11-12  1567  
0e446be4 Christoph Hellwig   2012-11-12 @1568  	return xfs_end_cksum(crc);
0e446be4 Christoph Hellwig   2012-11-12  1569  }
0e446be4 Christoph Hellwig   2012-11-12  1570  
0e446be4 Christoph Hellwig   2012-11-12  1571  /*
873ff550 Christoph Hellwig   2010-01-13  1572   * The bdstrat callback function for log bufs. This gives us a central
873ff550 Christoph Hellwig   2010-01-13  1573   * place to trap bufs in case we get hit by a log I/O error and need to
873ff550 Christoph Hellwig   2010-01-13  1574   * shutdown. Actually, in practice, even when we didn't get a log error,
873ff550 Christoph Hellwig   2010-01-13  1575   * we transition the iclogs to IOERROR state *after* flushing all existing
873ff550 Christoph Hellwig   2010-01-13  1576   * iclogs to disk. This is because we don't want anymore new transactions to be
873ff550 Christoph Hellwig   2010-01-13  1577   * started or completed afterwards.
873ff550 Christoph Hellwig   2010-01-13  1578   */
873ff550 Christoph Hellwig   2010-01-13  1579  STATIC int
873ff550 Christoph Hellwig   2010-01-13  1580  xlog_bdstrat(
873ff550 Christoph Hellwig   2010-01-13  1581  	struct xfs_buf		*bp)
873ff550 Christoph Hellwig   2010-01-13  1582  {
adadbeef Christoph Hellwig   2011-07-13  1583  	struct xlog_in_core	*iclog = bp->b_fspriv;
873ff550 Christoph Hellwig   2010-01-13  1584  
873ff550 Christoph Hellwig   2010-01-13  1585  	if (iclog->ic_state & XLOG_STATE_IOERROR) {
5a52c2a5 Chandra Seetharaman 2011-07-22  1586  		xfs_buf_ioerror(bp, EIO);
c867cb61 Christoph Hellwig   2011-10-10  1587  		xfs_buf_stale(bp);
1a1a3e97 Christoph Hellwig   2010-10-06  1588  		xfs_buf_ioend(bp, 0);
873ff550 Christoph Hellwig   2010-01-13  1589  		/*
873ff550 Christoph Hellwig   2010-01-13  1590  		 * It would seem logical to return EIO here, but we rely on
873ff550 Christoph Hellwig   2010-01-13  1591  		 * the log state machine to propagate I/O errors instead of
873ff550 Christoph Hellwig   2010-01-13  1592  		 * doing it here.
873ff550 Christoph Hellwig   2010-01-13  1593  		 */
873ff550 Christoph Hellwig   2010-01-13  1594  		return 0;
873ff550 Christoph Hellwig   2010-01-13  1595  	}
873ff550 Christoph Hellwig   2010-01-13  1596  
873ff550 Christoph Hellwig   2010-01-13  1597  	xfs_buf_iorequest(bp);
873ff550 Christoph Hellwig   2010-01-13  1598  	return 0;
873ff550 Christoph Hellwig   2010-01-13  1599  }
^1da177e Linus Torvalds      2005-04-16  1600  
^1da177e Linus Torvalds      2005-04-16  1601  /*
^1da177e Linus Torvalds      2005-04-16  1602   * Flush out the in-core log (iclog) to the on-disk log in an asynchronous 
^1da177e Linus Torvalds      2005-04-16  1603   * fashion.  Previously, we should have moved the current iclog
^1da177e Linus Torvalds      2005-04-16  1604   * ptr in the log to point to the next available iclog.  This allows further
^1da177e Linus Torvalds      2005-04-16  1605   * write to continue while this code syncs out an iclog ready to go.
^1da177e Linus Torvalds      2005-04-16  1606   * Before an in-core log can be written out, the data section must be scanned
^1da177e Linus Torvalds      2005-04-16  1607   * to save away the 1st word of each BBSIZE block into the header.  We replace
^1da177e Linus Torvalds      2005-04-16  1608   * it with the current cycle count.  Each BBSIZE block is tagged with the
^1da177e Linus Torvalds      2005-04-16  1609   * cycle count because there in an implicit assumption that drives will
^1da177e Linus Torvalds      2005-04-16  1610   * guarantee that entire 512 byte blocks get written at once.  In other words,
^1da177e Linus Torvalds      2005-04-16  1611   * we can't have part of a 512 byte block written and part not written.  By
^1da177e Linus Torvalds      2005-04-16  1612   * tagging each block, we will know which blocks are valid when recovering
^1da177e Linus Torvalds      2005-04-16  1613   * after an unclean shutdown.
^1da177e Linus Torvalds      2005-04-16  1614   *
^1da177e Linus Torvalds      2005-04-16  1615   * This routine is single threaded on the iclog.  No other thread can be in
^1da177e Linus Torvalds      2005-04-16  1616   * this routine with the same iclog.  Changing contents of iclog can there-
^1da177e Linus Torvalds      2005-04-16  1617   * fore be done without grabbing the state machine lock.  Updating the global
^1da177e Linus Torvalds      2005-04-16  1618   * log will require grabbing the lock though.
^1da177e Linus Torvalds      2005-04-16  1619   *
^1da177e Linus Torvalds      2005-04-16  1620   * The entire log manager uses a logical block numbering scheme.  Only
^1da177e Linus Torvalds      2005-04-16  1621   * log_sync (and then only bwrite()) know about the fact that the log may
^1da177e Linus Torvalds      2005-04-16  1622   * not start with block zero on a given device.  The log block start offset
^1da177e Linus Torvalds      2005-04-16  1623   * is added immediately before calling bwrite().
^1da177e Linus Torvalds      2005-04-16  1624   */
^1da177e Linus Torvalds      2005-04-16  1625  
a8272ce0 David Chinner       2007-11-23  1626  STATIC int
9a8d2fdb Mark Tinguely       2012-06-14  1627  xlog_sync(
9a8d2fdb Mark Tinguely       2012-06-14  1628  	struct xlog		*log,
9a8d2fdb Mark Tinguely       2012-06-14  1629  	struct xlog_in_core	*iclog)
^1da177e Linus Torvalds      2005-04-16  1630  {
^1da177e Linus Torvalds      2005-04-16  1631  	xfs_buf_t	*bp;
b53e675d Christoph Hellwig   2007-10-12  1632  	int		i;
^1da177e Linus Torvalds      2005-04-16  1633  	uint		count;		/* byte count of bwrite */
^1da177e Linus Torvalds      2005-04-16  1634  	uint		count_init;	/* initial count before roundup */
^1da177e Linus Torvalds      2005-04-16  1635  	int		roundoff;       /* roundoff to BB or stripe */
^1da177e Linus Torvalds      2005-04-16  1636  	int		split = 0;	/* split write into two regions */
^1da177e Linus Torvalds      2005-04-16  1637  	int		error;
62118709 Eric Sandeen        2008-03-06  1638  	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
0e446be4 Christoph Hellwig   2012-11-12  1639  	int		size;
^1da177e Linus Torvalds      2005-04-16  1640  
^1da177e Linus Torvalds      2005-04-16  1641  	XFS_STATS_INC(xs_log_writes);
155cc6b7 David Chinner       2008-03-06  1642  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
^1da177e Linus Torvalds      2005-04-16  1643  
^1da177e Linus Torvalds      2005-04-16  1644  	/* Add for LR header */
^1da177e Linus Torvalds      2005-04-16  1645  	count_init = log->l_iclog_hsize + iclog->ic_offset;
^1da177e Linus Torvalds      2005-04-16  1646  
^1da177e Linus Torvalds      2005-04-16  1647  	/* Round out the log write size */
^1da177e Linus Torvalds      2005-04-16  1648  	if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {
^1da177e Linus Torvalds      2005-04-16  1649  		/* we have a v2 stripe unit to use */
^1da177e Linus Torvalds      2005-04-16  1650  		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
^1da177e Linus Torvalds      2005-04-16  1651  	} else {
^1da177e Linus Torvalds      2005-04-16  1652  		count = BBTOB(BTOBB(count_init));
^1da177e Linus Torvalds      2005-04-16  1653  	}
^1da177e Linus Torvalds      2005-04-16  1654  	roundoff = count - count_init;
^1da177e Linus Torvalds      2005-04-16  1655  	ASSERT(roundoff >= 0);
^1da177e Linus Torvalds      2005-04-16  1656  	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 && 
^1da177e Linus Torvalds      2005-04-16  1657                  roundoff < log->l_mp->m_sb.sb_logsunit)
^1da177e Linus Torvalds      2005-04-16  1658  		|| 
^1da177e Linus Torvalds      2005-04-16  1659  		(log->l_mp->m_sb.sb_logsunit <= 1 && 
^1da177e Linus Torvalds      2005-04-16  1660  		 roundoff < BBTOB(1)));
^1da177e Linus Torvalds      2005-04-16  1661  
^1da177e Linus Torvalds      2005-04-16  1662  	/* move grant heads by roundoff in sync */
28496968 Christoph Hellwig   2012-02-20  1663  	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
28496968 Christoph Hellwig   2012-02-20  1664  	xlog_grant_add_space(log, &log->l_write_head.grant, roundoff);
^1da177e Linus Torvalds      2005-04-16  1665  
^1da177e Linus Torvalds      2005-04-16  1666  	/* put cycle number in every block */
^1da177e Linus Torvalds      2005-04-16  1667  	xlog_pack_data(log, iclog, roundoff); 
^1da177e Linus Torvalds      2005-04-16  1668  
^1da177e Linus Torvalds      2005-04-16  1669  	/* real byte length */
0e446be4 Christoph Hellwig   2012-11-12  1670  	size = iclog->ic_offset;
0e446be4 Christoph Hellwig   2012-11-12  1671  	if (v2)
0e446be4 Christoph Hellwig   2012-11-12  1672  		size += roundoff;
0e446be4 Christoph Hellwig   2012-11-12  1673  	iclog->ic_header.h_len = cpu_to_be32(size);
^1da177e Linus Torvalds      2005-04-16  1674  
f5faad79 Nathan Scott        2006-07-28  1675  	bp = iclog->ic_bp;
b53e675d Christoph Hellwig   2007-10-12  1676  	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
^1da177e Linus Torvalds      2005-04-16  1677  
^1da177e Linus Torvalds      2005-04-16  1678  	XFS_STATS_ADD(xs_log_blocks, BTOBB(count));
^1da177e Linus Torvalds      2005-04-16  1679  
^1da177e Linus Torvalds      2005-04-16  1680  	/* Do we need to split this write into 2 parts? */
^1da177e Linus Torvalds      2005-04-16  1681  	if (XFS_BUF_ADDR(bp) + BTOBB(count) > log->l_logBBsize) {
0e446be4 Christoph Hellwig   2012-11-12  1682  		char		*dptr;
0e446be4 Christoph Hellwig   2012-11-12  1683  
^1da177e Linus Torvalds      2005-04-16  1684  		split = count - (BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp)));
^1da177e Linus Torvalds      2005-04-16  1685  		count = BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp));
0e446be4 Christoph Hellwig   2012-11-12  1686  		iclog->ic_bwritecnt = 2;
0e446be4 Christoph Hellwig   2012-11-12  1687  
0e446be4 Christoph Hellwig   2012-11-12  1688  		/*
0e446be4 Christoph Hellwig   2012-11-12  1689  		 * Bump the cycle numbers at the start of each block in the
0e446be4 Christoph Hellwig   2012-11-12  1690  		 * part of the iclog that ends up in the buffer that gets
0e446be4 Christoph Hellwig   2012-11-12  1691  		 * written to the start of the log.
0e446be4 Christoph Hellwig   2012-11-12  1692  		 *
0e446be4 Christoph Hellwig   2012-11-12  1693  		 * Watch out for the header magic number case, though.
0e446be4 Christoph Hellwig   2012-11-12  1694  		 */
0e446be4 Christoph Hellwig   2012-11-12  1695  		dptr = (char *)&iclog->ic_header + count;
0e446be4 Christoph Hellwig   2012-11-12  1696  		for (i = 0; i < split; i += BBSIZE) {
0e446be4 Christoph Hellwig   2012-11-12  1697  			__uint32_t cycle = be32_to_cpu(*(__be32 *)dptr);
0e446be4 Christoph Hellwig   2012-11-12  1698  			if (++cycle == XLOG_HEADER_MAGIC_NUM)
0e446be4 Christoph Hellwig   2012-11-12  1699  				cycle++;
0e446be4 Christoph Hellwig   2012-11-12  1700  			*(__be32 *)dptr = cpu_to_be32(cycle);
0e446be4 Christoph Hellwig   2012-11-12  1701  
0e446be4 Christoph Hellwig   2012-11-12  1702  			dptr += BBSIZE;
0e446be4 Christoph Hellwig   2012-11-12  1703  		}
^1da177e Linus Torvalds      2005-04-16  1704  	} else {
^1da177e Linus Torvalds      2005-04-16  1705  		iclog->ic_bwritecnt = 1;
^1da177e Linus Torvalds      2005-04-16  1706  	}
0e446be4 Christoph Hellwig   2012-11-12  1707  
0e446be4 Christoph Hellwig   2012-11-12  1708  	/* calculcate the checksum */
0e446be4 Christoph Hellwig   2012-11-12 @1709  	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
0e446be4 Christoph Hellwig   2012-11-12  1710  					    iclog->ic_datap, size);
0e446be4 Christoph Hellwig   2012-11-12  1711  
aa0e8833 Dave Chinner        2012-04-23  1712  	bp->b_io_length = BTOBB(count);

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
