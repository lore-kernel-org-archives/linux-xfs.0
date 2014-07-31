Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6A6587FAB
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 02:33:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5815D304051
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 00:33:28 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	M052QGNstKwzpkMh for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 00:33:26 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XCkrW-0005gS-Pe
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XCkrW-0003xu-OS
	for xfs@oss.sgi.com; Thu, 31 Jul 2014 17:33:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfs: discombobulate sb updates and kill xfs_vnode.h
Date: Thu, 31 Jul 2014 17:33:09 +1000
Message-Id: <1406791995-14723-1-git-send-email-david@fromorbit.com>
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

Really two patch series in one. The first two patches remove the
bitfield based superblock update method and replace it with a simple
"update and log everything" operation. Superblock updates are
now relatively rare so there's no need to optimise for single field
updates. This patchset removes all that complex code and makes
everything nice and simple.

The last 4 patches clean up some old macros that are only used once
or twice and that allows us to remove the xfs_vnode.h file. One more
historical reference derived from Irix vnodes is now gone...

Comments, flames, testing all welcome.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
