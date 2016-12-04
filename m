Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:12742 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751227AbcLDXvk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Dec 2016 18:51:40 -0500
Date: Mon, 5 Dec 2016 10:50:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161204235059.GO31101@dastard>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 04, 2016 at 03:24:50PM -0800, Cyril Peponnet wrote:
> > On Dec 4, 2016, at 2:46 PM, Dave Chinner <david@fromorbit.com>
> > Which used LVM snapshots to take snapshots of the entire brick.
> > I don't see any LVM in your config, so I'm not sure what
> > snapshot implementation you are using here. What are you using
> > to take the snapshots of your VM image files? Are you actually
> > using the qemu qcow2 snapshot functionality rather than anything
> > native to gluster?
> > 
> 
> Yes sorry it was not clear enough, qemu-img snapshots no native
> snapshots.

Ok, so that's a fragmentation problem in it's own right. both
internal qcow2 fragmentation and file fragmentation.

> > Also, can you attach the 'xfs_bmap -vp' output of some of these
> > image files and their snapshots?
> 
> A snapshot:
> https://gist.github.com/CyrilPeponnet/8108c74b9e8fd1d9edbf239b2872378d
> (let me know if you need more basically there is around 600 live
> snapshots sitting here).

1200 extents, mostly small, almost entirely adjacent. Typical qcow2
file fragmentation pattern. That's not going to cause your memory
allocation problems - can you find one that has hundreds of
thousands of extents?

> > 
> > 56GB of cached file data. If you're getting high order
> > allocation failures (which I suspect is the problem) then this
> > is a memory fragmentation problem more than anything.
> > 
> >> ----------------------------------------------------------------
> >> DG/VD TYPE  State Access Consist Cache Cac sCC     Size Name
> >> ----------------------------------------------------------------
> >> 0/0   RAID0 Optl  RW     Yes     RAWBC -   ON  7.275 TB scratch
> >> ----------------------------------------------------------------
> >> 
> >> Cac=CacheCade|Rec=Recovery|OfLn=OffLine|Pdgd=Partially
> >> Degraded|dgrd=Degraded Optl=Optimal|RO=Read Only|RW=Read
> >> Write|HD=Hidden|B=Blocked|Consist=Consistent| R=Read Ahead
> >> Always|NR=No Read Ahead|WB=WriteBack| AWB=Always
> >> WriteBack|WT=WriteThrough|C=Cached IO|D=Direct IO|sCC=Scheduled
> > 
> > IIRC, AWB means that if the cache goes into degraded/offline
> > mode, you’re vulnerable to corruption/loss on power
> > failure…
> 
> Yes we have BBU + redundant PSU to address that.

BBU fails, data center loses power, corruption/data loss still
occurs. Not my problem, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
