Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E146B7F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 14:18:32 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D247F304059
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 12:18:29 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	9AhPvlNoHXB1a4uM for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 12:18:23 -0800 (PST)
Date: Wed, 2 Dec 2015 07:18:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: I/O 'owner' DoS probs (was Re: Does XFS support cgroup writeback
	limiting?)
Message-ID: <20151201201808.GU19199@dastard>
References: <5652F311.7000406@5t9.de> <20151123202619.GE26718@dastard>
	<56538E6A.6030203@5t9.de> <20151123232052.GI26718@dastard>
	<5655FDDA.9050502@5t9.de> <20151125213500.GK26718@dastard>
	<565D7E03.20008@tlinx.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <565D7E03.20008@tlinx.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "L.A. Walsh" <xfs@tlinx.org>
Cc: xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 03:01:23AM -0800, L.A. Walsh wrote:
> 
> 
> Dave Chinner wrote:
> >Metadata IO not throttled - it is owned by the filesystem and hence
> >root cgroup.
> ----
> 	Please forgive me if this is "obvious"....
> 
> 	If it is owned by the file system, then logically, such meta
> data wouldn't count against the user's quota limits?

Filesystem space usage accounting is not the same thing. It's just
accounting, and has nothign to do with how the metadata is dependent
on the transaction subsystem, caching, locking, parent/child
relationships with other metadata in the filesystem, etc.

> 	Is this metadata really I/O that is completely disconnected from
> a user that they cannot affect?

throttling metadata IO - read or write - can lead to entire
filesystem stalls/deadlocks. e.g. transaction reservation cannot
complete because the inode that pins the tail of the log is blocked
from being written due to the process that needs to write it being
throttled by the IO controller. Hence every transaction in the
filesytem stalls until the IO controller allows the critical
metadata IO to be dispatched and completed...

Or, alternatively, a process is trying to allocate a block, and
holds an AG locked. It then tries to read a btree block, which is
throttled and blocked for some time. Any other allocation that needs
to take place in that AG is now blocked until the first allocation
is completed.

i.e. the moment we start throttling global metadata IO based on
per-process/cgroup limits, we end up with priority inversions and
partial/complete fs stalls all over the place. You can educate/ban
stupid users, but we can't easily iprevent stalls due to
IO level priority inversions we have no control over at the
filesystem level...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
