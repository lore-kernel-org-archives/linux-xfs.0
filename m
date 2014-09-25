Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 618037F9E
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:20:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E5BE4AC007
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:20:46 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	aWsZz8tA2rFojMh5 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:20:44 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX82H-0006kq-8y
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:20:37 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX82H-0007MZ-7b
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:20:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 v2] xfs: superblock logging rework
Date: Thu, 25 Sep 2014 22:20:29 +1000
Message-Id: <1411647632-28240-1-git-send-email-david@fromorbit.com>
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

This is an updated version of the superblock logging simplification
patch series I first sent here:

http://oss.sgi.com/archives/xfs/2014-07/msg00465.html

Version 2:
- added initial patch to sanitse xfs_fs_writeable
- updated comments to describe caller requirements for
  xfs_sync_sb()

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
