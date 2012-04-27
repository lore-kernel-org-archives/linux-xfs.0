Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3R9jWMh148016 for <xfs@oss.sgi.com>; Fri, 27 Apr 2012 04:45:32 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gzBUhypJC7A9Wray for <xfs@oss.sgi.com>;
	Fri, 27 Apr 2012 02:45:31 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SNhjz-00048i-Va
	for xfs@oss.sgi.com; Fri, 27 Apr 2012 19:45:27 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SNhjz-0003lJ-RI
	for xfs@oss.sgi.com; Fri, 27 Apr 2012 19:45:27 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] xfs: failed writes and stale delalloc blocks.
Date: Fri, 27 Apr 2012 19:45:19 +1000
Message-Id: <1335519922-14371-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The fist patch fixes the original off-by-one I found that lead to assert
failures. The assert failures still happened, and that lead to the discovery
that we can leave delalloc blocks inside the file too. That's a much more
complex fix, explained in the patch, and effectively makes the first patch
redundant. I wanted to leave them as two separate patches, though, because it
shows that there are two definitely classes of errors we have to handle
correctly.

These two patches don't solve all the xfs_getbmap() and evict() assert failures
relating to delayed allocation blocks. When I have all the debug and tracing
turned on with ehese patches, test 083 can run in a loop for an hour and not
fail, running a successful test every ~20s.

However, one in every five test runs resulted in a test failure because of the
checking of the filesystem (using 512 byte block size) would trigger a mount
warning and that would cause a false detection of a failure. Hence the third
patch to prevent that warning from occurring. I'm still seeing a less regular
check failure when not running with debug and tracing, but this error message is
not the cause anymore.

Back to delayed allocation: when I remove either the debug or the tracing, I
still see fairly regular assert failures, but this time they are not a result of
failed writes.  The inodes that trigger failures do not show up in the failed
write debug output, and the extent debug output always indicates there are
delalloc blocks beyond EOF and the tracing indicates that they were put there as
a result of speculative delayed allocation beyond EOF.

I beleive the reason that fsstress is tripping the bmap assert is because,
unlike fiemap and the xfs_io bmap command, it is giving length to the range it
wants mapped and so we are trying to map beyond EOF. Of course, there are
delalloc blocks there which triggers the assert. I need to modify xfs_io to see
if this really is the cause of the remaining assert failures....

However, in the mean time, these patches remove one source of assert failures
and make my xfstests runs much less likely to fail. I can get the majority of my
auto group test runs completing with these patches instead of a 50% failure rate
without the patches.

I hope everyone enjoys reviewing patch 2/3 as much as I enjoyed writing it - it
was a PITA until I found that set_buffer_new() bug in __xfs_get_blocks().... ;)

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
