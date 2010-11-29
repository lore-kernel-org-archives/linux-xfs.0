Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAT0tT5f075118 for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 18:55:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D26361C7CE32
	for <xfs@oss.sgi.com>; Sun, 28 Nov 2010 16:44:21 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	OYoplAKs1a3VbvxH for <xfs@oss.sgi.com>;
	Sun, 28 Nov 2010 16:44:21 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	2736925-1927428
	for <xfs@oss.sgi.com>; Mon, 29 Nov 2010 11:14:20 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PMrqt-0000XV-5g
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:44:19 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PMrqT-0005MO-Tm
	for xfs@oss.sgi.com; Mon, 29 Nov 2010 11:43:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: dynamic speculative allocation beyond EOF V3
Date: Mon, 29 Nov 2010 11:43:49 +1100
Message-Id: <1290991431-20519-1-git-send-email-david@fromorbit.com>
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

This is the latest version of the dynamic speculative allocation
beyond EOF patch set. The description of the patchset can be found
here:

http://oss.sgi.com/archives/xfs/2010-10/msg00040.html

Version 3:

- allocsize mount option returned to fixed preallocation size only.
- reduces maximum dynamic prealloc size as the filesytem gets near
  full.
- split i_delayed_blks bug fixes into new patch (posted in 2.6.37-rc
  bug fix series)

Version 2:
- base speculative execution size on current inode size, not the
  number of previous speculative allocations.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
