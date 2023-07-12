Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B65EB64DC
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Jul 2023 01:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjGLBmb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jul 2023 21:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjGLBma (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jul 2023 21:42:30 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516F1E77
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 18:42:28 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-56368c40e8eso4035676eaf.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jul 2023 18:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689126147; x=1691718147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2o/po0X6dMIhy41rwVFtDUiwhMPTOIuhyHcDV8vEFgg=;
        b=K97bGvXt8R0mjRCfgXySYBiYp2Gb/y4G7KHKSq6NThgjCaLXA+yzCXm/sGO8CAA5xg
         Rz3xM0JxYAy70hc/orMhjAhseM5Y2wUFKxtif0oOgQZrJ4wct5qQHrZSzUMXIG1XAjC9
         /pEouQV/QpJf8PqfBXJmeiirDh7SVrOz5tIganr6Wz7B1z3Ce9ATGscVMX11r4PLO+/S
         RGBSr4WyFDejolLfbdMd6qxxKXEWqGtbaE1aV3pUzDFf9vebk62nPOA5p2OEjVpr5nPs
         mVkM1F7ZxbVzLW5I9BbnkPQGpk5hd5wp1n8QQYGMuiFVpe77q/MCodZ+glSRWDW03cnk
         Mz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689126147; x=1691718147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2o/po0X6dMIhy41rwVFtDUiwhMPTOIuhyHcDV8vEFgg=;
        b=j1yMdx6kJMHV561ss3IDq29Wd2kNc8OHagjhANPkTyUxRy48WEXpZl3GLWqPVR8u8v
         ePJ79ajLhObY6yWcgMcqmydR5QZ6pLUa7zQGbALpp+4Hzxf/FfaZctFTFHQJjlpsZTcn
         PqmX1KKfiTTO817XHsM7Gqa307MLClVPvXfaa59JL1qpoaNXFD5KQSERg7ti+YKVdrON
         B9S84wsRLrRibAXrpeWImj5WvUunXdSy/VGBSymAh8iUvy4RV5N6IMPgOTbK0SphHAaa
         8IWaYup1YmrTlIV9qd0LmMyZ1XB/cz2F4KbiM8uw8ZK1i99PF3KkPgU5jxIKUHTWadQ+
         S04g==
X-Gm-Message-State: ABy/qLbBndKQEZQbqwLWs0uwAQPeyS6lP5dVgPkpW/TlH7rMI7FqaYbw
        7uj+eGURaaSPFt0L96xyGiSFbWU9BqDCJH34vyo=
X-Google-Smtp-Source: APBJJlFiH6zUCDIhsZ5BhABptjh6jJLLuGfPK30HjgH0cc1++aXfBJRefGpYvDvmlIDhiLEXEGIX/A==
X-Received: by 2002:a05:6358:5e18:b0:134:fdfc:4319 with SMTP id q24-20020a0563585e1800b00134fdfc4319mr14689270rwn.20.1689126147360;
        Tue, 11 Jul 2023 18:42:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id m6-20020a637d46000000b0054a15146f53sm2189255pgn.13.2023.07.11.18.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 18:42:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJOs2-0050Z5-0l;
        Wed, 12 Jul 2023 11:42:22 +1000
Date:   Wed, 12 Jul 2023 11:42:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: rm hanging, v6.1.35
Message-ID: <ZK4E/gGuaBu+qvKL@dread.disaster.area>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
 <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
 <20230712011356.GB886834@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712011356.GB886834@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 11:13:56AM +1000, Chris Dunlop wrote:
> On Wed, Jul 12, 2023 at 08:21:11AM +1000, Dave Chinner wrote:
> > On Tue, Jul 11, 2023 at 05:05:30PM +1000, Chris Dunlop wrote:
> > > On Tue, Jul 11, 2023 at 01:10:11PM +1000, Dave Chinner wrote:
> > 
> > > More on the problem topic below, and apologies for the aside, but
> > > this is my immediate concern: post the reboot into v5.15.118 I have
> > > one of the filesystems failing to mount with:
> ...
> > I would suggest that this indicates a torn write of some kind. Given
> > the state of the system when you rebooted, and all the RAID 5/6
> > writes in progress, this is entirely possible...
> ...
> > It's probably safest to just zero the log and run repair at this
> > point.
> 
> Thanks. I did that last night (after taking a snapshot) - 'xfs_repair -v' is
> still running but there's a LOT of nasty output so it's not looking good.
> 
> ...oh. It finished whilst I've been writing this. If you're interested in
> the log:
> 
> https://file.io/XOGokgxgttEX

Oh, there's *lots* of CRC errors. All through the free space and
rmap btrees, but all in a similar range of LBAs.


$  grep CRC ~/Downloads/xfs_repair.log |sort -k 9
Metadata CRC error detected at 0x5557765dfc6d, xfs_rmapbt block 0x10518c600/0x1000
Metadata CRC error detected at 0x5557765dfc6d, xfs_rmapbt block 0x10518c648/0x1000
Metadata CRC error detected at 0x55577660b07d, xfs_bnobt block 0x10518c650/0x1000
Metadata CRC error detected at 0x55577660b07d, xfs_cntbt block 0x10518c668/0x1000
Metadata CRC error detected at 0x55577660b07d, xfs_bnobt block 0x10518ce88/0x1000
Metadata CRC error detected at 0x5557765dfc6d, xfs_rmapbt block 0x10518d6c0/0x1000
Metadata CRC error detected at 0x55577660b07d, xfs_bnobt block 0x10518d6d0/0x1000
Metadata CRC error detected at 0x5557765dfc6d, xfs_rmapbt block 0x10518d6e0/0x1000
Metadata CRC error detected at 0x5557765dfc6d, xfs_rmapbt block 0x10518d828/0x1000
Metadata CRC error detected at 0x55577660b07d, xfs_bnobt block 0x10518d858/0x1000
.....

There's a whole cluster of CRC errors very close together (10 across
0x1200 sectors = 6144 sectors = 3MB of disk space).

This pattern of "bad CRC clusters" occurs more often than not as
I look through the list of CRC errors. I suspect this indicates
something more fundamental wrong with either the RAID volume of the
dm-writecache on top of it...

> The directory structure looks sane, I'll start running checks on the data.

Given the amount of bad metadata, I wouldn't trust anything in that
filesystem to be properly intact.

> > > > I don't see anything indicating a filesystem problem here. This
> > > > looks like a massively overloaded RAID 5 volume. i.e. the fast
> > > > storage that makes up the write cache has filled, and now everything
> > > > is stuck waiting for the fast cache to drain to the slow backing
> > > > store before new writes can be made to the fast cache. IOWs,
> > > > everything is running as RAID5 write speed and there's a huge
> > > > backlog of data being written to the RAID 5 volume(s) keeping them
> > > > 100% busy.
> 
> Oddly, of the 56 similarly configured filesystems (writecache/lvm/rbd) on
> this box, with maybe 10 actively sinking writes at any time, that one above
> is the only one that had any trouble on reboot. If it had been a general
> problem w/ the cache device I would have thought more of the active writers
> would have similar issues. Maybe I just got lucky - and/or that demonstrates
> how hard xfs tries to keep your data sane.

I don't think it's XFS related at all....

> > > This had never been an issue with v5.15. Is it possible the upgrade
> > > to v6.1 had a hand in this or that's probably just coincidence?
> > 
> > It could be a dm-writecache or md raid regression, but it could be
> > just "luck".
> 
> Ugh. Sigh. I guess at some point I'm going to have to bite the bullet again,
> and next time watch the cache device like a hawk. I'll keep an eye out for
> dm-writecache and md raid problems and patches etc. so see what might come
> up.
> 
> Is there anything else that occurs to you that I might monitor prior to and
> during any future recurrance of the problem?

Not really. What every problem occurred that started things going
bad was not evident from the information that was gathered.

> > > In particular, could "5e672cd69f0a xfs: non-blocking inodegc pushes"
> > > cause a significantly greater write load on the cache?
> > 
> > No.
> > 
> > > I note that there's one fs (separate to the corrupt one above)
> > > that's still in mount recovery since the boot some hours ago. On
> > > past experience that indicates the inodegc stuff is holding things
> > > up, i.e. it would have been running prior to the reboot - or at
> > > least trying to.
> > 
> > I only found one inodegc working running in the trace above - it was
> > blocked on writecache doing a rmapbt block read removing extents. It
> > may have been a long running cleanup, but it may not have been.
> 
> Probably was a cleanup: that's the reason for the update to v6.1, every now
> and again the box was running into the problem of getting blocked on the
> cleanup. The extent of the problem is significantly reduced by moving from
> one large fs where any extended cleanup would block everything, to multiple
> small-ish fs'es (500G-15T) where the blast radius of an extended cleanup is
> far more constrained. But the problem was still pretty annoying when it
> hits.
> 
> Hmmm, maybe I can just carry a local backport of "non-blocking inodegc
> pushes" in my local v5.15. That would push back my need to move do v6.1.
> 
> Or could / should it be considered for an official backport?  Looks like it
> applies cleanly to current v5.15.120.

I thought that had already been done - there's supposed to be
someone taking care of 5.15 LTS backports for XFS....

> > As it is, mount taking a long time because there's a inode with a
> > huge number of extents that need freeing on an unlinked list is
> > *not* related to background inodegc in any way - this has -always-
> > happened with XFS; it's simply what unlinked inode recovery does.
> > 
> > i.e. background inodegc just moved the extent freeing from syscall
> > exit context to an async worker thread; the filesystem still has
> > exactly the same work to do. If the system goes down while that work
> > is in progress, log recovery has always finished off that cleanup
> > work...
> 
> Gotcha. I'd mistakenly thought "non-blocking inodegc pushes" queued up the
> garbage collection for background processing. My further mistaken hand-wavy
> thought was that, if the processing that was previously foreground was now
> punted to background (perhaps with different priorities) maybe the
> background processing was simply way more efficient, enough to swamp the
> cache with metadata updates.

Doubt it, the processing is exactly the same code, just done from a
different task context.

> But with your further explanation and actually reading the patch (should
> have done that first) shows the gc was already queued, the update was to NOT
> wait for the queue to be flushed.
> 
> Hmmm, then again... might it be possible that, without the patch, at some
> point after a large delete, further work was blocked whilst waiting for the
> queue to be flushed, limiting the total amount of work, but with the patch,
> the further work (e.g. more deletes) is able to be queued - possibly to the
> point of swamping the cache device?

Unlinks don't generate a lot of IO. They do a lot of repeated
operations to cached metadata, and the journal relogs all those
blocks without triggering IO to the journal, too.

> > > There's been no change to the cache device over the reboot, and it
> > > currently looks busy, but it doesn't look completely swamped:
> > ....
> > 
> > About 150 1MB sized reads, and about 1000-1500 much smaller
> > writes each second, with an average write wait of near 10ms.
> > Certainly not a fast device, and it's running at about 50%
> > utilisation with an average queue depth of 10-15 IOs.
> 
> That's hopefully the cache working as intended: sinking small continuous
> writes (network data uploads) and aggregating them into larger blocks to
> flush out to the bulk storage (i.e. reads from the cache to write to the
> bulk).
> 
> > > It should be handling about the same load as prior to the reboot.
> > 
> > If that's the typical sustained load, I wouldn't expect it to have
> > that much extra overhead given small writes on RAID 6 volumes have
> > the worse performance characteristics possible. If the write cache
> > starts flushing lots of small discontiguous writes, I'd expect to
> > see that device go to 100% utilisation and long write wait times for
> > extended periods...
> 
> There shouldn't be many small discontigous writes in the data: it's
> basically network uploads to sequential files in the 100s MB to multi GB
> range. But there's also a bunch of reflinking, not to mention occasionally
> removing highly reflinked multi-TB files, so these metadata updates might
> count as "lots of small discontiguous writes"?

Yeah, the metadata updates end up being small discontiguous
writes....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
