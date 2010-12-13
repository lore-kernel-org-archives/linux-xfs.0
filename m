Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD1P9Lc148093 for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 19:25:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 94DCB1E2B5F
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 17:26:59 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	6w5QCGUpoXGtiZBT for <xfs@oss.sgi.com>;
	Sun, 12 Dec 2010 17:26:59 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	49418373-1927428
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 11:56:58 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PRxBf-0001lv-5L
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 12:26:47 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PRxAB-00045q-Og
	for xfs@oss.sgi.com; Mon, 13 Dec 2010 12:25:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: dynamic speculative allocation beyond EOF V4
Date: Mon, 13 Dec 2010 12:25:09 +1100
Message-Id: <1292203511-15685-1-git-send-email-david@fromorbit.com>
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

Version 4:
- factored prealloc size into separate function to keep
  xfs_iomap_write_delay() easy to read.
- convert i_dirty_releases counter to a flag.

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
