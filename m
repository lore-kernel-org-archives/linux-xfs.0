Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0ANtCYh064711 for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 17:55:13 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65D581576DA
	for <xfs@oss.sgi.com>; Sun, 10 Jan 2010 15:56:05 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	evx4QI6G3KkYxAJH for <xfs@oss.sgi.com>;
	Sun, 10 Jan 2010 15:56:05 -0800 (PST)
Received: from discord (unverified [121.44.168.156])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11365178-1927428
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2010 10:26:04 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NU7da-0002qS-H6
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:56:02 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NU7ZY-0007Yj-Er
	for xfs@oss.sgi.com; Mon, 11 Jan 2010 10:51:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] 2.6.33-rcX candidate fixes
Date: Mon, 11 Jan 2010 10:51:44 +1100
Message-Id: <1263167508-9346-1-git-send-email-david@fromorbit.com>
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

The first three of these patches are the respun inode reclaim fixes
adressing all of Christoph's concerns. These should be OK for merge
now, and once merged canbe backported to .31/.32.

The last patch is a fix for a new lockdep warning since 2.6.32 that
occurs during mount of an XFS filesystem. The ASSERT for the rwsem
being held is redundant now that lockdep checks for the lock already
being held/in use during lock initialisation that happens directly
after the ASSERT in XFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
