Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6F0ZomA173166 for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 19:35:50 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B1B291596668
	for <xfs@oss.sgi.com>; Wed, 14 Jul 2010 17:38:45 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	BQj5YTyehQcXjjvH for <xfs@oss.sgi.com>;
	Wed, 14 Jul 2010 17:38:45 -0700 (PDT)
Received: from dastard (unverified [121.44.38.238])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	31375387-1927428
	for <xfs@oss.sgi.com>; Thu, 15 Jul 2010 10:08:43 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OZCTF-0002zA-Nr
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:37 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1OZCT2-0000Xo-5h
	for xfs@oss.sgi.com; Thu, 15 Jul 2010 10:38:24 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/5] xfs: reclaim bug fixes
Date: Thu, 15 Jul 2010 10:38:15 +1000
Message-Id: <1279154300-2018-1-git-send-email-david@fromorbit.com>
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

The following patches fix excessive CPU consumption during inode
cache shrinking when filesystems have lots of allocation groups as
well as prevent a couple of lockdep reports that were found during
testing. Also included is a fix for a reclaim recursion deadlock
when allocating memory during inode initialisation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
