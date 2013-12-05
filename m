Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 844C97F56
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 11:41:02 -0600 (CST)
Date: Thu, 5 Dec 2013 11:40:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: Sudden File System Corruption
Message-ID: <20131205174058.GF1935@sgi.com>
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>
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
To: Mike Dacre <mike.dacre@gmail.com>
Cc: xfs@oss.sgi.com

Hi Mike,

On Wed, Dec 04, 2013 at 06:55:05PM -0800, Mike Dacre wrote:
> Apologies if this is the wrong place to post or if this has been answered
> already.
> 
> I have a 16 2TB drive RAID6 array powered by an LSI 9240-4i.  It has an XFS
> filesystem and has been online for over a year.  It is accessed by 23
> different machines connected via Infiniband over NFS v3.  I haven't had any
> major problems yet, one drive failed but it was easily replaced.
> 
> However, today the drive suddenly stopped responding and started returning
> IO errors when any requests were made.  This happened while it was being
> accessed by  5 different users, one was doing a very large rm operation (rm
> *sh on thousands on files in a directory).  Also, about 30 minutes before
> we had connected the globus connect endpoint to allow easy file transfers
> to SDSC.
> 
> I rebooted the machine which hosts it and checked the RAID6 logs, no
> physical problems with the drives at all.  I tried to mount and got the
> following error:
> 
> XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1510 of file
> fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0432ba1
> mount: Structure needs cleaning
> 
> I ran xfs_check and got the following message:
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> 
> 
> I checked the log and found the following message:
> 
> Dec  4 18:26:33 fruster kernel: XFS (sda1): Mounting Filesystem
> Dec  4 18:26:33 fruster kernel: XFS (sda1): Starting recovery (logdev:
> internal)
> Dec  4 18:26:36 fruster kernel: XFS: Internal error XFS_WANT_CORRUPTED_GOTO
> at line 1510 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0432ba1
> Dec  4 18:26:36 fruster kernel:
> Dec  4 18:26:36 fruster kernel: Pid: 5491, comm: mount Not tainted
> 2.6.32-358.23.2.el6.x86_64 #1
> Dec  4 18:26:36 fruster kernel: Call Trace:
> Dec  4 18:26:36 fruster kernel: [<ffffffffa045b0ef>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa0432ba1>] ?
> xfs_free_extent+0x101/0x130 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa0430c2b>] ?
> xfs_free_ag_extent+0x58b/0x750 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa0432ba1>] ?
> xfs_free_extent+0x101/0x130 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa046de2d>] ?
> xlog_recover_process_efi+0x1bd/0x200 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa04796ea>] ?
> xfs_trans_ail_cursor_set+0x1a/0x30 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa046ded2>] ?
> xlog_recover_process_efis+0x62/0xc0 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa0471f34>] ?
> xlog_recover_finish+0x24/0xd0 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa046a3ac>] ?
> xfs_log_mount_finish+0x2c/0x30 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa0475a61>] ?
> xfs_mountfs+0x421/0x6a0 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa048d6f4>] ?
> xfs_fs_fill_super+0x224/0x2e0 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffff811847ce>] ?
> get_sb_bdev+0x18e/0x1d0
> Dec  4 18:26:36 fruster kernel: [<ffffffffa048d4d0>] ?
> xfs_fs_fill_super+0x0/0x2e0 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffffa048b5b8>] ?
> xfs_fs_get_sb+0x18/0x20 [xfs]
> Dec  4 18:26:36 fruster kernel: [<ffffffff81183c1b>] ?
> vfs_kern_mount+0x7b/0x1b0
> Dec  4 18:26:36 fruster kernel: [<ffffffff81183dc2>] ?
> do_kern_mount+0x52/0x130
> Dec  4 18:26:36 fruster kernel: [<ffffffff811a3f22>] ? do_mount+0x2d2/0x8d0
> Dec  4 18:26:36 fruster kernel: [<ffffffff811a45b0>] ? sys_mount+0x90/0xe0
> Dec  4 18:26:36 fruster kernel: [<ffffffff8100b072>] ?
> system_call_fastpath+0x16/0x1b
> Dec  4 18:26:36 fruster kernel: XFS (sda1): Failed to recover EFIs
> Dec  4 18:26:36 fruster kernel: XFS (sda1): log mount finish failed
> 
> 
> I went back and looked at the log from around the time the drive died and
> found this message:
> Dec  4 17:58:16 fruster kernel: XFS: Internal error XFS_WANT_CORRUPTED_GOTO
> at line 1510 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0432ba1


> Dec  4 17:58:16 fruster kernel:
> Dec  4 17:58:16 fruster kernel: Pid: 4548, comm: nfsd Not tainted
> 2.6.32-358.23.2.el6.x86_64 #1
> Dec  4 17:58:16 fruster kernel: Call Trace:
> Dec  4 17:58:16 fruster kernel: [<ffffffffa045b0ef>] ?
> xfs_error_report+0x3f/0x50 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0432ba1>] ?
> xfs_free_extent+0x101/0x130 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0430c2b>] ?
> xfs_free_ag_extent+0x58b/0x750 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0432ba1>] ?
> xfs_free_extent+0x101/0x130 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa043c89d>] ?
> xfs_bmap_finish+0x15d/0x1a0 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa04626ff>] ?
> xfs_itruncate_finish+0x15f/0x320 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa047e370>] ?
> xfs_inactive+0x330/0x480 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa04793f4>] ?
> _xfs_trans_commit+0x214/0x2a0 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa048b9a0>] ?
> xfs_fs_clear_inode+0xa0/0xd0 [xfs]
> Dec  4 17:58:16 fruster kernel: [<ffffffff8119d31c>] ?
> clear_inode+0xac/0x140
> Dec  4 17:58:16 fruster kernel: [<ffffffff8119dad6>] ?
> generic_delete_inode+0x196/0x1d0
> Dec  4 17:58:16 fruster kernel: [<ffffffff8119db75>] ?
> generic_drop_inode+0x65/0x80
> Dec  4 17:58:16 fruster kernel: [<ffffffff8119c9c2>] ? iput+0x62/0x70
> Dec  4 17:58:16 fruster kernel: [<ffffffff81199610>] ?
> dentry_iput+0x90/0x100
> Dec  4 17:58:16 fruster kernel: [<ffffffff8119c278>] ? d_delete+0xe8/0xf0
> Dec  4 17:58:16 fruster kernel: [<ffffffff8118fe99>] ? vfs_unlink+0xd9/0xf0
> Dec  4 17:58:16 fruster kernel: [<ffffffffa071cf4f>] ?
> nfsd_unlink+0x1af/0x250 [nfsd]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0723f03>] ?
> nfsd3_proc_remove+0x83/0x120 [nfsd]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa071543e>] ?
> nfsd_dispatch+0xfe/0x240 [nfsd]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa068e624>] ?
> svc_process_common+0x344/0x640 [sunrpc]
> Dec  4 17:58:16 fruster kernel: [<ffffffff81063990>] ?
> default_wake_function+0x0/0x20
> Dec  4 17:58:16 fruster kernel: [<ffffffffa068ec60>] ?
> svc_process+0x110/0x160 [sunrpc]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0715b62>] ? nfsd+0xc2/0x160
> [nfsd]
> Dec  4 17:58:16 fruster kernel: [<ffffffffa0715aa0>] ? nfsd+0x0/0x160 [nfsd]
> Dec  4 17:58:16 fruster kernel: [<ffffffff81096a36>] ? kthread+0x96/0xa0
> Dec  4 17:58:16 fruster kernel: [<ffffffff8100c0ca>] ? child_rip+0xa/0x20
> Dec  4 17:58:16 fruster kernel: [<ffffffff810969a0>] ? kthread+0x0/0xa0
> Dec  4 17:58:16 fruster kernel: [<ffffffff8100c0c0>] ? child_rip+0x0/0x20
> Dec  4 17:58:16 fruster kernel: XFS (sda1): xfs_do_force_shutdown(0x8)
> called from line 3863 of file fs/xfs/xfs_bmap.c.  Return address =
> 0xffffffffa043c8d6
> Dec  4 17:58:16 fruster kernel: XFS (sda1): Corruption of in-memory data
> detected.  Shutting down filesystem
> Dec  4 17:58:16 fruster kernel: XFS (sda1): Please umount the filesystem
> and rectify the problem(s)
> Dec  4 17:58:19 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 17:58:49 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 17:59:19 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 17:59:49 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:00:19 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:00:49 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:01:19 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:01:49 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:02:05 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:02:05 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> Dec  4 18:02:05 fruster kernel: XFS (sda1): xfs_do_force_shutdown(0x1)
> called from line 1061 of file fs/xfs/linux-2.6/xfs_buf.c.  Return address =
> 0xffffffffa04856e3
> Dec  4 18:02:19 fruster kernel: XFS (sda1): xfs_log_force: error 5 returned.
> 
> 
> I have attached the complete log from the time it died until now.
> 
> In the end, I successfully repaired the filesystem with `xfs_repair -L
> /dev/sda1`.  However, I am nervous that some files may have been corrupted.
> 
> Do any of you have any idea what could have caused this problem?

1456 STATIC int                      /* error */
1457 xfs_free_ag_extent(
1458         xfs_trans_t     *tp,    /* transaction pointer */
1459         xfs_buf_t       *agbp,  /* buffer for a.g. freelist header */
1460         xfs_agnumber_t  agno,   /* allocation group number */
1461         xfs_agblock_t   bno,    /* starting block number */
1462         xfs_extlen_t    len,    /* length of extent */
1463         int             isfl)   /* set if is freelist blocks - no sb acctg */
1464 {
1465         xfs_btree_cur_t *bno_cur;       /* cursor for by-block btree */
1466         xfs_btree_cur_t *cnt_cur;       /* cursor for by-size btree */
1467         int             error;          /* error return value */
1468         xfs_agblock_t   gtbno;          /* start of right neighbor block */
1469         xfs_extlen_t    gtlen;          /* length of right neighbor block */
1470         int             haveleft;       /* have a left neighbor block */
1471         int             haveright;      /* have a right neighbor block */
1472         int             i;              /* temp, result code */
1473         xfs_agblock_t   ltbno;          /* start of left neighbor block */
1474         xfs_extlen_t    ltlen;          /* length of left neighbor block */
1475         xfs_mount_t     *mp;            /* mount point struct for filesystem */
1476         xfs_agblock_t   nbno;           /* new starting block of freespace */
1477         xfs_extlen_t    nlen;           /* new length of freespace */
1478         xfs_perag_t     *pag;           /* per allocation group data */
1479 
1480         mp = tp->t_mountp;
1481         /*
1482          * Allocate and initialize a cursor for the by-block btree.
1483          */
1484         bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
1485         cnt_cur = NULL;
1486         /*
1487          * Look for a neighboring block on the left (lower block numbers)
1488          * that is contiguous with this space.
1489          */
1490         if ((error = xfs_alloc_lookup_le(bno_cur, bno, len, &haveleft)))
1491                 goto error0;
1492         if (haveleft) {
1493                 /*
1494                  * There is a block to our left.
1495                  */
1496                 if ((error = xfs_alloc_get_rec(bno_cur, &ltbno, &ltlen, &i)))
1497                         goto error0;
1498                 XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
1499                 /*
1500                  * It's not contiguous, though.
1501                  */
1502                 if (ltbno + ltlen < bno)
1503                         haveleft = 0;
1504                 else {
1505                         /*
1506                          * If this failure happens the request to free this
1507                          * space was invalid, it's (partly) already free.
1508                          * Very bad.
1509                          */
1510                         XFS_WANT_CORRUPTED_GOTO(ltbno + ltlen <= bno, error0);
1511                 }
1512         }

@ 1510 the extent list in one of the files that was being deleted included a
block that was already in the by block number freespace btree.  Unfortunately
repair may have removed all of the evidence.  It's one of those deals where the
corruption would have acutally happened awhile ago and we don't find out until
later.

Recently we found a bug in repair where it doesn't fix certain kinds of
corruption.  Here are the strings to look for in your xfs_repair output:

"fork in ino ... claims dup extent"
"fork in ino ... claims free block"
"fork in inode ... claims used block"

If you run repair again and see those messages you still have the corruption.

If you do still have the corruption it would be very helpful to grab a
metadump.  Then if you restart rm and get 'lucky' and hit it again, a logprint
would be helpful.

The fix for repair is here if you need it:
http://oss.sgi.com/archives/xfs/2013-12/msg00109.html

This is the same symptom that we're currently discussing in another thread:
http://oss.sgi.com/archives/xfs/2013-12/msg00108.html

It's too early to make an assertion that this is what you have, but it might
make some interesting reading if you are interested.  Kind of a crazy
coincidence.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
