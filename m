Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Sep 2008 07:02:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8DE2JlT015193
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:02:19 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92712126BF53
	for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:49 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id gGWfqm6BZyo6pTZE for <xfs@oss.sgi.com>; Sat, 13 Sep 2008 07:03:49 -0700 (PDT)
Received: from dave by disturbed with local (Exim 4.69)
	(envelope-from <david@fromorbit.com>)
	id 1KeVj1-0007gA-Ah
	for xfs@oss.sgi.com; Sun, 14 Sep 2008 00:03:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3] XFS: Prepare for combining the XFS and Linux inodes.
Date: Sun, 14 Sep 2008 00:03:44 +1000
Message-Id: <1221314627-29065-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

These three patches clean up code in preparation for combining
the Linux and XFS inodes. Each patch stands alone, but I've sent
them as a series becausee they have all been written to make it
easier to transition the code to an embedded struct inode in the
struct xfs_inode.
