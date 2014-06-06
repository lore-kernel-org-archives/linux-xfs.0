Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 079497F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 03:23:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE590304043
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 01:23:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	8zRnhepydRapYT6b for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 01:23:01 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WspQN-000327-A1
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:22:55 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1WspQN-0006qp-9E
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:22:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix a couple of swap extent issues
Date: Fri,  6 Jun 2014 18:22:51 +1000
Message-Id: <1402042973-26276-1-git-send-email-david@fromorbit.com>
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

Eric pointed out that this morning that if xfs_fsr didn't fsync the
target file, the swap extents ioctl deadlocked. Dumb bug, simple
fix. I also made sure that swap extent treats both inodes the same
in terms of flushing, page cache pages and being mmap()d so that if
anyone other than xfs_fsr uses it it doesn't go boom when the second
inode is not a newly created empty file.

Thoughts?

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
