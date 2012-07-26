Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8e4Ze001377 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:04 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	h3EB2meWik4cVi61 for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJbr-00013Z-PG
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003uQ-Kv
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/10] xfstests: rework large filesystem testing
Date: Thu, 26 Jul 2012 18:39:39 +1000
Message-Id: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

This is a resend of a series that has been sitting inmy local
workarea for months. It reworks the large filesystem testing
infrastructure for XFS to allow it to use xfs_repair by switching
the filesystem filling to using preallocation rather than xfs_db
hacks.

It also introduces support for ext4 testing, also via preallocation
to fill the filesystem. btrfs isn't yet supported because I haven't
worked out how to reliably get the size of the filesystem and
calculate how much space is actually available in it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
