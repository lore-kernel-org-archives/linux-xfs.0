Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC56C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 22:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbiHKWPr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 18:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbiHKWPq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 18:15:46 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 61B8E558D2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 15:15:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 323A362D187;
        Fri, 12 Aug 2022 08:15:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oMGSr-00BzJo-TU; Fri, 12 Aug 2022 08:15:41 +1000
Date:   Fri, 12 Aug 2022 08:15:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: retain superblock buffer to avoid write
 hook deadlock
Message-ID: <20220811221541.GQ3600936@dread.disaster.area>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
 <166007921743.3294543.7334567013352169774.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166007921743.3294543.7334567013352169774.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62f57f90
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=3sCO4b6wz0mG5skd7jMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 09, 2022 at 02:06:57PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Every now and then I experience the following deadlock in xfs_repair
> when I'm running the offline repair fuzz tests:
> 
> #0  futex_wait (private=0, expected=2, futex_word=0x55555566df70) at ../sysdeps/nptl/futex-internal.h:146
> #1  __GI___lll_lock_wait (futex=futex@entry=0x55555566df70, private=0) at ./nptl/lowlevellock.c:49
> #2  lll_mutex_lock_optimized (mutex=0x55555566df70) at ./nptl/pthread_mutex_lock.c:48
> #3  ___pthread_mutex_lock (mutex=mutex@entry=0x55555566df70) at ./nptl/pthread_mutex_lock.c:93
> #4  cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:231
> #5  cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e01b0, nodep=nodep@entry=0x7fffe55e0168) at cache.c:452
> #6  __cache_lookup (key=key@entry=0x7fffe55e01b0, flags=0, bpp=bpp@entry=0x7fffe55e0228) at rdwr.c:405
> #7  libxfs_getbuf_flags (btp=0x55555566de00, blkno=0, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0228) at rdwr.c:457
> #8  libxfs_buf_read_map (btp=0x55555566de00, map=map@entry=0x7fffe55e0280, nmaps=nmaps@entry=1, flags=flags@entry=0, bpp=bpp@entry=0x7fffe55e0278, ops=0x5555556233e0 <xfs_sb_buf_ops>)
>     at rdwr.c:704
> #9  libxfs_buf_read (ops=<optimized out>, bpp=0x7fffe55e0278, flags=0, numblks=<optimized out>, blkno=0, target=<optimized out>)
>     at /storage/home/djwong/cdev/work/xfsprogs/build-x86_64/libxfs/libxfs_io.h:195
> #10 libxfs_getsb (mp=mp@entry=0x7fffffffd690) at rdwr.c:162
> #11 force_needsrepair (mp=0x7fffffffd690) at xfs_repair.c:924
> #12 repair_capture_writeback (bp=<optimized out>) at xfs_repair.c:1000
> #13 libxfs_bwrite (bp=0x7fffe011e530) at rdwr.c:869
> #14 cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:240
> #15 cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e0470, nodep=nodep@entry=0x7fffe55e0428) at cache.c:452
> #16 __cache_lookup (key=key@entry=0x7fffe55e0470, flags=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:405
> #17 libxfs_getbuf_flags (btp=0x55555566de00, blkno=12736, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0538) at rdwr.c:457
> #18 __libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:501
> #19 libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:525
> #20 pf_queue_io (args=args@entry=0x5555556722c0, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flag=flag@entry=11) at prefetch.c:124
> #21 pf_read_bmbt_reclist (args=0x5555556722c0, rp=<optimized out>, numrecs=78) at prefetch.c:220
> #22 pf_scan_lbtree (dbno=dbno@entry=1211, level=level@entry=1, isadir=isadir@entry=1, args=args@entry=0x5555556722c0, func=0x55555557f240 <pf_scanfunc_bmap>) at prefetch.c:298
> #23 pf_read_btinode (isadir=1, dino=<optimized out>, args=0x5555556722c0) at prefetch.c:385
> #24 pf_read_inode_dirs (args=args@entry=0x5555556722c0, bp=bp@entry=0x7fffdc023790) at prefetch.c:459
> #25 pf_read_inode_dirs (bp=<optimized out>, args=0x5555556722c0) at prefetch.c:411
> #26 pf_batch_read (args=args@entry=0x5555556722c0, which=which@entry=PF_PRIMARY, buf=buf@entry=0x7fffd001d000) at prefetch.c:609
> #27 pf_io_worker (param=0x5555556722c0) at prefetch.c:673
> #28 start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:442
> #29 clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
> 
> From this stack trace, we see that xfs_repair's prefetch module is
> getting some xfs_buf objects ahead of initiating a read (#19).  The
> buffer cache has hit its limit, so it calls cache_shake (#14) to free
> some unused xfs_bufs.  The buffer it finds is a dirty buffer, so it
> calls libxfs_bwrite to flush it out to disk, which in turn invokes the
> buffer write hook that xfs_repair set up in 3b7667cb to mark the ondisk
> filesystem's superblock as NEEDSREPAIR until repair actually completes.
> 
> Unfortunately, the NEEDSREPAIR handler itself needs to grab the
> superblock buffer, so it makes another call into the buffer cache (#9),
> which sees that the cache is full and tries to shake it(#4).  Hence we
> deadlock on cm_mutex because shaking is not reentrant.
> 
> Fix this by retaining a reference to the superblock buffer when possible
> so that the writeback hook doesn't have to access the buffer cache to
> set NEEDSREPAIR.

If we are going to "retain" a permanent reference to the superblock
buffer, can we just do it the same way as the kernel does at mount
time? i.e. do this for every xfs_mount instance via an uncached
buffer, and attach it to mp->m_sb_bp so that the
superblock can be grabbed at any time in any context without needing
to hit the buffer cache?

If we've got code that exists to do this in a generic manner that
brings userspace closer to kernel behaviour, then that's what we
should use rather than create a special one-off implementation for a
single userspace binary...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
