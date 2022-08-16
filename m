Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020F5C2BB41
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Aug 2022 06:55:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiHPGz7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 02:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHPGzR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Aug 2022 02:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC249F47C4
        for <linux-xfs@vger.kernel.org>; Mon, 15 Aug 2022 19:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C32AB60F1D
        for <linux-xfs@vger.kernel.org>; Tue, 16 Aug 2022 02:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D791C433C1;
        Tue, 16 Aug 2022 02:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660615955;
        bh=AK6z2dm3HxSZooKALkKOTIzAe1MGaTcqQXW2zi8SZpQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RRa2l6fn++IQrHDsjCAImTOCJbwGZq+wuVsteBL5uSmHvQNMz1OCykgmDRmxTKK+v
         RUAVePLUiiKmf9Z9exxe8Qwty9XFmaEeFYoZmHRGOzd0+sf5pUrHzAIzQFjCt31r/d
         nFr6mg3nqkcki6htx2SNOXvCvdR4KAid0dJe2t02exGtRK5tqKU/Zh6rJU+q6HCLDP
         lO0DF8t9PgFEgI3doagsZylinabUrwyMSRc9CoEPHDkiuqkeP9zsOVdvkLKAhLJEIs
         14nDVGR/Jf0SZAJUhnwk5QMjQ0lEHkkHmbeAJdGC+1hyyaO6bPOiLFfvtgTbChAqkO
         rR6/ZrULofp+g==
Date:   Mon, 15 Aug 2022 19:12:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_repair: retain superblock buffer to avoid write
 hook deadlock
Message-ID: <Yvr9EmmADNYnRwUm@magnolia>
References: <166007920625.3294543.10714247329798384513.stgit@magnolia>
 <166007921743.3294543.7334567013352169774.stgit@magnolia>
 <20220811221541.GQ3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811221541.GQ3600936@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 12, 2022 at 08:15:41AM +1000, Dave Chinner wrote:
> On Tue, Aug 09, 2022 at 02:06:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Every now and then I experience the following deadlock in xfs_repair
> > when I'm running the offline repair fuzz tests:
> > 
> > #0  futex_wait (private=0, expected=2, futex_word=0x55555566df70) at ../sysdeps/nptl/futex-internal.h:146
> > #1  __GI___lll_lock_wait (futex=futex@entry=0x55555566df70, private=0) at ./nptl/lowlevellock.c:49
> > #2  lll_mutex_lock_optimized (mutex=0x55555566df70) at ./nptl/pthread_mutex_lock.c:48
> > #3  ___pthread_mutex_lock (mutex=mutex@entry=0x55555566df70) at ./nptl/pthread_mutex_lock.c:93
> > #4  cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:231
> > #5  cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e01b0, nodep=nodep@entry=0x7fffe55e0168) at cache.c:452
> > #6  __cache_lookup (key=key@entry=0x7fffe55e01b0, flags=0, bpp=bpp@entry=0x7fffe55e0228) at rdwr.c:405
> > #7  libxfs_getbuf_flags (btp=0x55555566de00, blkno=0, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0228) at rdwr.c:457
> > #8  libxfs_buf_read_map (btp=0x55555566de00, map=map@entry=0x7fffe55e0280, nmaps=nmaps@entry=1, flags=flags@entry=0, bpp=bpp@entry=0x7fffe55e0278, ops=0x5555556233e0 <xfs_sb_buf_ops>)
> >     at rdwr.c:704
> > #9  libxfs_buf_read (ops=<optimized out>, bpp=0x7fffe55e0278, flags=0, numblks=<optimized out>, blkno=0, target=<optimized out>)
> >     at /storage/home/djwong/cdev/work/xfsprogs/build-x86_64/libxfs/libxfs_io.h:195
> > #10 libxfs_getsb (mp=mp@entry=0x7fffffffd690) at rdwr.c:162
> > #11 force_needsrepair (mp=0x7fffffffd690) at xfs_repair.c:924
> > #12 repair_capture_writeback (bp=<optimized out>) at xfs_repair.c:1000
> > #13 libxfs_bwrite (bp=0x7fffe011e530) at rdwr.c:869
> > #14 cache_shake (cache=cache@entry=0x55555566de60, priority=priority@entry=2, purge=purge@entry=false) at cache.c:240
> > #15 cache_node_get (cache=cache@entry=0x55555566de60, key=key@entry=0x7fffe55e0470, nodep=nodep@entry=0x7fffe55e0428) at cache.c:452
> > #16 __cache_lookup (key=key@entry=0x7fffe55e0470, flags=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:405
> > #17 libxfs_getbuf_flags (btp=0x55555566de00, blkno=12736, len=<optimized out>, flags=<optimized out>, bpp=0x7fffe55e0538) at rdwr.c:457
> > #18 __libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:501
> > #19 libxfs_buf_get_map (btp=<optimized out>, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flags=flags@entry=1, bpp=bpp@entry=0x7fffe55e0538) at rdwr.c:525
> > #20 pf_queue_io (args=args@entry=0x5555556722c0, map=map@entry=0x7fffe55e05b0, nmaps=<optimized out>, flag=flag@entry=11) at prefetch.c:124
> > #21 pf_read_bmbt_reclist (args=0x5555556722c0, rp=<optimized out>, numrecs=78) at prefetch.c:220
> > #22 pf_scan_lbtree (dbno=dbno@entry=1211, level=level@entry=1, isadir=isadir@entry=1, args=args@entry=0x5555556722c0, func=0x55555557f240 <pf_scanfunc_bmap>) at prefetch.c:298
> > #23 pf_read_btinode (isadir=1, dino=<optimized out>, args=0x5555556722c0) at prefetch.c:385
> > #24 pf_read_inode_dirs (args=args@entry=0x5555556722c0, bp=bp@entry=0x7fffdc023790) at prefetch.c:459
> > #25 pf_read_inode_dirs (bp=<optimized out>, args=0x5555556722c0) at prefetch.c:411
> > #26 pf_batch_read (args=args@entry=0x5555556722c0, which=which@entry=PF_PRIMARY, buf=buf@entry=0x7fffd001d000) at prefetch.c:609
> > #27 pf_io_worker (param=0x5555556722c0) at prefetch.c:673
> > #28 start_thread (arg=<optimized out>) at ./nptl/pthread_create.c:442
> > #29 clone3 () at ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81
> > 
> > From this stack trace, we see that xfs_repair's prefetch module is
> > getting some xfs_buf objects ahead of initiating a read (#19).  The
> > buffer cache has hit its limit, so it calls cache_shake (#14) to free
> > some unused xfs_bufs.  The buffer it finds is a dirty buffer, so it
> > calls libxfs_bwrite to flush it out to disk, which in turn invokes the
> > buffer write hook that xfs_repair set up in 3b7667cb to mark the ondisk
> > filesystem's superblock as NEEDSREPAIR until repair actually completes.
> > 
> > Unfortunately, the NEEDSREPAIR handler itself needs to grab the
> > superblock buffer, so it makes another call into the buffer cache (#9),
> > which sees that the cache is full and tries to shake it(#4).  Hence we
> > deadlock on cm_mutex because shaking is not reentrant.
> > 
> > Fix this by retaining a reference to the superblock buffer when possible
> > so that the writeback hook doesn't have to access the buffer cache to
> > set NEEDSREPAIR.
> 
> If we are going to "retain" a permanent reference to the superblock
> buffer, can we just do it the same way as the kernel does at mount
> time? i.e. do this for every xfs_mount instance via an uncached
> buffer, and attach it to mp->m_sb_bp so that the
> superblock can be grabbed at any time in any context without needing
> to hit the buffer cache?

That was the first method that I tried, and promptly ran into all sorts
of weird issues, such (a) figuring out that someone's calling
libxfs_mount with no devices open so that it can compute something, and
(b) xfs_repair deciding to resize the buffer cache prior to phase 2.
That seemed like a whole lot of extra complexity to enable *one* use
case in one program while I was trying to help Eric get 5.19 out.

(Frankly, I'm already rather annoyed at the scope creep of NEEDSREPAIR,
and now it's creeping even more...)

> If we've got code that exists to do this in a generic manner that
> brings userspace closer to kernel behaviour, then that's what we
> should use rather than create a special one-off implementation for a
> single userspace binary...

I'd rather focus on getting through online repair's design review than
this, although given how sh*t email is, I have no idea if you (Dave)
stopped after patch 4 or if further replies simply got  eaten.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
