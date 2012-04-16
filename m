Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3G5EODE171375 for <xfs@oss.sgi.com>; Mon, 16 Apr 2012 00:14:24 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	zlYCXS6RFWpJQlZa for <xfs@oss.sgi.com>;
	Sun, 15 Apr 2012 22:14:22 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SJeGU-0000m7-3y
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:14 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SJeGT-0005Mz-W1
	for xfs@oss.sgi.com; Mon, 16 Apr 2012 15:14:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs: cleanups to make userspace merges simpler
Date: Mon, 16 Apr 2012 15:14:04 +1000
Message-Id: <1334553251-20571-1-git-send-email-david@fromorbit.com>
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

To make userspace merges easier, we really need to separate code
that exists purely in the kernel code from code that is used by both
usrespace and kernel code. This reduces the differences between the
userspace and kernel code, and makes it easier to maintain. This
patch series sits on top of my current patch queue as posted here:

http://oss.sgi.com/archives/xfs/2012-04/msg00768.html

The biggest change in the this series is to separate the busy extent
list code from xfs_alloc.c. The busy extent code is not needed
in userspace whilst the rest of the allocation code is, so it makes
sense to move it to it;s own file in the kernel code.

Similarly, xfs_rw.[ch] do not exist in userspace, but there are
includes all over the place for it in .c files that are shared with
userspace. We can trivially kill the xfs_rw.[ch] files in the kernel
altogether, removing another trivial difference between user and
kernel space.

Other header file cleanups are performed - moving xfs_agino_t to
xfs_types.h removes a lot of needless dependencies, as does making
the static inline function xfs_fsb_to_db a just a normal function in
a .c file.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
