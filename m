Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4373BEB64DC
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jul 2023 22:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjGKWVT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 18:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbjGKWVS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 18:21:18 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7145010EF
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:21:17 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-392116b8f31so4142525b6e.2
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 15:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689114076; x=1691706076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wo1KrxA3qHZXitFbbH4oxuiw4DNPuYbIv53ts90ps2I=;
        b=wcadspb9Ukp8p8sTNbZa4ipZObY6gAC/8tfchyPPQMYjCYuBDY+kI0hfOwS5uXskVV
         b+ZMwEdtahYDBTXUoxrTSagwMhRAhoDh3RT9AixVhlFMessM940JL+9G7IAwD0SJ2rXI
         slDRVKWUxCKjujJEzgA9q1DodlWQCDMjWcdqV9b1yAd7NKixoMnZqQr8QAyx/OSLu5dS
         4xh04PshkKROkb6L+vQHni41itRPQE3edlyyTJfeG6CxSznc9LXmkXSZZkSGo6FEt+6g
         GGWaR4NMtuBs+p2Lxinfr1e3SrXroAREFIIjmNcKfPfdFIsX2YwR2WLFwORzb642KA7D
         deuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689114076; x=1691706076;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wo1KrxA3qHZXitFbbH4oxuiw4DNPuYbIv53ts90ps2I=;
        b=TDLDXc+Yulc9DK3RccP3BHlazLQfT1oZbamI/d8tUUqtEimN0zM4UjkC0p05XLdzhD
         T8sRWzs+xVLE+M9Ta1uCyjTIXSB9QCNd+SNW0qvSapr7ZQQ05VyVXt3QpQ5UVS38eaIE
         seT0o3+SlGDvWcLrGwswFTCH/gyQI67dlrcKe2mCT8koRpEwL5zcxVN0l+mvoGju51Op
         No2vlPX5SVWUpuG6Vt5R1EBgNFuWQiwaPLlmUuqArF+RqAvds3q5a8ceqTsEvqWkvi4a
         H5EBIKHf+9rLTuGG+Ll6Zg01sBqVaUHe/z+wPPNBNoq2QQVfoGq9+sUlXFZFz6Vd9rTH
         PjyA==
X-Gm-Message-State: ABy/qLZ7CqGHdl6bswkZCW/vjfmql4KVglv66r4kLpo0jkLut8AJQUGY
        p0V39FOqjh/KFTuZrxL8MG8TfNx9yvdUijXNaeQ=
X-Google-Smtp-Source: APBJJlF3tvVI5SCECIeaX6xjjoHnaeKcLRhIGpLP6FF9fOx+rzvtABr58fPDWJ4dbw1Tg32cMZv0Bw==
X-Received: by 2002:a05:6871:825:b0:1b4:4931:d579 with SMTP id q37-20020a056871082500b001b44931d579mr16328808oap.8.1689114076444;
        Tue, 11 Jul 2023 15:21:16 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id 8-20020a17090a198800b0025eb5aafd3csm2475205pji.32.2023.07.11.15.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 15:21:15 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJLjL-004x5I-2v;
        Wed, 12 Jul 2023 08:21:11 +1000
Date:   Wed, 12 Jul 2023 08:21:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711070530.GA761114@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 11, 2023 at 05:05:30PM +1000, Chris Dunlop wrote:
> On Tue, Jul 11, 2023 at 01:10:11PM +1000, Dave Chinner wrote:
> > FYI, Chris: google is classifying your email as spam because it
> > doesn't have any dkim/dmarc authentication on it. You're lucky I
> > even got this, because I know that gmail mostly just drops such
> > email in a black hole now....
> 
> Dkim hopefully fixed now.

Looks good.

> More on the problem topic below, and apologies for the aside, but this is my
> immediate concern: post the reboot into v5.15.118 I have one of the
> filesystems failing to mount with:
> 
> Jul 11 16:13:10 b2 kernel: XFS (dm-146): Metadata CRC error detected at xfs_allocbt_read_verify+0x12/0xb0 [xfs], xfs_bnobt block 0x10a00f7f8
> Jul 11 16:13:10 b2 kernel: XFS (dm-146): Unmount and run xfs_repair
> Jul 11 16:13:10 b2 kernel: XFS (dm-146): First 128 bytes of corrupted metadata buffer:
> Jul 11 16:13:10 b2 kernel: 00000000: 41 42 33 42 00 00 01 ab 05 0a 78 fe 02 c0 2b ff  AB3B......x...+.
> Jul 11 16:13:10 b2 kernel: 00000010: 00 00 00 01 0a 00 f7 f8 00 00 00 26 00 3b 2d 40  ...........&.;-@
> Jul 11 16:13:10 b2 kernel: 00000020: cf 42 ed 07 78 a1 4e ff 9e 20 e3 d9 6f fc 3e 30  .B..x.N.. ..o.>0
> Jul 11 16:13:10 b2 kernel: 00000030: 00 00 00 02 80 b2 25 41 08 c7 6c 00 00 00 01 28  ......%A..l....(
> Jul 11 16:13:10 b2 kernel: 00000040: 08 c7 6d 3e 00 00 00 c2 08 c7 6f 65 00 00 00 a7  ..m>......oe....
> Jul 11 16:13:10 b2 kernel: 00000050: 08 c7 70 a5 00 00 00 3a 08 c7 71 00 00 00 00 c4  ..p....:..q.....
> Jul 11 16:13:10 b2 kernel: 00000060: 08 c7 71 e8 00 00 00 18 08 c7 72 50 00 00 02 c3  ..q.......rP....
> Jul 11 16:13:10 b2 kernel: 00000070: 08 c7 75 b1 00 00 02 4b 08 c7 78 db 00 00 02 3d  ..u....K..x....=
> Jul 11 16:13:10 b2 kernel: XFS (dm-146): log mount/recovery failed: error -74
> Jul 11 16:13:10 b2 kernel: XFS (dm-146): log mount failed

I would suggest that this indicates a torn write of some kind. Given
the state of the system when you rebooted, and all the RAID 5/6
writes in progress, this is entirely possible...

> Then xfs_repair comes back with:
> 
> # xfs_repair /dev/vg-name/lv-name
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_repair.  If you are unable to mount the filesystem, then use
> the -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> 
> At this point is "xfs_repair -L" (and attendant potential data loss) my only
> option?

One option is to correct the CRC with xfs_db, then try to mount the
filesystem again, but that will simply allow recovery to try to
modify what is possibly a bad btree block and then have other things
go really wrong (e.g. cross-linked data, duplicate freespace) at a
later point in time. That's potentially far more damaging, and I
wouldn't try it without having a viable rollback strategy (e.g. full
device snapshot and/or copy)....

It's probably safest to just zero the log and run repair at this
point.

> > This task holds the wc_lock() while it is doing this writeback
> > flush.
> > 
> > All the XFS filesystems are stuck in similar ways, such as trying to
> > push the journal and getting stuck in IO submission in
> > dm-writecache:
> ...
> > These are getting into dm-writecache, and the lock they are getting
> > stuck on is the wc_lock().
> ...
> > 
> > Directory reads are getting stuck in dm-write-cache:
> ...
> > Same lock.
> > 
> > File data reads are getting stuck the same way in dm-writecache.
> > 
> > File data writes (i.e. writeback) are getting stuck the same way
> > in dm-writecache.
> > 
> > Yup, everything is stuck on dm-writecache flushing to the underlying
> > RAID-5 device.
> > 
> > I don't see anything indicating a filesystem problem here. This
> > looks like a massively overloaded RAID 5 volume. i.e. the fast
> > storage that makes up the write cache has filled, and now everything
> > is stuck waiting for the fast cache to drain to the slow backing
> > store before new writes can be made to the fast cache. IOWs,
> > everything is running as RAID5 write speed and there's a huge
> > backlog of data being written to the RAID 5 volume(s) keeping them
> > 100% busy.
> 
> This had never been an issue with v5.15. Is it possible the upgrade to v6.1
> had a hand in this or that's probably just coincidence?

It could be a dm-writecache or md raid regression, but it could be
just "luck".

> In particular, could "5e672cd69f0a xfs: non-blocking inodegc pushes" cause a
> significantly greater write load on the cache?

No.

> I note that there's one fs (separate to the corrupt one above) that's still
> in mount recovery since the boot some hours ago. On past experience that
> indicates the inodegc stuff is holding things up, i.e. it would have been
> running prior to the reboot - or at least trying to.

I only found one inodegc working running in the trace above - it was
blocked on writecache doing a rmapbt block read removing extents. It
may have been a long running cleanup, but it may not have been.

As it is, mount taking a long time because there's a inode with a
huge number of extents that need freeing on an unlinked list is
*not* related to background inodegc in any way - this has -always-
happened with XFS; it's simply what unlinked inode recovery does.

i.e. background inodegc just moved the extent freeing from syscall
exit context to an async worker thread; the filesystem still has
exactly the same work to do. If the system goes down while that work
is in progress, log recovery has always finished off that cleanup
work...

> > If there is no IO going to the RAID 5 volumes, then you've got a
> > RAID 5 or physical IO hang of some kind. But I can't find any
> > indication of that - everything looks like it's waiting on RAID 5
> > stripe population to make write progress...
> 
> There's been no change to the cache device over the reboot, and it
> currently looks busy, but it doesn't look completely swamped:
....

About 150 1MB sized reads, and about 1000-1500 much smaller
writes each second, with an average write wait of near 10ms.
Certainly not a fast device, and it's running at about 50%
utilisation with an average queue depth of 10-15 IOs.

> It should be handling about the same load as prior to the reboot.

If that's the typical sustained load, I wouldn't expect it to have
that much extra overhead given small writes on RAID 6 volumes have
the worse performance characteristics possible. If the write cache
starts flushing lots of small discontiguous writes, I'd expect to
see that device go to 100% utilisation and long write wait times for
extended periods...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
