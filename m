Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:20049 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751823AbdISXi7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Sep 2017 19:38:59 -0400
Date: Wed, 20 Sep 2017 09:38:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: io_submit() blocks for writes for substantial amount of time
Message-ID: <20170919233856.GM10621@dastard>
References: <CAO2XSW6cctUGx18AdQQ29zHpjPiJ2vVJ-MHxrGcmoeMxzMvbbA@mail.gmail.com>
 <20170919122704.GA3487@bfoster.bfoster>
 <22a2db70-50e2-7a37-97f5-1751eafc3f7c@scylladb.com>
 <20170919173850.GA8139@dhcp-41-131.bos.redhat.com>
 <CAO2XSW5st7MpEAm=XEWHr_e0JHsn0yRk_q+qnj14N=GuTR0hJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO2XSW5st7MpEAm=XEWHr_e0JHsn0yRk_q+qnj14N=GuTR0hJg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tomasz Grabiec <tgrabiec@scylladb.com>
Cc: Brian Foster <bfoster@redhat.com>, Avi Kivity <avi@scylladb.com>, linux-xfs@vger.kernel.org

On Tue, Sep 19, 2017 at 07:53:52PM +0200, Tomasz Grabiec wrote:
> On Tue, Sep 19, 2017 at 7:38 PM, Brian Foster <bfoster@redhat.com> wrote:
> >> Is that because the disk is nearly full and there are no known flushed
> >> extents, or because the allocator doesn't prioritize known-flushed extents?
> >> From your comments below I gather you may not know for sure.
> >>
> >
> > I'm not sure without digging further into it. Hence the question around
> > free space availability.
> 
> The file system was utilized between 90% and 95% out of 165GB during the test.

Then I'm surprised that you only hit these relatively minor delays.
Once you get beyond 85-90% full the filesystem is typically not
running through allocation fast paths as large contiguous free
spaces are getting to be non-existant (especially for such small
filesystems like this).

Continued operation at >85-90% full will run you into premature
aging situations like free space fragmentation, and then all your
allocations and then data IO patterns will begin to suffer.  Once
you get above 95% full, various algorithms will even stop attempting
optimal allocations and instead start optimising for minimum size at
the expense of increased file fragmentation.

IOWs, expect unpredictable delays in the filesystem once you start
approaching ENOSPC, and the closer to ENOSPC you get the more
unpredictable the filesystem behaviour will get. And if you spend
long periods of time operating near ENOSPC, performance and
behaviour may not improve unless you free a large amount of space
(e.g. 50% of filesystem space) so that large contiguous free space
regions can reform....

So, yes, you can operate at near ENOSPC conditions. However, it's not
advisable if you require deterministic/predictable behaviour and/or
have long term filesystem performance requirements...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
