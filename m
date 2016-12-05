Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:57115 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751487AbcLEHqy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 02:46:54 -0500
Date: Mon, 5 Dec 2016 18:46:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161205074645.GB4326@dastard>
References: <E861E5C1-D1C2-4368-8BFC-505533C9A3A3@nuagenetworks.net>
 <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
 <20161204235059.GO31101@dastard>
 <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
 <20161205012243.GQ31101@dastard>
 <C07DD929-5600-4934-A6B0-C0A7D83D7247@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C07DD929-5600-4934-A6B0-C0A7D83D7247@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Sun, Dec 04, 2016 at 05:47:04PM -0800, Cyril Peponnet wrote:
> > On Dec 4, 2016, at 5:22 PM, Dave Chinner <david@fromorbit.com>
> > wrote: What deadlock is that? XFS is reporting memory allocation
> > issues, not that there is a filesystem deadlock. Your comments
> > that dropping caches make the problem go away indicate that
> > there isn't any deadlock, just blocking on memory allocation
> > that is taking a long time to resolve…
> 
> You are right by deadlock I meant that mount point hang for ls
> commands for instance (from the server it self) and basically the
> glusterfs mount on the hypervisors is also hanging for all vms (it
> makes the vms to remount RO).

So everything is /blocked/, not deadlocked. If the memory allocation
then makes progress, we're all ok.

> On this server I have 1200 living snapshots, usually not too much
> write in it except for some of them…
> 
> Is there a way to optimize the memory allocation? Or we likely
> need to add more ram…

More RAM won't help - it's likely a memory fragmentation problem
made worse by the fact that older kernels won't do memory compaction
(i.e. memory defrag) when high order memory allocation fails. If the
problem is file fragmentation, then the best you can probably do
right now is limit fragmentation.

Stopping qcow2 from fragmenting the crap out of the files will
prevent the problem from re-occurring. This is the primary use case
for extent size hints in XFS these days, though I know you can't
actually control the gluster back end to use this. perhaps there are
other tweaks to qcow formats (cluster size?) or gluster config to
limit the amount of fragmentation....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
