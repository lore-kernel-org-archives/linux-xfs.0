Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B43AC7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:36:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 92B96304064
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 02:36:32 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4cm2igHikfr4IlLT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 02:36:28 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s1AAaQvX024037
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 10:36:27 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s1AAaPNl007545
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 10:36:26 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s1AAaPNn025018 for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 10:36:25 GMT
Date: Mon, 10 Feb 2014 13:36:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: potential use after free in xfs_iomap_write_allocate()
Message-ID: <20140210103626.GA15018@elgon.mountain>
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

There is a static checker warning in xfs_iomap_write_allocate().  It's
sort of old so probably it's a false positive.

	fs/xfs/xfs_iomap.c:798 xfs_iomap_write_allocate()
	warn: 'tp' was already freed.

fs/xfs/xfs_iomap.c
   677  
   678          while (count_fsb != 0) {

There are some paths where if (count_fsb == 0) then "tp" is free.

   679                  /*
   680                   * Set up a transaction with which to allocate the
   681                   * backing store for the file.  Do allocations in a
   682                   * loop until we get some space in the range we are
   683                   * interested in.  The other space that might be allocated
   684                   * is in the delayed allocation extent on which we sit
   685                   * but before our buffer starts.
   686                   */
   687  
   688                  nimaps = 0;
   689                  while (nimaps == 0) {
   690                          tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
   691                          tp->t_flags |= XFS_TRANS_RESERVE;
   692                          nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
   693                          error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
   694                                                    nres, 0);
   695                          if (error) {
   696                                  xfs_trans_cancel(tp, 0);
   697                                  return XFS_ERROR(error);
   698                          }
   699                          xfs_ilock(ip, XFS_ILOCK_EXCL);
   700                          xfs_trans_ijoin(tp, ip, 0);
   701  
   702                          xfs_bmap_init(&free_list, &first_block);
   703  
   704                          /*
   705                           * it is possible that the extents have changed since
   706                           * we did the read call as we dropped the ilock for a
   707                           * while. We have to be careful about truncates or hole
   708                           * punchs here - we are not allowed to allocate
   709                           * non-delalloc blocks here.
   710                           *
   711                           * The only protection against truncation is the pages
   712                           * for the range we are being asked to convert are
   713                           * locked and hence a truncate will block on them
   714                           * first.
   715                           *
   716                           * As a result, if we go beyond the range we really
   717                           * need and hit an delalloc extent boundary followed by
   718                           * a hole while we have excess blocks in the map, we
   719                           * will fill the hole incorrectly and overrun the
   720                           * transaction reservation.
   721                           *
   722                           * Using a single map prevents this as we are forced to
   723                           * check each map we look for overlap with the desired
   724                           * range and abort as soon as we find it. Also, given
   725                           * that we only return a single map, having one beyond
   726                           * what we can return is probably a bit silly.
   727                           *
   728                           * We also need to check that we don't go beyond EOF;
   729                           * this is a truncate optimisation as a truncate sets
   730                           * the new file size before block on the pages we
   731                           * currently have locked under writeback. Because they
   732                           * are about to be tossed, we don't need to write them
   733                           * back....
   734                           */
   735                          nimaps = 1;
   736                          end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
   737                          error = xfs_bmap_last_offset(NULL, ip, &last_block,
   738                                                          XFS_DATA_FORK);
   739                          if (error)
   740                                  goto trans_cancel;
   741  
   742                          last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
   743                          if ((map_start_fsb + count_fsb) > last_block) {
   744                                  count_fsb = last_block - map_start_fsb;
   745                                  if (count_fsb == 0) {
   746                                          error = EAGAIN;
   747                                          goto trans_cancel;
   748                                  }
   749                          }
   750  
   751                          /*
   752                           * From this point onwards we overwrite the imap
   753                           * pointer that the caller gave to us.
   754                           */
   755                          error = xfs_bmapi_write(tp, ip, map_start_fsb,
   756                                                  count_fsb,
   757                                                  XFS_BMAPI_STACK_SWITCH,
   758                                                  &first_block, 1,
   759                                                  imap, &nimaps, &free_list);
   760                          if (error)
   761                                  goto trans_cancel;
   762  
   763                          error = xfs_bmap_finish(&tp, &free_list, &committed);
   764                          if (error)
   765                                  goto trans_cancel;
   766  
   767                          error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
   768                          if (error)
   769                                  goto error0;

The call to xfs_trans_commit() frees "tp".

   770  
   771                          xfs_iunlock(ip, XFS_ILOCK_EXCL);
   772                  }
   773  
   774                  /*
   775                   * See if we were able to allocate an extent that
   776                   * covers at least part of the callers request
   777                   */
   778                  if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
   779                          return xfs_alert_fsblock_zero(ip, imap);
   780  
   781                  if ((offset_fsb >= imap->br_startoff) &&
   782                      (offset_fsb < (imap->br_startoff +
   783                                     imap->br_blockcount))) {
   784                          XFS_STATS_INC(xs_xstrat_quick);
   785                          return 0;
   786                  }
   787  
   788                  /*
   789                   * So far we have not mapped the requested part of the
   790                   * file, just surrounding data, try again.
   791                   */
   792                  count_fsb -= imap->br_blockcount;
   793                  map_start_fsb = imap->br_startoff + imap->br_blockcount;
   794          }
   795  
   796  trans_cancel:
   797          xfs_bmap_cancel(&free_list);
   798          xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
                                 ^^
We dereference "tp" in xfs_trans_cancel().

regards,
dan carpenter

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
