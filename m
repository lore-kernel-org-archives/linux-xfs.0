Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B8CC7F58
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 21:06:30 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5C7088F8033
	for <xfs@oss.sgi.com>; Sun, 23 Feb 2014 19:06:30 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	PzMPLHldRMBbLUY7 for <xfs@oss.sgi.com>;
	Sun, 23 Feb 2014 19:06:28 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WHls1-0004Pq-Ef
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WHls1-0007oq-Cj
	for xfs@oss.sgi.com; Mon, 24 Feb 2014 14:06:17 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/6] xfstests: fixes for CRCs and small devices
Date: Mon, 24 Feb 2014 14:06:09 +1100
Message-Id: <1393211175-30016-1-git-send-email-david@fromorbit.com>
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

The following set of patches fix two sets of issues. The first is
that small, fast filesystems like on a ramdisk trigger some
interesting failures due to the rate of modification being so high
on such devices. Hence we can do things like run a small filesystem
out of space in a few seconds, whereas it woul dtake a few minutes
on a SSD or spinning disk. Hence some tests require some small
tweaks to avoid failures in such situations.

The second set of patches continue the work of fixing test failures
on CRC enabled filesystems due to issues with the tests themselves.
There are stll more test fixes needed, but I'm now down to single
digit failure rates on CRC enabled filesystems with these patches.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
