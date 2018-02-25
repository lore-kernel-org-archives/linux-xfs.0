Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:61054 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751989AbeBYVNS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 25 Feb 2018 16:13:18 -0500
Date: Mon, 26 Feb 2018 08:13:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180225211309.GF30854@dastard>
References: <9e69fcd01e1c02ea53e0e1ac66d60d24@assyoma.it>
 <20180224220757.GC30854@dastard>
 <711dd96e3c4b3e92d3fb38a01e77dc64@assyoma.it>
 <20180225024727.GD30854@dastard>
 <25ebcdb42650430d83d283435053efed@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ebcdb42650430d83d283435053efed@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-xfs@vger.kernel.org

On Sun, Feb 25, 2018 at 12:40:47PM +0100, Gionatan Danti wrote:
> Il 25-02-2018 03:47 Dave Chinner ha scritto:
> >
> >Yes, you have to freeze the filesystem to get a crash-consistent
> >snapshot of the filesystem.
> >
> >
> >You will end up with garbage.
> 
> Ok. Bonus question: am I right thinking this is due to the CoW copy
> not being atomic (ie: the various extents being in different state
> until the copy is finished)?

This isn't a copy on write issue. This is an issue of the state of
the file and the I/O stack above it at the time the data extents are
shared. There is I/O inflight, and so there's no guarantee that what
is in the extents being shared is consistent. Freezing the
filesystem stops IO in flight, so the extents can be shared while
the filesystem knows it has consistent state on stable storage.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
