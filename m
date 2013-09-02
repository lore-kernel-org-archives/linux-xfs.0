Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 697EB29DFB
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 22:23:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 07AF3AC003
	for <xfs@oss.sgi.com>; Sun,  1 Sep 2013 20:23:06 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	u1ZW1QFMHxp3YjEO for <xfs@oss.sgi.com>;
	Sun, 01 Sep 2013 20:23:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGKjF-0008RZ-TS
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGKjF-0006Vg-Su
	for xfs@oss.sgi.com; Mon, 02 Sep 2013 13:23:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fix some sparse warnings.
Date: Mon,  2 Sep 2013 13:22:57 +1000
Message-Id: <1378092179-24973-1-git-send-email-david@fromorbit.com>
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

The first patch is a new warning from the log recovery ordering code
- I used the wrong structure to pull the superblock LSN out of the
on disk buffer. On most platforms there should be no actual bug here
as both the xfs_sb and xfs_dsb have identical layouts.

The second patch is just fixing a few bits of warning noise that
sparse produces. There's not actual compiled code change from them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
