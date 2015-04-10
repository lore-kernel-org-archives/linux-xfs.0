Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6BE3029E04
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 08:38:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 49D6A8F8070
	for <xfs@oss.sgi.com>; Fri, 10 Apr 2015 06:38:11 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	6vU4JGsYjvAq8WGS for <xfs@oss.sgi.com>;
	Fri, 10 Apr 2015 06:38:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YgZ8E-0001Pe-3E
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YgZ8E-00068Z-2L
	for xfs@oss.sgi.com; Fri, 10 Apr 2015 23:38:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: fix direct IO completion issues
Date: Fri, 10 Apr 2015 23:37:55 +1000
Message-Id: <1428673080-23052-1-git-send-email-david@fromorbit.com>
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

This patchset addresses the deeper problems Brian outlined in the
description of this patch:

http://oss.sgi.com/archives/xfs/2015-04/msg00071.html

The basic issues is that DIO completion can run in interrupt context
and it does things it should not do in interrupt context because Bad
Things Will Happen.

Patches 1 and 2 convert the DIO write completion code to use an
ioend and to never run in interrupt context when a transaction or
EOF update may need to be run.

Patches 3 and 4 of this series are effectively the same as the patch
Brain sent, but by checking the ioend status in the completion
routine before taking the spinlock, we can guarantee we never take
the spinlock in interrupt context and hence don't need irq safe spin
locks and so can re-use an existing innermost spinlock for
serialisation here.

The final patch is a removal of redundant operations - most of
generic_file_direct_write is being done in the XFS code, so most of
the gneric function is redundant and unnecessary overhead. Hence it
moves the bits that we need into the XFS code path, and we stop
calling the generic code altogether.

This passes xfstests and everything I've thrown at it. There's a
couple of small cleanups that I think still need to be done, but
they are minor. e.g. xfs_end_io_dio_write() can now probably call
xfs_finish_endio_sync() directly now, rather than open coding the
calls it makes after updating the incore inode size....

Comments, thoughts?

-Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
