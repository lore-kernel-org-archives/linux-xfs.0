Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52OmY134484 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:25 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ECYcxGDb4AVkFKaJ for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZQ-0003Du-Ii
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZQ-0003bB-Ea
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
Date: Thu, 23 Aug 2012 15:01:18 +1000
Message-Id: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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

This series is a backport of all the major bug fixes in the current
TOT kernel to the current 3.0.x stable tree.

I won't make any secret of this - the fixes and supporting patches
have been selected as a result of the issues reported in the current
RHEL XFS codebase which currently is 2 commits short of the 3.0 code
base.  With that said, it doesn't take a brain surgeon to work out
the motivations behind this work and eventual destination of the
patch set. ;)

There's no guarantee I have caught every single bug fix that has
been made since 3.0, but I've tried to grab all the bug fix commits
as indicated by the commit headers (hence the importance of good one
line bug summaries).

Over the past couple of weeks of testing and refining, I've had only
three significant problems arise from QA and load testing:

	1) An unreproducable log space hang
	2) An unmount panic due to buffers not being cleaned up
	before tearing down the perag tree
	3) A forced shutdown panic in block_invalidatepage()
	via xfs_aops_discard_page()

It's entirely possible that #1 was due to the CIL space hang we
still haven't got to the bottom of, so i'm not not greatly concerned
by that. #2 implies I haven't quite backported the shutdown ordering
fixes correctly (or I missed one), so I have a bit more work to do
there. And for #3 - I've never seen that before and I haven't been
able to reproduce it, so I really don't know what potential cause or
impact it has.

I've been beating on the series with xfstests, dbench, fsmark,
postmark, compilebench and a few other load scripts that I've got,
and it seems fairly resilient.  Hence, it's time to give the series
wider testing and review to flush out any remaining issues.

For all the folks that run 3.0.x stable kernels, I'd appreciate it if
you could give this a whirl on your test systems to see if there are
any obvious, glaring problems that show up under your particular
workloads. This woul dbe of great benefit to me before I submit the
series to the stable kernel gurus - I'd prefer it there's more
substantial testing than "i've done what I can" when sending them
the series.

For all the XFS developers that have copious amounts of free time
available, I'd appreciate an eye run over the patch list to see if
there's any potential bug fixes that I missed or have made glaring
errors in backporting. Some of the fixes are dependent on cleanups I
haven't included, so some of the patches are a bit different to what
is in mainline (e.g. anything that touches setattr). Most important
to look at is probably the inode i_size changes and the logging of
all metadata changes.

Enjoy!

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
