Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99B7F29DF7
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 23:40:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2AA14AC003
	for <xfs@oss.sgi.com>; Sun,  2 Mar 2014 21:40:05 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	qqGGZOlWBR4rtg4Y for <xfs@oss.sgi.com>;
	Sun, 02 Mar 2014 21:40:00 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WKLbY-0002b7-Kg
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WKLbY-00085J-Ja
	for xfs@oss.sgi.com; Mon, 03 Mar 2014 16:39:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/2] xfs: fixes for for-next
Date: Mon,  3 Mar 2014 16:39:52 +1100
Message-Id: <1393825194-1719-1-git-send-email-david@fromorbit.com>
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

A couple of quick fixes - the new verifier code leaks EFSBADCRC to
userspace, so any code that is checking for EFSCORRUPTED is not
going to be working correctly. The first patch fixes this
regression.

The second patch fixes a long standing issues with vmapped RAM
potentially causing deadlocks due to GFP_KERNEL allocations being
done for page tables inside GFP_NOFS contexts. This will fix many of
the lockdep reports about it, but won't get rid of them all. It
will, however, guarantee that we won't deadlock due to the problem
which is a big step up.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
