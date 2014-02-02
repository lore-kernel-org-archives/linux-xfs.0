Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9B9777FAA
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 17:56:17 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A052AC002
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 15:56:16 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	6uEutTbHXDx7kXqO for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 15:56:15 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WA6tU-0005p3-RO
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WA6tU-0003N0-Qc
	for xfs@oss.sgi.com; Mon, 03 Feb 2014 10:56:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/4] xfstests: xfs and hole punch test fixes
Date: Mon,  3 Feb 2014 10:56:01 +1100
Message-Id: <1391385365-12790-1-git-send-email-david@fromorbit.com>
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

Hi Folks,

The first couple of patches fix failures in XFS tests that occur
with different configurations and block sizes. The last two patches
fix failures of the hole punch tests on filesystems that have a
block size other than 4k. It does this by a combination of filtering
and changing the way we detect failures on the block size sensitive
part of the test.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
