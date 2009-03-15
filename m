Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2FBlIHB008380 for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 06:47:38 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D00A419A0E1
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail08.adl2.internode.on.net
	[203.16.214.72]) by cuda.sgi.com with ESMTP id Q9wkNqzvwueMpbR2
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 04:46:55 -0700 (PDT)
Received: from destruction.internal (unverified [203.206.165.193])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	44231941-1927428
	for <xfs@oss.sgi.com>; Sun, 15 Mar 2009 22:16:53 +1030 (CDT)
Received: from dave by destruction.internal with local (Exim 4.69)
	(envelope-from <dave@destruction>) id 1Lionj-0006n8-84
	for xfs@oss.sgi.com; Sun, 15 Mar 2009 22:46:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] [XFS] introduce a AG inode tree walker
Date: Sun, 15 Mar 2009 22:46:37 +1100
Message-Id: <1237117603-26071-1-git-send-email-david@fromorbit.com>
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

This series splits up the sync and reclaim code into three
separate actions. The first is the tree walker, the second is
the inode validation and the third is the operation to execute
on the inode.

This allows us to somewhat abstract the radix tree away from the
act of walking the cached inodes and puts in place mechanisms that
can be extended for bulk inode cache lookups.

This also splits the inode writeback into separate data and metadata
sync operations and optimises them a little......

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
