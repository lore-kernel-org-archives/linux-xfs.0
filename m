Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:34467 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751510AbcLEVwy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 16:52:54 -0500
Date: Tue, 6 Dec 2016 08:45:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS: possible memory allocation deadlock in kmem_alloc on
 glusterfs setup
Message-ID: <20161205214557.GC4219@dastard>
References: <20161204214950.GL31101@dastard>
 <9B23CFED-4AFC-46FC-8E35-AD85B11FEA02@nuagenetworks.net>
 <20161204224604.GN31101@dastard>
 <D3BB642A-1CBB-47CB-89AA-E99837228F35@nuagenetworks.net>
 <20161204235059.GO31101@dastard>
 <A9F9389E-0CD8-4A85-BA08-C5503B781679@nuagenetworks.net>
 <20161205012243.GQ31101@dastard>
 <C07DD929-5600-4934-A6B0-C0A7D83D7247@nuagenetworks.net>
 <20161205074645.GB4326@dastard>
 <07D60BAA-A340-4AB0-9F22-D962A0478891@nuagenetworks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <07D60BAA-A340-4AB0-9F22-D962A0478891@nuagenetworks.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Cyril Peponnet <cyril.peponnet@nuagenetworks.net>
Cc: linux-xfs@vger.kernel.org

On Mon, Dec 05, 2016 at 07:51:45AM -0800, Cyril Peponnet wrote:
> I had the issue again but I don’t have more output in dmesg or
> journalctl even with the echo 11 > /proc/sys/fs/xfs/error_level
> set.

Which means your kernel does not have this commit:

commit 847f9f6875fb02b576035e3dc31f5e647b7617a7
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Mon Oct 12 16:04:45 2015 +1100

    xfs: more info from kmem deadlocks and high-level error msgs
    
    In an effort to get more useful out of "possible memory
    allocation deadlock" messages, print the size of the
    requested allocation, and dump the stack if the xfs error
    level is tuned high.
    
    The stack dump is implemented in define_xfs_printk_level()
    for error levels >= LOGLEVEL_ERR, partly because it
    seems generically useful, and also because kmem.c has
    no knowledge of xfs error level tunables or other such bits,
    it's very kmem-specific.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

> Is there another location where I should look at ?

Nope, there's nothing in your kernel we can use to identify the
source of memory allocations. I'm pretty sure that RH have used
systemtap scripts to pull this information from these kernels for
RHEL customers - we've added additional debug help here to avoid
that need, but your kernel doesn't have that code....

Essentially, best guess is that it's file fragmentation causing
problems with extent list allocation. Finding out why that one
snapshot is fragmenting so much and mitigating it is probably the
only thing you can do right now (i.e. extent size hints). Long term
is to get gluster to do the mitigation for VM images automatically.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
