Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:53179 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964884AbcJVRvN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 22 Oct 2016 13:51:13 -0400
Message-ID: <1477158668.2070.6.camel@lynxeye.de>
Subject: Re: [PATCH 0/2] XFS buffer cache scalability improvements
From: Lucas Stach <dev@lynxeye.de>
Date: Sat, 22 Oct 2016 19:51:08 +0200
In-Reply-To: <20161018212116.GC23194@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
         <20161018212116.GC23194@dastard>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

Am Mittwoch, den 19.10.2016, 08:21 +1100 schrieb Dave Chinner:
> On Tue, Oct 18, 2016 at 10:14:11PM +0200, Lucas Stach wrote:
> > 
> > Hi all,
> > 
> > this series scratches my own small itch with XFS, namely
> > scalability of the buffer
> > cache in metadata intensive workloads. With a large number of
> > cached buffers those
> > workloads are CPU bound with a significant amount of time spent
> > searching the cache.
> > 
> > The first commit replaces the rbtree used to index the cache with
> > an rhashtable. The
> > rbtree is a bottleneck in scalability, as the data structure itself
> > is pretty CPU
> > cache unfriendly. For larger numbers of cached buffers over 80% of
> > the CPU time
> > is spent waiting on cache misses resulting from the inherent
> > pointer chasing.
> > 
> > rhashtables provide a fast lookup with the ability to have lookups
> > proceed while the
> > hashtable is being resized. This seems to match the read dominated
> > workload of the
> > buffer cache index structure pretty well.
> 
> Yup, it's a good idea - I have considered doing this change for
> these reasons, but have never found the time.
> 
> > 
> > The second patch is logical follow up. The rhashtable cache index
> > is protected by
> > RCU and does not need any additional locking. By switching the
> > buffer cache entries
> > over to RCU freeing the buffer cache can be operated in a
> > completely lock-free
> > manner. This should help scalability in the long run.
> 
> Yup, that's another reason I'd considered rhashtables :P
> 
> However, this is where it gets hairy. The buffer lifecycle is
> intricate, subtle, and has a history of nasty bugs that just never
> seem to go away. This change will require a lot of verification
> work to ensure things like the LRU manipulations haven't been
> compromised by the removal of this lock...
> 
> > 
> > This series survives at least a xfstests auto group run (though
> > with the scratch
> > device being a ramdisk) with no regressions and didn't show any
> > problems in my
> > real world testing (using the patched FS with multiple large git
> > trees) so far.
> 
> It's a performance modification - any performance/profile numbers
> that show the improvement?
> 
In my testing with a small scale FS (some linux kernel git trees on a
FS with 4 AGs) the CPU time spent in xfs_buf_find while doing a git
checkout (going from one specific revision to another) with warm caches
goes down from 2% to 0.6% with this change.

I have a profile from a machine where xfs_buf_find is taking up the top
spot of the profile at 6% CPU time. Unfortunately I haven't been able
to re-run the test on a FS at that scale yet.

Regards,
Lucas
