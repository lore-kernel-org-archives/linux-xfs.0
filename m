Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:4812 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751646AbeB0WEq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 17:04:46 -0500
Date: Wed, 28 Feb 2018 09:04:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Reflink (cow) copy of busy files
Message-ID: <20180227220404.GI30854@dastard>
References: <25ebcdb42650430d83d283435053efed@assyoma.it>
 <20180225211309.GF30854@dastard>
 <d105d0000652be75774cc1f5f23eae68@assyoma.it>
 <20180226002533.GG30854@dastard>
 <6eacd8faae2779b8dfb62fb0d65a9411@assyoma.it>
 <CAOQ4uxixAP6F8f6hT5VENQLD0o_3Bym6pkAJhXva5b99BhE9Eg@mail.gmail.com>
 <73ef828837683073feb1c49e3405dd6a@assyoma.it>
 <20180226172601.GC19312@magnolia>
 <20180227003348.GH30854@dastard>
 <fc797c0a-7263-c347-729d-c381b6936d3a@assyoma.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc797c0a-7263-c347-729d-c381b6936d3a@assyoma.it>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Gionatan Danti <g.danti@assyoma.it>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Amir Goldstein <amir73il@gmail.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 27, 2018 at 09:06:25AM +0100, Gionatan Danti wrote:
> On 27/02/2018 01:33, Dave Chinner wrote:
> >On Mon, Feb 26, 2018 at 09:26:01AM -0800, Darrick J. Wong wrote:
> >
> >My point is that vfs_clone_file_range is not running fsync(2)i
> >operations.
> >
> >It's a fdatawrite_and_wait() call, which submits dirty data to disk
> >and waits for it, but does *not flush volatile storage caches*.
> >IOWs, it's not a data integrity operation.
> >
> >Hence while the reflink now has "data on disk" and can clone the
> >extents, Neither the data nor the extents being cloned are stable
> >and won't be until an fsync operation is performed on either the
> >reflink source or destination file....
> >
> >Still no cache flushes. Hence even after the clone has run,
> >you can still lose the data (and extents!) from the host file....
> 
> Am I right saying that you are speaking about an *host* crash during
> or just after the clone?
> 
> Even in such a case, only the newly created file clone should be
> lost/corrupted, while the original file will *not* be affected,
> right? Or will an interrupted clone operation (ie: due to a power
> failure) leave *both* files in an unconsistent state?

A host crash can lose data from the original file when it is
configured in writeback mode (as you've said you are using). If the
clone is there, both source and clone should be fully intact. If
it's not, then you will have lost data from the original image file.

But, really, why risk losing data or filesystem corruption by trying
to take shortcuts?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
