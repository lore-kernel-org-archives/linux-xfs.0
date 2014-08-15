Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9DA247F3F
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2014 01:39:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6FE13304048
	for <xfs@oss.sgi.com>; Thu, 14 Aug 2014 23:39:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Ff6RqmwKtYRsyE99 for <xfs@oss.sgi.com>;
	Thu, 14 Aug 2014 23:39:12 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XIBAL-0001ZO-9J
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XIBAL-0001UB-7U
	for xfs@oss.sgi.com; Fri, 15 Aug 2014 16:39:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/9] xfs: clean up xfs_buf io interfaces
Date: Fri, 15 Aug 2014 16:38:58 +1000
Message-Id: <1408084747-4540-1-git-send-email-david@fromorbit.com>
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

Hi folks,

This patch set has come from the conversion Brian and I have been
having over how to fix a use-after-free issue related to IO
completions racing with synchronous IO submission. It seemed to me
we were having trouble grasping all the different things that were
wrong and putting them in a line, so I figured the easiest way to do
with was to write a patchset that fixed the original bug, everything
else we'd noticed, and changed the IO API such that we wouldn't have
problems in the future.

So, this patch contains:

	a) initial fix for the use after free issue (patch 1)
	b) clear separation of IO submission errors at the XFS level
	   from IO errors reported through BIO completion callbacks
	   (patches 2,3)
	c) removal of some historic cruft around IO submission
	   (patch 4)
	d) rework of unnecessarily complex historic error handling
	   paths (patches 5,6,7)
	e) a new API for clear and concise asynchronous and
	   synchronous IO.  (patch 8)

The last patch fixes a bug I found writing patch 8, and can probably
be moved to first in the series...

I was just going to send this compile tested for comments, but I
threw it at a couple of VMs and it's half way through xfstests now
without any failures. That means I haven't broken anything badly,
though the error hendling changes will be interesting to test.

The error handling changes have something in common - a buffer that
took an IO error was mostly marked stale, but not always. Sometimes
they were marked as "not done" indicating that IO needed to be done
on them before the contents were valid. Some got marked stale and
done, and so on. The thing is, when we mark a buffer stale, it is
essentially the same thing as marking it !XBF_DONE. So all the error
handling paths now stale the buffer and clear XBF_DONE. Nice,
consistent error handling. This enabled some significant cleanups -
xfs_trans_buf_read_map() finally got the love it's been needing for
long time.

It also defines a specific, safe way for waiting on XBF_ASYNC buffer
IO, and makes use of that in the buffer delayed write code. Hence
the patchset also solves the problem of how do async dispatch, some
work, then wait for IO completion as separate steps as opposed to
issuing synchronous IO that is waited on immediately.

Also, the rework of the IO submission interfaces removes the fixes
added in the first patch to solve the use-after-free issue - we no
longer need an extra reference to protect parts of the IO completion
path because the reference we take during submission is held until
after the IO completion wait has occurred.

Anyway, I figured patches would speak louder than any description,
and most especially a diffstat that looks like this:

	9 files changed, 286 insertions(+), 360 deletions(-)

Comments welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
