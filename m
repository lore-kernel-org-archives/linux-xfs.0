Return-Path: <SRS0=UV4a=4J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75DCC11D00
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 01:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94366206E2
	for <linux-xfs@archiver.kernel.org>; Fri, 21 Feb 2020 01:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgBUBRq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Feb 2020 20:17:46 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:54845 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729476AbgBUBRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 20:17:45 -0500
Received: from dread.disaster.area (pa49-195-185-106.pa.nsw.optusnet.com.au [49.195.185.106])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D186D3A1A6C;
        Fri, 21 Feb 2020 12:17:41 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j4wwn-000521-1w; Fri, 21 Feb 2020 12:17:41 +1100
Date:   Fri, 21 Feb 2020 12:17:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, sandeen@sandeen.net,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs_db: check that metadata updates have been
 committed
Message-ID: <20200221011741.GS10776@dread.disaster.area>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216293385.601264.3202158027072387776.stgit@magnolia>
 <20200220140623.GC48977@bfoster>
 <20200220165840.GX9506@magnolia>
 <20200220175857.GI48977@bfoster>
 <20200220183450.GA9506@magnolia>
 <20200221000119.GR10776@dread.disaster.area>
 <20200221003921.GE9506@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200221003921.GE9506@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=bkRQb8bsQZKWSSj4M57YXw==:117 a=bkRQb8bsQZKWSSj4M57YXw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=7-415B0cAAAA:8 a=6gELCi-BzjVnx6CXXGkA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 20, 2020 at 04:39:21PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 21, 2020 at 11:01:19AM +1100, Dave Chinner wrote:
> > On Thu, Feb 20, 2020 at 10:34:50AM -0800, Darrick J. Wong wrote:
> > > > I think
> > > > having libxfs_umount() do a proper purge -> flush and returning any
> > > > errors instead is a fair tradeoff for simplicity. Removing the
> > > > flush_devices() API also eliminates risk of somebody incorrectly
> > > > attempting the flush after the umount frees the buftarg structures
> > > > (without reinitializing pointers :P).
> > 
> > You mean like this code that I'm slowly working on to bring the
> > xfs_buf.c code across to userspace and get rid of the heap of crap
> > we have in libxfs/{rdwr,cache}.c now and be able to use AIO properly
> > and do non-synchronous delayed writes like we do in the kernel?
> > 
> > libxfs/init.c:
> > ....
> > static void
> > buftarg_cleanup(
> >         struct xfs_buftarg      *btp)
> > {
> >         if (!btp)
> >                 return;
> > 
> >         while (btp->bt_lru.l_count > 0)
> >                 xfs_buftarg_shrink(btp, 1000);
> >         xfs_buftarg_wait(btp);
> >         xfs_buftarg_free(btp);
> 
> Not quite what the v3 series does, but only because it's still stuck
> with "whack the bcache and then go see what happened to each buftarg".

Right - I've completely reimplemented the caching and LRUs so that
global bcache thingy goes away.

> > }
> > 
> > /*
> >  * Release any resource obtained during a mount.
> >  */
> > void
> > libxfs_umount(
> >         struct xfs_mount        *mp)
> > {
> >         struct xfs_perag        *pag;
> >         int                     agno;
> > 
> >         libxfs_rtmount_destroy(mp);
> > 
> >         buftarg_cleanup(mp->m_ddev_targp);
> >         buftarg_cleanup(mp->m_rtdev_targp);
> >         if (mp->m_logdev_targp != mp->m_ddev_targp)
> >                 buftarg_cleanup(mp->m_logdev_targp);
> 
> Yep, that's exactly where I moved the cleanup call in v3.

OK, good :P

> > .....
> > 
> > libxfs/xfs_buftarg.c:
> > .....
> > void
> > xfs_buftarg_free(
> >         struct xfs_buftarg      *btp)
> > {
> >         ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
> >         percpu_counter_destroy(&btp->bt_io_count);
> >         platform_flush_device(btp->bt_fd, btp->bt_bdev);
> > 	libxfs_device_close(btp->bt_bdev);
> >         free(btp);
> 
> I'm assuming this means you've killed off the buffer handling parts of
> struct libxfs_xinit too?

Which bits are they? THe bcache init stuff is gone, yes, but right
now that function still does all the device opening and passing the
dev_ts to xfs_buftarg_alloc() for it to initialise similar to the
way the kernel initialises the buftarg.


> > I haven't added the error returns for this code yet - I'm still
> > doing the conversion and making it work.
> > 
> > I'll probably have to throw the vast majority of that patchset away
> > and start again if all this API change that darrick has done is
> > merged. And that will probably involve me throwing away all of the
> > changes in this patch series because they just don't make any sense
> > once the code is restructured properly....
> 
> ...or just throw them at me in whatever state they're in now and let me
> help figure out how to get there?
> 
> Everyone: don't be afraid of the 'RFCRAP' for interim patchsets.
> Granted, posting git branches with a timestamp might be more
> practicable...

I'm not afraid of them - I've got to at least get it to the compile
stage with all the infrastructure in place and that's been the hold
up. :P

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
