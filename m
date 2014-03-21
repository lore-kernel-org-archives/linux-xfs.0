Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 694997F3F
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 05:12:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3692E8F8068
	for <xfs@oss.sgi.com>; Fri, 21 Mar 2014 03:12:56 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	UmtlqNtwmSR4WBW4 for <xfs@oss.sgi.com>;
	Fri, 21 Mar 2014 03:12:54 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/6] xfs: delalloc, DIO and corruption....
Date: Fri, 21 Mar 2014 21:11:44 +1100
Message-Id: <1395396710-3824-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

Hi folks,

This patch series mostly shuts a can of worms that Al opened when he
found the cause of the generic/263 fsx failures. The fix for that is
patch 6 of this series, but, well, there are a bunch of other
problems that need to be fixed before making that change.

Basically, the direct Io block mapping behaviour was covering up a
bunch of other bugs in the delayed allocation extent/page cache
state coherency mappings. Essentially, we punch out the page cache
in quite a few places without first cleaning up delayed allocation
extents over that range and that exposes all sorts of nasty issues
once the direct IO mapping changes are made.  All of these are
existing problems, most of them are very unlikely to be seen in the
wild.

This patch set passes xfstests on a 4k block size/4k page size
config with out problems. However, there is still a fsx failure in
generic/127 on 1k block size/4k page size configurations that I
haven't yet tracked down. That test was failing occasionally before
this patch set as well, so it may be a completely unrelated problem.

The sad fact of this patchset is it is mostly playing whack-a-mole
with visible symptoms of bugs.  It drives home the fact that
bufferheads and the keeping of internal filesystem state attached to
the page cache simply isn't a verifiable architecture.  After
spending several days of doing nothing else but tracking down these
inconsistencies i can only conclude that the code is complex,
fragile and extremely difficult to verify that behaviour is correct.
As such, I doubt that the fixes are entirely correct, so I'm left
with using fsx and fsstress to tell me if I've broken anything.

Eyeballs appreciated, as is test results.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
