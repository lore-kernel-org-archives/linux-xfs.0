Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 515FC7F99
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 22:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DD8AAAC002
	for <xfs@oss.sgi.com>; Mon,  5 May 2014 20:56:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6Y4Uh8ADYJZ36nCC for <xfs@oss.sgi.com>;
	Mon, 05 May 2014 20:56:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WhWU5-0002Us-G9
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WhWU5-0005IY-F1
	for xfs@oss.sgi.com; Tue, 06 May 2014 13:56:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: sanitise supberlock feature bit support
Date: Tue,  6 May 2014 13:55:54 +1000
Message-Id: <1399348559-19889-1-git-send-email-david@fromorbit.com>
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

This patchset is a followup to the original feature bit cleanup
patch I sent here:

http://oss.sgi.com/archives/xfs/2014-03/msg00101.html

It basically removes all the old cruft that we inherited from Irix
(such as tests and conversion to/from v1-3 superblocks) that we've
never supported on Linux.  On Linux, we've ony ever supported V2
directories, and so anything that doesn't know about V2 directories
is simply going to be rejected at mount time. Hence we don't need
all the code to handle versions older than this.

Nor do we care about Irix bootloader feature bit masks (the SASH
feature bits) or about things that were never implemented like
shared readonly superblock support. Hence we can remove a fairly
large chunk of complexity out of the feature bit testing if we
only test for things that we can support.

Further, we should really always use to v2 inodes these days
on v4 superblock filesystems. We've been setting the NLINK feature
bit by default at mkfs time since 2007, so no we make the kernel set
it by default at mount time, too. This means that we always convert
v1 inodes to v2 inodes, and so reduce the number of different code
paths we need to test and support.

Thoughts, comments?

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
