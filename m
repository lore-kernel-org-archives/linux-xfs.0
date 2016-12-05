Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:19447 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751070AbcLEBXM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 20:23:12 -0500
Date: Mon, 5 Dec 2016 12:22:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161205012243.GQ31101@dastard>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
 <20161204235059.GO31101@dastard>
 <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 04, 2016 at 05:14:51PM -0800, Cyril Peponnet wrote:
> 
> > On Dec 4, 2016, at 3:50 PM, Dave Chinner <david@fromorbit.com>
> > wrote:
> > 
> > On Sun, Dec 04, 2016 at 03:24:50PM -0800, Cyril Peponnet wrote:
> >>> On Dec 4, 2016, at 2:46 PM, Dave Chinner <david@fromorbit.com>
> >>> Which used LVM snapshots to take snapshots of the entire
> >>> brick.  I don't see any LVM in your config, so I'm not sure
> >>> what snapshot implementation you are using here. What are you
> >>> using to take the snapshots of your VM image files? Are you
> >>> actually using the qemu qcow2 snapshot functionality rather
> >>> than anything native to gluster?
> >>> 
> >> 
> >> Yes sorry it was not clear enough, qemu-img snapshots no native
> >> snapshots.
> > 
> > Ok, so that's a fragmentation problem in it's own right. both
> > internal qcow2 fragmentation and file fragmentation.
> > 
> >>> Also, can you attach the 'xfs_bmap -vp' output of some of
> >>> these image files and their snapshots?
> >> 
> >> A snapshot:
> >> https://gist.github.com/CyrilPeponnet/8108c74b9e8fd1d9edbf239b2872378d
> >> (let me know if you need more basically there is around 600
> >> live snapshots sitting here).
> > 
> > 1200 extents, mostly small, almost entirely adjacent. Typical
> > qcow2 file fragmentation pattern. That's not going to cause your
> > memory allocation problems - can you find one that has hundreds
> > of thousands of extents?
> 
> I found one with 10799109 :/ 576GB in size (I need to find why
> this one is so big this is not normal…)… Could it lead to
> the issue?

The memory allocation issue, yes. 10 million extents is
unusually high even for VM image files...

> I mean could one file cause the deadlock of the entire
> FS?

What deadlock is that? XFS is reporting memory allocation issues,
not that there is a filesystem deadlock. Your comments that dropping
caches make the problem go away indicate that there isn't any
deadlock, just blocking on memory allocation that is taking a long
time to resolve...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
