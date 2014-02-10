Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 993FC7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:34:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 79A9E304067
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 13:34:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	zFGZLWWZbVa0Sm9M for <xfs@oss.sgi.com>;
	Mon, 10 Feb 2014 13:34:15 -0800 (PST)
Date: Tue, 11 Feb 2014 08:34:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: potential use after free in xfs_iomap_write_allocate()
Message-ID: <20140210213409.GS13647@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140210145041.GC26776@mwanda>
 <52F8E086.8030805@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs@oss.sgi.com

[ reformatted two replies to put the context back in that is needed
to answer questions ]

On Mon, Feb 10, 2014 at 10:21:58PM +0800, Jeff Liu wrote:
> On 02/10 2014 18:36 PM, Dan Carpenter wrote:
> > There is a static checker warning in xfs_iomap_write_allocate().  It's
> > sort of old so probably it's a false positive.
> > 
> > 	fs/xfs/xfs_iomap.c:798 xfs_iomap_write_allocate()
> > 	warn: 'tp' was already freed.
> > 
> > fs/xfs/xfs_iomap.c
> >    677  
> >    678          while (count_fsb != 0) {
> > 
> > There are some paths where if (count_fsb == 0) then "tp" is free.
> 
> I can not see a call pach would introduce "count_fsb == 0" because we only
> call xfs_iomap_write_allocate() in extent delayed allocation context,
> that is the count_fsb should be >= 1.
>
> I am confused.  That's a while condition and not an if condition.
> On line 792 we do:
> 
> 	count_fsb -= imap->br_blockcount;
> 
> I assume you saw that, and it's still a false positive but I just want
> to be sure.

(count_fsb == 0) is not the usual loop termination case here. In
fact, it probably never terminates through that at all - the loop is
there to ensure that we do allocations for the entire range that the
delayed allocation extent covers.

Indeed, we do a checks on count_fsb within the loop:

> >    679                  /*
> >    680                   * Set up a transaction with which to allocate the
> >    681                   * backing store for the file.  Do allocations in a
> >    682                   * loop until we get some space in the range we are
> >    683                   * interested in.  The other space that might be allocated
> >    684                   * is in the delayed allocation extent on which we sit
> >    685                   * but before our buffer starts.
> >    686                   */
> >    687  
> >    688                  nimaps = 0;
> >    689                  while (nimaps == 0) {
> >    690                          tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> >    691                          tp->t_flags |= XFS_TRANS_RESERVE;
> >    692                          nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
> >    693                          error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write,
> >    694                                                    nres, 0);
> >    695                          if (error) {
> >    696                                  xfs_trans_cancel(tp, 0);
> >    697                                  return XFS_ERROR(error);
> >    698                          }
> >    699                          xfs_ilock(ip, XFS_ILOCK_EXCL);
> >    700                          xfs_trans_ijoin(tp, ip, 0);
> >    701  
> >    702                          xfs_bmap_init(&free_list, &first_block);
> >    703  
> >    704                          /*
> >    705                           * it is possible that the extents have changed since
> >    706                           * we did the read call as we dropped the ilock for a
> >    707                           * while. We have to be careful about truncates or hole
> >    708                           * punchs here - we are not allowed to allocate
> >    709                           * non-delalloc blocks here.
> >    710                           *
> >    711                           * The only protection against truncation is the pages
> >    712                           * for the range we are being asked to convert are
> >    713                           * locked and hence a truncate will block on them
> >    714                           * first.
> >    715                           *
> >    716                           * As a result, if we go beyond the range we really
> >    717                           * need and hit an delalloc extent boundary followed by
> >    718                           * a hole while we have excess blocks in the map, we
> >    719                           * will fill the hole incorrectly and overrun the
> >    720                           * transaction reservation.
> >    721                           *
> >    722                           * Using a single map prevents this as we are forced to
> >    723                           * check each map we look for overlap with the desired
> >    724                           * range and abort as soon as we find it. Also, given
> >    725                           * that we only return a single map, having one beyond
> >    726                           * what we can return is probably a bit silly.
> >    727                           *
> >    728                           * We also need to check that we don't go beyond EOF;
> >    729                           * this is a truncate optimisation as a truncate sets
> >    730                           * the new file size before block on the pages we
> >    731                           * currently have locked under writeback. Because they
> >    732                           * are about to be tossed, we don't need to write them
> >    733                           * back....
> >    734                           */
> >    735                          nimaps = 1;
> >    736                          end_fsb = XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
> >    737                          error = xfs_bmap_last_offset(NULL, ip, &last_block,
> >    738                                                          XFS_DATA_FORK);
> >    739                          if (error)
> >    740                                  goto trans_cancel;
> >    741  
> >    742                          last_block = XFS_FILEOFF_MAX(last_block, end_fsb);
> >    743                          if ((map_start_fsb + count_fsb) > last_block) {
> >    744                                  count_fsb = last_block - map_start_fsb;
> >    745                                  if (count_fsb == 0) {
> >    746                                          error = EAGAIN;
> >    747                                          goto trans_cancel;
> >    748                                  }
> >    749                          }

e.g. where we handle truncate races and trim count_fsb back to the
EOF - if it's zero we drop out with a valid transaction handle.

> >    750  
> >    751                          /*
> >    752                           * From this point onwards we overwrite the imap
> >    753                           * pointer that the caller gave to us.
> >    754                           */
> >    755                          error = xfs_bmapi_write(tp, ip, map_start_fsb,
> >    756                                                  count_fsb,
> >    757                                                  XFS_BMAPI_STACK_SWITCH,
> >    758                                                  &first_block, 1,
> >    759                                                  imap, &nimaps, &free_list);
> >    760                          if (error)
> >    761                                  goto trans_cancel;
> >    762  
> >    763                          error = xfs_bmap_finish(&tp, &free_list, &committed);
> >    764                          if (error)
> >    765                                  goto trans_cancel;
> >    766  
> >    767                          error = xfs_trans_commit(tp, XFS_TRANS_RELEASE_LOG_RES);
> >    768                          if (error)
> >    769                                  goto error0;
> > 
> > The call to xfs_trans_commit() frees "tp". 
> 
> Yep, seems to me this is correct because if no error is occurred
> in xfs_trans_commit(), tp is freed up internally, otherwise it
> would be freed in error0 path.

And in finishing the transaction, we exit then inner loop because
nimaps == 1 because we successfully did an allocation whose range is
contained in imap...

> > 
> >    770  
> >    771                          xfs_iunlock(ip, XFS_ILOCK_EXCL);
> >    772                  }
> >    773  
> >    774                  /*
> >    775                   * See if we were able to allocate an extent that
> >    776                   * covers at least part of the callers request
> >    777                   */
> >    778                  if (!(imap->br_startblock || XFS_IS_REALTIME_INODE(ip)))
> >    779                          return xfs_alert_fsblock_zero(ip, imap);
> >    780  
> >    781                  if ((offset_fsb >= imap->br_startoff) &&
> >    782                      (offset_fsb < (imap->br_startoff +
> >    783                                     imap->br_blockcount))) {
> >    784                          XFS_STATS_INC(xs_xstrat_quick);
> >    785                          return 0;
> >    786                  }

And here, if the allocation overlaps the range we passed in,
we return. IOWs, this is the common return path, and so we almost
never go past this point in the function. IOWs, we never get to
the (count_fsb == 0) case because we exit on the first allocation
that overlaps the requested range.

> >    787  
> >    788                  /*
> >    789                   * So far we have not mapped the requested part of the
> >    790                   * file, just surrounding data, try again.
> >    791                   */
> >    792                  count_fsb -= imap->br_blockcount;
> >    793                  map_start_fsb = imap->br_startoff + imap->br_blockcount;
> >    794          }
> >    795  
> >    796  trans_cancel:
> >    797          xfs_bmap_cancel(&free_list);
> >    798          xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT);
> >                                  ^^
> > We dereference "tp" in xfs_trans_cancel().
> 
> Maybe I missed something, but the current logic looks correct to me. :)

Well, I think that the checker has found an actual logic problem -
if we get to count_fsb == 0 then we'll have issues, but the code is
structured such that we never hit that logic. 

In theory, gcc should be warning about tp and free_list potentially
being used uninitialised, as if we start with the initial condition
count_fsb == 0 then we never initialise tp or free_list at all.....

Cheers,

Dave.
> 
> Thanks,
> -Jeff
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

On Mon, Feb 10, 2014 at 05:50:41PM +0300, Dan Carpenter wrote:
> On Mon, Feb 10, 2014 at 10:21:58PM +0800, Jeff Liu wrote:
> > 
> > On 02/10 2014 18:36 PM, Dan Carpenter wrote:
> > > There is a static checker warning in xfs_iomap_write_allocate().  It's
> > > sort of old so probably it's a false positive.
> > > 
> > > 	fs/xfs/xfs_iomap.c:798 xfs_iomap_write_allocate()
> > > 	warn: 'tp' was already freed.
> > > 
> > > fs/xfs/xfs_iomap.c
> > >    677  
> > >    678          while (count_fsb != 0) {
> > > 
> > > There are some paths where if (count_fsb == 0) then "tp" is free.
> > 
> > I can not see a call pach would introduce "count_fsb == 0" because we only
> > call xfs_iomap_write_allocate() in extent delayed allocation context,
> > that is the count_fsb should be >= 1.
> 
> 
> regards,
> dan carpenter
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
