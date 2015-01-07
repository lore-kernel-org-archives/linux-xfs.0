Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 47EA37FA7
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 15:51:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 255E7304043
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 13:51:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	cWAiycFCOuvKqACm for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 13:51:09 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Y8yVP-0005JF-1B
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:51:07 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Y8yVP-0001xR-06
	for xfs@oss.sgi.com; Thu, 08 Jan 2015 08:51:07 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/3 v3] xfs: simplify superblock logging
Date: Thu,  8 Jan 2015 08:51:02 +1100
Message-Id: <1420667465-7453-1-git-send-email-david@fromorbit.com>
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

This patchset removes all the field-flag based logging and writeback
updates from the superblock and replaces it with "whole structure"
updates and logging as done for other buffer updates. Previous
versions:

http://oss.sgi.com/archives/xfs/2014-07/msg00465.html
http://oss.sgi.com/archives/xfs/2014-09/msg00397.html

Comments welcome.

-Dave.

Version 3:
- rebased on current for-next
- dropped xfs_fs_writeable changes as that's already been merged.
- fixed endian conversion in quota flags updates
- updated transaction type definitions

Version 2:
- added initial patch to sanitse xfs_fs_writeable
- updated comments to describe caller requirements for
  xfs_sync_sb()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
