Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 26B247F53
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 16:11:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A9A6304032
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 14:11:06 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ExbgBcaDu5CAVACQ for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 14:11:04 -0700 (PDT)
Date: Wed, 13 Mar 2013 08:11:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests #111 + XFS debug = infinite-loop oops
Message-ID: <20130312211101.GQ21651@dastard>
References: <CAJzLF9nAQvXCRoNqVw7jiTqmNugau_nK9KTT1ChsrwAv502gTA@mail.gmail.com>
	<513F8FBD.4080805@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <513F8FBD.4080805@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Tue, Mar 12, 2013 at 03:27:41PM -0500, Mark Tinguely wrote:
> On 03/12/13 13:46, Michael L. Semon wrote:
> >Hi!  I was running xfstests #111 under the following conditions...
> >
> >(*) zeroed partitions, and
> >(*) a fresh mkfs.xfs for each file system, and
> >
> >(1) CONFIG_XFS_DEBUG used, rtdev used, external logdev used, or
> >(2) CONFIG_XFS_DEBUG used, external logdev used, or
> >(3) CONFIG_XFS_DEBUG used, all internal, mkfs.xfs called with no options
> >
> >...and I get a trace like the one below (from (3)).  The trace is from
> >kernel 3.9.0-rc2 on an old Pentium III, using a normal VGA console on
> >the test PC, captured by another PC over serial cable.  The trace is
> >part of an infinite loop that becomes finite only if I rip out the
> >console and VGA entirely.  Overall, more is in play here than just
> >XFS, but I don't know to whom I should write.  [A relevant question
> >for which I don't know the answer:  Are there critical sections where
> >you should not use assertions or call BUG() in debug code?]  Something
> >in XFS debug is fighting the console/VGA/framebuffer system, and I
> >don't know where to go from here.
> >
> >You'll know you've reproduced this one because you'll need the power
> >button to shut the PC off, so be careful.
> >
> >This is crash report; no fix is requested.  I'm using the simple
> >workarounds "don't run xfstests #111 with XFS debugging enabled" and
> >"Backups!  Backups!  Backups!"   All is well.
> >
> >Thanks!
> >
> >Michael
> >
> >[ 1399.347056] XFS (sda12): Corruption detected. Unmount and run xfs_repair
> >[ 1399.353815] XFS (sda12): bad inode magic/vsn daddr 64 #8 (magic=5858)
> 
> 0x58 == 'X'
> 
> >[ 1399.360277] XFS: Assertion failed: 0, file: fs/xfs/xfs_inode.c, line: 416
> 
> Thanks for the report, but there is no bug here. Maybe we should
> list test 111 as "dangerous".

Don't think so - do we actually need that assert in the verifier?
The test is actaully checking that we don't end up with an endless
loop in bulkstat when corruption is hit, so we should really make
sure the test can perform it's functions on CONFIG_XFS_DEBUG=y
kernels...

> The inode verifiers are doing their job.

Well, they aren't supposed to crash the kernel. The debug check is
historic behaviour that we can probably now remove...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
