Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 000A729DFB
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 17:06:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 928F4AC003
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 15:06:07 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	3pdXyxfcBqpIpNau for <xfs@oss.sgi.com>;
	Wed, 04 Sep 2013 15:06:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VHLD9-0007ck-FE
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VHLD9-0003r9-EM
	for xfs@oss.sgi.com; Thu, 05 Sep 2013 08:06:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/55] xfsprogs: bring code up to date with kernel
Date: Thu,  5 Sep 2013 08:05:04 +1000
Message-Id: <1378332359-14737-1-git-send-email-david@fromorbit.com>
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

This is an updated version of the patchset posted here:

http://oss.sgi.com/archives/xfs/2013-07/msg00454.html

Changes since the previous version:

- rebased onto master branch of repository
- updated to match current kernel code
- added several new patches for changes added to the kernel code
- fixed many bugs
	- mkfs log sizing was wrong
	- dtype output for block format directories didn't work
	- repair was crashing on corrupt block format directories
	- xfs_trans.h completely removed

There is not support for validating dtype in xfs_repair yet - that
is part of a series of improved validation changes I'm making at the
moment on top of this patchset, along with stuff like making xfs_db
use libxfs infrastructure....

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
