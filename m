Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7C66E7F50
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2016 00:10:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1E813AC003
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 22:10:29 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	di6Adl9VBZ4ZOxGF for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2016 22:10:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aJb68-0002OR-Kr
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aJb68-0001Uo-Jt
	for xfs@oss.sgi.com; Thu, 14 Jan 2016 17:09:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH v2 0/8] xfs: shrink the xfs_icdinode
Date: Thu, 14 Jan 2016 17:09:17 +1100
Message-Id: <1452751765-4420-1-git-send-email-david@fromorbit.com>
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

This is a followup to the original RFC patchset posted here:

http://oss.sgi.com/archives/xfs/2016-01/msg00366.html

This patchset actually works, and passes through xfstests without
any regressions at all. So feel free to test and comment on this
version.

-Dave.

Version 2
- timestamps are signed, so need casting to int before being stored
  in a 64 bit variable when read from disk. Fixes generic/258
  failure (patch 2).
- nlink wasn't being accounted correctly for O_TMPFILE files and
  rename whiteouts. Fixes generic/078 and others. (patch 5)
- VFS does not initialise i_mode, ever, so we need to initialise it
  directly after slab allocation to ensure that we correctly detect
  new file creates and hence don't add the inode the sb list twice,
  corrupting it. (busy inodes after unmount, self destruct in 5
  seconds, have a nice day!) (patch 8)
- when reallocating a reclaimable inode, we need to save the
  variables that hold on-disk values across the inode_init_always()
  call, otherwise we lose them. This results in corruption of these
  fields. (patch 8)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
