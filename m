Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o06N8VIM120044 for <xfs@oss.sgi.com>; Wed, 6 Jan 2010 17:08:32 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0C1FEDA2A1
	for <xfs@oss.sgi.com>; Wed,  6 Jan 2010 15:09:22 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	2RTVPm9vqpVxm6B5 for <xfs@oss.sgi.com>;
	Wed, 06 Jan 2010 15:09:22 -0800 (PST)
Received: from discord (unverified [121.44.238.220])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11070986-1927428
	for <xfs@oss.sgi.com>; Thu, 07 Jan 2010 09:39:21 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NSf0B-0000jR-8O
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:09:19 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NSewS-00073q-SU
	for xfs@oss.sgi.com; Thu, 07 Jan 2010 10:05:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] Fix inode reclaim problems (hopefully)
Date: Thu,  7 Jan 2010 10:05:23 +1100
Message-Id: <1262819125-27083-1-git-send-email-david@fromorbit.com>
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

These two patches seem to fix the inode reclaim issues I've been
able to reproduce lately. The changes are still running xfsqa in a
loop to confirm this, but the directory/small file stress test I've
been running to trigger the problem has run for 10 hours with these
fixes instead of dying after 20-30 minutes.

The first patch is a rewrite of Christoph's reclaim under write lock
fixes without all the code duplication, and the second avoids direct
reclaim altogether because xfs_inode_clean() needs to be run when the
flush lock is held to ensure the inode not under IO and really is
reclaimable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
