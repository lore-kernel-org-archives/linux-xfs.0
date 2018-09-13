Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:58945 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726495AbeIML1D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Sep 2018 07:27:03 -0400
Date: Thu, 13 Sep 2018 16:18:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Strange XFS problem
Message-ID: <20180913061833.GB27618@dastard>
References: <1063031109.4602643.1536739675362.JavaMail.zimbra@casalogic.dk>
 <20180913041944.GA27618@dastard>
 <1406319049.4700361.1536816119283.JavaMail.zimbra@casalogic.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406319049.4700361.1536816119283.JavaMail.zimbra@casalogic.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Troels Hansen <th@casalogic.dk>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Thu, Sep 13, 2018 at 07:21:59AM +0200, Troels Hansen wrote:
> 
> > 
> > What happens on your network every 14 days or so? Is there a rogue
> > client side backup or admin task running somewhere?
> > 
> 
> Well, we run nightly backups, but thats read ops.

Yup, but that can get stuck modifying atime, like the bacula process
in the hung process traces. :)

Hmmm - just a thought - it's hardware raid - it's not running a
background admin op like a media scrub every 14 days, is it?

> When I look at the load, its not particular more loaded at that time, than normal work.

OK.

> > Does this repeat every 120s?
> 
> No, what I sent is the full trace. It happened around 23:23, but
> no more XFS errors in the log (which is on the ext4 OS disk).

Ok, so those processes reported as hung have been woken and made
progress again. It seems like a temporary overload situation.

> It was working when I came in the following morning aroung 6:45,
> and worked for some time,  but initially failed, and we had to
> reboot the server to get NFS exports to work.  But, as I said,
> even though the fs was inaccessible from NFS I could `ls` the
> filesystem locally, but we really have no indication of it being
> an NFS problem, as we only see the XFS problem.

That could be the same problem, with all the kernel nfsds blocked
waiting for the filesystem so no new NFS requests could be
processed.  How many kernel nfsd threads do you run?  Local
operations can still be done (don't go through nfsds), and they
won't be slow if they hit the caches rather than have to retreive
data from disk.

> It could also boil down to a NFS problem, I just wasn't sure how
> to read the XFS trace.

Like you, I don't think this is an NFS problem - it smells more of
how huge hardware writeback caches in front of slow disks using
RAID5/6 behave.

i.e. Flushing 100MB of sequential write data from the cache takes a
fraction or a second, flushing 100MB of random 4k write data to
RAID5 luns can take minutes. While the hardware cache and flushing is
supposed to be completely invisible to the OS, we can see it's
impact via unexpectedly high device utilisations and long IO times
for otherwise normal IO loads.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
