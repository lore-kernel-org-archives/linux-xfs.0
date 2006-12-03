Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Dec 2006 15:50:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kB3NoKaG032621
	for <xfs@oss.sgi.com>; Sun, 3 Dec 2006 15:50:22 -0800
Date: Mon, 4 Dec 2006 10:49:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
Message-ID: <20061203234928.GA37654165@melbourne.sgi.com>
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <457080EA.1010807@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <457080EA.1010807@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Dec 01, 2006 at 07:22:18PM +0000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Thu, Nov 30, 2006 at 06:03:40PM +0000, Lachlan McIlroy wrote:
> >I think the slow path code is somewhat clearer with a separate
> >mutex - it clearly documents the serialisation barrier that
> >the slow path uses and allows us to do slow path checks on the
> >per-cpu counters without needing the SB_LOCK.
> 
> It's certainly an improvement over the original code.
> 
> >
> >It also means that in future, we can slowly remove the need for
> >holding the SB_LOCK across the entire rebalance operation and only
> >use it when referencing the global superblock fields during
> >the rebalance.
> 
> Sounds good.
> 
> >
> >If the need arises, it also means we can move to a mutex per counter
> >so we can independently rebalance different types of counters at the
> >same time (which we can't do right now).
> 
> That seems so obvious - I'm surprised we can't do it now.

Well, the reason I didn't go down this path in the first place
was that typically only one type of counter would need rebalancing
at a time (e.g. free blocks or free inodes, but not both at the
same time). I tested this out on revenue2 with simultaneous creates
and deletes of small files but could not cause contention on the
single global lock under these loads. i also tried parallel
writes of large files with creates and deletes, but hte create/delete
was slowed sufficiently by the parallel writes that it once again
didn't cause an issue.

Hence it didn't seem to be an issue and a single lock simplified
the initial implementation. What I'm thinking now is that it may
become an issue with MDFS as acheivable create and delete rates
should be much higher on one of these filesystems and then it may
prove to be an issue.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
