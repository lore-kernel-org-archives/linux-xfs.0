Return-Path: <SRS0=aNSJ=7F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B79C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CC820878
	for <linux-xfs@archiver.kernel.org>; Sat, 23 May 2020 16:18:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="v0MzPH+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgEWQSp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 23 May 2020 12:18:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34548 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727033AbgEWQSo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 23 May 2020 12:18:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGIeW6015196;
        Sat, 23 May 2020 16:18:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=2mYMVZgF3c4RPkzmpblgfiJPKqJqApEQqId/GWbX624=;
 b=v0MzPH+R2uvWWv46oCGJSqwzx40EtBDh86935r5xmWiGYj0i5XhzUecrUtSQin4HkVUs
 84gPCdNy+gVcQ9VjA3eelBgXv/RQASgY250dQvphkM3zMGWrSEeuU/wzYvReKlHXHxP3
 +GKuzGN8pSYuZKjxLgH6Ipd6WtoJi90+bzNzJEDuF7ZpdjD8r2qjMW5puA9imZ+6U2H5
 fHH1BJr+r/noAAmdgnBnN1QZU0zHoncqPf+2+SRagpwLwyg2M+FPW4K/YtVn873Z+Cyl
 vb7jS0F/OD14KCcWqxnAPSJMDMY0CXdZOhjFinKWCm6V8L5bLCRRISAe4LgeIDsFeM77 mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 316uskh5fd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 16:18:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04NGIdYO120326;
        Sat, 23 May 2020 16:18:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 316rxrv2kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 16:18:39 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04NGIZXt000860;
        Sat, 23 May 2020 16:18:35 GMT
Received: from localhost (/10.159.158.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 23 May 2020 09:18:34 -0700
Date:   Sat, 23 May 2020 09:18:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/24] xfs: rework inode flushing to make inode reclaim
 fully asynchronous
Message-ID: <20200523161833.GF8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522040401.GE2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522040401.GE2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=7 mlxlogscore=999
 phishscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005230134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=7 spamscore=0 priorityscore=1501 clxscore=1015
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230134
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 02:04:01PM +1000, Dave Chinner wrote:
> 
> FWIW, I forgot to put it in the original description - the series
> can be pulled from my git tree here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-async-inode-reclaim

Hmm, so I tried this out with quotas enabled and hit this in xfs/438:

MKFS_OPTIONS="-m reflink=1,rmapbt=1 -i sparse=1 /dev/sdf
MOUNT_OPTIONS="-o usrquota,grpquota,prjquota"

 BUG: kernel NULL pointer dereference, address: 0000000000000020
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0 
 Oops: 0000 [#1] PREEMPT SMP
 CPU: 3 PID: 824887 Comm: xfsaild/dm-0 Tainted: G        W         5.7.0-rc4-djw #rc4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
 RIP: 0010:do_raw_spin_trylock+0x5/0x40
 Code: 64 de 81 48 89 ef e8 ba fe ff ff eb 8b 89 c6 48 89 ef e8 de dc ff ff 66 90 eb 8b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <8b> 07 85 c0 75 28 ba 01 00 00 00 f0 0f b1 17 75 1d 65 8b 05 83 d8
 RSP: 0018:ffffc90000afbdc0 EFLAGS: 00010086
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: ffff888070ee0000 RSI: 0000000000000000 RDI: 0000000000000020
 RBP: 0000000000000020 R08: 0000000000000001 R09: 0000000000000001
 R10: 0000000000000000 R11: ffffc90000afbc3d R12: 0000000000000038
 R13: 0000000000000202 R14: 0000000000000003 R15: ffff88800688a600
 FS:  0000000000000000(0000) GS:ffff88807e000000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000020 CR3: 000000003bba2001 CR4: 00000000001606a0
 Call Trace:
  _raw_spin_lock_irqsave+0x47/0x80
  ? down_trylock+0xf/0x30
  down_trylock+0xf/0x30
  xfs_buf_trylock+0x1a/0x1f0 [xfs]
  xfsaild+0xb69/0x1320 [xfs]
  kthread+0x130/0x170
  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
  ? kthread_park+0x90/0x90
  ret_from_fork+0x3a/0x50
 Modules linked in: dm_thin_pool dm_persistent_data dm_bio_prison btrfs blake2b_generic xor zstd_decompress zstd_compress lzo_compress lzo_decompress zlib_deflate raid6_pq dm_snapshot dm_bufio dm_flakey xfs libcrc32c ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 ip_set_hash_ip xt_REDIRECT ip_set_hash_net xt_set ip_set_hash_mac xt_tcpudp ip_set iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nfnetlink ip6table_filter ip6_tables iptable_filter bfq sch_fq_codel ip_tables x_tables nfsv4 af_packet [last unloaded: scsi_debug]
 Dumping ftrace buffer:
    (ftrace buffer empty)
 CR2: 0000000000000020
 ---[ end trace 4ac61a00d1e3b068 ]---

--D

> Cheers,
> 
> Dave.
> 
> On Fri, May 22, 2020 at 01:50:05PM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > Inode flushing requires that we first lock an inode, then check it,
> > then lock the underlying buffer, flush the inode to the buffer and
> > finally add the inode to the buffer to be unlocked on IO completion.
> > We then walk all the other cached inodes in the buffer range and
> > optimistically lock and flush them to the buffer without blocking.
> > 
> > This cluster write effectively repeats the same code we do with the
> > initial inode, except now it has to special case that initial inode
> > that is already locked. Hence we have multiple copies of very
> > similar code, and it is a result of inode cluster flushing being
> > based on a specific inode rather than grabbing the buffer and
> > flushing all available inodes to it.
> > 
> > The problem with this at the moment is that we we can't look up the
> > buffer until we have guaranteed that an inode is held exclusively
> > and it's not going away while we get the buffer through an imap
> > lookup. Hence we are kinda stuck locking an inode before we can look
> > up the buffer.
> > 
> > This is also a result of inodes being detached from the cluster
> > buffer except when IO is being done. This has the further problem
> > that the cluster buffer can be reclaimed from memory and then the
> > inode can be dirtied. At this point cleaning the inode requires a
> > read-modify-write cycle on the cluster buffer. If we then are put
> > under memory pressure, cleaning that dirty inode to reclaim it
> > requires allocating memory for the cluster buffer and this leads to
> > all sorts of problems.
> > 
> > We used synchronous inode writeback in reclaim as a throttle that
> > provided a forwards progress mechanism when RMW cycles were required
> > to clean inodes. Async writeback of inodes (e.g. via the AIL) would
> > immediately exhaust remaining memory reserves trying to allocate
> > inode cluster after inode cluster. The synchronous writeback of an
> > inode cluster allowed reclaim to release the inode cluster and have
> > it freed almost immediately which could then be used to allocate the
> > next inode cluster buffer. Hence the IO based throttling mechanism
> > largely guaranteed forwards progress in inode reclaim. By removing
> > the requirement for require memory allocation for inode writeback
> > filesystem level, we can issue writeback asynchrnously and not have
> > to worry about the memory exhaustion anymore.
> > 
> > Another issue is that if we have slow disks, we can build up dirty
> > inodes in memory that can then take hours for an operation like
> > unmount to flush. A RMW cycle per inode on a slow RAID6 device can
> > mean we only clean 50 inodes a second, and when there are hundreds
> > of thousands of dirty inodes that need to be cleaned this can take a
> > long time. PInning the cluster buffers will greatly speed up inode
> > writeback on slow storage systems like this.
> > 
> > These limitations all stem from the same source: inode writeback is
> > inode centric, And they are largely solved by the same architectural
> > change: make inode writeback cluster buffer centric.  This series is
> > makes that architectural change.
> > 
> > Firstly, we start by pinning the inode backing buffer in memory
> > when an inode is marked dirty (i.e. when it is logged). By tracking
> > the number of dirty inodes on a buffer as a counter rather than a
> > flag, we avoid the problem of overlapping inode dirtying and buffer
> > flushing racing to set/clear the dirty flag. Hence as long as there
> > is a dirty inode in memory, the buffer will not be able to be
> > reclaimed. We can safely do this inode cluster buffer lookup when we
> > dirty an inode as we do not hold the buffer locked - we merely take
> > a reference to it and then release it - and hence we don't cause any
> > new lock order issues.
> > 
> > When the inode is finally cleaned, the reference to the buffer can
> > be removed from the inode log item and the buffer released. This is
> > done from the inode completion callbacks that are attached to the
> > buffer when the inode is flushed.
> > 
> > Pinning the cluster buffer in this way immediately avoids the RMW
> > problem in inode writeback and reclaim contexts by moving the memory
> > allocation and the blocking buffer read into the transaction context
> > that dirties the inode.  This inverts our dirty inode throttling
> > mechanism - we now throttle the rate at which we can dirty inodes to
> > rate at which we can allocate memory and read inode cluster buffers
> > into memory rather than via throttling reclaim to rate at which we
> > can clean dirty inodes.
> > 
> > Hence if we are under memory pressure, we'll block on memory
> > allocation when trying to dirty the referenced inode, rather than in
> > the memory reclaim path where we are trying to clean unreferenced
> > inodes to free memory.  Hence we no longer have to guarantee
> > forwards progress in inode reclaim as we aren't doing memory
> > allocation, and that means we can remove inode writeback from the
> > XFS inode shrinker completely without changing the system tolerance
> > for low memory operation.
> > 
> > Tracking the buffers via the inode log item also allows us to
> > completely rework the inode flushing mechanism. While the inode log
> > item is in the AIL, it is safe for the AIL to access any member of
> > the log item. Hence the AIL push mechanisms can access the buffer
> > attached to the inode without first having to lock the inode.
> > 
> > This means we can essentially lock the buffer directly and then
> > call xfs_iflush_cluster() without first going through xfs_iflush()
> > to find the buffer. Hence we can remove xfs_iflush() altogether,
> > because the two places that call it - the inode item push code and
> > inode reclaim - no longer need to flush inodes directly.
> > 
> > This can be further optimised by attaching the inode to the cluster
> > buffer when the inode is dirtied. i.e. when we add the buffer
> > reference to the inode log item, we also attach the inode to the
> > buffer for IO processing. This leads to the dirty inodes always
> > being attached to the buffer and hence we no longer need to add them
> > when we flush the inode and remove them when IO completes. Instead
> > the inodes are attached when the node log item is dirtied, and
> > removed when the inode log item is cleaned.
> > 
> > With this structure in place, we no longer need to do
> > lookups to find the dirty inodes in the cache to attach to the
> > buffer in xfs_iflush_cluster() - they are already attached to the
> > buffer. Hence when the AIL pushes an inode, we just grab the buffer
> > from the log item, and then walk the buffer log item list to lock
> > and flush the dirty inodes attached to the buffer.
> > 
> > This greatly simplifies inode writeback, and removes another memory
> > allocation from the inode writeback path (the array used for the
> > radix tree gang lookup). And while the radix tree lookups are fast,
> > walking the linked list of dirty inodes is faster.
> > 
> > There is followup work I am doing that uses the inode cluster buffer
> > as a replacement in the AIL for tracking dirty inodes. This part of
> > the series is not ready yet as it has some intricate locking
> > requirements. That is an optimisation, so I've left that out because
> > solving the inode reclaim blocking problems is the important part of
> > this work.
> > 
> > In short, this series simplifies inode writeback and fixes the long
> > standing inode reclaim blocking issues without requiring any changes
> > to the memory reclaim infrastructure.
> > 
> > Note: dquots should probably be converted to cluster flushing in a
> > similar way, as they have many of the same issues as inode flushing.
> > 
> > Thoughts, comments and improvemnts welcome.
> > 
> > -Dave.
> > 
> > 
> > 
> > Dave Chinner (24):
> >   xfs: remove logged flag from inode log item
> >   xfs: add an inode item lock
> >   xfs: mark inode buffers in cache
> >   xfs: mark dquot buffers in cache
> >   xfs: mark log recovery buffers for completion
> >   xfs: call xfs_buf_iodone directly
> >   xfs: clean up whacky buffer log item list reinit
> >   xfs: fold xfs_istale_done into xfs_iflush_done
> >   xfs: use direct calls for dquot IO completion
> >   xfs: clean up the buffer iodone callback functions
> >   xfs: get rid of log item callbacks
> >   xfs: pin inode backing buffer to the inode log item
> >   xfs: make inode reclaim almost non-blocking
> >   xfs: remove IO submission from xfs_reclaim_inode()
> >   xfs: allow multiple reclaimers per AG
> >   xfs: don't block inode reclaim on the ILOCK
> >   xfs: remove SYNC_TRYLOCK from inode reclaim
> >   xfs: clean up inode reclaim comments
> >   xfs: attach inodes to the cluster buffer when dirtied
> >   xfs: xfs_iflush() is no longer necessary
> >   xfs: rename xfs_iflush_int()
> >   xfs: rework xfs_iflush_cluster() dirty inode iteration
> >   xfs: factor xfs_iflush_done
> >   xfs: remove xfs_inobp_check()
> > 
> >  fs/xfs/libxfs/xfs_inode_buf.c   |  27 +-
> >  fs/xfs/libxfs/xfs_inode_buf.h   |   6 -
> >  fs/xfs/libxfs/xfs_trans_inode.c | 108 +++++--
> >  fs/xfs/xfs_buf.c                |  44 ++-
> >  fs/xfs/xfs_buf.h                |  49 +--
> >  fs/xfs/xfs_buf_item.c           | 205 +++++--------
> >  fs/xfs/xfs_buf_item.h           |   8 +-
> >  fs/xfs/xfs_buf_item_recover.c   |   5 +-
> >  fs/xfs/xfs_dquot.c              |  32 +-
> >  fs/xfs/xfs_dquot.h              |   1 +
> >  fs/xfs/xfs_dquot_item_recover.c |   2 +-
> >  fs/xfs/xfs_file.c               |   9 +-
> >  fs/xfs/xfs_icache.c             | 293 +++++-------------
> >  fs/xfs/xfs_inode.c              | 515 +++++++++++---------------------
> >  fs/xfs/xfs_inode.h              |   2 +-
> >  fs/xfs/xfs_inode_item.c         | 281 ++++++++---------
> >  fs/xfs/xfs_inode_item.h         |   9 +-
> >  fs/xfs/xfs_inode_item_recover.c |   2 +-
> >  fs/xfs/xfs_log_recover.c        |   5 +-
> >  fs/xfs/xfs_mount.c              |   4 -
> >  fs/xfs/xfs_mount.h              |   1 -
> >  fs/xfs/xfs_trans.h              |   3 -
> >  fs/xfs/xfs_trans_buf.c          |  15 +-
> >  fs/xfs/xfs_trans_priv.h         |  12 +-
> >  24 files changed, 680 insertions(+), 958 deletions(-)
> > 
> > -- 
> > 2.26.2.761.g0e0b3e54be
> > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
