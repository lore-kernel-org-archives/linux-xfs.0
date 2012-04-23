Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xIgt127390 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PUUxbQhkTSjZCnYx for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Ze-DC
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004X9-8Z
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/37] xfs: current 3.4 patch queue
Date: Mon, 23 Apr 2012 15:58:30 +1000
Message-Id: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

Folks,

This is my current patch queue that I'm testing. It's sitting on top
of Jan Kara's freeze series, but otherwise it is based on an
unmodified 3.4-rc4 + oss-xfs/master tree.

First of all, this series picks up Christoph's xfsbufd removal
series (patches 1-10). I've fixed all the known problems and made
all the changes suggested by myself and others in review. It passes
106 just fine, too. ;)

The next series (patches 11-14) are bug fixes and features that I've
previously posted. I haven't been able to reproduce Ben's CIL commit
sequence assert failure from the async log flushing patch (patch
12/37), so whatever the cause of that problem is is still unknown.

[ Actually, as I wrote this I had a concurrent rm -rf just trip this
assert, so the problem is real and I've obviously got more work to
do on this one.... ]

Following that is the buffer cache cleanup series (patches 15-26).
That is all essentially unchanged, except for a couple of minor
fixes from review comments.

Next up is a fix for XFS_IOC_ALLOCSP, followed by a previously
posted but unreviewed series (patches 28-34) that cleans up some
includes, removes xfs_rw.[ch] and moves all the busy extent handling
out to it's own file. This is all to make it easier to merge code
with userspace.

Finally, 3 new patches that clean up an issue seen in buffer flag
handling, fixes a log mount failure oops, and a further buffer flag
cleanup by making the dominant behaviour the default and not needing
flags to be specified.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
